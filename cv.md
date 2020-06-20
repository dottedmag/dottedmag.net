---
layout: page
menu_title: CV
title: Mikhail Gusarov - CV
toplevel: true
weight: 2
---

# Contact information

- Mikhail Gusarov
- E-mail [me@mikhailgusarov.com](mailto:me@mikhailgusarov.com)
- Phone +356 99100291 (timezone is UTC+1)

# Summary

I design, develop, maintain and run software systems with a focus on long-term
maintainability, and lead small teams doing so.

# What do I do?

## Software design

Software systems need both functionality and properties such as flexibility,
adaptability and ease of operations. I know how to isolate layers, invert
dependencies, partition systems, evict state, add immutability, split interfaces
and make tons of other small and large decisions to make it happen.

Requirements change all the time. I know how to do an MVP to avoid spending
months implementing features nobody wants.

Complexity creeps in. I know how to prune unwanted statefulness, remove layering
violations, keep the interfaces minimal.

All software is distributed now: Web SPA and mobile apps are distributed systems
too. I know how to manage upgrades, do a staged rollout client- and server-side,
collect metrics and log messages, how to deal with old versions of client
software suddenly reappearing out of the blue and how to version REST protocols
to avoid breakages while staying flexible.

## Software development

Give me a task, I'll do it. Or better: give me a problem and I'll solve it.

I always try to see the big picture: can this problem be solved without writing
new code? By deleting existing code? By a change in an internal process? Or by
using an external service (price, SLA)? Does this problem need to be solved at
all?

## (Distributed) team leadership

I have experience leading small engineering teams (from 2 to 8 people), both
on-site and distributed (with timezones spread from UTC-4 to UTC+8), both in
commercial setting and in a voluntary cooperation around an open source project.

I like this kind of work and would like to do it again, especially in an
environment where management and technical leadership are separate roles.

## Reengineering and refactoring

Is your legacy system a mess? Does implementing a new feature take ages, do
bugfixes cause more problems than they solve, do system administrators have to
apply enormous amount of effort to keep it running?

This is something I am able to do and like to tackle. I have experience
decluttering various software systems, getting rid of creeping statefulness and
streamlining operations.

## Tools

I know my tools. I have introduced CI into several projects, bootstrapped an
embedded Linux distribution and all of its infrastructure, and wrote a countless
number of tests, makefiles and scripts.

## DevOps / SRE

Server configuration management is so XX century (I'm saying this as
[a major contributor to CFEngine](https://github.com/cfengine/core/graphs/contributors)).

Read-only stateless containers are a good thing (I added a [container-related tool to util-linux](https://git.kernel.org/pub/scm/utils/util-linux/util-linux.git/tree/AUTHORS#n71)).

I'd like to work on a project that either already uses or switches to existing
tools, such as Docker and Kubernetes. Implementing infrastructure bits and
pieces from scratch is a lot of fun and one can spend enormous amount of time on
it, while it does not bring any customer-facing value.

# What I can not (will not) do

* NEW FEATURES NO MATTER WHAT-NEW FEATURES NO MATTER WHAT-NEW FEATURES NO MATTER
  WHAT. There are many people who are way too happy to create new features and
  never look back at the mess created. I'd rather take additional time making
  sure the new functionality integrates with the rest of the system and does not
  contribute to a Big Ball of Mud.
* Client-side all day long. I'm reasonably proficient in working with client-side functional UI libraries (React, Reagent), but it is not my forté.
* PHP.
* Perl.
* Windows as a mandated development environment.

# What do I want?

* Remote work (unless the company offices are located on Malta).
* Flexible work schedule, to a reasonable extent.

# Projects/Companies

## [Open Source](/software)

I have [contributed numerous patches](/software) to various open source
projects, mostly fixing problems I have encountered.

Are you running Ubuntu or Debian? Say `apt-cache show libssh2-1` and see the
Maintainer field.

Are you running Linux? Check out the `AUTHOR` stanza in `man 1 unshare`.

## [Ridge](https://ridge.co) (2018+)

I am a software architect of Ridge project.

I am responsible for eliciting and developing users' needs, formulating
requirements for Ridge, shaping the architecture to fulfill these needs.

I am also responsible for code reviews and for for improving project tooling.

## [Hola!](https://hola.org) / [Luminati](https://luminati.io) (2013-2018)

Wearing my SRE hat, I have improved insight into performance of Hola services,
by adding
- centralised application-level logging, and
- application-level metrics

that made it much easier to pinpoint and resolve performance problems and bugs.

I have created several internal-facing statistic dashboards for Hola VPN and
also user-facing statistics for Hola Spark CDN.

While working on Luminati I have implemented a custom in-memory DB to track the
status of 1M+ peers of Luminati network that decreased the price of hardware
running this database by 8x compared to the off-the-shelf DB.

## [Debian](https://debian.org/) (2006+)

I maintain several packages in Debian, mostly "scratching my own itch".

My Debian experience usually makes me a "resident Debian/Ubuntu expert" in
companies I work for.

## [CFEngine](https://cfengine.com) (2011-2013)

I have thrust CFEngine from SunOS 4 times into 21 century (not single-handedly,
but pushing hard for the changes), converting it from R&D-ware to a reliable
software package along the way, adding unit and system testing, continuous
integration, discernible release management and other useful software
engineering practices.

## [OpenInkpot](https://wiki.mobileread.com/wiki/Openinkpot) (2007-2012)

A Linux distribution for eBook readers. It was fun while it lasted until Kindle
killed it.

I have started it, have built the infrastructure (from bugtracking to
cross-compiling Debian packages in CI environment to repository manager) and was
BDFLing it until it withered out.

Also I've got the experience managing distributed team in addition to the
previous experince working in one.

## [Parallels](https://parallels.com) (2004-2007)

For Plesk for Unix I have created (in a team) a tool for transferring contents
of competing hosting panels to Plesk, which was then repurposed as a backup
system.

OpenFusion project was my first spell as a software architect. I have designed
SSO mechanism for Parallels apps, and also
a [Web applications packaging format](http://www.apsstandard.org/)
([Wikipedia page](https://en.wikipedia.org/wiki/Application_Packaging_Standard)).

## Other

| From | To | Name  | What it was/is about? |
| - | - | - | - | - |
| 2009 | 2010 | IPlinux | Unwillingly started a Debian-based embedded distro to build OpenInkpot on top of something after previous base distribution got abandoned by the primary developer. Worked OK, but OpenInkpot was always the main focus. |
| 2007 | 2009 | ALT&nbsp;Linux | I was maintaining distro bugtracker, bringing development documentation into order and creating internal web apps for analysis of development process. |
| 2003 | 2004 | Axmor | As a member of IBM Solutions Group team I was doing R&D work for IBM, evaluating new cool technologies of the time for potential usefulness for IBM projects. Also doubled as system administrator. |
| 2003 | 2003 | Novosoft | An intern! My first "real" place of work. Billing system based on Cisco NetFlow. |

# Keywords/Experience

## 30Y+ experience in

Russian language (native).

## 10Y+ experience in

C, Linux, Make, Debian, Korn-like shells, POSIX/SUSv3.

## 5Y+ experience in

C++, Javascript, Node.js, TCP/IP, Python, git, CFEngine.

Norwegian language (upper intermediate).

## 3Y+ experience in

MongoDB, various Internet protocols, REST interfaces, ElasticSearch, AWS.

## 1Y+ experience in

Clojure, Perl, various Unices, XSLT, Java, Django, Eclipse RCP, SQLite,
PostgreSQL.

## Have a good grasp of

OO, functional, structured and other kinds of programming. OO and functional
design. Various tools and toolchains (CI, builds, testing etc).

## Toyed with

Various Lisps, Go, Docker, Haskell, React, Ruby, OCaml, Rust, Erlang, C#, J2EE
(old one), Google Cloud Platform, Kubernetes, Ansible, Salt, Puppet, and
everything else on the front page of Hacker News.
