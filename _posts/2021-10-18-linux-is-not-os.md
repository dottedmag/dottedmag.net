---
layout: post
title: "Linux is not OS"
---
TL;DR: Linux is not an operating system. GNU/Linux is not an operating system
either. A Linux distribution is. This is important for niche distrbutions.

## What is operating system anyway?

There are many definitions of operating systems. For this blog post by operating
system I mean a software that fulfills two functions:
- shares hardware resources of a computer between several programs that have
  utility for the user (applications),
- provides applications with a stable interface to make use of these hardware
  resources.

Some operating systems only support a single application, therefore the second
function, the stable interface, is the crucial one.

## Why Linux or GNU/Linux is not OS?

Linux is a source code of an operating system kernel. GNU is a source code of
operating system userspace components. These are raw ingredients for build an
OS.

Linux distributions vary greatly: file locations, libraries, build options,
package formats, ABI variants. This is best seen by comparing radical
distributions with mainstream, e.g. NixOS with RHEL, but even mainstream
distributions vary: it's not given that an application built for Ubuntu will
work on RHEL.

The interface is defined by the distribution. Different distributions expose
similar, though not fully compatible interfaces, and therefore they are closely
related operating systems, but not a single OS. Even Linux syscall interface
subtly changes from distribution to distribution, as they pick and choose
options to build their kernels.

## Shouldn't application authors stick to the published API, and let distribution authors build and package their software?

This is totally fine. However note that this means application authors merely
supply more raw ingredients, and distribution authors have to make/port
applications for their OS out of these ingredients.

As an aside, a free software license is not a universally sound choice for
software authors. This limits the set of software available for the OS.

## Isn't proprietary software evil?

No.

## Shouldn't application authors stick to the standards to make porting trivial?

It does not work.

First, there aren't many great standards out there to stick to. LSB is outdated.
SUSv4 only covers basic syscalls and shell. X11 and Wayland are low-level, and
contain numerous extensions.

Second, existing standards cover a small subset of functionality provided by
Linux and userspace libraries. Standards do not cover `signalfd(2)` or GTK4.

## Aren't Snap and Flatpak designed to run applications on any Linux distribution?

This is true. Snap and Flatpak can be seen as virtualized operating systems.

Some underlying variations still leak through the abstraction (e.g. the set of
supported Linux syscalls may vary based on distribution's kernel configuration),
but the resulting ABI is way stabler than the native one.

## What are the consequences for niche Linux distributions?

Every niche Linux distribution that does not follow the ABI, set of libraries,
set of local services and file organization of the larger one is a unique OS,
closely related but not necessarily compatible with other Linux OSes. This means
the software has to be ported.

This is most evident in case of a radically new way of OS userspace
organization, e.g. NixOS: all software for NixOS undergoes a (sometimes hackish)
process of porting: changing paths for data, shared libraries, `RPATH`.

Application developers are resource-constrained, as everything in this world.
This means they have to choose what targets their applications support. With
Linux distributions being just a blip on the graph of operating systems
popularity, the application developers may not invest significant amount of
resources into porting and testing.

Even this blip is hopelessly fragmented: there are hundreds of Linux
distributions and dozens of package managers. Therefore the only realistic
option for application developers is to care about several largest
distributions, if they care about Linux at all.

This places the burden of porting and testing to the distribution makers, and
niche distributions do not possess enough resources to do it themselves, which
means that the only most popular software will be supported there.

## What if I do not care about software except packaged by the distribution?

This is totally fine. Just note you are using a niche OS with a limited set of
software.

## Isn't all this discussion moot as all the software is in the Web?

Not yet.
