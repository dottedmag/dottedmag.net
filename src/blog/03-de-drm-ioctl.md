title: DE/compositor development notes - DRM operations - capabilites
date: 2023-07-08
----
What can compositor do with DRM devices once it [has found](/blog/01-de-drm/) them?

These devices respond to a number of `ioctl`s. All DRM devices respond to a set
of common `ioctl`s that cover display controller functionality, and there are
driver-specific `ioctl`s used chiefly by Mesa for rendering operations. In addition,
kernel writes data to open DRM file descriptors whenever an
[event happened](/blog/08-de-drm-atomic) and userspace has requested to know about it.

The list of `ioctl`s is pretty large, so this post covers only a small subset.

## Versions

`DRM_IOCTL_VERSION` returns human-readable version, name, description
and (release?) date of DRM device.

## Device capabilities

`DRM_IOCTL_GET_CAP` returns capabilities of a DRM device.

Many of these capabilities refer to specific DRM `ioctl`s, so they may not
make much sense yet.

### Framebuffer capabilities

- `DRM_CAP_ADDFB2_MODIFIERS`. boolean. Framebuffers support pixel format modifiers.
- `DRM_CAP_DUMB_BUFFER`. boolean. The device can create dumb framebuffers (`DRM_IOCTL_MODE_CREATE_DUMB` et al)
- `DRM_CAP_DUMB_PREFERRED_DEPTH`. integer. The preferred pixel depth of dumb framebuffers.
- `DRM_CAP_DUMB_PREFER_SHADOW`. boolean. Non-sequential writes or reading from dumb framebuffer is slow.

### Syncobj capabilities

- `DRM_CAP_SYNCOBJ`. boolean. The device supports DRM sync objects.
- `DRM_CAP_SYNCOBJ_TIMELINE`. boolean. The device supports DRM timeline sync objects
  (they can signal at specific points in their lifetimes).

### Page flipping capabilities

- `DRM_CAP_ASYNC_PAGE_FLIP`. boolean. The device can pageflip without delay (tearing pageflip).
- `DRM_CAP_PAGE_FLIP_TARGET`. boolean. The device can pageflip with a specified target
   (`DRM_MODE_PAGE_FLIP_TARGET_{ABSOLUTE,RELATIVE}`).

### Other capabilities

- `DRM_CAP_CURSOR_HEIGHT`, `DRM_CAP_CURSOR_WIDTH` integer. return _valid_ (not necessary the maximum) hardware cursor size.
- `DRM_CAP_PRIME`. bitfield. The device can export buffers to other GPUs and/or import buffers from them.

### Obsolete capabilities

- `DRM_CAP_CRTC_IN_VBLANK_EVENT`. boolean. Always true since Linux 4.12.
- `DRM_CAP_TIMESTAP_MONOTONIC`. boolean. Always true since Linux 4.15.
- `DRM_CAP_VBLANK_HIGH_CRTC`. boolean. Always true since Linux 2.6.39

## Client capabilities

DRM client may indicate it has certain capabilites. This is necessary to activate backward-incompatible
functionality that would otherwise break old clients.

Client capabilities are set using `DRM_IOCTL_SET_CLIENT_CAP`.

- `DRM_CLIENT_CAP_STEREO_3D`. boolean. Client can handle stereo 3D, so show it the corresponding modes in the list of modes.
- `DRM_CLIENT_CAP_UNIVERSAL_PLANES`. integer[^xuni]. If > 0 then client can handle multiple planes, show it planes beyond primary and cursor ones in the list of planes.
- `DRM_CLIENT_CAP_ATOMIC`. boolean. Client can use atomic modesetting `ioctl`s. Also enables universal planes and aspect ratio.
- `DRM_CLIENT_CAP_ASPECT_RATIO`. boolean. Client can handle aspect ratio in modes, so provide it.
- `DRM_CLIENT_CAP_WRITEBACK_CONNECTORS`. boolean. Client can handle writeback connectors (connectors that capture output and save it into a framebuffer).

## References

- [DRM uAPI](https://dri.freedesktop.org/docs/drm/gpu/drm-uapi.html)
- Linux `drivers/gpu/drm/drm_ioctl.c`.

## Footnotes

[^xuni]:
	Xserver modesetting DDX is completely broken: it asks for universal planes, but is not ready to
	handle them. To avoid blowing up users' desktops, any process with name starting with `X` is
	required to set this capability to 2 to really enable universal planes.
	[Yes, really](https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/tree/drivers/gpu/drm/drm_ioctl.c?id=723dad977acd1bd37f87e88d430958a833491ff1#n339).
