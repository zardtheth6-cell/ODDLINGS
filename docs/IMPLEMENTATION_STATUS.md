# Implementation status (as of 2026-11-13)

Legend: ✅ built and tested in Studio · 🟡 built, not yet tested (needs multiple players or live servers) · ⚙️ needs manual setup

## Gameplay systems

| System | Status | Notes |
|---|---|---|
| Wild spawning (rarity + luck, per-territory caps, respawn) | ✅ | 32 wild Oddlings active across 4 territories |
| Guardian AI (Slow / Fast / Ambush / Persistent / Large) | ✅ | Chase → capture → creature returns → player respawns at base observed |
| Stealing, carrying, carry penalty, delivery | ✅ | Income starts on delivery |
| Sprint / stamina / dash / slide | 🟡 | Implemented client-side with server speed sanity check; not exercised with real input |
| Player-to-player snatching | 🟡 | Needs 2+ players |
| Base raids (timer, cooldowns, beginner protection, atomic transfer) | 🟡 | Needs 2+ players |
| Free bat + cosmetic bats | ✅ / 🟡 | Granted + equipped verified; hits on players need 2+ players |
| Security: door, alarm, lasers, shield, detection | ✅ / 🟡 | Purchases, door visuals, shield on/refusal verified; intruder triggers need 2+ players |
| Upgrade visuals on bases (cameras, sirens, pylons, banners) | ✅ | 31 decor parts shown for a test profile |
| Cash, gems, passive income | ✅ | |
| Upgrades, items, capacity, territory unlocks | ✅ | Invalid / unaffordable requests rejected |
| Game passes | ⚙️ | Code complete; asset IDs are 0 in `Config` until created on the Creator Dashboard |
| Developer products / ProcessReceipt | ✅ ⚙️ | Duplicate receipt granted once; unknown product refused; IDs still to configure |
| Daily rewards | ✅ | Double-claim refused |
| Rebirth | ✅ | Resets cash/upgrades/territories, keeps creatures/security/purchases |
| Titles, levels, collection milestones | ✅ | |
| Collection index | ✅ | Uses shared definitions + the same model builder |
| World events (5) | ✅ | All started and cleaned up without errors |
| Leaderboards | ✅ | Global OrderedDataStore boards render |
| Saving / loading (session lock, retries, BindToClose) | ✅ | Progress persisted across Studio sessions; failed-DataStore path untested |

## Interfaces

All built at runtime by the client: Main HUD, Shop (Upgrades / Gamepasses / Items), Security, Base,
Collection, Daily, Rebirth, Leaderboards, Profile & Titles, Settings, carry/raid/event/intruder HUDs,
notifications, mobile touch controls. Visually verified on PC in Studio; not tested on a real phone.

## Environment

See [ENVIRONMENT.md](ENVIRONMENT.md). ~10,500 parts total, StreamingEnabled with persistent bases, gates and portals.

## Known limitations

- Animations are procedural (no uploaded animation assets); slide pose is visible only to the sliding player.
- Sounds use Roblox's built-in client sounds; no music, birdsong, wind or lava audio.
- Raid-transfer saves write the victim first: a crash between the two saves can lose (never duplicate) a creature.
- UI is created at runtime, so it does not appear in `StarterGui` while editing.

## Manual setup still required

1. Create game passes + developer products on the Creator Dashboard; paste their IDs into `ReplicatedStorage.Shared.Config` (`GamePasses[*].assetId`, `Products[*].assetId`).
2. Game Settings → Security → *Enable Studio Access to API Services* (for Studio testing).
3. Run a multiplayer test: Test tab → Clients and Servers (2–3 players) for raids, snatching, bat hits and base traps.
