# AFTERHOURS — Map and Environment Specification

## Environment standard
Build believable places, not empty horror mazes. Every room needs a purpose, believable dimensions, access routes, fixtures and environmental storytelling. The Mall is the first vertical-slice map. Do not build multiple huge maps before one location is polished and playable.

## Flagship location: THE MALL
A large, once-successful regional shopping mall that closed after an unexplained incident. It must feel like a real commercial property: consistent architecture, tenants, wayfinding, loading areas, security infrastructure, public spaces and back-of-house circulation. Create original store brands and signage.

### Required zones
1. Main entrance and security vestibule.
2. Central atrium with multiple visible levels.
3. Main concourse and side corridors.
4. Food court and kitchen/service access.
5. Department store.
6. Smaller retail units with unique layouts.
7. Public restrooms and janitor closets.
8. Security office / CCTV room.
9. Maintenance rooms, electrical room and HVAC access.
10. Loading dock and receiving corridor.
11. Parking access and garage connection.
12. Emergency exits and stairwells.
13. Restricted back corridors.
14. At least one secret or optional discovery area.

### Conceptual top-down blockout (not to scale)
NORTH
+-------------------+----------------------+-------------------+
| DEPT STORE        | UPPER ATRIUM / RAIL   | CINEMA / RETAIL   |
| storage + offices | overlooks lower floor| closed entrances  |
+---------+---------+----------+-----------+---------+---------+
| SERVICE | RETAIL  | CENTRAL ATRIUM        | FOOD COURT        |
| CORRIDOR| WING A  | escalators / fountain | kitchen / seating |
+---------+---------+----------+-----------+---------+---------+
| SECURITY| RETAIL  | MAIN CONCOURSE        | RESTROOMS / JAN.  |
| OFFICE  | WING B  | entrance sightline    | service access    |
+---------+---------+----------+-----------+---------+---------+
| LOADING DOCK / RECEIVING | PARKING ACCESS | MAINTENANCE       |
+--------------------------+----------------+------------------+
SOUTH / PRIMARY ENTRY

### Vertical structure
Ground floor: public spaces, retail, food court and service access. Upper floor: additional retail, balcony overlooking atrium, offices and restricted service routes. Below/adjacent: loading, maintenance and parking connection where performance allows. Prevent Creature players seeing through floors/walls.

### Gameplay zoning
Public zones have larger sightlines and higher exposure. Retail zones contain props, search containers, alternate routes and hiding opportunities. Service zones are narrower with shortcuts and higher tension. Atrium is an iconic landmark with long sightlines. Security room is useful but never a permanent safe room. Extraction zones are communicated clearly and should not always be simultaneously available.

### Map design rules
- Every major zone connects to at least two routes where practical; avoid unavoidable dead ends.
- Hiding spots are authored and validated; no hiding inside arbitrary geometry.
- Creature navigation works across floors, stairs, doors, vents and approved shortcuts.
- Define human and Creature navigation/collision separately when needed.
- Add landmarks and signage so players can orient themselves without a permanent minimap.
- Keep emergency routes legible.
- Randomize loot/objective placements only within validated spawn nodes.
- Use modular kits and streaming; avoid one monolithic unstreamable model.

## Secondary location: THE HOTEL
Build only after Mall vertical slice passes. Include lobby, reception, lounge, restaurant, guest corridors, guest rooms, housekeeping, laundry, kitchen, service elevator, stairwells, conference room and restricted floor. More enclosed and vertically layered than the Mall. Use repeating room modules with controlled variation.

## Realism checklist
Believable building proportions and ceiling heights; consistent structural grid; detailed floors, walls, ceilings, trim, doors, glazing and fixtures; material-specific roughness and reflectivity; purposeful prop placement; signage and wayfinding; ceiling systems (lights, vents, sprinklers, beams, cable trays and access panels); selective scuffs, dust, stains and water damage; no obvious repeated prop clusters; light sources correspond to visible fixtures; darkness creates tension without making navigation unusable.

## Performance and validation
Use modular kits, LOD/visibility strategy where appropriate, texture budgets, collision simplification, streaming and profiling. Test with multiple clients and lower-end device profiles. Capture screenshots from player height and overhead. A map is not approved because it looks good in Studio edit mode; it must look good and navigate correctly in live play.