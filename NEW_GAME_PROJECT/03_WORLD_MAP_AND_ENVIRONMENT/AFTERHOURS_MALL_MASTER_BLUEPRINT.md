# AFTERHOURS — THE MALL Master Blueprint

**Document authority:** This is the primary spatial planning document for the first flagship map. It expands the concept layout into a buildable architectural and gameplay plan. Dimensions below are initial greybox targets, not claims about an existing Roblox build. Claude must validate proportions in playtests and record any approved changes.

## 1. The intended visual result

Build a believable, high-end regional shopping mall that has been closed for years after an unexplained incident. It must read instantly as a real commercial property, not a horror maze assembled from random corridors. The building has a consistent structural grid, logical tenant spaces, public circulation, back-of-house circulation, service infrastructure, vertical connections and believable emergency access.

The atmosphere is grounded and cinematic: large quiet public spaces, partially lit storefronts, abandoned seating, closed metal shutters, dusty skylights, dead digital directories, emergency fixtures, maintenance carts, distant PA speakers and isolated signs of recent activity. The player should believe the mall operated normally before it was abandoned.

The Mall should be memorable even in a still screenshot. Its central atrium is the signature landmark: a multi-storey void, upper balcony, escalators, inactive fountain or sculptural centerpiece, skylight structure, multiple retail sightlines and carefully staged practical lighting.

## 2. Macro dimensions and scale targets

Use these as starting blockout dimensions, then validate against the Roblox avatar and camera:
- Main mall footprint: approximately 420 x 300 studs.
- Two public levels with a 36–44 stud floor-to-floor target in the atrium zone; use realistic 14–20 stud retail ceiling heights outside the atrium.
- Main concourse: 26–34 studs wide.
- Secondary retail corridors: 16–22 studs wide.
- Service corridors: 10–14 studs wide.
- Typical retail unit depth: 32–60 studs.
- Large department store: approximately 100 x 80 studs, with a separate stockroom and staff area.
- Food court: approximately 90 x 70 studs plus kitchens/service support.
- Loading/receiving: approximately 70 x 55 studs with truck bay and staging.
- Public door clear width: 6–10 studs depending on use.
- Standard door height: approximately 10–12 studs.
- Typical storefront height: 14–18 studs.
- Stair and escalator landings must allow two-way movement and pursuit without collision snagging.

These are greybox targets, not architectural law. Never distort the player avatar to make a room appear larger. Keep doors, counters, shelves, seating and stairs believable relative to the character.

## 3. Site orientation

Use a consistent compass for all map docs and Studio labels:
- SOUTH = primary public entrance and arrival plaza.
- NORTH = upper mall retail/cinema end.
- WEST = department store and service wing.
- EAST = food court, cinema/entertainment wing and secondary retail.
- CENTER = atrium and primary concourse.
- SOUTHWEST = security and public services.
- SOUTHEAST = restrooms, janitorial and service access.
- NORTHWEST = department store back-of-house and offices.
- NORTHEAST = entertainment/retail and upper-floor connections.
- SOUTH EDGE = parking access and arrival.
- WEST/SOUTHWEST back edge = loading and receiving.
- EAST/SOUTHEAST back edge = maintenance and building plant.

Do not rotate individual floors or signage relative to this compass. Label all plan views with NORTH arrow, scale bar, floor name and legend.

## 4. Ground-floor adjacency plan

Conceptual layout (not to scale; use as adjacency truth, not final geometry):

NORTH
+----------------------+----------------------+----------------------+
| DEPARTMENT STORE     | NORTH ATRIUM EDGE    | ENTERTAINMENT /      |
| sales floor          | upper void above     | CLOSED CINEMA FRONT  |
| stock + staff rooms  | retail overlook      | ticket lobby         |
+----------+-----------+----------+-----------+-----------+----------+
| WEST     | RETAIL    | CENTRAL ATRIUM / MAIN CONCOURSE | FOOD COURT |
| SERVICE  | ARCADE    | fountain / directory / escalators| seating    |
| SPINE    |           |                                  | kitchens   |
+----------+-----------+----------------------+-----------+----------+
| SECURITY | SOUTHWEST | MAIN ENTRY / SOUTH CONCOURSE     | RESTROOMS |
| CCTV     | RETAIL    | vestibule / directory / doors     | JANITOR   |
+----------+-----------+----------------------+-----------+----------+
| LOADING / RECEIVING | SERVICE YARD / PARKING ACCESS | PLANT ROOMS |
+---------------------+------------------------------+-------------+
SOUTH

### Public circulation
A continuous public loop must connect the main entrance, central atrium, department store, north retail/entertainment, food court, east retail and south retail. Players should have at least two viable routes between major public zones, except deliberately gated areas.

### Back-of-house circulation
A separate staff/service spine links loading/receiving, stockrooms, department store back rooms, kitchen support, janitorial, security, electrical and HVAC. This route must feel like staff infrastructure, not a second public mall. Doors, signage, floor finishes, lighting and ceiling services should communicate the transition.

### Vertical circulation
Provide two public escalator pairs near the atrium, at least two public stair cores, one staff/service stair, and one service elevator. The upper level must connect to the atrium balcony and continue the public loop. Avoid making a single staircase the only route between floors.

## 5. Upper-floor adjacency plan

NORTH
+----------------------+----------------------+----------------------+
| DEPARTMENT STORE     | NORTH BALCONY        | ENTERTAINMENT        |
| offices / stock      | overlook to atrium  | CLOSED CINEMA        |
+----------+-----------+----------------------+-----------+----------+
| WEST     | UPPER     | ATRIUM BALCONY / RETAIL LOOP      | EAST     |
| OFFICES  | RETAIL    | railings / kiosks / overlooks      | RETAIL   |
+----------+-----------+----------------------+-----------+----------+
| STAFF    | SMALL     | SOUTH BALCONY / DIRECTORY         | LOUNGE   |
| CORRIDOR | TENANTS   | overlooks entrance                 | CLOSED   |
+----------+-----------+----------------------+-----------+----------+
SOUTH

Upper floor should not be an empty ring. Give it tenant depth, a few closed storefronts, a small seating lounge, staff access, an office cluster and controlled views down to the atrium. Some portions may be blocked by shutters or temporary barriers, but the reason must be believable.

## 6. Zone-by-zone build requirements

### A. Exterior arrival and primary entrance
- Covered entrance canopy with believable supports, glazing and weathering.
- Exterior mall sign with original fictional brand name; do not use a real mall brand.
- Automatic sliding doors or fixed glass vestibule doors, some disabled or partly shuttered.
- Exterior paving, curb, bollards, planters, litter, parking-lot lighting and abandoned vehicles only where justified.
- Arrival sightline reveals the atrium but does not expose the whole map.
- One clear player spawn staging area; do not spawn players directly into a Creature's line of sight.

### B. Security vestibule / main entrance
- Two-door airlock-like public vestibule with mat wells, glass, door sensors and security signage.
- Directory kiosk visible beyond the doors.
- Emergency exit signage and believable ceiling fixtures.
- Environmental storytelling should be restrained: abandoned flyers, a tipped queue barrier, a dead display.

### C. Central atrium (signature set piece)
- Full-height open volume with two visible levels.
- Skylight or high clerestory system with structural beams.
- Upper balcony railings with safe collision and correct height.
- Two escalator banks and at least one conventional stair.
- Fountain, dry water feature or sculptural centerpiece; choose one coherent design and do not clutter it.
- Seating clusters, planters, kiosk island and directory display.
- Multiple storefront facades with unique silhouettes around the perimeter.
- Strong vertical composition from ground-level player camera.
- Lighting must create depth and readable silhouettes; do not make the atrium uniformly pitch black.
- Include at least three routes out of the atrium at ground level and two routes on the upper level.

### D. Main concourse
- Broad polished tile or stone floor with expansion joints and realistic wear.
- Ceiling grid, recessed fixtures, skylight transitions, HVAC diffusers, sprinklers, speakers and access panels.
- Original hanging directional signage at intersections.
- Seating islands and planters that do not obstruct required routes.
- A few abandoned movable props, placed with believable logic.

### E. Retail units
Create at least six visually distinct tenant shells for the vertical slice; each needs a different frontage and internal purpose. Example fictional tenants:
- Lumen & Leaf — home/lifestyle display store.
- Northline Outfitters — apparel and storage racks.
- Paper Harbor — books, stationery and shelving.
- Circuit House — electronics display counters.
- Bellwether Goods — department-style general retail.
- Marrow & Thread — fashion boutique.

All names are provisional fictional examples. Do not use real brands or logos. Vary ceiling height, shelving, counter placement, display windows, stockroom doors and clutter. Do not copy/paste identical box rooms with different signs.

### F. Department store
- Large multi-department sales floor with counters, shelving, mannequins or display forms used tastefully.
- Separate stockroom, staff break room, office, receiving door and fitting room cluster.
- Distinct floor finish or lighting identity.
- Multiple sightline breaks without making every aisle a hiding tunnel.
- Upper floor or mezzanine only if it supports the overall architecture and route plan.

### G. Food court and kitchens
- Shared seating area with varied table layouts, chairs, trash/recycling points and service counters.
- Multiple fictional food vendor fronts with consistent mall signage language.
- Behind counters: prep surfaces, refrigeration silhouettes, pass-throughs and staff-only doors.
- Back kitchen service corridor links to receiving and janitorial.
- Grease, dust, water marks and abandoned packaging used sparingly.
- Avoid random food clutter everywhere.

### H. Restrooms and janitorial
- Separate public restroom entrances with privacy-conscious layouts.
- Sink and mirror zone, stalls, partitions, accessible stall and service access.
- Janitor closet includes mop sink, shelves, cart, cleaning supplies and floor drain.
- No arbitrary crawlspace or hiding spot inside every stall; authored hiding rules only.

### I. Security office / CCTV
- Located near south/west public zone with a staff corridor connection.
- Reception window, security desk, monitors, radio charging dock, wall map, filing storage and staff lockers.
- CCTV screens can be dark, static or partially functioning; never display fake real-time player tracking unless the gameplay system supports it.
- It is not a permanent safe room. Entry and exit routes must be multiple and contestable.

### J. Loading dock and receiving
- Service truck bay, dock leveler silhouette, roll-up shutter, receiving staging, pallet jacks, carts, shelving and waste/recycling area.
- Connect to department store stockroom and service spine.
- Believable high ceiling and industrial lighting.
- Avoid open routes that allow players to bypass the entire map.

### K. Maintenance / electrical / HVAC
- Electrical switch room with panels and warning labels; no real-world hazardous instructions.
- Mechanical plant with ducts, pipes, pumps, fans and service platforms.
- Maintenance workshop with tool benches and parts storage.
- Service doors and access controls should align with objectives.
- HVAC routes may be Creature-only shortcuts only if designed and tested; never allow arbitrary wall traversal.

### L. Parking connection
- A limited, readable connection to a parking garage or covered parking access.
- Concrete columns, parking bay markings, directional arrows, pedestrian doors and emergency stair core.
- Do not build a giant parking map for the first slice. A short, atmospheric connection is enough.

### M. Optional discovery room
- A hidden former mall operations archive or sealed tenant room.
- Entry must be discoverable through environmental clues, not random wall clipping.
- Contains lore/evidence, a cosmetic discovery or optional contract clue, not mandatory progression.
- Must be reachable by a legitimate route and have a safe exit.

## 7. Environmental storytelling
Use small coherent stories rather than piles of random props:
- A maintenance cart left beside a half-repaired light.
- A security clipboard and hand-drawn closure notice.
- A food court table set for a group that never returned.
- A department store display with one missing mannequin.
- A directory screen stuck on an outdated announcement.
- A service door marked with an original fictional mall department label.
- Evidence of hurried closure near receiving.
Every clue should have a location, narrative purpose and optional gameplay relevance. Avoid readable paragraphs on tiny props; use large, legible short labels.

## 8. Map landmarks and orientation
At minimum:
1. Main entrance canopy / directory.
2. Central atrium centerpiece.
3. Distinctive escalator pair.
4. Department store facade.
5. Food court vendor sign band.
6. Security office glass frontage.
7. Loading dock shutter and receiving sign.
8. Upper balcony feature or skylight.
9. Parking connector sign.
10. Optional archive clue.

Place wayfinding signs at every major decision junction. Use a consistent naming convention (e.g., SOUTH CONCOURSE, WEST RETAIL, FOOD COURT, NORTH WING, SERVICE CORRIDOR). Keep sign text large enough to read in motion.

## 9. Spawn, objectives, loot and extraction
- Explorer spawn: protected staging location near entrance/briefing access, not inside the active threat path.
- AI Creature spawn: selected from validated spawn nodes with path access and fair distance from players.
- Human Creature spawn: designated zone with a setup window and no immediate line of sight to Explorer spawn.
- Objective nodes: security office, electrical room, receiving, selected tenant stockroom and one optional archive clue. Rotate objectives only among validated nodes.
- Loot nodes: display counters, office drawers, stockroom shelves, lockers and service containers; avoid placing every reward in the same room type.
- Extraction candidates: primary public entrance and one alternate service/parking exit. Only activate the configured extraction route(s) per round; announce activation clearly.
- Never place extraction in a one-door dead end. Ensure approach, defense and retreat options are understandable.

## 10. Navigation and fairness rules
- Major public zones connect through at least two routes where practical.
- Every objective has a fallback route.
- No spawn camping.
- No hiding inside arbitrary mesh geometry.
- All hiding spots have explicit entry, occupancy, exit and Creature interaction rules.
- Creature pathing must work on both floors and approved service shortcuts.
- Human and Creature collision may differ only through explicitly authored traversal rules.
- Doors and shutters cannot create unbreakable traps.
- Avoid infinite loop routes; define gates, cooldowns or route risk.
- Validate every stair, escalator, vault and slide clearance with actual rigs.
- Mark no-go areas and invisible boundaries clearly in the blockout.

## 11. Build sequence
1. Establish scale reference using a Roblox avatar and a door/counter/stair kit.
2. Build the exterior shell and structural grid.
3. Build ground-floor public loop with simple materials.
4. Build the atrium void and upper balcony; validate sightlines.
5. Add the upper-floor public loop and vertical connections.
6. Build the service spine and back-of-house rooms.
7. Add retail shells and tenant-specific interiors.
8. Add objectives, loot nodes, extraction and hiding spots.
9. Test Explorer and Creature traversal with collision.
10. Only then perform the full art and lighting pass.
11. Add environmental storytelling and sound zones.
12. Profile streaming, memory, draw/instance load and server pathfinding.
13. Capture required review screenshots and request approval.

## 12. Required review camera views
Capture these exact views in Roblox Studio/live play:
- Exterior front approach at avatar eye height.
- First-person entrance looking into atrium.
- Ground-floor atrium wide view toward skylight.
- Atrium view from upper balcony looking down.
- Main concourse looking north.
- Main concourse looking south toward entrance.
- Food court wide and kitchen threshold.
- Department store sales floor and stockroom threshold.
- Security office from public corridor and inside.
- Loading dock looking toward receiving.
- Maintenance/electrical room.
- Upper retail loop.
- Parking connector.
- Optional discovery room.
- Top-down ground-floor plan with labels.
- Top-down upper-floor plan with labels.
- Explorer route overlay and Creature route overlay.

## 13. Definition of map approval
The Mall is not approved until:
- Its public and service circulation makes architectural sense.
- It has the full signature atrium and recognizable landmark identity.
- The floor plans match the built map.
- All required zones are present or explicitly deferred.
- No major room is an empty placeholder.
- Routes are navigable and fair in solo and multiplayer.
- AI and human Creature traversal are verified.
- Lighting supports both atmosphere and visibility.
- Materials, props and signage are coherent and original.
- It performs acceptably on representative low-end mobile and desktop devices.
- The review screenshot set is supplied.
- The user approves the map before Hotel production begins.