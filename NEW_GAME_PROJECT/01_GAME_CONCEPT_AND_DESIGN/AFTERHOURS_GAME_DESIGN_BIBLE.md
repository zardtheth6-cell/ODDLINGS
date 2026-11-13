# AFTERHOURS — Game Design Bible

## High concept
A closed shopping mall, hotel or other public building is not necessarily empty after closing. Players enter as Explorers to investigate, search for valuables, complete contracts and escape. The building can behave strangely. Entities may observe, stalk, deceive or hunt them. Alternatively, a player can take control of a Creature and attempt to stop the Explorers.

Tagline: **Explore. Hunt. Survive. Escape.**

## Non-negotiable identity
This is horror exploration, stealth, survival and extraction—not a shooter. Explorers are ordinary people using flashlights, batteries, backpacks, keys, access cards, lockpicks, scanners and practical tools. There are no firearms, guns, ammunition, shooting, weapon loadouts, crosshairs, hit markers or military HUD elements.

## Core Explorer loop
1. Return to headquarters and prepare equipment.
2. Choose a location, contract and difficulty.
3. Enter the building and learn its layout.
4. Search rooms, containers and restricted areas.
5. Complete primary and optional objectives.
6. Respond to environmental events and entity behavior.
7. Decide whether to extract now or risk staying for more rewards.
8. Reach a valid exit and extract.
9. Receive rewards, XP, progression and discoveries.

## Creature round loop
1. Matchmaking assigns or offers the Creature role fairly.
2. Player selects an available Creature archetype and cosmetic presentation.
3. Round briefing explains the map and role rules.
4. Creature spawns in a fair designated zone with a short setup period.
5. Creature tracks Explorers through its own senses and abilities.
6. Creature uses patrol, deception, pursuit, ambush and area control.
7. Server-confirmed captures trigger creature-specific cinematic sequences.
8. Round ends when Explorer or Creature win conditions are met.
9. Both sides receive fair rewards based on participation and performance.

## Modes
### Solo Expedition
One human Explorer versus AI threat director and AI creatures. Objectives, loot density, event intensity, threat count and extraction rules are balanced for one player. Solo is a complete experience, not an empty multiplayer lobby.

### Cooperative Expedition
1–4 Explorers. Teamwork helps but no role requires voice chat. Use contextual pings, quick commands, objective markers and optional text chat.

### Asymmetrical Hunt
One player-controlled Creature versus 1–4 human Explorers. Creature has separate locomotion, camera, senses, audio, abilities and capture animation. Balance this mode separately from AI expeditions.

### Practice
Teach Explorer movement, equipment and Creature controls in a safe training space.

## Win conditions and fairness
Explorers win by meeting the primary objective threshold and successfully extracting the required number of players. Optional loot increases rewards but is not required. Creature wins by preventing the extraction condition or capturing the required number before time expires. Avoid instant unavoidable kills, spawn camping, infinite loops, door trapping and unfair extraction camping. Give Explorers tells and counterplay; give Creature abilities meaningful limits.

## Progression and economy
Soft currency comes from objectives, recovered valuables, contracts, discoveries, extraction and fair role participation. XP and levels unlock titles, cosmetics, equipment options and locations. Equipment upgrades expand options and modestly improve convenience, not remove vulnerability. Creature progression focuses on archetype access, cosmetics, alternate animations, intros and victory poses—not decisive pay-to-win power. Paid purchases must be transparent and must not make free players unable to survive or compete.

## Headquarters
A believable after-hours operations room and dispatch facility, not a military command center. Include expedition board, equipment counter, appraisal station, profile display, trophy shelves, party/matchmaking area, tutorial access and daily/weekly contracts. Use grounded architecture: concrete, painted steel, glass, practical lighting, signage and functional props.

## Hybrid horror
Psychological/environmental events include power failures, distant footsteps, PA announcements, moving objects, strange elevators, silhouettes, locked wings, room sounds and moments of silence. Physical entities have unique tells, movement, senses, AI, capture sequences and counterplay. Quiet stretches build anticipation. Do not trigger a jumpscare every minute. Events must be paced and context-aware.

## Signature systems
### Building State / Event Director
Server-authoritative weighted event scheduler based on location, elapsed time, noise, objective progress, player distribution and threat pressure. Enforce cooldowns, prevent contradictory events and preserve safe windows.

### Noise and attention
Actions emit noise with intensity, distance falloff and category. Sprinting, sliding, jumping/landing, slamming doors and dropping objects are louder than careful walking or crouch movement. Creature perception uses server-validated stimuli; do not expose exact Explorer positions unless an ability legitimately reveals limited information.

### Loot risk
Valuables occupy capacity/weight. Carrying more may modestly reduce speed or increase noise. Players choose when to extract. Communicate loss and retention rules clearly.

### Capture and recovery
Capture is a server-confirmed state transition. The caught player's client plays the private camera sequence after confirmation. Other players see an appropriate world-space animation. Define eliminated, carried, rescued or spectate outcomes per mode. Prevent duplicate triggers and animation desync.

## Initial content strategy
Build one excellent vertical slice first: headquarters slice, one Mall expedition route, core movement, loot/objectives, one environmental event family, one AI Creature and one playable Creature prototype. Validate fun and performance before multiplying content.

## Quality definition
Realism means convincing scale, material response, lighting, sound, movement, animation, UI hierarchy and environmental storytelling within Roblox constraints. It does not mean maximum polygon count or unoptimized effects. Prioritize authored quality over map size.