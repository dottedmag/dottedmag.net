title: How to add a new feature to Wayland?
date: 2025-04-14
----
The Wayland development process is often quite frustrating for application developers.
When they discover missing functionality by Wayland and try to request it
they find series of closed bugs and discussions development channels that go nowhere.

I'll try to demystify the process a bit and explain the reasons why this is happening
and how to avoid it.

So read on if you'd like to request new functionality. And if you need help in any step
of the process, drop into Wayland development channels and ask for help.

## Wayland principles

The biggest source of confusion is the mismatch between application developers'
expectations for a UI framework and Wayland principles. Wayland does not strive
to be familiar or have feature parity with other UI frameworks. Instead, it has the
following principles that override everything else:

- Security. Applications must not be able to spy on each other through Wayland. Unlike X11, the only trusted component in Wayland is the compositor.
- Compositor interoperability. Wayland specifies behaviour in terms of intent, not physical interaction, so that different Wayland compositors may all implement it consistently.
- Fidelity (aka "every frame is perfect"). Wayland is specified to allow implementations without visual glitches.

## How to apply these principles?

### Step zero: Reformulate missing functionality in terms of intent

Drop any references to how it is done under other UI frameworks. Not "I need to grab the whole screen", but
"The application is trying to share a window/desktop content". Not "I'd like to grab the mouse", but "The
application is trying to use mouse as a relative pointing device, like games do". Not "I'd like to position
this window in absolute coordinate space", but "The application would like to open a pop-up menu".

This step is crucial. Without this reformulation, it's impossible to evaluate whether this functionality
is already present in Wayland/XDG portals, what its scope if it isn't, and where it belongs.

### Step one: Does the missing functionality require obtaining data from other _uncooperating_ applications?

If it does, then it runs afoul of the principle of security. This behaviour will never be added to the Wayland protocol.
It either should go to compositors or to an XDG portal.

As an example, screen sharing was initially requested to be an application feature where an application could
unilaterally grab the whole screen, and then it was narrowed down to a compositor mediating access via an sXDG portal
with the user's control and awareness of what is being shared.

If your functionality belongs here, then start a discussion either in your compositor's development channels, if
it is closely tied to the compositor, or in XDG portals development channel if it looks useful across the compositors.

Most of functionality from the "accessibility" category in other UI frameworks belongs here.

### Step two: Re-check assumptions

Does the missing functionality still have assumptions about the behaviour of a compositor? Does it assume that
windows are laid out as overlapping rectangles? Does it assume that pixels in an application correspond to pixels
on screen?

If it does, then it's still not a pure intent but a mechanism. Try to strip it further to find a user's intent
behind it.

### Step three: Formulate a concrete use-case

The general format is as follows:
- An application is trying to provide _the following functionality_ to the user.
- It is missing _this_ kind of information/control to do so.

It's better if you can find several use-cases.

Note that the format calls for _concrete_ use-cases, not generalities. Note that the format calls for functionality
as it it provided to the _user_, not for implementation details.

### Step four: Discuss

Now that you've got your functionality cleaned up from implementation details, assumptions from other UI frameworks,
and checked that the functionality is not security-sensitive, please start the discussion.

You'll need everything you have collected on the previous steps:
- concrete use-cases
- reasoning why the use-cases cannot be implemented using existing Wayland functionality
- reasoning why the functionality belongs to Wayland, and not to a compositor or XDG portal
- reasoning why the functionality can be implemented across compositors consistently

Also, throw in information on how other UI frameworks implement the same functionality, for the reference.

Does it sound overly bureaucratic? In a way, yes. On the other hand, you wouldn't be banging on the door of a
standardization's body meeting that specifies sizes of hydraulic tubes while holding in your hands an oval pipe you
bought from aliens on Mars and demanding that they make your country's connectors compatible with it, would you?
Wayland is this kind of plumbing.
