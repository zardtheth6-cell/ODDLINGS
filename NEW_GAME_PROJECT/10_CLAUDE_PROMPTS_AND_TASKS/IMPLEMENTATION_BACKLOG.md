# AFTERHOURS Implementation Backlog

Initial status for every task is NOT STARTED unless a test report proves otherwise.

## Foundation
- [ ] Create clean Roblox place and project bootstrap.
- [ ] Establish source synchronization workflow.
- [ ] Create shared configuration, types and remote registry.
- [ ] Create server/client service boundaries.
- [ ] Establish structured logging and startup diagnostics.
- [ ] Document place settings and collision groups.

## Movement
- [ ] Walk and sprint.
- [ ] Crouch and crouch locomotion.
- [ ] Jump, fall and landing.
- [ ] Slide with valid entry/exit conditions.
- [ ] Vault with server-validated traversal.
- [ ] Lean and hide.
- [ ] Stamina and recovery.
- [ ] Footstep surfaces and noise events.
- [ ] Keyboard, touch and controller input.
- [ ] Movement exploit regression tests.

## Mall vertical slice
- [ ] Greybox floor plan and route.
- [ ] Validate circulation, sightlines and Creature routes.
- [ ] Build objective and loot rooms.
- [ ] Build extraction space.
- [ ] Add art pass, lighting, props and signage.
- [ ] Profile streaming and performance.

## Core expedition
- [ ] Round state machine.
- [ ] Interaction system.
- [ ] Inventory and carry penalties.
- [ ] Objective chain.
- [ ] Loot spawn and pickup claims.
- [ ] Environmental event director.
- [ ] Extraction and result resolution.
- [ ] Rewards and return to lobby.

## Creature
- [ ] Creature role assignment.
- [ ] First Creature AI.
- [ ] Perception and sensory rules.
- [ ] Human-controlled Creature movement and abilities.
- [ ] Capture arbitration.
- [ ] Unique capture presentation.
- [ ] Spectator and respawn flow.
- [ ] Role balance and counterplay tests.

## Online systems
- [ ] Solo queue.
- [ ] Party and invitations.
- [ ] Co-op matchmaking.
- [ ] Reserved server/teleport flow.
- [ ] Reconnect and disconnect handling.
- [ ] Player-controlled Creature queue.

## UI and progression
- [ ] Main menu and lobby.
- [ ] Matchmaking UI.
- [ ] Explorer HUD and Creature HUD.
- [ ] Inventory and shop UI.
- [ ] Results UI.
- [ ] Profile, levels and titles.
- [ ] Contracts.
- [ ] Accessibility settings.
- [ ] Credits and reward breakdown.
- [ ] Save/load and schema migration.

## Security and release
- [ ] Remote abuse tests.
- [ ] Data integrity tests.
- [ ] Purchase receipt idempotency tests.
- [ ] Moderation/report flow.
- [ ] PC/mobile/controller QA.
- [ ] Performance sign-off.
- [ ] Store assets and descriptions.
- [ ] Staged launch and rollback rehearsal.

## Backlog rules
Do not mark tasks complete because a script was generated. Link completed tasks to test evidence. Split large tasks into independently testable work, record blockers and dependencies, and keep the first public scope focused on a polished Mall experience.