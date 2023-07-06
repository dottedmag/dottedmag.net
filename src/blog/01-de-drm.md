title: DE/compositor development notes - Linux DRM devices
date: 2023-07-06
----
To draw anything on screen compositor should be able to communicate with display
controller and GPU[^dispgpu][^libdrm].

Linux exposes them to userspace via DRM subsystem[^drm], as
character devices in `/dev/dri`[^dri][^proc].

There might be one or two devices for every display controller or GPU[^control]:
- there is always a device named `card<N>`. It accepts all requests:
  for controlling the display (KMS[^kms]) and for rendering operations.
  If `card<N>` belongs to a pure display controller, then it won't accept
  any rendering operations, of course.
- GPUs typically expose second device named `renderD<N>`. This device
  accepts only rendering operations. However this device does have the
  concept of "DRM master"&mdash;the process controlling the device&mdash;as
  rendering does not involve global operations such as changing the
  display mode or updating the framebuffer, so there is no need to limit
  concurrent access.

Matching `card<N>` and `renderD<N>` devices used to be awkward: the numbers
are not the same for the devices of one card. The algorithm was bus-dependent:
PCI/USB cards were matched by PCI/USB bus info, platform devices were matched
using device tree info. To find this information one had to scrounge around
in `/sys/dev/char/<N>/device/subystem`. All of this is implemented in `libdrm`.

Fortunately, `udev` nowadays creates symlinks in `/dev/dri/by-path` of form
`<unique-id-for-card>-{card,render}`, so userspace does not care about device
matching anymore.

## References
- [libdrm's x86drm.c](https://cgit.freedesktop.org/drm/libdrm/tree/xf86drm.c)
- [Linux's DRM uAPI documentation](https://dri.freedesktop.org/docs/drm/gpu/drm-uapi.html)

## Footnotes

[^dispgpu]:
	Display controller is a hardware block that takes bitmaps and displays them
	somewhere. It cares about outputs, links, modes etc. GPU takes a number of
	rendering commands and produces a bitmap based on these commands. It cares
	about triangles, shaders, textures and pixels. In PCs these two components
	are usually colocated in a "graphic card", display controller may require
	bitmaps to be placed in a specialized on-card memory, and GPU may produce
	bitmaps in that specialized memory.
[^libdrm]:
	There exists [libdrm](https://cgit.freedesktop.org/drm/libdrm/) library that
	hides low-level details from the applications, but it is not a transparent
	wrapper, so it makes sense to understand what it actually does and what
	it actually calls.
[^drm]:
    Direct rendering manager, not digital rights management.
[^dri]:
    DRI stands for "direct rendering interface". Historical reasons.
[^proc]:
	These devices used to be also exposed as `/proc/dri`. It is no longer the case.
[^control]:
	There used to be a third kind of device, `controlD<N>`, but it did nothing
	and was eliminated.
[^kms]:
	Kernel modesetting, a generic API to setup display controllers. Named
	to contrast with userland modesetting, where userland poked hardware
	directly to set the configuration of display controller.
