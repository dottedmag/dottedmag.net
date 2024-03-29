title: New Linux desktop environment
date: 2021-12-26
----
I am developing a new Linux desktop environment. This may sound odd in
2021, desktop environments being a part of Linux landscape for the last
20 years, so why I'm doing it?

Obviously, I'm not satisfied with the available options (not only on Linux,
but also under macOS, but there is no chance to having better desktop environment
for macOS).

More specifically, I do not see an existing solution that successfully
covers the following needs:
- deep work,
- dynamic hardware and networking environment,
- hackability.

## Deep work

Deep work, or work in the state of the flow, requires environment that minimises
distractions and promotes formation of habits.

Existing desktop environments are not scoring high on these counts:

* Visible latency of desktop environments is a constant source of distraction.
  One can often _see_ the lag of GNOME desktop, even on a last-generation video
  card! This means keystrokes and mouse clicks often get misdelivered or lost,
  and this breaks the formation of habits: one can start forming a habit by
  using keystrokes or mouse actions, only to see it crumbling when one becomes
  good at this habit, as latency kicks in and breaks the flow.

* Application laggines creates unneeded source of distraction too. While desktop
  environment may not do much in this regard, there is not enough work for
  detection of laggy applications popping up their windows in the middle of
  unrelated operation.

* Stability. One might think that after 20 years of development desktop environments
  finally settled down, but [this is not what happens](https://gitlab.gnome.org/GNOME/gnome-shell/-/commit/7298ee23e91b756c7009b4d7687dfd8673856f8b).
  Due to lack of hackability (see below), this makes upgrades very disruptive.

* Notification systems are a nuisance, and desktop environments, while
  acknowledging their distraction potential, and providing crude ways to disable
  notifications, do not have a good solution for important, non-urgent
  notifications.

## Dynamic hardware and networking environment

Desktop environments are no longer used on PCs encased in tower cases sitting
on the floor with peripherals connected to them before boot. Hence the
desktop environment has to give user the control over the hardware and networks
coming and going dynamically, and the following is the _minimal_ list:

- WiFi connectivity
- Mobile broadband connectivity
- VPNs
- Bluetooth input and output (keyboards, mices, trackpads, audio)
- USB peripheral devices (mass storage, eGPUs)
- Displays (HDMI, DisplayPort, Thunderbolt, DB-over-USB tunneling)
- Thunderbolt access control
- Various weird stuff, like pairing Logitech mice and keyboards using
  their special dongles.

This rules out any Wayland compositors except KDE and GNOME: like X11 window
managers, many niche Wayland compositors are scoring high in the "deep work"
department, but they do not provide the user with any tools for hardware
management.

As a side-note, wlroots-enabled compositors are doubly disqualified
[as wlroots project won't merge support for NVidia drivers due to political reasons](https://github.com/danvd/wlroots-eglstreams).

## Hackability

If the software was perfect, hackability won't be needed. Alas it is not, so
to overcome the imperfections of software we still have to improve it.

Hackability is a freedom often touted by open source advocates, but this
freedom is very hard to exercise in reality for existing desktop
environments.

Imagine a single person trying to change a way GNOME shell works. How does one
learn how to do it, how does one prepare, how does one execute the change, and
how does one integrate this change?

Direct dependencies of `gnome-shell` package in Debian include 64 packages,
including JavaScript and Python interpreters. The whole list of obviously
GNOME-related indirect dependencies is over a hundred packages long.

How does one understand which piece of code to change? By wading around in the
source code that contains tons of boilerplate?

How does one create a debug environment for experimenting with GNOME shell?
GNOME shell contains a lot of C code, so all the libraries have to be rebuilt in
debug mode. I don't see a documentation how to do it in a way that does not
ruin the system one is developing on. NixOS comes close, and actually provides
a way to integrate changes back to the running system, but
[it comes with its own set of drawbacks](/2021/10/18/linux-is-not-os).

Once this is done, how one uses the changed code, especially if the fix is not
in the shell itself (as a leaf package it could easily be replaced), but in a
library? What if the change is spread over several packages?

Hackability can't be introduced into a large system once it's built, so
there is no hope it can be added to existing desktop environments.

## Project

The project is named [5DE](https://github.com/5de), and the goals for the project
are as stated above: try to make a Linux desktop environment that facilitates
deep work, handles dynamic hardware/networking environment of computers and
provides hackability.

There is not much there yet, and I will be documenting its progress in this blog
for the time being.
