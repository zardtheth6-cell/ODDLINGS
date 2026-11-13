# AFTERHOURS — QA Test Matrix

Record build/version, device, tester, steps, expected result, actual result, severity, evidence and status.

## Movement
- Walk/sprint transitions; sprint release; stamina depletion and recovery.
- Crouch under valid and invalid clearances.
- Jump/land across tile, carpet, metal and concrete.
- Slide initiation, deceleration, recovery and obstacle clearance.
- Vault valid/invalid obstacles and landing clearance.
- Lean beside walls, corners and narrow spaces; camera never clips through.
- Hiding entry/exit, blocked hiding spot and creature inspection.
- Carry-load movement; no stuck or exploit state.

## Horror and Creature
- AI detection by sight and sound.
- Crouch/sprint/slide noise differences.
- Creature loses line of sight correctly.
- No permanent wall vision or position leak.
- Ability cooldown, range and invalid state.
- Capture validates once only.
- Caught-player camera sequence works and exits cleanly.
- Teammates see world animation without camera hijack.
- Creature player sees responsive attack result.
- Accessibility reduced shake/effects.
- Creature disconnect and Explorer disconnect behavior.

## Expedition and economy
- Objective progress server validation.
- Loot pickup distance/ownership validation.
- Inventory capacity and carry effects.
- Extraction eligibility and round result.
- Solo difficulty and reward balance.
- Multiplayer reward consistency.
- Reconnect, shutdown, save retry and duplicate reward prevention.
- Shop purchase success, failure, insufficient funds and duplicate requests.

## UI/UX
- Every screen and button works.
- No guns/shooter imagery or controls.
- PC hover/focus/keyboard navigation.
- Mobile touch targets, safe area and HUD scaling.
- Controller focus navigation and button prompts.
- Loading, empty, error, disabled and confirmation states.
- UI remains readable in bright and dark environments.
- No overlap with movement controls or interaction prompts.

## Environment and performance
- Mall navigation and landmarks.
- Door/collision/pathfinding.
- Creature route across stairs/vents/approved shortcuts.
- Hiding nodes and objective nodes.
- Streaming boundaries and re-entry.
- Lighting/material appearance at player height.
- Lower-end mobile profiling.
- Server/client memory, network and frame-rate profiling.
- Particle/light/audio cleanup after round ends.

## Release blockers
Data loss, currency exploit, unvalidated capture, unavoidable spawn kill, broken extraction, stuck camera, non-functional required control, critical mobile blocker or severe performance failure is a release blocker.