# Backend Development Guidelines

> Runtime contracts for the local saveData service, global data service, and generated Flash compatibility assets.

## Guidelines Index

| Guide | Description | Status |
|-------|-------------|--------|
| [Platform Runtime Contracts](./platform-runtime-contracts.md) | Cross-layer union, arena, online identity, and SWF patch contracts | Active |

## Pre-Development Checklist

- Read `platform-runtime-contracts.md` before changing `runtime/save-data/`, `runtime/global-data/`, or platform-facing SWF patches under `src/swf/`.
- Trace native URL rewriting through the Windows saveData boundary before adding or changing a global route.
- For arena changes, verify that every returned rank candidate can resolve a complete save by the same UID/gameId/slot tuple.
- For online profile changes, verify global profile, local account, save identity fields, and remote save revisions remain aligned.

## Quality Check

- Run `npm run saveData:test:db`, `npm run globalData:test`, `npm run typecheck`, and `git diff --check`.
- Inspect generated SWF compatibility state when changing `src/swf/` patch logic.
- Assert transient arena mirrors do not change player, save, or rank row counts.
