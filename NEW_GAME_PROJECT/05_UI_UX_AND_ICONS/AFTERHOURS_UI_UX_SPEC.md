# AFTERHOURS — UI / UX Specification

## Design identity
Premium, restrained, atmospheric, realistic-feeling and legible. Designed for cinematic horror exploration—not a shooter, military tactical simulator or cartoon Roblox tycoon.

### Strictly prohibited
No guns, ammunition, weapon slots, crosshairs, hit markers, combat stats, military dashboard, soldier motifs, oversized colorful cartoon buttons or generic simulator panels.

## Visual system
Base palette: charcoal, near-black, warm grey and muted off-white. Accent: restrained deep red for warnings only. Utility accent: muted green/amber for status, battery and confirmation. Typography: legible modern sans-serif with restrained condensed display headings. Thin low-contrast borders, consistent icon stroke and optical size, subtle transitions. Avoid heavy futuristic glass dashboards; this is an ordinary person exploring a real building.

## Explorer HUD
Essential information only: small objective tracker; stamina indicator that becomes prominent during exertion; condition/health only if meaningful; flashlight battery/status; compact quick-item slots for flashlight/keys/tools; contextual interaction prompt near target; teammate status when needed; subtle event/danger notification. No crosshair, ammunition or weapon inventory. Keep center of screen clear and reduce HUD noise during quiet exploration.

## Creature HUD
Small ability icons with cooldown ring/number, Creature sense status, round objective and timer. No aim reticle or shooter presentation. Distinct from Explorer HUD but within the same design language.

## Required screens
1. Main menu.
2. Headquarters/lobby.
3. Expedition/location selection.
4. Party and matchmaking.
5. Mission briefing.
6. Explorer in-game HUD.
7. Inventory and backpack.
8. Equipment shop.
9. Item detail/upgrade panel.
10. Objective/contract board.
11. Player profile, statistics, titles and achievements.
12. Settings: graphics, audio, controls, sensitivity, camera shake, accessibility and HUD scale.
13. Pause menu.
14. Captured/defeat screen.
15. Spectate and teammate status.
16. Creature selection and preview.
17. Creature in-game HUD and ability cooldowns.
18. Round results and rewards.
19. Loading and reconnection states.
20. Error, empty, disabled and confirmation states.

## Inventory
Items include flashlight, batteries, keys, access cards, lockpicks, scanner, medical supplies, backpack, valuables, evidence and collectibles. Show item name, icon/render, quantity, weight/space, description, rarity if relevant and equip/use/drop/inspect actions. Drag/drop on PC; touch-friendly controls on mobile; focus navigation on controller.

## Shop
Exploration equipment, practical utility tools, backpack upgrades and cosmetics. Display price, ownership, stats, confirmation and insufficient currency states. Purchases are server-validated. Robux products use platform purchase flows and transparent descriptions. No weapons.

## Expedition briefing
Show location image, premise, objective, difficulty, expected duration band, team roster, equipment readiness, extraction condition and ready/start controls. Do not reveal hidden entity positions or secret triggers.

## Creature selection
Show Creature preview, role summary, learning curve, abilities, cooldowns, counterplay and cosmetic options. Never sell a decisive gameplay advantage.

## Responsive requirements
PC: mouse/keyboard, hover/focus and shortcuts. Mobile: thumb-reachable controls, scalable panels, adjustable HUD positions and no overlapping buttons. Controller: clear focus order, bumper navigation and button prompts. One coherent design system with responsive layouts.

## Functional acceptance
Every visible button has a working action. Every screen binds to real data. Handle loading, errors, empty inventory, insufficient funds, unavailable map, full party, matchmaking timeout, disconnect and respawn. Server-authoritative data for currencies, purchases, inventory and progression. Test all screens in actual Roblox clients and all supported input types.