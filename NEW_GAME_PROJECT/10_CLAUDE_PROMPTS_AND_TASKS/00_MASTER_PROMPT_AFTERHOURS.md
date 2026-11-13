# CLAUDE MASTER PROMPT — AFTERHOURS
**Project-defining instruction. Read every linked specification before building.**

You are acting as a senior Roblox game director, technical architect, gameplay engineer, environment artist, UI/UX designer, character/creature animator, sound designer and QA lead. Build AFTERHOURS from a clean Roblox Studio place, using this repository as the source of truth. Do not assume an existing implementation. Do not import ODDLINGS or unrelated project assets.

## A. FIRST: READ, PLAN, DO NOT RUSH INTO BUILDING
Read the project brief, Game Design Bible, Visual Reference Index, Map and Environment Spec, Creature Bible, UI/UX Spec, Player and Gameplay Systems Spec, Audio/VFX Spec, QA Test Matrix and phase prompts.

Before implementation, produce:
- Roblox Explorer hierarchy and folder structure.
- Server/client/shared module architecture.
- Data flow and state ownership diagram.
- RemoteEvent/RemoteFunction contract with validation rules.
- Round and player state machines.
- Data schema and migration strategy.
- Full UI screen inventory.
- Mall blockout plan and navigation plan.
- Creature rig/animation/AI plan.
- Asset manifest and provenance plan.
- Test matrix, risks and milestone plan.

Identify ambiguities and propose defaults. Do not silently discard requirements. Keep phases independently testable. Do not claim a feature is finished until it passes the acceptance tests.

## B. NON-NEGOTIABLE GAME IDENTITY
AFTERHOURS is an ultra-realistic-feeling horror exploration, stealth, survival and extraction game with an asymmetrical mode where a player can become the Creature. It is NOT a shooter.

**ABSOLUTELY NO GUNS, FIREARMS, SHOOTING, AMMUNITION, WEAPON LOADOUTS, CROSSHAIRS, HIT MARKERS, SOLDIER CLASSES OR MILITARY TACTICAL HUD.** Do not introduce these as optional features, monetization, placeholders or future ideas. Humans use flashlights, batteries, backpacks, keys, access cards, lockpicks, scanners, medical supplies and practical exploration tools. The verbs are explore, investigate, listen, hide, crouch, sprint, jump, slide, vault, lean, collect, evade, hunt and escape.

The Explorer is an ordinary person entering a closed building after hours. Maintain this identity in story, environment, animations, audio, menus, props, progression and marketing.

## C. GAME MODES
Implement all of these as first-class modes:
1. Solo Explorer vs AI threat director and AI creatures. Fully playable and balanced without other humans.
2. Cooperative Explorer expeditions for 1–4 players.
3. Asymmetrical Creature mode: one human-controlled Creature vs 1–4 human Explorers.
4. Practice/tutorial for Explorer movement, equipment and Creature controls.

No mode may require Roblox voice chat. Provide contextual pings, quick commands, teammate/objective indicators and optional platform text chat. A random-match player must participate without a friend group.

Explorer objectives and extraction must be clear. Creature victory must be possible but not guaranteed. Role assignment must be fair, transparent and not permanently paywalled. Balance human-vs-AI and human-vs-human separately. Handle queue population gracefully.

## D. QUALITY TARGET — ULTRA-REALISTIC WITHIN ROBLOX
Do not confuse realism with simply making everything dark or adding high polygon counts. Realism comes from correct scale, architecture, materials, lighting, animation, audio, interactions, environmental storytelling and coherent UI.

### Environment art
- Build believable commercial architecture with consistent structural logic.
- Use detailed PBR-style materials and SurfaceAppearance where appropriate and supported.
- Distinguish tile, polished stone, concrete, carpet, wood, glass, painted metal, stainless steel, fabric and plastic through roughness, reflection, color and wear.
- Include ceilings, trims, vents, sprinklers, cable trays, signage, electrical panels, light fixtures, door hardware, glass frames, realistic furniture and functional clutter.
- Use scratches, scuffs, fingerprints, dust, stains, water damage and aging selectively; do not dirty every surface uniformly.
- Every room has a believable function. Avoid giant empty rooms, arbitrary corridors, repeated prop spam and unfinished graybox areas presented as final.
- Light sources correspond to visible fixtures where practical. Use layered practical lighting, emergency lighting and controlled shadows. Keep routes navigable.
- Build landmarks, wayfinding and sightlines. The Mall must be spatially understandable without a permanent minimap.
- Every hiding spot, vent route, shortcut, door and objective node must be authored and tested.

### Creature art and animation
Create original entities with distinct silhouette, anatomy, surface treatment, rig, locomotion, sounds, senses, AI, player-control behavior and capture sequence. Do not copy known game monsters. Produce front/side/back views, scale comparison and animation reference sheets before final modeling. Creatures must feel physically grounded and terrifying through timing, posture, sound and facial animation, not gore.

### Cinematic capture
Every creature has a unique server-validated capture sequence. Server confirms the catch; caught player's client plays its camera sequence. Nearby Explorers see world-space animation; their cameras must not be hijacked. Creature player sees responsive attack animation. Prevent duplicate capture, camera clipping, stuck states and desynchronization. Add reduced shake/reduced motion options.

## E. REQUIRED HUMAN MOVEMENT
Implement polished, interconnected states: walk, sprint, crouch, jump, fall, land, slide, vault, lean, hide, interact, carry-load movement, captured and spectate. Movement must feel responsive and grounded:
- Sprint consumes stamina and increases noise/breathing.
- Crouch reduces speed and noise, changes camera/collision height safely.
- Jump has a controlled arc and meaningful landing noise.
- Slide starts from sprint with valid direction/stamina, decelerates, has a recovery window and cannot clip through geometry.
- Vault only over validated obstacles with landing clearance.
- Lean is collision-safe and never reveals camera through walls.
- Hide uses authored hiding locations and is not universally safe.
- Footsteps change by surface and match animation timing.
- Carrying loot may reduce speed modestly; no impossible encumbrance.
- No infinite stamina, infinite jump, bunny-hop exploit or client-authoritative movement exploit.
Controls support PC, mobile and controller, with remapping/settings where feasible.

## F. CREATURE PLAY SYSTEM
Creature is a real playable role with separate locomotion, camera, audio, animation and abilities. Start with The Watcher, The Crawler and The Employee as original prototypes. Abilities have cooldowns, readable tells, counterplay and limits. No permanent wall vision, unrestricted teleportation, infinite speed, unavoidable instant captures or map-boundary bypass. Server validates abilities, senses and captures. Do not leak Explorer positions to Creature client except through a balanced ability result.

## G. UI/UX — REALISTIC AND NON-SHOOTER
Build a complete connected interface, not mockups. UI is restrained, premium, atmospheric, legible and minimal. Charcoal/black/warm grey/off-white with subtle red danger accents and restrained status colors. No military dashboard, no shooter HUD, no weapon slots, no crosshair, no ammunition.

Required screens: main menu, headquarters, matchmaking/party, location selection, mission briefing, Explorer HUD, inventory, shop, equipment detail, contracts, profile, titles/achievements, settings/accessibility, pause, capture/defeat, spectate, Creature selection, Creature HUD, results, loading, error/empty/confirmation states. Every button works and binds to real data. Provide PC/mobile/controller layouts and test them. Show only essential HUD information: objective, stamina when needed, flashlight battery, condition if used, compact items, contextual interaction, teammate state and subtle danger cue.

## H. SYSTEM ARCHITECTURE AND SECURITY
Use clean modular Luau architecture. Separate server authority from client presentation. Server owns inventory, currency, progression, objective completion, loot, extraction, Creature abilities, captures, cooldowns and rewards. Client may render animation, UI, camera and responsive predicted movement but cannot award itself items/currency or declare a capture.

Create a documented remotes contract. Validate every remote argument, player state, distance, cooldown, item ownership, round state and rate limit. Never trust client-reported prices, positions or success flags. Use server-side state machines and idempotent operations for purchases/rewards. Use versioned persistent data and safe retry/error handling. Handle disconnects, reconnects, server shutdown and party matchmaking.

## I. PERFORMANCE AND PLATFORM
Target PC, mobile and controller. Use StreamingEnabled and modular environment construction appropriately. Profile client and server. Control part counts, texture sizes, transparent layers, particle counts, dynamic lights, shadows, audio emitters and replication. Use collision simplification and cleanup. Do not sacrifice playable frame rate for an unoptimized screenshot. Test low-end mobile, mid-range mobile, PC and controller input.

## J. BUILD PHILOSOPHY
Build one vertical slice first, not the entire dream in one pass. The first playable slice must contain:
- Functional headquarters entry and expedition start.
- One polished Mall route.
- Human movement: walk, sprint, crouch, jump, slide, vault and lean.
- Flashlight, inventory and several loot types.
- One primary objective and extraction.
- One environmental event.
- One AI Creature with fair detection/counterplay.
- One playable Creature prototype in a private test round.
- Functional minimal HUD and results.

Then test and improve. Only after this is stable, expand maps, creatures, content and progression.

Do not substitute a low-quality map for a complete one. Do not use placeholder UI in a milestone marked complete. Do not leave buttons unconnected. If an asset is unavailable, create a high-quality original substitute or clearly report the blocker; never silently use a crude placeholder.

## K. ACCEPTANCE GATES
A phase is complete only when:
1. All specified features exist.
2. All UI controls work.
3. Server authority and exploit validation are implemented.
4. Solo mode works.
5. Multiplayer mode works with multiple clients.
6. Creature role is tested separately where relevant.
7. PC, mobile and controller paths are checked.
8. Performance is profiled.
9. Visual quality is inspected from player height in live play.
10. Known issues are documented with reproduction steps.
11. Screenshots/video captures are saved to project build/reference folder.
12. Completion report lists implemented, tested, not tested and deferred items.

## L. REQUIRED DELIVERABLES
Maintain architecture/hierarchy, map plans and zone diagrams, creature sheets and animation checklist, UI screen inventory and design tokens, movement state table and tuning config, remote/security contract, data schema, test matrix, known bugs, phase completion reports, asset manifest with source/licensing and final Studio place/build instructions.

Start by returning the proposed architecture, detailed phase plan, risk register and first vertical-slice checklist. Then proceed phase by phase. Do not skip planning and do not compress the project into one giant unreviewable script.
