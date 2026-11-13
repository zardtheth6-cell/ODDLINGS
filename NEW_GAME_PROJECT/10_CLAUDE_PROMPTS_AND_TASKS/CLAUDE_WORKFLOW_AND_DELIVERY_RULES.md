# Claude Workflow and Delivery Rules

## Purpose
This file tells Claude how to work in the AFTERHOURS repository without skipping requirements, inventing completion, or producing a large pile of disconnected scripts.

## First actions
1. Read the project README.
2. Read the project brief and game design bible.
3. Read the technical architecture, movement systems, map specification, Creature bible, UI/UX specification, audio/VFX specification, economy and persistence specifications, security plan, production roadmap and test matrix.
4. Read the master prompt and phase prompts.
5. Report the current repository state and identify missing prerequisites before editing.
6. Work on one approved phase at a time.

## Non-negotiable identity
AFTERHOURS is realistic-feeling horror exploration, stealth, survival and extraction. It is not a shooter. Never add guns, firearms, ammunition, crosshairs, hit markers, military UI or shooting mechanics. Players use practical exploration tools such as flashlights, batteries, keys, access cards, scanners, lockpicks, backpacks and medical supplies.

## Build behavior
- Build systems from scratch for this project.
- Do not copy scripts, assets, branding or mechanics from ODDLINGs.
- Do not create fake functionality, dead buttons or decorative-only UI where working behavior is required.
- Do not use placeholder blocks and claim the map is finished.
- Do not create a giant monolithic script.
- Use the architecture and service boundaries in the technical specification.
- Keep server authority over round outcomes, objectives, inventory, captures, currency, rewards and purchases.
- Use modular, documented, testable code.
- Do not silently change approved design decisions.
- Ask a concise question only when a missing decision blocks safe implementation; otherwise use the documented default and record it.

## Phase execution protocol
For each phase:
1. State the exact scope and files to be changed.
2. List dependencies and risks.
3. Implement the complete phase, not just a mockup.
4. Run static checks or available tests.
5. Test in Roblox Studio where possible.
6. Report what was actually tested and what could not be tested.
7. Provide exact Studio setup steps.
8. Update documentation and status.
9. Do not begin the next phase until the current acceptance gate passes or the user explicitly approves proceeding with known gaps.

## Map quality requirements
The Mall must have coherent architecture, convincing scale, believable store layouts, detailed materials, lighting logic, props, signage, maintenance spaces and navigable routes. Greybox and test circulation before detailed dressing. Avoid empty box rooms, random repeated storefronts, floating props, stretched textures and excessive darkness. Show overhead layout and in-world screenshots for review.

## Creature requirements
Each Creature needs a distinct silhouette, movement language, audio signature, detection model, counterplay and capture sequence. The server authorizes capture. The jumpscare animation is cinematic presentation after authorization. Do not let an animation event decide whether a player is captured.

## UI requirements
All buttons must work. Menus must connect to real systems. Provide loading, empty, error, selected and disabled states. UI must be responsive and support PC, mobile and controller. Use the approved premium horror visual language; do not default to generic simulator UI.

## Delivery report format
At the end of each task, report:
- Implemented:
- Files created/modified:
- Systems connected:
- Studio setup required:
- Tests run:
- Tests passed:
- Tests not run and why:
- Known issues:
- Performance observations:
- Security considerations:
- Next approved task:

## Truthfulness rule
Never say a feature is finished, working, optimized, secure or tested unless there is evidence. Separate implemented from verified. If Studio execution is unavailable, say so clearly and provide a test plan rather than pretending tests ran.

## Stop conditions
Stop and report rather than guessing if:
- The project file or place structure is missing.
- A required asset ID or permission is unknown.
- A dependency is unavailable.
- A feature conflicts with approved design.
- A migration could destroy player data.
- A purchase path cannot be verified.
- A change would introduce an unapproved pay-to-win advantage.