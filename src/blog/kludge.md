title: Kludge design pattern
date: 2024-08-26
----
# Kludge

Kludge allows one to quickly implement a requested change with no regard for long-term maintainability of the codebase.

## Also Known As

- Band-Aid
- Crutch

## Motivation

There is a codebase that does not lend itself to the requested change:
either because the codebase is not in a good shape, or because the deadline is looming,
or because the programmer is unfamiliar with the code.

## Applicability

The biggest appeal of a kludge is its wide applicability: it can be applied to any piece of the code to solve a problem at hand.

## Structure

Kludge consists of a chunk of unprincipled code applied with no respect for existing code structure.

## Consequences

Applying a kludge to a codebase pushes it slightly in direction of applying more kludges.
After a while the only possible operations on the codebase in question become applying another kludge and abandoning it altogether.

## Known Uses

All around you.

## Related Patterns

Many original GoF design patterns may be considured kludges covering deficiencies in underlying programming languages of the era.
