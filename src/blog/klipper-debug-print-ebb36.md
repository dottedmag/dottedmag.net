title: Klipper: BTT EBB36 debug print over serial
date: 2023-12-15
----
Debugging [Klipper](https://www.klipper3d.org/) communication with
a MCU is not trivial: Klipper has debug commands, but these commands
use the same communication protocol that might being debugged.

[My Klipper branch](https://github.com/dottedmag/klipper/tree/debug-print)
adds `debug_print` function that outputs text to the serial port for
STM32G0B1 MCU.

The board I was debugging is [BTT EBB36](https://biqu.equipment/products/bigtreetech-ebb-36-42-can-bus-for-connecting-klipper-expansion-device?variant=39760665149538).
It does not have a serial port header, so I had to reuse a couple of probe pins:

![BTT EBB36 pinout](pinout.jpg)
