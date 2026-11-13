# AFTERHOURS — Player and Gameplay Systems

## Human movement states
Idle, Walk, Sprint, CrouchIdle, CrouchWalk, JumpStart, JumpApex, Fall, Land, Slide, Vault, LeanLeft, LeanRight, HideEnter, HiddenIdle, HideExit, Interact, Captured and Spectate.

### Walk
Natural baseline speed, responsive but not twitchy. Surface-dependent footsteps and subtle camera bob.

### Sprint
Hold/toggle configurable. Uses stamina, louder footsteps and heavier breathing. Smooth acceleration/deceleration. Ends when stamina is depleted, blocked by state or player stops.

### Crouch
Toggle/hold configurable. Lower camera and collision height with safe clearance checks. Reduced speed and noise. Must not clip through geometry.

### Jump
Controlled arc and gravity. Jumping/landing emit noise. No infinite jump or repeated bunny-hop exploit. Landing animation and sound depend on fall height and surface.

### Slide
Triggered from sprint with valid direction and sufficient stamina. Short controlled momentum, lowered capsule/camera, limited duration, friction-based deceleration and recovery. Cannot clip through walls/doors or slide indefinitely. Under-obstacle traversal only through authored clearance checks.

### Vault
Contextual traversal over approved low obstacles. Validate height, landing clearance, direction and state. Avoid client-authoritative root movement exploits.

### Lean
Small lateral peek with collision checks so camera/body never passes through walls. Limit lean angle and exposure. PC Q/E, controller remappable controls and mobile contextual controls.

### Hide
Only authored hiding volumes. Enter/exit animations, restricted movement and clear state. Some entities may inspect or challenge hiding places; never promise universal safety.

## Stamina and carrying
Stamina drains while sprinting/sliding and strenuous actions. Recovers while walking/standing in safe conditions. Carrying more loot may modestly reduce speed or increase noise, with a readable cap. Avoid impossible encumbrance. Equipment upgrades may improve capacity modestly, not create unlimited sprint.

## Interaction
Context prompts for doors, containers, switches, keys, evidence, extraction and hiding spots. Hold interactions where appropriate. Cancel on movement, damage or range break if specified. Server validates important actions and distance. Doors support open/close, locked, blocked and peek states where appropriate.

## Noise and detection
Actions generate noise events with intensity, radius, timestamp, position and category. Account for distance and basic occlusion where feasible. Crouch walking is quieter than walking; sprint, slide, jump landing, door slam and dropped objects are louder. Server handles perception. Avoid sending raw player positions to Creature clients.

## Inventory and loot
Backpack capacity with stable item IDs, weight/size, value, rarity, category and allowed actions. Valuables can be sold or submitted for contracts. Keys/evidence cannot be accidentally sold. Server owns inventory and rewards. Define persistence and reconnect behavior.

## Objectives and extraction
Objective types: locate item, retrieve evidence, restore system, unlock access, inspect location, activate sequence, identify anomaly and optional side contract. Use validated spawn nodes and dependencies. Extraction requires clear feedback and activation. Avoid unavoidable extraction camping.

## Environmental event director
Server-side weighted scheduler with cooldowns, intensity tiers, location pools, player-aware pacing and conflict prevention. Events: localized light failure, full outage, PA message, elevator movement, object displacement, distant footsteps, locked wing, false silhouette, alarm, water leak, door movement, radio/static and unexplained room sound. Some events are harmless; others foreshadow danger. No random event spam.

## Round flow
Lobby, Matchmaking, Briefing, Loading, Setup, Active, Extraction/FinalPhase, Results and Cleanup. Handle disconnects, late join rules, party split prevention and server shutdown. Use reserved/private servers where appropriate.

## Server authority and anti-exploit
Server validates movement bounds, stamina, item actions, loot pickup, purchases, objective completion, Creature abilities, capture range, cooldowns, extraction and rewards. Client may predict cosmetic movement/UI but cannot award currency or decide capture. Rate-limit remotes and validate types, ranges and states.

## Data persistence
Versioned profile schema. Save currency, XP, level, cosmetics, equipment unlocks, titles, stats and settings. Do not store transient round state as permanent progression. Use safe retries, session locking strategy and graceful failure messages. Test data loss and reconnect scenarios.

## Camera and cross-platform
Stable first-person camera with subtle movement feedback. No forced camera seizure except caught player's authored capture sequence after server validation. Provide camera shake intensity, reduced motion and sensitivity settings. Prevent camera clipping. Support PC, mobile and controller from first prototype with input abstraction and remapping.