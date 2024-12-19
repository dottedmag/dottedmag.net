title: Systems are sticky
date: 2024-12-05
----
A friend of mine has observed that pedestrian crossings in Cyprus still use buttons of British design, despite Cyprus
having been independent from the UK for 64 years now.

That's not surprising: systems are _very_ sticky.

Pedestrian crossing buttons are a part of Cyprus's road traffic control system, consisting most obviously of traffic
lights and push buttons, as well as underground sensors, control relays, substations, and central control stations.

Imagine a tender is put out to replace the ageing pushbuttons with new ones, and one of the bidders proposes a new type
of pushbutton, say, of German manufacture, at a slightly lower price per unit. Let's enumerate the most obvious
dependencies of the button:

- Physical interfaces. Pushbuttons may connect to poles in different ways, potentially requiring a non-trivial amount of
  rework.

- Electrical interfaces. Pushbuttons transmit and receive information to the hub controlling the particular road
  intersection, so the communication interface must match, or an adapter must be provided. Moreover, they might have
  different power requirements.

- Programming interfaces. Pushbuttons now contain MCUs, so they need to communicate with hubs via a compatible protocol.

- Legal interfaces. Cyprus's road regulations are closely modelled on UK road regulations, so any legal requirements,
  such as accessibility or mandated indicators, are likely met by a UK manufacturer and have be taken into account
  by other manufacturers specifically for a bid in Cyprus.

- Operational interfaces. Cyprus's road administration will need to stock spare parts, equip and train their maintenance
  personnel to service two kinds of traffic control buttons.

To overcome this amount of friction, a new proposal must be much more economical than the existing one. For example, if
new pushbuttons operate on any power source from 12V to 240V, create a mesh network eliminating the need for maintaining
control wires, tap into existing control interfaces using cheap radio relays, and provide telemetry that enables
just-in-time servicing, thereby significantly reducing the amount of maintenance, and if the price per unit is
significantly lower than that of existing units, then switching to a new system becomes possible.

Without radical shifts like those described above, existing systems prevail by inertia, compatibility, and investment.
