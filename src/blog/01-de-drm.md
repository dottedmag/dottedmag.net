title: DE/compositor development notes - Linux DRM devices
date: 2023-07-06
----
To draw on the screen, the compositor needs to communicate with the display
controller and GPU[^dispgpu][^libdrm].

Linux exposes them to userspace via DRM subsystem[^drm], which presents them
as character devices in `/dev/dri`[^dri][^proc].

There could be one or two devices per display controller or GPU[^control]:
- there is always a device named `card<N>` that accepts all requests
  for controlling the display (KMS[^kms]) and rendering operations.
  If `card<N>` belongs to a pure display controller, it won't accept
  rendering operations.
- GPUs typically have a second device called `renderD<N>`. It is dedicated
  to rendering operations only.

Card and render devices for one card do not have the same number in the name.
To match them, use symlinks in `/dev/dri/by-path`, which are of the format
`<unique-id-for-card->{card,render}`[^udev][^oldmatch].

## References
- [libdrm's x86drm.c](https://cgit.freedesktop.org/drm/libdrm/tree/xf86drm.c)
- [Linux's DRM uAPI documentation](https://dri.freedesktop.org/docs/drm/gpu/drm-uapi.html)

## Footnotes

[^dispgpu]:
	A display controller is a hardware component that takes bitmaps and displays them.
	It handles outputs, links, and modes. A GPU is a hardware component that receives
	(3D) rendering commands and creates bitmaps based on these commands. It deals
	with triangles, shaders, textures and pixels. In PCs, these two components
	are usually colocated in a graphics card. The display controller may need
	the bitmaps to be placed in a specialized on-card memory, and the GPU may produce
	bitmaps in that specialized memory.
[^libdrm]:
	The [libdrm](https://cgit.freedesktop.org/drm/libdrm/) library exists to
	hide low-level details from applications. However, it is not a transparent
	wrapper, so it is important to understand what it actually does and the
	specific syscalls it makes.
[^drm]:
    Direct rendering manager, not digital rights management.
[^dri]:
    DRI stands for "direct rendering interface". Linux uses directory `/dev/dri`
	for historical reasons. FreeBSD has changed it to `/dev/drm`.
[^proc]:
	These devices used to also be exposed as `/proc/dri`, but that is no longer the case.
[^control]:
	There used to be a third type of device called `controlD<N>`, but it was removed because
	it did nothing.
[^kms]:
	Kernel modesetting is a generic kernel API to configure display controllers,
	contrasting with userland modesetting which involves userland poking hardware
	directly for display controller configuration.
[^udev]:
	It's `udev` that creates these symlinks.
[^oldmatch]:
    The matching of `card<N>` and `renderD<N>` devices used to be cumbersome because
    their numbers do not correspond. The algorithm for matching was dependent on bus
	type, with PCI/USB being matched by PCI/USB bus information, and platform devices
	being matched using device tree information. This required searching for the necessary
	information in `/sys/dev/char/<N>/device/subystem`. All of this functionality is
	is implemented in `libdrm`.
