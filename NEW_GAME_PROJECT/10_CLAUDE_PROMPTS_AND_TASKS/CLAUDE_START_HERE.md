# Claude Desktop — Start Here

You are building AFTERHOURS, not ODDLINGS. Work from this repository and follow the master prompt, the technical specifications and the phase gates.

## Required reading order
1. NEW_GAME_PROJECT/README.md
2. 00_PROJECT_OVERVIEW/AFTERHOURS_PROJECT_BRIEF.md
3. 00_PROJECT_OVERVIEW/PRODUCTION_ROADMAP_AND_DEFINITION_OF_DONE.md
4. 01_GAME_CONCEPT_AND_DESIGN/AFTERHOURS_GAME_DESIGN_BIBLE.md
5. 02_VISUAL_REFERENCES/REFERENCE_IMAGE_INDEX.md
6. 03_WORLD_MAP_AND_ENVIRONMENT/AFTERHOURS_MAP_AND_ENVIRONMENT_SPEC.md
7. 03_WORLD_MAP_AND_ENVIRONMENT/AFTERHOURS_MAP_BUILD_AND_PERFORMANCE_STANDARD.md
8. 03_WORLD_MAP_AND_ENVIRONMENT/AFTERHOURS_MALL_MASTER_BLUEPRINT.md
9. 03_WORLD_MAP_AND_ENVIRONMENT/AFTERHOURS_MALL_ROOM_SCHEDULE.md
10. 03_WORLD_MAP_AND_ENVIRONMENT/AFTERHOURS_MALL_VISUAL_LANGUAGE.md
11. 03_WORLD_MAP_AND_ENVIRONMENT/AFTERHOURS_MALL_GAMEPLAY_ROUTE_PLAN.md
12. 03_WORLD_MAP_AND_ENVIRONMENT/CLAUDE_MALL_MAP_BUILD_PROMPT.md
8. 04_CHARACTERS_AND_CREATURES/AFTERHOURS_CREATURE_BIBLE.md
9. 05_UI_UX_AND_ICONS/AFTERHOURS_UI_UX_SPEC.md
10. 05_UI_UX_AND_ICONS/AFTERHOURS_ACCESSIBILITY_AND_DEVICE_UX.md
11. 06_GAMEPLAY_SYSTEMS/AFTERHOURS_PLAYER_AND_GAMEPLAY_SYSTEMS.md
12. 06_GAMEPLAY_SYSTEMS/AFTERHOURS_TECHNICAL_ARCHITECTURE.md
13. 06_GAMEPLAY_SYSTEMS/AFTERHOURS_ECONOMY_AND_PROGRESSION.md
14. 06_GAMEPLAY_SYSTEMS/AFTERHOURS_DATA_SCHEMA_AND_PERSISTENCE.md
15. 07_AUDIO_AND_EFFECTS/AFTERHOURS_AUDIO_VFX_SPEC.md
16. 08_ROBLOX_SOURCE_CODE/README.md
17. 09_ASSETS_AND_MODELS/AFTERHOURS_ASSET_MANIFEST.md
18. 09_ASSETS_AND_MODELS/ASSET_APPROVAL_AND_IMPORT_CHECKLIST.md
19. 10_CLAUDE_PROMPTS_AND_TASKS/CLAUDE_WORKFLOW_AND_DELIVERY_RULES.md
20. 10_CLAUDE_PROMPTS_AND_TASKS/IMPLEMENTATION_BACKLOG.md
21. 10_CLAUDE_PROMPTS_AND_TASKS/00_MASTER_PROMPT_AFTERHOURS.md
22. 10_CLAUDE_PROMPTS_AND_TASKS/01_PHASE_PROMPTS.md
23. 11_TESTING_AND_BUGS/AFTERHOURS_TEST_MATRIX.md
24. 11_TESTING_AND_BUGS/SECURITY_ABUSE_AND_MODERATION_PLAN.md
25. 12_BUILDS_AND_RELEASES/RELEASE_CHECKLIST_AND_ROLLBACK.md
26. 13_MARKETING_AND_PUBLISHING/LAUNCH_AND_STORE_PAGE_PLAN.md

## Execution rules
- Start with Phase 0 only. Return the architecture, hierarchy, state machines, remotes contract, data schema, UI inventory, Mall blockout plan, risk register and milestone plan.
- Do not begin a giant all-at-once build.
- Do not mark planned features as implemented or tested.
- Build one vertical slice, test it, then proceed.
- Keep every feature aligned with the ordinary-person horror exploration identity.
- No guns, no shooting, no ammunition, no crosshairs, no military HUD.
- Explorer and Creature roles both matter. Solo and multiplayer both matter.
- Every menu button must work; every map area must be purposeful; every Creature must have distinct behavior and capture animation.
- Server-authoritative logic is mandatory for round outcomes, objectives, inventory, captures, rewards, purchases and persistence.
- Support keyboard/mouse, touch and controller. Voice chat must never be required.
- Follow the backlog and the Definition of Done. A generated script or attractive screenshot is not proof of completion.
- Report blockers honestly and propose a concrete resolution.

## First message to Claude
Read the required documents and inspect the existing project. Do not edit or generate the full game yet. Return a concise Phase 0 readiness report listing the actual repository files inspected, decisions already approved, missing prerequisites, architecture proposal, Roblox Studio setup plan, first vertical-slice scope, risks and acceptance tests. Wait for approval before implementing Phase 0.