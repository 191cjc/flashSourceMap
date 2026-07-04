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
- The active runtime area is `runtime/save-data/`: local saves, wallet/recharge mock, mall purchase mock, resource serving, and browser host page.
- `tools/saveData/` is now documentation and analysis context, not the runtime implementation.
- Payment and anti-cheat analysis lives in `tools/paymentLogic/README.md` and `tools/noCheat/README.md`.
- Public web access and future Windows desktop packaging boundaries are documented in `tools/saveData/packaging/README.md`.

### Runtime Structure

Keep saveData runtime code in these layers:

```text
runtime/save-data/persistence/     # SQLite connection, schema init, repositories
runtime/save-data/services/        # save parsing, identity canonicalization, shop value rules
runtime/save-data/platform4399/    # 4399 API and FlashStoreApi protocol adaptation
runtime/save-data/server/          # HTTP routing, static assets, logging, startup
runtime/save-data/public/          # shared browser/WebView UI
runtime/save-data/schema/          # SQLite schema
runtime/save-data/tests/           # runtime flow tests
apps/saveData-desktop/             # Electron desktop shell
```

`tools/` is for analysis notes, FFDec/decompile helpers, and temporary diagnostics. Do not add new runtime save, wallet, shop, or resource-serving logic under `tools/saveData/`.

### Setup And Checks

Use the existing npm scripts:

```bash
npm install
npm run saveData:test:db
npm run typecheck
```

Run these checks after changing saveData logic, schema, or TypeScript types:

```bash
npm run saveData:test:db
npm run typecheck
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
- The browser host prefers Ruffle `webgl` rendering for Flash filters, and uses Ruffle `deviceFontRenderer: "canvas"` so Windows browsers/WebViews can render the game's device fonts (`SimSun`, `宋体`, `微软雅黑`, etc.) through system fonts. This is different from Ruffle's main canvas renderer. If WebGL cannot be created, Ruffle may still fall back to its canvas renderer; check `ruffle.renderer` client logs before assuming the active renderer. `?deviceFonts=embedded` is a fallback/diagnostic mode that loads generated SWF font aliases from `/font-aliases/*.swf`; keep it off by default because it is heavier than system device-font rendering.
- The local recharge button is disabled after the page detects that a save slot has entered gameplay, because in-game recharge can leave SQLite `total_recharged` newer than the game's in-memory `allChongGod`.
- Do not duplicate save, wallet, mall, or resource-serving logic in future desktop packaging. A desktop shell should start the same `runtime/save-data/server` server and load the shared `runtime/save-data/public` UI in a local WebView.
- Desktop packaging should store `local-save.db`, WAL/SHM files, resource caches, generated public assets, and logs in a user data directory, not in the application install directory.
- GitHub Release packaging is driven by `.github/workflows/release-desktop.yml`; push a `v*` tag to build and upload the Windows desktop zip package.
