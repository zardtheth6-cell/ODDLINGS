# Architecture

Server-authoritative. Clients only *request* actions; the server validates and decides.

## Server — `ServerScriptService`

`MainServerBootstrap` (Script) requires every service, calls `Init(S)` then `Start(S)` in a fixed order,
owns the player lifecycle, the `Request` RemoteFunction dispatcher, station prompts, territory
barriers/enforcement and portals. A Studio-only test hook (`ServerStorage.__TestRunner`) is wired
only when `RunService:IsStudio()` is true.

| Module (`Server/`) | Responsibility |
|---|---|
| AntiExploitService | Token-bucket rate limits, safe-zone checks, speed sanity check, server teleports |
| PlayerDataService | DataStore load/save with session locking, retries, versioned reconcile/migration, autosave, BindToClose, debounced client sync |
| EconomyService | Cash/gems, central 1 Hz income loop, upgrades, items, capacity, territory unlocks, XP/levels, titles, daily rewards, rebirth, selling, client snapshot |
| MonetizationService | Game-pass ownership (MarketplaceService), developer-product `ProcessReceipt` with duplicate protection and save-or-rollback |
| BaseService | Plot assignment/release, creature displays, door/alarm/laser/shield/detection logic, upgrade visuals |
| CreatureService | Wild spawning by rarity+luck, guardian AI (5 behaviour types, Humanoid-driven, one 10 Hz loop), carrying, wild theft, player snatching, base raids, delivery, atomic ownership transfer |
| BatCombatService | Free bat tool + cosmetic skins, server-side swing/hit validation, stun, knockback, immunity |
| EventService | Scheduled world events: Golden Oddling, Stampede, Meteor, Blackout, Rare Visitor |
| LeaderboardService | OrderedDataStore boards (5 stats) with live-server fallback; physical boards + UI |

## Shared — `ReplicatedStorage`

- `Shared/Config` — all balancing: rarities, 20 creatures, territories, guardians, movement, upgrades, security, raid rules, bats, game passes/products (asset IDs), items, daily, rebirth, titles, events, sounds.
- `Shared/CreatureBuilder` — builds every Oddling and guardian from parts; used by wild spawns, carried creatures, base displays and collection previews.
- `Remotes/` — `Sync, Notify, Swing, Raid, Intruder, Effect, WorldEvent, CarryState, Settings` (RemoteEvents) and `Request` (RemoteFunction).

## Client — `StarterPlayer.StarterPlayerScripts`

`ClientMain` (LocalScript) builds all UI at runtime and wires controllers in `Client/`:
UIKit, State, HUDController, ShopController, CollectionController, PanelsController,
MovementController, CombatController, EffectsController, InputController.

## Assets

`ServerStorage/EnvironmentAssets/WorldKit` — the prop/architecture kit used to build the map in Studio
(edit-time tooling; not required at runtime).
