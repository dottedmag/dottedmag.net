title: DE/compositor development notes - DRM framebuffers (1)
date 2023-07-09
----
[Display controller pipeline](/blog/05-de-drm-pipeline/) takes framebuffers as input.

Framebuffer in DRM is a raster picture. Graphics display hardware is very particular
about location and layout of that memory, and the details vary significantly between
cards, so DRM provides some common functionality and leaves the rest to drivers.

A framebuffer consists of:
- a chunk of memory (may be several chunks for pictures that are composed of several planes[^drmplane])
- width, height information, in pixels
- pitch (also known as stride): number of bytes between successive lines of picture
- pixel format and modifier (see below)

Display controllers are very particular about data format as they have to be able to scan
and combine several megabytes' worth of data fast enough to generate video signal for every frame,
so DRM planes have restrictions on pixel formats they accept.

## Memory handles

Display controller or GPU might have their own memory space, so DRM uses _handles_ to allocated
memory. Some of these handles may be `mmap`ed to obtain memory pointers though it might be very
slow.

## Framebuffer formats and modifiers

Display controller needs to know how data in framebuffer is laid aout to know how to interpret
it. This is indicated by pixel format and optional modifier. There are lots of formats and
modifiers specified in `drm/drm_fourcc.h`. Formats are four-letter codes, modifiers are 32-bit
integers.

Pixel formats typically specify how one pixel is laid out: single-planar/multi-planar layout,
order of components within a pixel, width and interpretation of every component.

Pixel formats also can be classified as single-plane and multi-plane. Single-plane store all
information for a pixel in one place, multi-plane formats store components of the pixel
separately, with every plane (chunk of memory) laying out components of pixels in the same order.

For example, `DRM_FORMAT_ABGR1555` is defined as `[15:0] B:G:R:x 5:5:5:1 little endian`:
single-planar, RGB, one pixel occupies 16 bits, 5 bits of blue, green, red components
and 1 bit of alpha.

Some formats are more cryptic: `DRM_FORMAT_YUV444` is `non-subsampled Cr (1) and Cb (2) planes`:
YCbCr, 3 planes, 8 bit Y plane, 8 bit Cr plane, 8 bit Cb plane.

Pixel format modifiers typically specify how multiple pixels are laid out in memory: there
is `DRM_FORMAT_MOD_LINEAR` to force linear layout (pixels are laid out in memory one after
another, left-to-right, top-to-bottom, with a possible padding between rows), and a number
of modifiers to specify various tiling layouts (clumps of nearby pixels are stored
in memory together) and framebuffer compression algorithms.

Every DRM plane exposes supported formats, so it's up to userspace to pick one for best
performance. Some DRM planes are specifically created to speedup frequent operations: it is
common to see overlay planes that support YUV pixel formats for video playback: many video
formats encode picture in YUV, so it allows decoding video directly into a framebuffer and
skipping YUV->RGB conversion.

## Dumb buffers

Display controllers differ wildly in their requirements for memory allocation, so DRM drivers
expose driver-specific `ioctl`s for that, and rely on userspace to properly drive the hardware.
However, requiring full Mesa to draw anything at all is a bit excessive, so DRM drivers also
expose _dumb buffers_: a limited API for allocating memory. Dumb buffers are allowed to be
very slow, so they are provided mainly for diagnostic messages, splash screens and similar
circumstances where speed is not a concern.

A dumb buffer is allocated using `DRM_IOCTL_MODE_CREATE_DUMB` that takes width, height, and bpp
of the buffer to be allocated. Buffer handle and pitch is returned. Dumb buffers can always
be passed to DRM to draw images with (other types of buffers may not be, e.g. if they are
GPU-only).

Dumb buffers may be `mmap`ed using `DRM_IOCTL_MODE_MAP_DUMB` and destroyed using
`DRM_IOCTL_MODE_DESTROY_DUMB`.

DRM driver indicates dumb buffer support by `DRM_CAP_DUMB_BUFFER` capability.

These drivers also expose `DRM_CAP_DUMB_PREFERRED_DEPTH` capability for preferred depth
(some drivers are unable to allocate dumb buffer of depth different from preferred),
and `DRM_CAP_DUMB_PREFER_SHADOW` to indicate that random access to dumb buffers is very slow,
and applications should render somewhere else and batch-copy data to dumb buffer once done.

## Non-dumb buffers

Non-dumb buffers are complicated and will be discussed in another post.

## Footnotes

[^drmplane]:
	Framebuffer planes are unrelated to DRM planes, even though the idea is similar: take several
	memory buffers and produce a combined picture. Plane image formats actually precede modern
	display controllers by a significant margin: NES used planar graphics back in 1983.
