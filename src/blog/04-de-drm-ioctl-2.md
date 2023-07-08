title: DE/compositor developmetn notes - DRM operations (2)
date: 2023-07-08
----
Graphics hardware might need to be shared by the compositor and applications.

Compositor is in charge of display controller as a final arbiter of what goes to screen
(except leasing, see below), but applications need access to rendering functionality.
Several compositors need to share hardware too.

## Giving application access to the rendering

Application (actually, usually Mesa on behalf of application) opens rendering device node,
uses it for rendering. Easy[^oldmaster].

## Sharing a display controller between compositors

There is a concept of "DRM master": an application that owns the display controller functionality
in DRM. First process that opens DRM card device becomes master automatically.

Whenever a compositor needs to yield access to display controller to another compositor,
it issues `DRM_IOCTL_DROP_MASTER`. Whenever it needs to become a master again, it
issues `DRM_IOCTL_SET_MASTER`.

This dance is typically performed in [VT switch sequence](/blog/02-de-vt/).

## Handing over the display controller to the application

Sometimes an application needs full control over a display controller. Typically it happens
when a display controller is a part of specialized device, such as VR hardware. In this case
compositor may _lease_ a DRM device to an application.

Compositor calls `DRM_IOCTL_MODE_CREATE_LEASE` with a set of DRM objects it wants to
lease, gets back a new DRM file descriptor and passes it to the application.

Compositor may list the active leases with `DRM_IOCTL_LIST_LESSEES`, leased objects
using `DRM_IOCTL_GET_LEASE` and yank control back at any time using `DRM_IOCTL_REVOKE_LEASE`.

Application can use new file descriptor as if it is a real DRM master.

## References

- [DRM security](https://www.x.org/wiki/Events/XDC2013/XDC2013DavidHerrmannDRMSecurity/slides.pdf)
- `wlroots` source code
- [DRM lease](https://keithp.com/blogs/DRM-lease/), [DRM lease-2](https://keithp.com/blogs/DRM-lease-2/), [DRM lease-3](https://keithp.com/blogs/DRM-lease-3/) keithp blog posts.

## Footnotes

[^oldmaster]:
	This used to be much more complicated. Before rendering devices were introduced, applications
	opened card devices, used `DRM_IOCTL_GET_MAGIC` to obtain a magic cookie, passed it
	to the compositor that used `DRM_IOCTL_AUTH_MAGIC` to allow applications to render.
