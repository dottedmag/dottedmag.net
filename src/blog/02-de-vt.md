title: DE/compositor development notes - Linux VT
date: 2023-07-07
----
Before drawing any visuals on screen, the compositor must ensure it
owns the screen it wishes to draw on. If it doesn't, the results
won't look good, as multiple processes or the kernel may draw over
the compositor's output[^example].

In Linux, VT subsystem draws terminals across multiple screens
attached to computer[^novt], so the compositor needs to cooperate
with it. The VT subsystem emulates multiple physical consoles on a single
display, providing functionality to add, destroy and switch between
these consoles.

Consoles are numbered beginning from 1 and represented as character
devices `/dev/ttyN`. Only one of them is active at a time. `/dev/tty0` is
an alias for the currently active console.

## Text/graphics mode

Every console can be in text or graphics mode. In text mode, the VT
subsystem manages text rendering, cursor display and idle blanking.
In graphics mode, the VT subsystem does not do anything. To draw anything
on the screen, the compositor must pick a console and switch it to graphics
mode. On exit, it must restore the previous mode; otherwise the text console
will not be redrawn[^exit].

The text/graphic mode is selected by `ioctl` `KDSETMODE`.

## VT switching

Switching between consoles begins by pressing a special
key[^kmap] (managed by the kernel itself), or by issuing `ioctl`
`VT_ACTIVATE`[^gfxkmap].

The kernel manages the saving and restoring of content for consoles in text mode.
For graphics consoles, the kernel expects applications to self-redraw.

## Auto/process-controlled VT switching

Every console can be in one of two modes:
- automatic VT switching,
- process-controlled VT switching.

The mode is selected by `ioctl` `VT_SETMODE` that takes three parameters:
- the mode: auto or process-controlled[^ackacq],
- the signal sent on console deactivation (release signal)
- the signal sent on console activation (acquire signal).

The process that called this `ioctl` becomes the console owner.

If the console is in auto mode, nothing happens when it is activated
(switched to) or deactivated (swiched from).

If the console is in process-controlled mode, both its activation
and deactivation are coordinated with the owning process:
- on deactivation, the kernel sends the release signal to the owning process.
  The kernel then waits for that process to call `ioctl` `VT_RELDISP`,
  marking the console as released.
- The same procedure occurs on console activation: the acquire signal is
  sent to the owner of the console being switched to.

## References

- `console_ioctl(4)`
- `seatd` source code
- `Xfree86` source code

## Footnotes

[^example]:
	For instance, if compositor is started from the virtual console, using
	it directly instead of switching to a new one, and without compositor
	telling VT to stop drawing, its own stdout and stderr will overwrite
	its output.
[^novt]:
	If it is not compiled with `CONFIG_VT=n`.
[^exit]:
	Actually, Linux includes a kludge for this situation: whenever console
	switch occurs, it checks whether the owning process has died. If it did,
	Linux switches the console back to text mode.
[^kmap]:
	The Linux console input map provides actions "switch to console N", "switch
	to next console" and "switch to previous console". Typcially, these actions
	are bound to key combinations [Ctrl+]Alt+FnX, [Ctrl+]Alt+{Left,Right}.
[^gfxkmap]:
	That's how X server and Wayland compositors implement switching to
	another VT. They disable the VT console input, so they must handle the
	keys themselves.
[^ackacq]:
	`ioctl_console(2)` manpage also mentions `VT_ACKACQ`, but it's not a mode;
	instead, it's an argument for `VT_RELDISP`.
