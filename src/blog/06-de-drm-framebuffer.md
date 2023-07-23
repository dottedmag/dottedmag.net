title: DE/compositor development notes - DRM framebuffers
date: 2023-07-10
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

## API

DRM framebuffers are manipulated using the following `ioctls`:

`DRM_IOCTL_MODE_ADDFB2` creates a new framebuffer. It takes framebuffer metadata
(width/height/pixel format+modifier/flags, handles/pitches(strides) of planes), and
returns framebuffer ID.

`DRM_IOCTL_MODE_RMFB` removes a framebuffer.

`DRM_IOCTL_MODE_GETFB2` retrieves framebuffer metadata: everything one has supplied to `ADDFB2`.

## Memory handles

Display controller or GPU might have their own memory space, so DRM uses _handles_ to allocated
memory. Some of these handles may be `mmap`ed to obtain memory pointers though it might be very
slow.

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
