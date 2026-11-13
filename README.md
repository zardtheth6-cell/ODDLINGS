# ODDLINGS — Project Review Repository

**STEAL. ESCAPE. COLLECT. EARN. PROTECT.**

A Roblox creature-collecting / stealing / base-raiding simulator, built in Roblox Studio
(place: `oodlings`, placeId 116527791032115, universeId 10776423801).

This repository is a **review export** of the Studio place. Roblox Studio is the source of
truth; nothing here is synced back into the game automatically.

## Layout

| Folder | Contents |
|---|---|
| `src/` | Every Luau script, exported 1:1 from the place file, in Explorer order (`.server.lua` = Script, `.client.lua` = LocalScript, `.lua` = ModuleScript) |
| `docs/` | Architecture, implementation status, test results, hierarchy, environment notes, manual setup |
| `screenshots/` | Captures of the map, territories, bases, creatures and UI taken from Studio |
| `place/` | `ODDLINGS.rbxl` — the binary place file this export was generated from (backup) |
| `tools/` | `extract_rbxl.js` — regenerates `src/` and `docs/HIERARCHY_FULL.md` from a `.rbxl` place file (Node 22.15+) |

## Re-exporting after changes

1. In Studio: **File → Save to File As…** and save over `place/ODDLINGS.rbxl`.
2. `node tools/extract_rbxl.js place/ODDLINGS.rbxl src docs/HIERARCHY_FULL.md`
3. Commit and push.

Start with [`docs/IMPLEMENTATION_STATUS.md`](docs/IMPLEMENTATION_STATUS.md).

## Export verification

All 25 scripts were extracted from the place file; byte sizes were checked against the live Studio session and match exactly.
