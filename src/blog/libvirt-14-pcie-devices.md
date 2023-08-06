title: Why does libvirt support only 14 PCIe hotplugged devices on x86-64?
date: 2023-08-06
----
There is a curious limitation in VMs started by `libvirt`:
[they can only have 14 hotpluggable PCIe slots](https://bugzilla.redhat.com/show_bug.cgi?id=1408810),
trying to start a VM with 15 PCIe slots will fail.

14 sounds like a ridiculously low number, so why 14? Turns out
it is a result of a series of events starting back in 1970.

## Datapoint 2200 and Intel 8008

![Datapoint 2200](dp2200.jpg)

In June 1970, Computer Terminal Corporation announced
[Datapoint 2200](https://en.wikipedia.org/wiki/Datapoint_2200), a programmable
computer terminal.

Datapoint 2020 contained a primitive CPU, and two of the instructions of that
CPU were `INP`/`OUT`. These instructions read or wrote one byte of data from one
of 8 input/output ports.

![Intel 8008](8008.jpg)

Intel was tasked with collecting a number of discrete modules into one,
and came up with Intel 8008, one-chip CPU that implemented the same instruction
set.

## Intel 8080

![Intel 8080](8080.jpg)

When Intel engineers had set out to develop a new product that eventually became
known as Intel 8080, they definitely were inspired by 8008 instruction set,
so 8080 ISA contains instructions `IN`/`OUT`, albeit extended to 256 addresses.

I'm not a hardware engineer, so I'm not entirely sure why this CPU retained the
separate I/O address space instead of using memory-mapped peripherals like other CPUs.
I'll defer to [this explanation](https://retrocomputing.stackexchange.com/a/25528):
- it made peripherals cheaper
- it didn't hog the memory space that was very limited (8080 only had 64 KiB of address space)

## Intel 8086, PC and x86-64

![Intel 8086](8086.jpg)

Intel 8086 was designed to make porting software from 8080 easy, so it kept
I/O instructions in the ISA, though extending their addresses to full 16 bit,
whole 65536 I/O ports.

IBM PC [has made an extensive use](https://en.wikipedia.org/wiki/Input/output_base_address)
of I/O ports for peripherals such as interrupt controller, system timer or keyboard,
and thus these ports were enshrined in PC-compatible computers ever since, though
their use has decreased over time.

However unlike memory address space that grew from 64 KiB in 8080 to 1 MiB in 8086
to [128PiB in Ice Lake](https://en.wikipedia.org/wiki/Intel_5-level_paging), I/O address
space remains fixed at 65536 addresses.

## PCI

![PCI](pci.jpg)

In 1990, Intel has started developing a new computer bus to replace MCA and EISA,
eventually known as PCI.

This bus acknowledged the need of peripherals to communicate with host via shared
memory, however it also provides the option for a PCI device to [reserve a range
of I/O ports](https://en.wikipedia.org/wiki/Peripheral_Component_Interconnect#PCI_address_spaces). This reservation is not fixed unlike original PC, but the reserved
range has to be continuous.

I can only guess why the new bus has got such a x86-specific feature. It might be
the design decision to ease adapting hardware peripherals utilizing I/O ports
to a new bus. Or it might be the result of Intel engineers designing spec to
match Intel hardware.

## PCI bridges

I/O ports reservation would not be a big issue: it was an optional feature,
so if no cards were plugged in that requested it, no I/O ports would have
to be reserved.

However, engineers working on PCI specification came up with
[PCI bridges](https://cds.cern.ch/record/551427/files/cer-2308933.pdf),
the way to increase the address space of the bus (PCI bus without bridges can
contain only 63 devices).

To be able to handle PCI devices requesting ranges of I/O ports, a PCI bridge
has to reserve I/O ports for itself. There is no dynamic range allocation in
PCI, so any bridge has to reserve the I/O ports on power on.

Moreover, PCI bridge specification says that I/O ports reservation granularity
is 4K, so every bridge has to allocate at least 4K of I/O ports to be able to
handle a PCI card that requests as little as 1 port.

PCI bridges were quite static hardware, so this was not a large consideration
when the bridges were introduced. Several 4096 blocks were allocated out of 65536
I/O address space, and unless the PCI bus was enormous it all worked out quite well.

## PCIe

![PCIe](pcie.jpg)

In 2003, PCI Express bus has been created to replace and simultaneously be
backwards-compatible with PCI.

Due to compatibility considerations any PCIe slot is represented in PCI
hierarchy as a PCI bridge.

You can see where it is going:
- PCI bridge has to request at least 4K contiguous I/O ports to be able to
  serve cards that request I/O ports,
- Every PCIe slot is a PCI bridge,
- Thus, the total maximum number of PCIe slots in any PC is 65536/4096 = 16,
  or less, as there might be some legacy PC devices still around, especially
  in virtualized environment.

The designers of PCIe has recognized this limitation and stipulated that any
PCIe hardware must still be functional if its I/O port request is not fulfilled.

## QEMU

QEMU [has an option](https://patchwork.kernel.org/project/qemu-devel/patch/1501964858-5159-5-git-send-email-zuban32s@gmail.com/#20795751)
for PCIe root ports to disable I/O allocation.

I'm at loss why it's off by default. Maybe there are configurations where
this is not going to work? PCI device plugged into PCIe->PCI bridge?

Anyway, the option is there, and if it is used, then the amount of PCIe slots
in the QEMU machine is not limited to 16 (it is going to be limited by number
of PCI bus numbers, as every PCI bridge takes one number, but that's a different
story).

## libvirt

![libvirt logo](libvirt.svg)

Given that QEMU has exposed this option for some time, one would think
it's just a matter of adding another option to libvirt domain definition.

It already supports a number of obscure options (you can make QEMU claim to
support a CPU feature no matter if the host CPU supports it, really?), so
yet another one woild fit in just fine.

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
