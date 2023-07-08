title: Codenames
date: 2023-07-08
----
Codenames are useful.

Whenever we develop software we invent names. Tons of names. VCS repository
names, directory names, executable names, package names, class names, function
names, configuration file names, database names, usernames. The list goes on.

A natural impulse is to use your product's name in these names. After all,
if you are developing X it makes sense to name things after X.

The problem is that most of the time we don't know how the project will turn
out: the product might (and probably will) change its the target audience,
format and may metamorphose completely.

You can guess what happens in this case: public-facing identifiers will
be changed quickly, but internal ones will lag: the ones that are easy to
change will be changed eventually, the ones that are hard will get stuck.

Now imagine the public name changing several times over the lifetime of the
project.

The codebase will accrete all names used by the product in past. From time to
time a heroic effort will be applied to clean the old cruft, as it becomes
harder and harder to explain to new team members that X, Y, Z and W are
actually the same thing. It will _mostly_ succeed, except that one place
that requires somebody to spend an hour in a SaaS console somewhere... However
there is a backlog of features, so let's postpone it to another day...

Changing identifiers is a huge waste of time. Use codenames instead.

Codename is an internal techincal identifier. It is guarded from marketing.
It is not allowed to escape to the public. It is stable. It is used everywhere
where internal identifiers are needed, starting from the name of VCS repository.

Use codenames as much as you can. Don't leak them to the users though.

P.S: If you develop desktop software, more details of your software leak
to the users: configuration files or main executables should be named
after marketing name. The life is much easier for SaaS or mobile apps:
user-facing domains, UIs, marketplace entries and APIs have to use marketing
names, everything else is hidden from the users and should use the codename.
