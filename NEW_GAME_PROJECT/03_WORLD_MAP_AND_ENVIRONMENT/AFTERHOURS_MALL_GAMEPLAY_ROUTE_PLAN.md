# AFTERHOURS — Mall Gameplay Route and Objective Plan

## Purpose
Define how the architecture supports exploration, stealth, AI navigation, human Creature play and replayability. The map is not a decorative backdrop; routes and room adjacencies are gameplay systems.

## Route network
Create three overlapping but distinct networks:
1. Public loop: wide, readable, high-exposure circulation through entrance, atrium, concourses, retail, food court and department store.
2. Service spine: narrow, staff-only circulation linking loading, stockrooms, kitchens, security and maintenance.
3. Vertical network: public escalators/stairs, staff stair and service elevator connecting both floors.

Players should learn that the public loop is easier to read but exposes them, while service routes are shorter and more dangerous. Do not make either route universally superior.

## Initial vertical-slice route
A recommended first mission route:
1. Enter through the south entrance and orient at the directory.
2. Cross a portion of the atrium to reach the west concourse.
3. Search a tenant or security reception for an access clue.
4. Use the service corridor to reach the electrical room.
5. Complete a power/restore objective using a simple interaction sequence.
6. The building event director triggers a context-appropriate event after the objective state changes.
7. Players decide whether to recover an optional evidence item in the archive/stockroom.
8. Extraction activates at one of the configured exits.
9. Players route through either the public concourse or a validated service/parking connector to extract.

This is a reference flow, not a mandatory fixed route for every mission. Randomized objectives must remain in validated room nodes and preserve a navigable path.

## Objective node categories
- Access: keys, access cards, locked staff doors.
- Restoration: electrical panel, breaker sequence, emergency lighting.
- Recovery: evidence case, ledger, package, tenant records.
- Search: locate a specified object category in a named zone.
- Delivery: carry a mission item to a handoff point.
- Optional discovery: find an archive clue or hidden tenant record.

Avoid objectives that require arbitrary pixel hunting. Use clear interaction prompts, readable clues and contextual pings.

## Loot placement
Use tagged spawn nodes grouped by room type:
- Public retail: display cases, checkout drawers, shelves.
- Offices: desks, cabinets, filing storage.
- Stockrooms: shelves, cartons, lockers.
- Maintenance: tool cabinets and parts storage.
- Food service: supply storage and staff lockers.
Do not spawn high-value loot in impossible-to-reach, blocked or random collision spaces. Each spawn node has a unique ID and an allowed item table.

## Creature route design
For each zone, author:
- AI path nodes and patrol loops.
- Sightline breaks.
- Sound propagation hints or approximate zones.
- Approved traversal shortcuts.
- Hide spots and their visibility.
- Chase loops and counterplay exits.
- Areas where Creature size/rig clearance is a concern.

Creature routes should create pressure but not guarantee capture. Avoid long straight corridors with no escape, and avoid loops where Explorers can kite indefinitely.

## Hiding spot rules
Only authored hiding spots are valid. Each has:
- Stable ID.
- Entry and exit interaction.
- Occupancy limit.
- Visibility/occlusion rule.
- Noise rule.
- Creature search interaction.
- Timeout or risk rule if needed.
- Rescue/escape behavior.
Never allow hiding inside arbitrary shelves, wall gaps, ceiling meshes or prop collision.

## Extraction design
At least two candidate extraction locations should exist in the map, but only the mission-configured extraction points activate. Each extraction point needs:
- A readable approach route.
- A clear interaction/hold zone.
- At least two approach/retreat options where practical.
- An appropriate line-of-sight profile.
- No one-way trap or inaccessible platform.
- A visible and audible activation cue.
- Server-authoritative extraction progress and interruption rules.

## Round variants
Replayability can come from changing:
- Objective node combinations.
- Which access doors are locked.
- Which service shortcut is available.
- Which extraction point activates.
- Which environmental event family is eligible.
- Loot distribution within safe spawn tables.
Do not randomize the architecture or create unreachable combinations. Build a mission validator that checks connectivity between spawn, required objectives and extraction before the round begins.

## Fairness tests
- Solo Explorer can complete the objective with reasonable pressure.
- Co-op players cannot permanently block each other in narrow corridors.
- Human Creature has multiple routes to contest objectives.
- Explorer has multiple routes to disengage from most major encounters.
- Spawn zones are protected from immediate capture.
- No objective can softlock if an optional door or interaction fails.
- Extraction cannot be triggered from outside its valid region.