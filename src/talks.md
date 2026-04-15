title: Talks
----
# "One little config," they said

Configuration files were invented when software developers and operators became separate groups,
so that the operators could adjust the software for their local environments without bothering the
developers.

Configuration files come at a cost:
- they use their own languages with worse ergonomics and tooling than the programming languages used for the code,
- they are often limited in expressivity,
- they need serializers and deserializers,
- they have to be read at runtime,
- they come with their own deployment complexities.

SaaS systems are often developed and operated by the same people, so the initial motivation for separate
configuration files no longer applies.

Why don't we put the configuration back into the source code, thus removing serializers, deserializers, DTOs,
schemas, command-line flags, bolted-on templating overlays, and poor parser error messages?

Just create a package `config`, define an environment variable `PROJECT_ENV` for selecting the current
environment, put secrets into KMS, and off you go.

This solution doesn't always work (which one does?), but when it fits, it works gloriously: whole swaths of
plumbing code disappear.

- [Slides](https://github.com/dottedmag/talks/blob/master/configs-2026-04-15/gusarov-2026-04-15-configs-malta-tech-talks.pdf)

15 Apr 2026, [Malta Tech Talks](https://maltatechtalks.com/).

# You're Wasting Most of Your Production CPUs

Modern CPUs are beasts of performance. Are you sure your Python program uses significant part of this power? Or even your C program?
This talk gives you a glimpse of what has changed in CPUs in the last 30 years, and why it's important to software engineer's day-to-day work and month-to-month AWS bill.

- [Slides](https://github.com/dottedmag/talks/blob/master/perf-2025-05-22/gusarov-2025-05-22-perf-malta-tech-talks.pdf)
- [Source code](https://github.com/dottedmag/talks/tree/master/perf-2025-05-22/src)

Blog posts, documentation and papers mentioned in the talk:
- [Apple Silicon CPU Optimization Guide](https://developer.apple.com/documentation/apple-silicon/cpu-optimization-guide) (needs Apple account)
- HAProxy [The State of SSL Stacks](https://www.haproxy.com/blog/state-of-ssl-stacks)
- T0ST [How I cut GTA Online loading times by 70% ](https://nee.lv/2021/02/28/How-I-cut-GTA-Online-loading-times-by-70/)
- McSherry, Isard, Murray [Scalability! But at what COST?](https://www.usenix.org/system/files/conference/hotos15/hotos15-paper-mcsherry.pdf)
- Drake [Command-line Tools can be 235x Faster than your Hadoop Cluster](https://adamdrake.com/command-line-tools-can-be-235x-faster-than-your-hadoop-cluster.html)

Recommended:
- [Performance-Aware Programming Series](https://www.computerenhance.com/p/table-of-contents), a paid course (not mine :-).

22 May 2025, [Malta Tech Talks](https://maltatechtalks.com/).
