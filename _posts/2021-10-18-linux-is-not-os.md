---
layout: post
title: "Linux is not OS"
---
# Linux is not OS

TL;DR: Every Linux distribution is a separate OS. Niche Linux distributions will
never enjoy even the modest application selection available for mainstream Linux
distributions.

## Operating systems and why they matter

Operating system is software that sits directly atop computer hardware, and performs multiple functions, namely
- sharing resources between applications,
- isolating applications from each other,
- providing applications with a stable interface to access the hardware.

Operating systems by themselves are useless, they exist solely to enable
applications to be run.

Stable interface is the crucial invention that enables applications: without it
every application would have to be ported to every combination of hardware in
existence, an untenable task[^1].

## Linux distributions are operating systems

Operating system is defined by its interface: syscalls, file layout, packages
and package managers, services and libraries, function call ABI etc.

Linux and GNU projects do not produce operating systems. Both projects produce
source code, one for the kernel, another for userspace components.

Every Linux distribution takes the source code produced by Linux, GNU and other
projects, and combines them into an operating system, deciding on syscall
interface, file layout, available libraries and other aspects that together
specify the operating system interface.

Different distributions make different choices, and therefore they are closely
related operating systems, but not a single OS. Even Linux syscall interface
subtly changes from distribution to distribution, as they pick and choose
options to build their kernels.

In practice this means that application developers are unable to target "Linux",
they have to target many Linux distributions. This is most evident when clicking
"Download" button that opens a menu with the set of packages to choose from, but
even if the package for a particular package manager is available, the installed
application may not work if it was not tested on this particular distribution.

## Consequences for niche Linux distributions

Every niche Linux distribution that does not follow the interface of a larger
one is a unique OS, closely related but not compatible with other Linux OSes.
This means the applications have to be ported.

Application developers have to choose what targets their applications support.
With Linux distributions being just a blip on the graph of operating systems
popularity, the application developers may not invest significant amount of
resources into porting and testing.

Even this blip is hopelessly fragmented: there are hundreds of Linux
distributions. Therefore the only realistic option for application developers is
to care about several largest distributions, if they care about Linux at all.

This places the burden of porting and testing on the niche distribution makers,
which means that the only most popular and easily ported applications will be
available.

## Q&A

### Aren't Snap and Flatpak designed to run applications on any Linux distribution?

This is true. Snap and Flatpak can be seen as virtualized operating systems.

Some underlying variations still leak through the abstraction (e.g. the set of
supported Linux syscalls may vary based on distribution's kernel configuration),
but the resulting ABI is way stabler than the native one.

For the applications that do not require system services beyond what's available
in Snap and Flatpack sandboxes this target is the least painful way to support
Linux.

### Shouldn't application authors stick to the published API, and let distribution authors build and package their software?

This is totally fine. However note that this means application authors merely
supply more raw ingredients, and distribution authors have to make/port
applications for their OS out of these ingredients[^2].

### Shouldn't application authors stick to the standards to make porting trivial?

It does not work.

First, there aren't many great standards out there to stick to. LSB is outdated.
SUSv4 only covers basic syscalls and shell. X11 and Wayland are low-level, and
contain numerous extensions.

Second, existing standards cover a small subset of functionality provided by
Linux and userspace libraries. Standards do not cover `signalfd(2)` or GTK4.

Third, even if porting is made relatively trivial, there is additional per-OS
work of testing the application. Application authors have at least be aware of
existence of a particular niche distribution to be able to test and release
their application, and with distributions counting in hundreds this is not
feasible.

### I don't care about anything that's not packaged by the distribution

This is totally fine. Just note that you are using a niche OS with a limited set
of applications available.

## Footnotes

[^1]:
    Some small platforms (ZX Spectrum, C64) could get away with it for a while by having a stable set of hardware, however this approach does not work long-term, due to sheer number of computer components and periphery produced.
    Manufacturers of these platforms got bitten by the hardware stability when they introduced new versions of their computers.
    Application developers were disincentivised to use new features because they also had to target large install base of older computers, so new computers didn't provide any benefits to the end users due to lack of applications, and both Sinclair and Commodore ultimately closed down.

[^2]:
    Moreover, a free software license is not a universally sound choice for software authors. This limits the set of applications available for the distributions that insist that the application packaging and testing has to be done by the distribution maintainers.
