title: Dependencies
date: 2022-12-01
----
## Why dependencies are useful?

- Quick prototyping
- Bugs are someone's else concern
- Reverse engineering is someone's else concern
- Complicated algorithms and cryptography are someone's else concern
- Security-critical code testing is someone's else concern

## Why dependencies are problematic?

- Balooning build times
- Balooning build graph (hence tools slow down)
- Someone's else ideas of interfaces
- Someone's else ideas how to structure programs
- Someone's else ideas about build and code generation
- Someone's else bugs, and the authors of dependencies have their own priorities for bugfixing
- Someone's else release and deprecation schedules
- Conflicts due to transitive dependencies

## Useful dependencies

- Algorithmics, such as cryptography and compression
- Stable interfaces for unstable external systems (scraping, unstable APIs etc)
- Parsing, including basic network protocols: JSON, HTTP, XML et al.

By and large, slower the dependency changes (without accumulating known bugs) more potentially useful it is.

## Harmful dependencies

- Trivial wrappers around REST APIs
- Opinionated clients, libraries, helpers
- Abstractions over stable interfaces, especially unstable abstractions

## An experience of dependectomy in a medium-scale Go project (~300 kLOC)

- Removing dependency does not make the code longer. Majority of removals made the code shorter.
- Build (especially link stage) becomes significantly faster.
- Linting becomes significantly faster.
- Non-REST protocols are painful but doable (small subset of Mongo protocol and Protobuf can be written in several
  hours, though it's definitely not production-grade. We try to avoid these protocols in production).
