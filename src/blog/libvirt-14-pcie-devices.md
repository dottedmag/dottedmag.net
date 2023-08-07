title: Why does libvirt support only 14 hot-plugged PCIe devices on x86-64?
date: 2023-08-06
----
<hr>

*See the discussion of this blog post on [Hacker News](https://news.ycombinator.com/item?id=37023885)*

<hr>

You might have used `libvirt`, a Linux daemon that provides an abstraction
and management layer for virtualization software. This daemon allows you
to submit an XML file containing a description of a VM, disk image or network.
`libvirt` is then able to configure, start it and keep it running.

There is a peculiar limitation in VMs started by `libvirt`:
[they can only support up to 14 hotpluggable PCIe slots](https://bugzilla.redhat.com/show_bug.cgi?id=1408810).
Attempting to start a VM with 15 PCIe slots will fail.

14 seems like an absurdly low number, so why exactly 14? It turns out
this is the result of a chain of events that began in 1970.

## Datapoint 2200 and Intel 8008

![Datapoint 2200](dp2200.jpg)

In June 1970, the Computer Terminal Corporation announced
the [Datapoint 2200](https://en.wikipedia.org/wiki/Datapoint_2200), a programmable
computer terminal.

The Datapoint 2200 contained a primitive CPU, two of its instructions being `INP`/`OUT`.
These instructions were designed to read or write one byte of data from one
of 8 input/output ports.

![Intel 8008](8008.jpg)

Intel was tasked with consolidating a number of discrete modules in the Datapoint 2200
into one, and they came up with Intel 8008, a one-chip CPU that implemented the same
instruction set.

## Intel 8080

![Intel 8080](8080.jpg)

When Intel engineers had set out to develop a new product that eventually became
known as the Intel 8080, they were definitely inspired by the 8008 instruction set,
so the 8080 ISA contains the `IN`/`OUT` instructions, though they extended to 256
addresses.

I'm not a hardware engineer, so I'm not entirely sure why this CPU retained the
separate I/O address space instead of using memory-mapped peripherals like other CPUs.
I'll defer to [this explanation](https://retrocomputing.stackexchange.com/a/25528):
- it made peripherals cheaper
- it didn't hog the very limited address space; the 8080 only had 64 KiB available.

## Intel 8086, PC and x86-64

![Intel 8086](8086.jpg)

Intel 8086 was designed to simplify porting of software from the 8080, so it retained
the I/O instructions in the ISA. However, it expanded their addresses to full 16 bit,
allowing 65536 I/O ports.

The IBM PC [extensively used](https://en.wikipedia.org/wiki/Input/output_base_address)
I/O ports for peripherals such as the interrupt controller, system timer and keyboard.
These ports have been enshrined in PC-compatible computers ever since, although
their usage has decreased over time.

However, unlike the memory address space, which grew from 64 KiB in 8080 to 1 MiB in 8086,
and to [128PiB in Ice Lake](https://en.wikipedia.org/wiki/Intel_5-level_paging), I/O address
space has remained fixed at 65536 addresses.

## PCI

![PCI](pci.jpg)

In 1990, Intel started developing a new computer bus to replace MCA and EISA,
eventually known as PCI.

This bus acknowledged the need for peripherals to communicate with the host via shared
memory, however it also provided the option for a PCI device to [reserve a range
of I/O ports](https://en.wikipedia.org/wiki/Peripheral_Component_Interconnect#PCI_address_spaces).
Unlike the orignial PC, this reservation is not fixed; however the reserved
range had to be continuous.

I can only guess why the new bus has such an x86-specific feature. It might have
been a design decision made to simplify the adaptation of hardware peripherals
that utilize I/O ports to a new bus. Or it might have been the result of Intel
engineers designing the specification to match Intel hardware.

## PCI bridges

I/O ports reservation would not be a big issue: it was an optional feature,
so if no cards were plugged in that requested it, no I/O ports would have
to be reserved.

However, engineers working on the PCI specification developed
[PCI bridges](https://cds.cern.ch/record/551427/files/cer-2308933.pdf)
as a way to increase the address space of the bus, as a PCI bus without bridges
can only contain 63 devices.

To handle PCI devices that request ranges of I/O ports, a PCI bridge
must reserve I/O ports for itself. PCI does not support dynamic port allocation,
so every bridge must reserve I/O ports upon powering on.

Moreover, PCI bridge specification states that the reservation granularity
of I/O ports is 4K, so every bridge must allocate a minimum of 4K of I/O ports
to handle a PCI card that requests as few as one port.

PCI bridges were quite static hardware, so this was not a major consideration
when the bridges were introduced. Several 4096 I/O port blocks were allocated
from a 65536 I/O address space, and provided the PCI bus was not extraordinarily
large, it generally worked out well.

## PCIe

![PCIe](pcie.jpg)

In 2003, the PCI Express bus was created to replace the PCI and maintain
backwards compatibility.

Due to compatibility considerations, any PCIe slot is represented in the PCI
hierarchy as a PCI bridge.

You can see where it is going:
- The PCI bridge must request at least 4K contiguous I/O ports to serve cards
  that request I/O ports,
- Every PCIe slot is a PCI bridge,
- Thus, the maximum total number of PCIe slots in any PC is 16 (= 65536/4096).
  However, the actual number will be less, given the presence of legacy PC devices,
  especially in virtualized environment.

The designers of PCIe have recognized this limitation and stipulated that any
PCIe hardware must still be functional if its I/O port request is not fulfilled.

## QEMU

QEMU [has an option](https://patchwork.kernel.org/project/qemu-devel/patch/1501964858-5159-5-git-send-email-zuban32s@gmail.com/#20795751)
for PCIe root ports to disable I/O allocation.

I'm at loss as to why it's off by default. Could there be configurations where
this is not going to work, such as PCI device plugged into PCIe->PCI bridge?

Anyway, the option is available, and if used, the amount of PCIe slots
in the QEMU machine won't be limited to 16 (it will instead be limited by the number
of PCI bus numbers, as each PCI bridge uses one number, but that's a different
story).

## libvirt

![libvirt logo](libvirt.png)

Given that QEMU has provided this option for some time, one might think
it's simply a matter of adding another option to the libvirt domain definition.

It already supports a number of obscure options (you can make QEMU claim to
support a CPU feature regardless of whether the host CPU supports it, really?), so
adding one more would fit in just fine.

Nope. ["there are no plans to address it further or fix it in an upcoming release"](https://bugzilla.redhat.com/show_bug.cgi?id=1408810).

So if you wish to have more than 14 PCIe slots in your VM, you'll have to use
QEMU directly.

### Image sources

Images from Wikimedia Commons:
[1](https://commons.wikimedia.org/wiki/File:Intel_8080_open-closed.jpg)
[2](https://commons.wikimedia.org/wiki/File:Datapoint2200img.jpg)
[3](https://commons.wikimedia.org/wiki/File:Intel_8080_open-closed.jpg)
[4](https://commons.wikimedia.org/wiki/File:Intel_C8086.jpg)
[5](https://commons.wikimedia.org/wiki/File:PCI_Slots_Digon3.JPG)
[6](https://commons.wikimedia.org/wiki/File:PCI-E_%26_PCI_slots_on_DFI_LanParty_nF4_SLI-DR_20050531.jpg)
[7](https://commons.wikimedia.org/wiki/File:Libvirt_logo.svg)
