<!-- TRELLIS:START -->
# Trellis Instructions

These instructions are for AI assistants working in this project.

This project is managed by Trellis. The working knowledge you need lives under `.trellis/`:

- `.trellis/workflow.md` — development phases, when to create tasks, skill routing
- `.trellis/spec/` — package- and layer-scoped coding guidelines (read before writing code in a given layer)
- `.trellis/workspace/` — per-developer journals and session traces
- `.trellis/tasks/` — active and archived tasks (PRDs, research, jsonl context)

If a Trellis command is available on your platform (e.g. `/trellis:finish-work`, `/trellis:continue`), prefer it over manual steps. Not every platform exposes every command.

If you're using Codex or another agent-capable tool, additional project-scoped helpers may live in:
- `.agents/skills/` — reusable Trellis skills
- `.codex/agents/` — optional custom subagents

Managed by Trellis. Edits outside this block are preserved; edits inside may be overwritten by a future `trellis update`.

<!-- TRELLIS:END -->

## Project Notes

These notes are project-specific operating rules for agents working in this repository. Keep the Trellis-managed block above intact.

### Current Focus

- The project is mocking local Flash platform capabilities for an original 4399 game.
- The active runtime area is `tools/saveData/`: local saves, wallet/recharge mock, mall purchase mock, resource serving, and browser host page.
- Payment and anti-cheat analysis lives in `tools/paymentLogic/README.md` and `tools/noCheat/README.md`.
- Public web access and future Windows desktop packaging boundaries are documented in `tools/saveData/packaging/README.md`.

### Setup And Checks

Use the existing npm scripts:

```bash
npm install
npm run saveData:test:db
npx tsc --noEmit
```

Run these checks after changing saveData logic, schema, or TypeScript types:

```bash
npm run saveData:test:db
npx tsc --noEmit
git diff --check
```

### Running saveData

Local-only development:

```bash
npm run saveData:serve
```

Default URL:

```text
http://127.0.0.1:8787/
```

Public access is off by default. Only expose it when the user explicitly asks:

```bash
SAVE_DATA_LOGS=0 SAVE_DATA_HOST=0.0.0.0 SAVE_DATA_PORT=80 npm run saveData:serve
```

If detailed runtime logs are needed, omit `SAVE_DATA_LOGS=0`, but prefer no-log mode for gameplay testing because logging can add I/O jitter.

When asked to close public access, stop the matching saveData server process and verify that `80` and `8787` are no longer listening:

```bash
ss -ltnp | rg ':(80|8787)\b' || true
```

### Protected Local Data

Do not delete or overwrite these unless the user explicitly asks and confirms the risk:

```text
workspace/saveData/local-save.db
workspace/saveData/remote-assets/
workspace/saveData/public/
workspace/onlineSave/raw/
workspace/onlineSave/decoded/
```

These can usually be cleaned when they are clearly temporary:

```text
workspace/saveData/logs/*.ndjson
workspace/saveData/logs/*.out
workspace/saveData/*.png
temporary FFDec logs
```

### Runtime Behavior Notes

- Local recharge and mall purchase mock data is stored in the SQLite database; it does not affect real 4399 accounts or real recharge totals.
- Mall purchase mock must stay consistent with the game's anti-cheat expectations: current balance and cumulative recharge are separate concepts, and saved mall item value is compared against cumulative recharge.
- The browser host defaults to `canvas` rendering for smoother public gameplay. Use `?renderer=webgl` only when checking original-like Flash filters such as text outlines.
- Do not duplicate save, wallet, mall, or resource-serving logic in future desktop packaging. A desktop shell should start the same `tools/saveData/src` server and load the shared `tools/saveData/public` UI in a local WebView.
