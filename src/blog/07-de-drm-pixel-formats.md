title: DE/compositor development notes - DRM pixel formats and modifiers
date: 2023-07-11
----
Display controller needs to know how data in framebuffer is laid out to know how to interpret
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
