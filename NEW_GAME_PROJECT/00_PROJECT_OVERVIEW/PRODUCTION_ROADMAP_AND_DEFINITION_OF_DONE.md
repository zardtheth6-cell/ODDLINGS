# AFTERHOURS Production Roadmap and Definition of Done

## Purpose
This document turns the approved concept into a controlled production plan. It prevents the project from becoming a collection of unfinished systems. A feature is not complete because a model, menu, animation, or script exists; it is complete only when it works, is integrated, is tested, and meets the acceptance criteria.

## Current truth
Status: PRE-PRODUCTION. The design package exists. Roblox Studio implementation, integration, performance validation, multiplayer testing, and release certification are not yet complete. Never describe planned systems as implemented.

## Production principles
1. Build a playable, polished vertical slice before expanding content.
2. Implement server-authoritative gameplay and data before cosmetic polish that depends on them.
3. Use placeholder assets only when clearly labeled and replace them before the relevant quality gate.
4. Every feature must have an owner, dependencies, acceptance criteria, test cases, and a status.
5. Do not add firearms, shooting, ammunition, crosshairs, military presentation, or shooter mechanics.
6. Solo play is a first-class mode, not a fallback for empty servers.
7. Never require voice chat for communication or progression.
8. Target PC, mobile, and controller from the beginning.
9. Do not promise a release date until scope, performance, and test results support it.

## Phase 0 — Foundation and project setup
Deliverables:
- New Roblox experience and correctly configured place hierarchy.
- Repository and source-control workflow established.
- Rojo or an explicitly documented alternative chosen.
- Project settings, collision groups, streaming strategy, team definitions, and remote-event policy documented.
- Naming conventions, module boundaries, logging conventions, and code review checklist.
- Empty but correctly wired server/client bootstrap.
- Development, staging, and production configuration separation.

Gate: a clean test place starts without errors; source can be synchronized reproducibly; no production secrets or private keys are stored in the repository.

## Phase 1 — Core movement and interaction
Deliverables:
- Walk, sprint, crouch, jump, slide, vault, lean, hide, interact, fall, landing and spectating states.
- Stamina and recovery.
- Surface-aware footstep/noise events.
- Camera and animation state synchronization.
- Input mappings for keyboard/mouse, touch and controller.
- Server validation for movement-sensitive actions.

Gate: all movement states transition correctly, cannot be exploited for speed or clipping, and remain readable at target frame rates on supported devices.

## Phase 2 — One complete Mall expedition
Deliverables:
- A compact but convincing Mall route with spawn, objective rooms, loot, threat zones, safe-ish staging areas and extraction.
- One complete objective chain.
- One working inventory and carry system.
- One working environmental event.
- One Creature AI archetype.
- Capture sequence, spectator flow, result screen and reward grant.
- Solo mode fully playable.

Gate: a player can enter, understand the objective, explore, experience danger, complete or fail, extract or be captured, receive correct rewards, and return to the lobby without staff intervention.

## Phase 3 — Co-op and matchmaking
Deliverables:
- Party creation/invites, queueing, server reservation/teleport flow, reconnect policy and party-safe result handling.
- Solo queue and co-op queue.
- Ready state, loading state, timeout handling and server-full handling.
- No voice-chat dependency.
- Server-authoritative objective and extraction state.

Gate: one to four Explorers can complete the full expedition together; disconnects and late arrivals do not corrupt the round.

## Phase 4 — Player-controlled Creature
Deliverables:
- Creature selection and role eligibility.
- Creature-specific movement, sensory tools, abilities and counterplay.
- Fair round setup, readable cooldowns and clear objective pressure.
- Anti-grief safeguards, AFK handling, role rotation and leaver handling.
- Separate Creature HUD and controls.

Gate: one human Creature can play a complete fair round against one to four Explorers; all role abilities are server validated and have meaningful counterplay.

## Phase 5 — Content and progression
Deliverables:
- Additional Creature archetypes.
- Mall content expansion and then Hotel prototype.
- Contracts, account progression, titles, cosmetics and unlocks.
- Currency earn/spend loop and optional Robux purchases.
- Save/load, migration, receipt processing and purchase recovery.

Gate: progression is reliable, understandable, non-pay-to-win, and survives rejoining and server restarts.

## Phase 6 — Polish, accessibility and optimization
Deliverables:
- Lighting, materials, props, animation, sound, VFX and cinematic capture polish.
- Mobile/controller UX pass.
- Reduced-motion, flash intensity, camera shake, subtitle and audio controls.
- Streaming and memory budgets.
- Network, server and client performance profiles.
- Exploit and abuse testing.

Gate: no critical blockers; target device performance is measured, not guessed; accessibility options are verified.

## Phase 7 — Release readiness
Deliverables:
- Store page copy, icon, thumbnails, trailer capture plan, age-appropriate content review.
- Telemetry dashboards and error logging.
- Moderation and player-report process.
- Support/known-issues page and rollback plan.
- Staged release and post-launch monitoring checklist.

Gate: all release checklist items are signed off; no known critical data-loss, exploit, crash, purchase, or progression defects.

## Definition of Done for every feature
- Written purpose and player-facing behavior.
- Dependencies and edge cases documented.
- Correct client/server ownership.
- Inputs supported on keyboard, touch and controller where applicable.
- UI states include loading, empty, success, error and disabled states where relevant.
- Server validates all important state changes.
- Data persistence and retry behavior verified if applicable.
- Analytics events defined without collecting unnecessary personal data.
- Tests pass in solo and multiplayer contexts.
- No output errors or unexplained warnings.
- Performance impact measured.
- Accessibility settings respected.
- Documentation and status updated.
- Evidence recorded: test place, test steps, screenshots/video, logs or automated test output.

## Status vocabulary
- NOT STARTED: no implementation.
- IN DESIGN: behavior and acceptance criteria being finalized.
- IN PROGRESS: implementation underway.
- BLOCKED: dependency or issue prevents progress.
- IMPLEMENTED: code/assets exist but acceptance is not yet proven.
- TESTING: integrated and undergoing verification.
- VERIFIED: acceptance criteria passed with evidence.
- DEFERRED: intentionally postponed with reason.
- REJECTED: removed from scope with reason.

## Scope control
Any new feature request must state: player value, complexity, dependencies, security impact, performance impact, monetization impact, and whether it delays the vertical slice. Do not silently expand the first release.