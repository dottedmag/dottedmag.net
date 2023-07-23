title: DE/compositor development notes - DRM properties and atomic interface
date: 2023-07-16
----
As explained in [DRM pipeline](/blog/05-de-drm-pipeline), DRM is configured
by setting up framebuffers, CRTCs, planes, connectors and encoders.

Framebuffers have their own API discussed in [DRM framebuffers](/blog/06-de-drm-framebuffer).
All other objects are configured through _atomic_ interface, named thus as it provides an
operation to apply a number of changes in atomic (all or none) manner[^non-atomic].

## Objects

In atomic interface, DRM is configured through _objects_ and _properties_. An object
is framebuffer, CRTC, plane, connector or encoder. They all are indexed by a unique
number, chosen by the kernel.

One can obtain the lists of framebuffers, CRTCs, connectors and encoders using
`DRM_IOCTL_MODE_GETRESOURCES`. This returns lists of IDs of the corresponding objects.
Planes are enumerated separately in a similar manner using
`DRM_IOCTL_MODE_GETPLANERESOURCES`[^sigh].

To obtain information about object, one uses one of `DRM_IOCTL_MODE_GETCRTC`,
`DRM_IOCTL_MODE_GETPLANE`, `DRM_IOCTL_MODE_GETCONNECTOR`, `DRM_IOCTL_MODE_GETENCODER`.
However a lot of information, including all mutable information, is specified
via properties.

## Properties

CRTCs, planes and connectors have properties: mapping of string to value. Some values are
read/only, some are read/write. Values of properties may be of several types:
- integer
- range (two unsigned integers)
- enum (one of several string values)
- blob (a bag of bytes)
- bitmask (some bit flags)
- object (DRM object ID)
- signed range (two signed integers)

The list of properties is fixed during the lifetime of object, and can be queried using
`DRM_IOCTL_MODE_OBJ_GETPROPERTIES`. This returns a list of property IDs (integers scoped
to the object) and property values themeslves.

Property metadata (name, type, enum values) can be read using `DRM_IOCTL_MODE_GETPROPERTY`.

### Blobs

Blobs are a bit different from other properties, as they are not set directly. Instead,
one creates a blob value using `DRM_IOCTL_MODE_CREATEPROPBLOB`, and uses returned ID as a value.

When a blob is no longer needed, it can removed using `DRM_IOCTL_MODE_DESTROYPROPBLOB`. Current
value can be retrieved using `DRM_IOCTL_MODE_GETPROPBLOB`.

## CRTC

### Properties

- `ACTIVE` should the display of this CRTC be enabled
- `MODE_ID` display mode
- `VRR_ENABLED` VRR toggle
- `DEGAMMA_LUT`, `GAMMA_LUT`, `CTM` color management properties

## Plane

Every plane provides a set of compatible CRTCs.

### Properties

- `FB_ID` which framebuffer should be rendered
- `SRC_[XYWH]` source rectangle on that framebuffer,
- `CRTC_[XYWH]` destination rectangle on the CRTC,
- `CRTC_ID` the target CRTC
- (read-only) `IN_FORMATS` the list of supported pixel formats+modifiers
- (read-only) `type`. Hint of plane usage, one of "primary", "cursor" and "overlay".

Some drivers provide more properties:
- `COLOR_ENCODING`, `COLOR_RANGE` specification of the plane's color space
- `alpha` global plane opacity
- `pixel_blend_mode` alpha blending mode
- `rotation` plane rotation
- `zpos` Z-order of plane within the planes stack on CRTC

## Connector

Every connector provides:
- type, e.g. `VGA` or `eDP`
- physical size
- subpixel order
- a set of compatible encoders

### Properties

- `CRTC_ID` the target CRTC for the connector.
- `audio` Configuration of audio on the connector.
- (read-only) `TILE` Configuration of tiled displays.
- (read-only) `EDID` EDID blob. Not always available.
- (read-only) `link-status` Display connection status.
- (read-only) `max bpc` Maximum supported bit depth of the display/connector.
- (read-only) `non-desktop` 1 for connectors that are attached to displays
  not generally useful as regular desktop outputs (e.g. touchbar)
- (read-only) `subconnector` Detailed connector type
- (read-only) `vrr_capable` 1 if connector supports VRR

## Encoder

Every encoder provides:
- type, e.g. `DAC` or `LVDS`
- a set of compatible CRTCs
- a set of encoders that can be set up as mirrors

## Applying changes atomically

To apply changes to DRM objects, one creates a set of triples "object, property, new value"
and passes it to `DRM_IOCTL_MODE_ATOMIC`. The changes are either applied all at once, or none
and error is returned. For example, an error returns if the configuration of
CRTCs/planes/encoders/connectors fails to satisfy compatibility rules.

There are several flags for this `ioctl`:
- `DRM_MODE_PAGE_FLIP_EVENT`. Requests an "vblank" event to be reported by kernel whenever
  the requested changes begin to be displayed to the user.
- `DRM_MODE_ATOMIC_TEST_ONLY`. Does not apply the changes, checks if the hardware actually supports whatever was specified.
- `DRM_MODE_ATOMIC_NONBLOCK`. Do not wait for changes to be applied.
- `DRM_MODE_ATOMIC_ALLOW_MODESET`. Without this flag, only changes that do not
  cause visual artifacts may be applied. Which changes cause artifacts depends on
  the hardware/driver[^artifacts].

### Events

If requested, kernel notifies userspace when events happen. The events
can be read from the DRM file descriptor as structs `drm_event_*`.

If `DRM_MODE_PAGE_FLIP_EVENT` is specified to `DRM_IOCTL_MODE_ATOMIC`,
`drm_event_vblank` struct is sent to the fd whenever a "vblank" has happened.
Other events are related to page flipping and will be discussed separately.

## References

- [DRMDB properties](https://drmdb.emersion.fr/properties)

## Footnotes

[^non-atomic]:
	There is another interface predating atomic that provided operations to apply changes
	piece by piece. It led to various races and display artifacts, so the atomic interface
	was invented.
[^sigh]:
	Sigh.
[^artifacts]:
	Historically these were changes that caused a change of display mode, that's the reason
	for the flag name.
