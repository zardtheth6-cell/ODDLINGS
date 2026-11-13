# CLAUDE TASK — BUILD THE AFTERHOURS MALL MAP

You are now responsible for constructing the flagship Mall environment for AFTERHOURS in the Roblox project. Treat this prompt and the other map documents in this folder as a production handoff. Your job is to reproduce the approved architectural language, layout, scale, atmosphere and room purpose in an actual playable Roblox map—not to produce a quick visual mockup.

## Read before building
Read in full:
- 03_WORLD_MAP_AND_ENVIRONMENT/AFTERHOURS_MAP_AND_ENVIRONMENT_SPEC.md
- 03_WORLD_MAP_AND_ENVIRONMENT/AFTERHOURS_MAP_BUILD_AND_PERFORMANCE_STANDARD.md
- 03_WORLD_MAP_AND_ENVIRONMENT/AFTERHOURS_MALL_MASTER_BLUEPRINT.md
- 03_WORLD_MAP_AND_ENVIRONMENT/AFTERHOURS_MALL_ROOM_SCHEDULE.md
- 03_WORLD_MAP_AND_ENVIRONMENT/AFTERHOURS_MALL_VISUAL_LANGUAGE.md
- 03_WORLD_MAP_AND_ENVIRONMENT/AFTERHOURS_MALL_GAMEPLAY_ROUTE_PLAN.md
- 04_CHARACTERS_AND_CREATURES/AFTERHOURS_CREATURE_BIBLE.md
- 06_GAMEPLAY_SYSTEMS/AFTERHOURS_TECHNICAL_ARCHITECTURE.md
- 11_TESTING_AND_BUGS/AFTERHOURS_TEST_MATRIX.md

Written specs are authoritative. Do not copy an existing Roblox mall or another game's map. All branding and tenant names must be original.

## Absolute visual requirements
- The mall must look like a real, large regional shopping mall, not a maze of empty boxes.
- Build a recognizable multi-level central atrium as the signature set piece.
- The atrium must have a believable skylight/ceiling structure, upper balcony, safe railings, escalators, storefronts, a coherent centerpiece and convincing public circulation.
- Ground and upper floors must feel like parts of one building, with consistent structural rhythm and logical vertical connections.
- Storefronts must be varied and have real interiors, display glazing, sign bands, tenant-specific dressing and stock/service access.
- Food court, department store, security office, loading dock, maintenance plant, restrooms, janitor closets, service corridors and parking connector must have distinct believable functions.
- Ceilings, lighting fixtures, HVAC, sprinklers, speakers, access panels, signage, doors, frames, trims and floor transitions are part of the realism. Do not leave blank ceilings or empty walls.
- Use realistic material scale, restrained wear, nuanced roughness and practical light sources. Avoid random grunge, oversaturated horror lighting, excessive fog and global darkness.
- Use original fictional brands and readable signage. No real mall or retailer branding.
- No guns, shooting, ammunition, military equipment or shooter UI. This map is for horror exploration and stealth.

## Mandatory build method
### Stage A — Plan before construction
1. Inspect the current Roblox project and report its state.
2. Confirm the map is being built in the correct AFTERHOURS place, not another project.
3. Create a dimensioned floor-plan proposal for both floors, with a north arrow, scale, room IDs and legend.
4. Create a room schedule matching AFTERHOURS_MALL_ROOM_SCHEDULE.md.
5. Create a route graph showing public loop, service spine, vertical routes, Explorer spawn, Creature spawn candidates, objective nodes, loot zones, hiding spots and extraction candidates.
6. Identify asset needs and whether each will be original, generated, built from parts, or sourced with clear permission.
7. Present the plan and identify any unavoidable deviations before doing a detailed art pass.

### Stage B — Greybox and circulation
1. Establish avatar scale and reusable door, stair, railing, counter and storefront dimensions.
2. Build the outer shell and structural grid.
3. Build the complete ground-floor public loop.
4. Build the atrium void and upper balcony.
5. Build the upper-floor circulation loop and vertical connections.
6. Build the service spine and back-of-house spaces.
7. Add simple collision and map boundaries.
8. Test walking, sprinting, crouching, jumping, sliding and vaulting through the routes.
9. Test AI/human Creature traversal clearances.
10. Fix circulation and scale before adding detail.

### Stage C — Architectural art pass
Build the public areas first: entrance, atrium, concourses, storefronts, food court and department store. Then back-of-house: security, service corridors, loading, maintenance, janitorial and parking connector. Build the upper floor as a complete environment, not a thin empty balcony ring.

Use modular architectural kits, but vary storefront dimensions, recesses, ceiling treatments, prop clusters and tenant layouts. Do not create dozens of identical rooms. Ensure collisions are simple and deliberate.

### Stage D — Materials, lighting and storytelling
Apply the visual language specification. Every major zone must have a lighting plan. Lights should correspond to visible fixtures. Place environmental wear according to foot traffic, moisture and maintenance logic. Add props in functional clusters. Use a few carefully composed story moments instead of random clutter. Add sound-zone markers or documented audio positions for the audio implementation phase.

### Stage E — Gameplay integration readiness
Mark and document:
- Explorer spawn and briefing route.
- Human Creature spawn candidates.
- AI patrol and investigation nodes.
- Objective nodes and access gates.
- Loot spawn nodes.
- Authored hiding spots.
- Public/service/vertical route links.
- Candidate extraction points.
- No-go areas and safe boundaries.

Do not implement arbitrary hiding or teleport-through-wall shortcuts. Do not make objective completion dependent on unvalidated random placements.

### Stage F — Review and polish
Capture every required camera view from the master blueprint. Include both top-down floor plans with labels and actual in-game screenshots at player eye height. Review the map on low graphics settings and at representative mobile resolution. Fix floating props, clipping, stretched textures, repetitive storefronts, blank ceilings, broken collision, unreadable signs and empty rooms.

## Quality bar: what NOT to deliver
Do not deliver:
- A flat plane with a few box rooms.
- A giant empty atrium with no believable architecture.
- A single long hallway with shops pasted on both sides.
- Repeated identical storefronts.
- Blank ceilings or black void ceilings.
- Random props with no believable purpose.
- Fake signs made from unreadable text.
- Global darkness used to disguise missing detail.
- Fog so dense players cannot navigate.
- A map that only looks good from the Studio camera.
- A decorative map with no tested player routes.
- A final claim of completion without screenshots, playtest results and performance evidence.

## Required delivery report
Return:
1. Floor plans for both levels with scale, compass and room IDs.
2. Room-by-room completion matrix.
3. Screenshots from every required camera view.
4. Public loop, service spine and vertical route diagrams.
5. Spawn/objective/loot/hiding/extraction node list.
6. Collision and traversal test results.
7. AI and human Creature navigation test results.
8. Asset provenance list.
9. Performance observations on representative devices.
10. Remaining issues and deviations from the specification.
11. Exact Roblox Studio files, models and instances created or modified.
12. Clear status for each zone: NOT STARTED, GREYBOX, ART PASS, INTEGRATED, TESTED or APPROVED.

Do not begin the Hotel. Do not call the Mall complete until the user has reviewed the evidence and approved it.