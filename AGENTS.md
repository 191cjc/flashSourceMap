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
- The active runtime area is `runtime/save-data/`: local saves, wallet/recharge mock, mall purchase mock, resource serving, and the native Flash host page.
- The current Windows runtime path is native CEF + Pepper Flash.
- Native packaging is a self-contained portable Windows bundle with `FlashSourceMap.exe`; it starts the Node mock server and CEF host without showing a console window.
- `tools/saveData/` is now documentation and analysis context, not the runtime implementation.
- Payment and anti-cheat analysis lives in `tools/paymentLogic/README.md` and `tools/noCheat/README.md`.
- Public web access and native Flash/CEF runtime boundaries are documented in `tools/saveData/packaging/README.md`.

### Runtime Structure

Keep saveData runtime code in these layers:

```text
runtime/save-data/persistence/     # SQLite connection, schema init, repositories
runtime/save-data/services/        # save parsing, identity canonicalization, shop value rules
runtime/save-data/platform4399/    # 4399 API and FlashStoreApi protocol adaptation
runtime/save-data/server/          # HTTP routing, static assets, logging, startup
runtime/save-data/public/          # native Flash host page and side-panel scripts
runtime/save-data/schema/          # SQLite schema
runtime/save-data/tests/           # runtime flow tests
```

`tools/` is for analysis notes, FFDec/decompile helpers, and temporary diagnostics. Do not add new runtime save, wallet, shop, or resource-serving logic under `tools/saveData/`.

### Setup And Checks

Use the existing npm scripts:

```bash
npm install
npm run saveData:test:db
npm run typecheck
npm run native-flash:build-host
npm run native-flash:package
```

Run these checks after changing saveData logic, schema, or TypeScript types:

```bash
npm run saveData:test:db
npm run typecheck
git diff --check
```

Run these checks after changing native CEF, native launcher, package contents, or the native Flash page layout:

```bash
npm run native-flash:build-host
npm run native-flash:package
git diff --check
```

When only JavaScript in `runtime/save-data/public/` changes, also run `node --check` on the changed browser scripts.

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

Native Flash gameplay testing:

```bash
npm run native-flash:build-host
npm run start:native-flash:mock
```

`start:native-flash:mock` should prefer `workspace/native-host/Release/flash-native-host.exe`. The official CEF sample `cefclient.exe` can consume Space before Pepper Flash receives it, so do not switch back to it unless explicitly debugging host differences.

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
vendor/native-flash/pepflashplayer64.dll
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
- Union bootstrap continues past `applyList` with two `FlashScoreApi.submit` batches. The local rank mock must return Thrift `submit_result.success` as `map<i32, FSR_Submit>` entries with `code=10000` and `FSRE_Submit` data, or `DataIngPanelXX` never closes.
- Mall purchase mock must stay consistent with the game's anti-cheat expectations: current balance and cumulative recharge are separate concepts, and saved mall item value is compared against cumulative recharge.
- The local recharge button is disabled after the page detects that a save slot has entered gameplay, because in-game recharge can leave SQLite `total_recharged` newer than the game's in-memory `allChongGod`.
- The native Flash side panel uses fixed left-sidebar width and a game viewport matching the SWF stage (`960x600`). The CEF host must size the outer window from the desired client area and account for Windows DPI and window chrome; otherwise high-DPI screens can make the game appear half-sized.
- The native Flash side panel currently has Chinese tabs, including the wallet/recharge tab and the `体验优化` tab. Level reward boosting is always on when its generated SWF is available; the UI should show status instead of exposing a toggle.
- Do not duplicate save, wallet, mall, or resource-serving logic in native packaging. The native launcher should start the same `runtime/save-data/server` server and load `runtime/save-data/public/native.html` in CEF/Pepper Flash.
- Native packaging should store package-local caches and logs under the package `data/` directory. For save compatibility, the GUI launcher first reuses `%APPDATA%/flash-source-map/saveData/local-save.db` when it already exists; otherwise it uses `data/saveData/local-save.db` in the extracted package.
- The old desktop shell has been removed. Do not add desktop-only windowing, desktop package builders, or `desktop:*` scripts back unless the runtime strategy changes again.
- `npm run native-flash:package` writes `builds/release-assets/FlashSourceMap-NativeFlash-v*-win-x64.zip` and `.sha256`. The package contains `FlashSourceMap.exe`, Node, the custom CEF host, Pepper Flash, runtime code, resources, and a debug batch file.
- `.github/workflows/release.yml` creates GitHub Release pages for `v*` tags after running checks and can upload the native Flash release assets. It must not resurrect the old Electron desktop package.
