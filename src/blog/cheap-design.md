title: Cheap design
date: 2026-02-08
----
In the physical world, making things has two costs: design and fabrication.
Design is drawing up the part. Fabrication is producing it. Both are expensive,
so physical things are made from standard parts: bolts, beams, extrusions,
brackets. You accept the overhead of fasteners and adapters because custom
fabrication costs too much.

3D printing made fabrication cheap. Now a built-to-purpose bracket can be one
piece instead of an assembly of catalog parts, two bolts, two nuts, two washers
and a shim. But 3D printing has a quality penalty: layer lines, anisotropic
strength, limited materials. So standard parts survive wherever strength and
precision matter.

Software has only ever had one cost: design. Fabrication — compilation,
copying — is cheap, and has been from the start. But design is labor, and labor
is expensive, so software converged on the same pattern as physical
manufacturing: build from standard parts. Libraries, frameworks, package
managers. The `node_modules` folder is a junk drawer of standard components,
except the drawer is the size of a room. `go.mod` is a curated
components library with a card catalog — you still don't make the
parts yourself, but at least you know what's in there.

This has the same consequences as in the physical world. You adapt your design
to the available parts. You write glue code, configuration, and adapters. You
accept someone else's idea of an interface. You inherit someone else's bugs
and deprecation schedule. You deal with transitive dependency conflicts.
You accidentally build two nuclear power plants to run a night lamp on the
porch (one is a backup). The resulting system is larger, more complex, and
more fragile than the ideal solution, but each individual part is (presumably)
well-tested, and the alternative — writing everything from scratch — is too
expensive.

## Jigs

In machining, a jig holds a workpiece in place during an operation. It is
a one-off tool, built for a specific task. Before 3D printing, making a jig
meant machining it from metal or wood, so you'd only make one if the production
run justified it. Small shops would skip the jig and do things by hand: slower,
less accurate, but cheaper than the tooling.

3D printing made jigs cheap. Now every small shop can afford custom fixturing
for every job.

Note that dies — the tooling for mass production, injection molds and
extrusion dies — are still expensive. Nobody 3D prints an injection mold.
The analogy only works for the cheap end of tooling.

Software has its own jigs: migration scripts, data format converters, one-off
test harnesses, log analyzers for a specific bug, importers, exporters. Before
LLMs, these were either not written at all (you'd wrangle the data in a
spreadsheet by hand) or assembled from libraries that don't quite fit. The
tooling cost exceeded the benefit, so you'd skip it.

LLM-assisted coding collapsed this cost. The jig that wasn't worth writing
is now generated, used, and discarded. And unlike the physical world,
the analogy doesn't stop at jigs.

## Better than 3D printing

In the physical world, 3D printing is limited to jigs and prototypes
because printed parts are weaker than machined ones. A 3D-printed jig has layer
lines, limited thermal resistance, it creeps under load. There is an inherent
quality penalty. For a jig it usually doesn't matter, but it prevents 3D
printing from replacing standard parts in production.

LLM-generated code has no such penalty. It is made of the same bytes. It runs
on the same CPU. If it is correct, it is indistinguishable from hand-written
code. The quality ceiling is the same.

More custom code means more code to test. But you were already testing library
behavior indirectly through your own code — now it's directly testable. And
tests themselves are cheap to generate and can target the actual problem space.

This is as if 3D printing suddenly produced parts with the material properties
of machined steel. In that world, the standard-parts catalog becomes much less
interesting. Why assemble a bracket from catalog parts when you can print one
that's just as strong, fits exactly, and has no fasteners?

Same question applies to software: why import a library and write glue around
it when you can generate a module that does exactly what you need?

## What changes

The [dependency calculus](https://dottedmag.net/blog/dependencies/) flips.

The old question: "is there a library for this?" The new question: "is this
problem hard enough to justify taking on a dependency?"

Cryptography — yes, use a library. Compression — yes. An HTTP
client — yes, HTTP/2 and TLS alone justify it. These are genuinely hard
problems.

An ORM that imposes its own model of your data in exchange for saving you
from writing SQL — maybe. A logging framework with pluggable backends when
you need JSON to stderr — probably not. A configuration library with layered
overrides, hot-reloading and a remote config server when you need to read
five environment variables — no.

There is a real counterargument: when a vulnerability is found in a standard
library, you update a version number. When a vulnerability is found in custom
code, you have to know about it, find it, and fix it. Cheap design creates
surface area for expensive maintenance.

This is why the line between "use a library" and "generate it" matters more
than before. Drawing it correctly is the most impactful design decision
in the cheap-design world. Crypto, compression, HTTP, TLS — these sit on
the "library" side not just because they are hard to implement, but because
they are hard to maintain: the stream of CVEs never stops, and tracking them
is a full-time job.

The categories of harmful dependencies — trivial wrappers, opinionated
clients, unstable abstractions over stable interfaces — are the first
casualties. They existed because writing the equivalent code by hand took
twenty minutes and nobody wanted to spend twenty minutes. Now it takes twenty
seconds.

The result: codebases become smaller for the same amount of functionality.
Custom code that does exactly what you need is almost always shorter
than a library import plus the glue, configuration and adapters to make it fit.
In the standard-parts world, "custom" meant "reimplemented everything badly."
In the cheap-design world, "custom" means "one piece, designed for this exact
purpose." Less dependency management, less glue, less accidental complexity
from adapting your problem to someone else's abstraction.

## What doesn't change

Design got cheaper, not free. The cost moved, it didn't disappear.

What matters more now is understanding the problem you are solving: the business
logic, the edge cases, the constraints. What matters less is the mechanical
knowledge of how to express the solution in code. The LLM generates code, not
understanding.

The standard-parts model was a rational response to expensive design. If design
is cheap, the model is due for a revision.

3D printing pioneers promised "a factory in every home." It worked up to a
point: you can print a phone stand, not a phone. LLM-assisted coding is
id Software's engineering department on your laptop. We've seen their code.
It's tight, purposeful, no unnecessary parts. That's what cheap design
enables: not more software, but better-fitting software.

In the physical world, cheap fabrication gave us 3D-printed rockets
that are lighter and cheaper than the ones assembled from standard parts.
I wonder what cheap design will give us in software.

<hr>

*[Comments here](https://news.ycombinator.com/item?id=46932797)*
