# AFTERHOURS Roblox Technical Architecture

## Architecture goals
Build a maintainable, secure Roblox experience with clear ownership boundaries. The server is authoritative for round state, objectives, captures, inventory, currency, rewards, purchases, cooldowns, and saved progression. The client owns presentation, input collection, camera effects, local animation presentation, and responsive UI.

## Recommended service boundaries
- Bootstrap: starts services in a deterministic order and reports startup failures.
- RoundService: round lifecycle, phase transitions, timers, win/loss resolution.
- MatchmakingService: solo/co-op/Creature queue coordination and teleport preparation.
- PartyService: invites, membership, leader transfer, ready state and party cleanup.
- PlayerStateService: per-round state, role, status, stamina authority and safe state transitions.
- MovementService: validates movement requests and movement constraints.
- InteractionService: validates prompts, distance, line of sight, cooldown and interaction state.
- InventoryService: item ownership, slots, stack rules, carry penalties and item use.
- ObjectiveService: objective graph, prerequisites, progress and completion.
- LootService: spawn tables, rarity, pickup claims and anti-duplication.
- CreatureService: Creature role, ability validation, cooldowns, senses and capture requests.
- CreatureAIService: server-side AI state and pathing decisions.
- CaptureService: capture arbitration, one-time capture state, animation sequence and respawn/spectate transition.
- EventDirectorService: environmental events, pacing, intensity and event cooldowns.
- ExtractionService: extraction eligibility, progress, interruption and result.
- EconomyService: soft currency, sinks, reward calculation and transaction ledger.
- PurchaseService: developer products, game passes and receipt fulfillment.
- DataService: profile load/save, retries, schema versions and migration.
- AnalyticsService: privacy-conscious gameplay and funnel events.
- ModerationService: report intake, abuse signals and administrative audit events.
- ConfigurationService: typed configuration and environment-specific settings.

## Client boundaries
- InputController: keyboard, mouse, touch and gamepad abstraction.
- MovementController: local prediction/presentation and animation state.
- CameraController: first-person/third-person rules, lean, sprint sway, capture camera and accessibility options.
- InteractionController: prompts and interaction intent.
- HUDController: role-specific HUD and status.
- InventoryController: inventory presentation and item selection.
- AudioController: local mix, subtitles and accessibility.
- EffectsController: local visual effects with quality scaling.
- MenuController: menus, party, queue, settings, shop and results.
- CreatureController: Creature input and ability presentation.

## Suggested folder layout
ReplicatedStorage
- Shared
  - Config
  - Types
  - Constants
  - Util
  - Remotes
- Client
  - Controllers
  - UI
  - Camera
  - Audio
  - Effects
ServerScriptService
- Bootstrap
- Services
- Systems
- AI
- Data
ServerStorage
- ServerAssets
- CreatureTemplates
- MapTemplates
- LootTables
StarterPlayer
- StarterPlayerScripts
- StarterCharacterScripts
StarterGui
- Screens
- Components
Workspace
- Map
- Runtime
- SpawnLocations
- Interactables

This is a logical architecture, not a claim that these instances already exist. Claude must create them deliberately and document any justified deviation.

## Remote communication rules
- Create a central remote registry with typed request/response contracts.
- Never allow a client to directly set currency, inventory, objective completion, extraction success, role, capture result, reward amount or saved progression.
- Validate argument types, bounds, ownership, distance, line of sight, cooldown, round phase and player role on the server.
- Rate-limit every client-triggered action.
- Reject unknown item IDs, ability IDs, objective IDs and malformed payloads.
- Do not trust client timestamps, client-reported damage, client-reported distance or client animation completion.
- Use server-issued transaction IDs for important grants and purchases.
- Log rejected high-risk requests with a reason code, but avoid flooding logs.

## Round state machine
Recommended phases:
1. Lobby
2. Matchmaking
3. Preparing
4. Infiltration
5. Active
6. ExtractionAvailable
7. ExtractionInProgress
8. Results
9. Returning

All transitions must be server-controlled. Define allowed transitions explicitly. A round must not move backwards except through a deliberate recovery path. Every phase has timeout and disconnect handling. The server resolves simultaneous completion, capture and extraction events deterministically.

## Capture arbitration
Capture is a server decision. A Creature contact request is checked against role, round phase, distance, collision/line of sight rules, cooldown, target status, safe zones and invulnerability windows. CaptureService marks a target captured atomically before playing presentation. Duplicate capture requests must be idempotently rejected. A capture animation is presentation of an already-authorized state change, never the authority for the state change.

## Movement security
Movement should feel responsive, but the server must enforce maximum speeds, acceleration assumptions, stamina costs, cooldowns, valid state transitions and map traversal rules. Use server-side plausibility checks and correction thresholds. Do not blindly rubber-band every small replication discrepancy. Separate legitimate latency from impossible movement.

## AI architecture
Creature AI should use explicit states such as Dormant, Patrol, Investigate, Search, Stalk, Chase, Attack, Recover and Return. Perception should combine distance, visibility, light, noise, obstruction and difficulty settings. Use pathfinding budgets, waypoint caching and stuck recovery. AI should not know hidden player locations without a defined sensory ability.

## Error handling and observability
Use structured log categories: startup, round, movement, objective, inventory, creature, capture, data, purchase, matchmaking and security. Errors should include round/session correlation IDs, service name and safe reason codes. Do not log credentials, private chat, or unnecessary personal information.

## Dependency and startup order
Configuration and shared types load first; remotes are registered next; data and player lifecycle services start before round orchestration; client controllers wait for explicit readiness signals. Startup failure in a required service should fail closed and display a recoverable message rather than leave a broken round running.

## Performance architecture
- Use StreamingEnabled where the map design supports it.
- Keep client visual effects cosmetic and quality-scalable.
- Pool frequently created transient effects where practical.
- Avoid per-frame loops when event-driven updates suffice.
- Budget pathfinding and raycasts.
- Use collision groups to reduce unnecessary physics interactions.
- Keep replicated state minimal and intentional.
- Profile server frame time, memory, network send/receive and client frame time on target devices.

## Required implementation artifacts
- Service dependency diagram.
- Remote contract table.
- Round-state transition table.
- Data schema and migration plan.
- Configuration reference.
- Logging and error-code reference.
- Test evidence for exploit-sensitive paths.
- Setup instructions for a clean Roblox Studio place.