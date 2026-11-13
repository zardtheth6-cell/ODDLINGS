# AFTERHOURS Map Build and Performance Standard

## Visual target
The Mall must feel like a believable, abandoned commercial building with coherent architecture, material scale, lighting logic, wear patterns, signage, clutter and navigation. Realism comes from composition and consistency, not from filling every surface with random detail.

## Greybox before art
Build and validate:
- Overall floor plan and circulation.
- Entrances, exits and extraction route.
- Main loop and alternate routes.
- Objective room locations.
- Safe-ish staging and high-risk areas.
- Vertical links, stairs, escalators and service corridors.
- Spawn points and Creature traversal.
- Sightlines, hiding spaces and bottlenecks.
- Accessibility and collision clearance.

Do not fully detail rooms before the route and pacing are playable.

## Spatial readability
Each zone needs a distinct silhouette, lighting identity, landmark and sound identity. Players should be able to build a mental map without a minimap. Use consistent signage, store naming, color/material families and environmental landmarks. Do not use visual noise to hide poor navigation.

## Environment detail layers
1. Primary architecture: walls, floors, ceilings, columns, storefronts and structural rhythm.
2. Large props: kiosks, counters, seating, shelving and escalator structures.
3. Mid-scale storytelling: abandoned merchandise, carts, posters, security equipment and maintenance items.
4. Surface detail: stains, scratches, dust, water marks and edge wear.
5. Lighting: practical fixtures, emergency lights, signage and localized failures.
6. Atmosphere: restrained fog, particles, distant movement and spatial audio.

## Material quality
Use plausible material roughness, reflectance, scale and wear. Avoid overusing glossy surfaces, noisy textures, stretched UVs, repeated decals and extreme normal intensity. Keep texture resolution proportional to camera distance. Use trim sheets and reusable material families where possible.

## Lighting rules
Lighting must support navigation and tension. Every dark area still needs safe visual readability and a deliberate gameplay purpose. Use a coherent color temperature and believable practical light sources. Avoid global darkness as a substitute for atmosphere. Test all critical routes at minimum supported graphics settings.

## Performance budgets
Set explicit budgets during greybox and update them after profiling:
- Visible instance count by zone.
- Texture memory and texture resolution tiers.
- Dynamic lights and shadow-casting lights.
- Particle emitters and active particles.
- Animated rigs and simultaneous animation tracks.
- AI pathfinding and raycast workload.
- Streaming region size and replication volume.
- Audio emitters and concurrent sound count.

Do not invent a universal safe part count. Profile the actual experience on representative low-end mobile and desktop devices.

## Reuse and modularity
Use modular wall, floor, ceiling, storefront and corridor kits. Reuse does not mean obvious repetition: vary approved modules through layout, dressing and lighting while preserving architectural logic. Keep collision meshes simple and invisible where possible.

## Navigation and collision
- Player collision must not snag on decorative props.
- Vault and slide clearances must be tested.
- Hiding spots need explicit occupancy and exit rules.
- Creature traversal routes must be deliberate and fair.
- No accidental softlocks or inaccessible loot.
- Every objective must have a readable route and fallback if a door or prop fails.

## Review checklist
- Is the layout believable?
- Can players navigate without voice chat?
- Are objective routes understandable?
- Are hiding spots fair and discoverable?
- Can the Creature reach intended areas?
- Are there unintended exploits or out-of-bounds routes?
- Does the map stream correctly?
- Does it maintain performance on target devices?
- Does the lighting preserve gameplay readability?
- Are all assets original, licensed or otherwise approved for use?