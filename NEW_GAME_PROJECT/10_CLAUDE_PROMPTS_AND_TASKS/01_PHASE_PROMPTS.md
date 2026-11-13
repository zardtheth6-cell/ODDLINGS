# AFTERHOURS — Phase-by-Phase Claude Prompts
Run these in order. Do not ask Claude to execute all phases in one response. Each phase ends with a tested deliverable and a report.

## Phase 0 — Audit and architecture
Read the master prompt and all design specifications. Produce Roblox Explorer hierarchy, module architecture, server/client responsibility table, remotes contract, state diagrams, data schema, UI screen inventory, map blockout plan, asset plan, risk register and milestone checklist. Do not build content yet. Explicitly confirm no-guns/no-shooter identity and solo + multiplayer + playable Creature requirements.
Acceptance: architecture is internally consistent; every requirement has an owner/module; no missing screen or mode; security and performance plan exists.

## Phase 1 — Project foundation
Create a clean place structure, shared configuration, service modules, server/client bootstraps, remote registry, logging/error utilities, round state service and profile/data service skeleton. Implement safe loading, retry and shutdown behavior. Do not create final Mall yet.
Acceptance: clean startup, no infinite waits, no unhandled errors, server/client separation documented, data schema versioned, remotes validated.

## Phase 2 — Human controller
Implement walk, sprint, crouch, jump, slide, vault, lean, hide and interaction states. Add stamina, camera behavior, footsteps and noise generation. Support keyboard, touch and controller from the beginning. Provide tuning values in config.
Acceptance: transitions smooth; no clipping; no infinite jump/stamina; slide cannot exploit collision; footsteps match surfaces; input works on all targets.

## Phase 3 — First Mall vertical slice
Before construction, read the complete Mall map package: AFTERHOURS_MALL_MASTER_BLUEPRINT.md, AFTERHOURS_MALL_ROOM_SCHEDULE.md, AFTERHOURS_MALL_VISUAL_LANGUAGE.md, AFTERHOURS_MALL_GAMEPLAY_ROUTE_PLAN.md and CLAUDE_MALL_MAP_BUILD_PROMPT.md. Submit dimensioned ground/upper floor plans, room schedule, route graph and asset plan for review. Then block out and art-pass one complete navigable Mall route: entrance, atrium segment, retail zone, service corridor, security/maintenance objective and extraction. Use realistic architecture and detailed materials. Add valid hiding locations, landmarks, loot spawn nodes and AI navigation paths.
Acceptance: floor plans match the built map; signature atrium is recognizable; no giant empty rooms; consistent scale and architectural logic; required rooms have real functions; public loop/service spine/vertical routes work; AI and human Creature traversal are verified; performance profiled; required player-height and overhead screenshots are supplied; user approval is required before Hotel work.

## Phase 4 — Explorer gameplay loop
Implement flashlight/battery, inventory/backpack, loot, item interactions, primary and optional objectives, extraction, reward calculation and results screen. Server owns item and reward decisions.
Acceptance: solo expedition completes end-to-end; multiplayer expedition completes end-to-end; exploit tests cannot create items/currency; failure/reconnect behavior defined.

## Phase 5 — Environmental horror director
Implement weighted event director, event pools, cooldowns, pacing, audio/lighting cues and player-aware event selection. Start with at least five polished events; expand to 15+ after quality passes. Ensure events do not trap players unfairly.
Acceptance: event logs prove cooldowns and conflict prevention; events are readable; quiet pacing exists; events vary between rounds.

## Phase 6 — AI Creature and capture
Implement one Creature AI with patrol, investigate, detect, stalk, chase, attack, capture, search and cooldown/recovery states. Create unique animation/audio/capture sequence. Server validates capture and client plays presentation.
Acceptance: fair tells/counterplay; no wall vision; no stuck camera; no duplicate capture; solo balance works; teammate view works.

## Phase 7 — Playable Creature mode
Implement Creature role assignment, Creature-specific camera/controls, locomotion, ability cooldowns, perception, attack/capture and asymmetrical win conditions. Begin with one archetype, then add the others.
Acceptance: human-controlled Creature can play a full round against human Explorers; no hidden position leaks; abilities have limits; role selection/matchmaking is fair.

## Phase 8 — Full UI/UX
Implement all required screens using the design system. Connect every button and field to live game data. Add responsive PC/mobile/controller layouts, accessibility, settings, loading/error/empty states and transitions.
Acceptance: no placeholder controls; no shooter UI; no disconnected mockups; all platform layouts tested.

## Phase 9 — Progression, economy and headquarters
Implement currency, XP, levels, contracts, shop, equipment upgrades, cosmetics, titles, stats, profile and headquarters stations. Server validates purchases and rewards. Keep progression fair and avoid pay-to-win.
Acceptance: data persists; purchases idempotent; free players can compete; UI updates accurately.

## Phase 10 — Second location and content expansion
Build The Hotel only after Mall vertical slice approval. Add location-specific event pools, objectives, loot, routes and Creature opportunities. Add more creatures only when each has unique identity and counterplay.
Acceptance: Hotel has distinct layout/atmosphere; performance stable; no copy-paste map filler.

## Phase 11 — QA, optimization and release readiness
Run test matrix across solo, parties, random matchmaking, Creature mode, disconnects, respawns, data saves, mobile, PC and controller. Profile server/client, fix bugs, audit monetization and polish onboarding. Prepare release assets and update cadence.
Acceptance: all critical tests pass; known issues documented; no broken UI; no exploit paths; stable performance on target devices; release checklist signed off.
