title: PCI basics
date: 2023-08-02
----
PCI is a bus: there is a number of wires, PCI devices (targets in PCI parlance)
connected to these wires, a protocol how to make it all work and PCI
host controller that arbitrates bus access and provides interface for
CPU to talk to the devices.

## Multiple buses

There is a limited amount of devices that can be addressed on a single
PCI bus, so PCI can be extended by _bridges_: a PCI-PCI bridge attaches
a separate PCI bus (wires, slots, devices etc) to a main bus.

CPU addresses these extended buses through the same PCI host controller,
and bridges take care of routing commands to the proper device.

Bridges are PCI devices themselves, so they occupy an address on a
bus they are connected to.

## Domains

There might be several independent sets of PCI devices (e.g. several host
PCI controllers on a mainboard chipset). Each of these sets are called
PCI domain.

## Functions

One PCI device (e.g. pluggable card) may implement several functions
(e.g. sound card and joystick controller used to be a common combo),
so PCI provides for up to 8 separate functions on a single PCI device.

## Device addressing

Any PCI device is addressed as `[domain:]bus:device.function` (BDF).

Amount of PCI domains is not limited, though in practice in PCs there
is only one domain 0, omitted from the PCI device addresses.

There might be 256 PCI buses in a PCI domain.

There might be 32 devices on a single PCI bus.

One device might have from 1 to 8 functions. Function `.0` is required to
be present, other functions, if any, may be assigned any number from 1 to 7.

### Example

There is only one PCI domain in the example system, so it is omitted.

`10:00.4 Audio device: Advanced Micro Devices, Inc. [AMD] Starship/Matisse HD Audio Controller`

The device is on the PCI bus `10`, and the device itself is `00`. There are multiple functions
on the device, and function `.4` is audio controller.

Bus `10` is claimed by the bridge `00:08.1 00:08.1 PCI bridge: Advanced Micro Devices, Inc. [AMD] Starship/Matisse Internal PCIe GPP Bridge 0 to bus[E:B]`,
and this bridge is sitting on the main bus `00` with device address `08` and function `.1`.

Other functions of the device include `.0 Starship/Matisse Reserved SPP` (not used by Linux),
`.1 Starship/Matisse Cryptographic Coprocessor PSPCPP` (cryptographic coprocessor),
and `.3 Matisse USB 3.0 Host Controller` (USB 3.0 controller). `.2` is not populated,
and the the functions seem to be completely unrelated, so it is a composition of several
unrelated controllers designers of mainboard chipset exposed as a single PCI device either to
conserve PCI bus space, or to make the chipset a bit cheaper to produce.

## Configuration space

Configuration space is 256 (4096 for PCIe) bytes that can be read/written by the host.
This is done by sending `Configuration Read` / `Configuration Write` command to PCI bus
with the BDF address and offset in configuration space. On PC these requests are typically
mapped to several MMIO registers: one sets an address and offset in a couple of registers,
and reads the retrieved data from the data register.

## Memory space

Any PCI device might request some memory to be mapped. This is communicated by BAR
(base address) registers in configuration space. Host can query the amount of memory
requested, and then set the BARs to the values that are distinct from memory of other
PCI devices. Once done, the device will respond to `Memory Read` / `Memory Write`
PCI commands on the bus for the specific region.

On PC, a memory read/write, if it failed to be served by RAM or other memory-mapped devices,
is typically passed to PCI controller that issues `Memory Read` / `Memory Write` command.

This means that on a PC OS kernel should set up memory mapping of PCI devices so that the
ranges do not overlap with memory ranges claimed by other devices (RAM etc).

## I/O space

Any PCI device may also request I/O space mapping. This is also communicated by BAR registers.

On PC I/O space is mapped to `in`/`out` I/O ports. There are only 65536 I/O ports, and some
of them are claimed by other devices, so allocating and assigning a _range_ of I/O ports for
a PCI device might be a huge problem.

## Device discovery

Every PCI device is required to return answer to configuration space requests, so discovery
is simple: read first 2 bytes of configuration space for every possible device.
If the result is not 0xffff, then the device is present.

To enumerate functions, read `Header Type` byte (offset `0xd` in configuration space), and
see if 7th bit is set. If it is, probe functions `.1` to `.7`.

To descend into bridges, check `Header Type` byte, ignoring "multiple functions" bit. If it is
1, then the device is a PCI-to-PCI bridge. This device needs to be configured with bridge bus
number, and then the devices on this bus can be enumerated[^bus-config].

## DMA, IRQ etc

Not covered (yet).

## References

- [PCI addressing](https://stackoverflow.com/questions/49050847/how-is-pci-segmentdomain-related-to-multiple-host-bridgesor-root-bridges/49090341#49090341)
- [PCI bus info](https://www.waste.org/~winkles/hardware/pci.htm)
- [OSDev PCI](https://wiki.osdev.org/PCI)
- [OSDev PCI Express](https://wiki.osdev.org/PCI_Express)

## Footnotes

[^bus-config]:
  This is tricky to get right, so [see this article for details](https://www.science.unitn.it/~fiorella/guidelinux/tlk/node76.html).
