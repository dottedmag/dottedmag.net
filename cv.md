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

# What do I do?

## Software design

Software systems need both functionality and properties such as flexibility,
adaptability and ease of operations. I know how to isolate layers, invert
dependencies, partition systems, evict state, add immutability, split interfaces
and make a thousand other small and large decisions to make it happen.

Requirements change all the time: I know how to do an MVP, and avoid spending
months implementing features nobody wants.

Complexity creeps in. I know how to prune unwanted statefulness, remove layering
violations, keep the interfaces minimal.

All software is distributed now: Web SPA is, and a mobile app too. I know how to
manage upgrades, do a staged rollout client- and server-side, collect metrics
and log messages. I know how to deal with old versions of client software
suddenly reappearing out of the blue. I know how to version REST protocols to
avoid breakages, but to stay flexible.

## Software development

Give me a task, I'll do it. Or better: give me a problem and I'll solve it.

I always try to see the big picture: can this problem be solved without writing
new code? By deleting the code we already have? By a change in an internal
process? Or by using an external service (price, SLA)? Does this problem need to
be solved at all?

## (Distributed) team leadership

I have an experience leading small engineering teams (from 2 to 8 people), both
on-site and distributed (with timezones spread from UTC-4 to UTC+8), both in
commercial setting and in a voluntary cooperation around an open source project.

I like this kind of work, and would like to do it again, especially in an
environment where management and technical leadership are separated.

## Reengineering and refactoring

Is your legacy system a mess? Does implementing new feature takes ages, bugfixes
cause more problems than they solve, system administrators have to apply
enormous amount of effort to keep it running?

This is something I can and like to tackle. I have experience decluttering
various software systems, getting rid of creeping statefulness and streamlining
operations.

## Tools

I know my tools. I have introduced CI into several projects, bootstrapped an
embedded Linux distribution and all of its infrastructure, and wrote a countless
number of tests, makefiles and scripts.

## DevOps / SRE

Server configuration management is so XX century (I'm saying this as
[a major contributor to CFEngine](https://github.com/cfengine/core/graphs/contributors)).

Read-only stateless containers are a good thing (I added a [container-related tool in util-linux](https://git.kernel.org/pub/scm/utils/util-linux/util-linux.git/tree/AUTHORS#n71)).

I'd like to work on a project which either already uses or switches to existing
tools, such as Docker and Kubernetes. Implementing infrastructure bits and
pieces from scratch is a lot of fun and one can spend enormous amount of time on
it, but it does not bring any customer-facing value.

# What can't (won't) I do?

* NEW FEATURES-NEW FEATURES-NEW FEATURES-NEW FEATURES. There are many people who
  are way too happy to create new features. I'd rather prevent the whole system
  from collapsing into a Big Ball of Mud.
* Client-side. I'm reasonably proficient in working with client-side functional
  UI libraries (React, Reagent), but it is not my forté.
* PHP.
* Perl.
* Windows as a mandated development environment.

# What do I want?

* Remote work (unless the company offices are located on Malta).
* Flexible work schedule, to a reasonable extent.
* Good salary.

# Projects/Companies

## [Open Source](/software)

I have [contributed numerous patches](/software) to various open source
projects, mostly fixing problems I have encountered.

Are you running Ubuntu or Debian? Say `apt-cache show libssh2-1` and see the
Maintainer field.

Are you running Linux? Check out the `AUTHOR` stanza in `man 1 unshare`.

## [Hola!](https://hola.org) / [Luminati](https://luminati.io) (2013+)

Wearing my SRE hat, I have improved insight into performance of Hola services,
by adding
- centralised application-level logging, and
- application-level metrics,

which made it much easier to pinpoint and resolve performance problems and bugs.

I have created several internal-facing statistic dashboards for Hola VPN and
also user-facing statistics for Hola Spark CDN.

For Luminati I have implemented a custom in-memory DB to track the status of 1M+
peers of Luminati network, which decreased the price of hardware running this
database by 8x compared to the off-the-shelf DB.

## [Debian](https://debian.org/) (2006+)

I maintain several packages in Debian, mostly "scratching my own itch".

My Debian experience usually makes me a "resident Debian/Ubuntu expert" in the
companies I work for.

## [CFEngine](https://cfengine.com) (2011-2013)

I have thrust CFEngine from SunOS 4 times into 21 century (not single-handedly,
but pushing hard for the changes), converting it from R&D-ware to a reliable
software package along the way, adding unit and system testing, continuous
integration, discernible release management and other useful software
engineering practices.

## [OpenInkpot](https://wiki.mobileread.com/wiki/Openinkpot) (2007-2012)

A Linux distribution for eBook readers. It got eventually killed by Kindle, but
it was fun while it lasted.

I have started it, have built the infrastructure (from bugtracking to
cross-compiling Debian packages in CI environment to repository manager) and was
BDFLing it until it withered out.

Also I've got the experience managing distributed team in addition to the
previous experince working in one.

## [Parallels](https://parallels.com) (2004-2007)

For Plesk for Unix I have created (in a team) a tool for transferring contents
of competing hosting panels to Plesk, which then was repurposed as a backup
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

# Buzzwords (yay Ctrl-F!)

## 5Y+ experience in/with

C, Javascript, Node.js, Debian, Make, TCP/IP, Python, git, Linux, Korn-like
shells, POSIX/SUSv3, CFEngine.

## 3Y+ experience in/with

MongoDB, C++, various Internet protocols, REST interfaces, ElasticSearch, AWS.

## 1Y+ experience with

Clojure, Perl, other Unices, XSLT, Java, Django, Eclipse RCP, SQLite,
PostgreSQL.

## Have a good grasp of

OO, functional, structured and other kinds of programming. OO and functional
design. Various tools and toolchains (CI, builds, testing etc).

## Toyed with

Various Lisps, Go, Docker, Haskell, React, Ruby, OCaml, Rust, Erlang, C#, J2EE
(old one), Google Cloud Platform, Kubernetes, Ansible, Salt, Puppet, and
everything else on the front page of Hacker News.
