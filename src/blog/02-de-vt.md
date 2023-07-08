title: DE/compositor development notes - Linux VT
date: 2023-07-07
----
Before drawing anything on screen compositor should ensure it
owns the screen it wants to draw on, or the results won't look
good: several processes or kernel may draw over whatever compositor
has drawn[^example].

Under Linux, VT subsystem draws terminals on various screens
attached to computer[^novt], so the compositor has to cooperate
with it. VT subsystem simulates several physical consoles on a single
display, providing functionality to create, destroy and switch between
several consoles.

Consoles are named from 1 upwards and represented as character devices
`/dev/ttyN`. One of them is active at any time. `/dev/tty0` is alias
for the currently active console.

## Text/graphics mode

Every console might be in text or graphics mode. In text mode VT
subsystem draws the text, the cursor and handles idle blanking.
In graphics mode VT subsystem does not do anything. To draw anything
to screen, compositor should pick a console and switch it to graphics
mode. On exit it should restore the previous mode, or text console
won't be redrawn[^exit].

Text/graphic mode is activated by `ioctl` `KDSETMODE`.

## VT switching

Switching between consoles is started by by pressing a special
key[^kmap] (handled by kernel itself), or by issuing `ioctl`
`VT_ACTIVATE`[^gfxkmap].

For consoles in text mode kernel handles saving and restoring content
on switch, for graphics consoles kernel expects applications to redraw
themselves.

## Auto/process-controlled VT switching

Every console might be in one of two modes:
- auto VT switching,
- process-controlled VT switching.

This mode is set by `ioctl` `VT_SETMODE` that takes three parameters:
- the mode: auto/process-controlled[^ackacq],
- the signal to send on console deactivation
- the signal to send on console activation (see below).

If console is in auto mode nothing happens if it is activated
(switched to) or deactivated (switched from).

If console is in process-controlled mode then both activating
and deactivating console is coordinated with the process that
owns the console:
- on console deactivation kernel sends the process that owns the
  console being switched from a signal and awaits that process to
  call `ioctl` `VT_RELDISP` to mark the console as released.
- on console activation the same happens on console being
  switched to.

How kernel knows which process to send the signal to? It sends
the signal to the process that called `VT_SETMODE`.

## References

- `console_ioctl(4)`
- `seatd` source code
- `Xfree86` source code

## Footnotes

[^example]:
	For example, if compositor is started from the virtual console and uses
	it instead of switching to a new one and without telling VT to stop
	drawing, its own stdout and stderr will be written over the its own
	output.
[^novt]:
	If not compiled with `CONFIG_VT=n`.
[^exit]:
	Actually, Linux contains a kludge to work around it: on console switch
	Linux checks if the process that was supposed to draw on the console
	died, and switches the console to text mode if it did.
[^kmap]:
	Linux console input map contains actions "switch to console N", "switch
	to next console", "switch to previous console". In most console keymaps
	these are bound to [Ctrl+]Alt+FnX, [Ctrl+]Alt+{Left,Right}.
[^gfxkmap]:
	That's how X server and Wayland compositors implement switching to
	another VT. They disable VT console input, so they have to handle the
	keys themselves.
[^ackacq]:
	`ioctl_console(2)` manpage also lists `VT_ACKACQ`, but that's not a mode,
	it's an argument for `VT_RELDISP`.
