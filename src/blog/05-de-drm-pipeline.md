title: DE/compositor development notes - DRM pipeline
date: 2023-07-09
----
Once compositor has obtained the control over graphics hardware, it needs to find
out what's available for use.

DRM exposes display controllers using the following objects: framebuffers, planes, CRTCs, connectors and encoders.

## Framebuffers

Framebuffer is a bunch of pixels in memory with metadata (size, pixel format, memory layout).

Framebuffers are typically an output of rendering, either GPU or CPU.

## CRTCs and planes

Display controllers combine several framebuffers into one picture and display this picture
on physical displays.

CRTC[^crtc] is an abstraction of a display controller: it takes a number of framebuffers using
_planes_, global display propeties, such as display mode, gamma and VRR; and a number of
_connectors_ that represent hardware outputs.

Plane is a slot for a framebuffer, plus information needed for combining several planes into a
picture: position, rotation and scaling of framebuffer, blend mode, Z-position and color information.

Planes traditionally have roles: "primary", "cursor" and "overlay". DRM is role-agnostic, but
these roles hint on their expected uses (e.g. cursor planes may be limited in size and overlay
planes may support YUV pixel fomats).

A set of CRTCs and planes is fixed, and they may be matched many-to-many, though in many cards
a plane is compatible with only one CRTC. When a plane is compatible with multiple CRTCs, it
is typically an overlay plane compatible with any of them. For some devices all planes are
compatible with all CRTCs.

Planes and CRTCs are bound to one DRM device: a plane from one device cannot be compatible with
CRTC from another device.

## Connectors and encoders

Connector is a hardware output port of a display controller (think VGA or DisplayPort output).
Some connectors are wired permanently, some come and go (e.g. connecting a USB-C hub with
DisplayPort outputs causes new connectors to appear).

Connectors store output information (state of the link, DPMS state, EDID, tiling information
for tiled displays and so on).

Encoder represents a piece of hardware inside a display controller that converts pixels into
the electrical signals of a display protocol (e.g. TMDS encoder provides signals for HDMI,
DAC encoder for VGA or S-Video). Encoders are static.

Not all CRTCs are wired to supply all encoders, and not all encoders can supply all connectors,
so compositors should solve the constraints to properly select CRTCs for outputs.

### Writeback connectors

Connectors of "writeback" type are special: instead of displaying the picture on a display,
they copy it into associated framebuffer.

## Footnotes

[^crtc]:
	Cathode-ray tube controller. Yeah.
