# ODDLINGS — COMPLETE MASTER GAME DEVELOPMENT PROMPT
## Roblox Studio | Full Game Creation | Production-Quality Implementation

You are acting as a senior Roblox game developer, technical architect, gameplay designer, 3D environment artist, UI/UX designer, economy designer, multiplayer engineer, and monetization specialist.

Your assignment is to BUILD a complete, polished, commercially viable Roblox game called **ODDLINGS**.

This is not a request for a concept, prototype, design document, tutorial, or collection of disconnected scripts.

You must actually construct the playable game inside Roblox Studio.

You are starting from a **completely NEW, EMPTY Roblox Baseplate**. There is no existing game architecture, no prebuilt map, no existing UI, no existing creature system, and no existing gameplay systems that you may assume are available.

You must create everything required.

Do not simply explain what you would build. Build it.

Do not leave important systems as placeholders.

Do not create decorative buttons that do nothing.

Do not create fake functionality.

Do not tell me something is complete unless it actually works.

Every important mechanic, interface, purchase, interaction, animation, sound, and progression system must be connected to the appropriate backend and tested.

---

# SECTION 1 — THE GAME VISION

## 1.1 Game Identity

Game name: ODDLINGS

Core gameplay identity:

**STEAL. ESCAPE. COLLECT. EARN. PROTECT.**

ODDLINGS is a colorful, highly replayable multiplayer creature-collecting simulator.

Players discover strange and entertaining creatures called Oddlings throughout a colorful island.

They steal creatures from guarded territories, carry them back to their bases, protect their collections from other players, raid rival bases, and earn passive income from the creatures they own.

Players use their income to:
- Upgrade their movement.
- Unlock new territories.
- Increase their collection capacity.
- Improve their base security.
- Purchase useful items.
- Customize their bases.
- Unlock new creatures and progression rewards.

The game must be immediately understandable to a younger Roblox audience.

A player should be able to join and understand the main objective within their first 30 seconds.

The gameplay should be simple to understand but difficult to put down.

The intended gameplay loop is:

1. Spawn into the world.
2. Explore the island.
3. Find an interesting Oddling.
4. Steal it while avoiding its guardian.
5. Carry it back to your base.
6. Add it to your collection.
7. Earn passive cash.
8. Upgrade your character and base.
9. Raid other players.
10. Defend your own collection.
11. Unlock stronger territories and rarer Oddlings.
12. Repeat.

Do not turn this into an unnecessarily complicated RPG.

The focus is collecting, stealing, escaping, earning, upgrading, and defending.

## 1.2 Target Audience

Design primarily for Roblox players who enjoy:
- Creature collecting.
- Simulator progression.
- Stealing and raiding mechanics.
- Competitive multiplayer.
- Base building and upgrading.
- Rare collectibles.
- Social flexing.
- Fast rewards.
- Funny and memorable characters.

The experience must be approachable for younger players while retaining enough depth to keep experienced Roblox players engaged.

## 1.3 Visual Identity

The game must look like a professionally developed Roblox simulator.

Visual direction:
- Colorful.
- Vibrant.
- Playful.
- Highly polished.
- Rich environmental detail.
- Memorable characters.
- Oversized landmarks.
- Beautiful lighting.
- Carefully designed interfaces.

Do not create a generic Roblox map consisting of randomly placed Parts.

Do not use default-looking gray blocks as the final environment.

Do not make the game look like an unfinished simulator template.

Every area must have intentional art direction.

---

# SECTION 2 — COMPLETE WORLD DESIGN

## 2.1 World Name: Oddling Island

Create one connected, colorful island with multiple themed territories.

The world must feel like a real designed environment rather than a collection of disconnected platforms.

Use:
- Carefully sculpted terrain.
- Natural elevation.
- Hills.
- Valleys.
- Rivers.
- Ponds.
- Bridges.
- Paths.
- Decorative vegetation.
- Large landmarks.
- Detailed buildings.
- Gates.
- Portals where appropriate.

The map should be compact enough that players can understand it but large enough to feel like a proper multiplayer world.

Players should not spend excessive time walking through empty areas.

Every major location should have a recognizable silhouette and visual identity.

## 2.2 Central Plaza — Oddling Plaza

The plaza is the main social hub.

It should be immediately visible after spawning.

Include:

- Main spawn area.
- Large Oddling Island sign.
- Creature marketplace.
- Cash shop.
- Premium shop.
- Upgrade shop.
- Daily reward station.
- Rebirth station.
- Leaderboards.
- Collection index station.
- Event announcement area.
- Portal and territory access points.
- Decorative fountains.
- Creature statues.
- Benches.
- Flower beds.
- Animated decorations.
- Detailed paths.
- Attractive lighting.

The plaza should feel lively and premium.

Add animated environmental details, ambient sounds, and small visual surprises.

The shop should be physically represented in the world and also accessible through a convenient UI.

## 2.3 Territory One — Mushroom Woods

This is the beginner territory.

Environment:
- Rich green grass.
- Giant mushrooms.
- Small ponds.
- Colorful flowers.
- Trees.
- Mossy rocks.
- Winding dirt paths.
- Wooden bridges.
- Small waterfalls.
- Glowing mushrooms.
- Decorative plants.

Creatures:
- Beginner Common Oddlings.
- Uncommon Oddlings.
- A limited selection of Rare Oddlings.

Guardians:
- Friendly-looking but dangerous creatures.
- Relatively forgiving chase behavior.
- Easy-to-understand movement patterns.

This zone should teach players the stealing and escaping mechanics naturally.

## 2.4 Territory Two — Frostbite Fields

A snowy environment.

Include:
- Snow-covered hills.
- Frozen rivers.
- Ice caves.
- Snow-covered trees.
- Frozen bridges.
- Crystal formations.
- Frost particles.
- Cold environmental lighting.
- Detailed icy surfaces.

Guardians should be faster and more challenging than beginner guardians.

Creature rewards should be more valuable.

## 2.5 Territory Three — Molten Valley

A volcanic territory.

Include:
- Lava rivers.
- Volcanic rocks.
- Smoke vents.
- Glowing cracks.
- Industrial-looking structures.
- Fire effects.
- Heat distortion where practical.
- Dark red and orange environmental lighting.
- Metal bridges.
- Dangerous-looking terrain.

Guardians should be aggressive and have more challenging chase behavior.

## 2.6 Territory Four — Cosmic Outlands

An advanced, initially locked territory.

Include:
- Floating islands.
- Purple and deep-blue skies.
- Glowing plants.
- Strange alien vegetation.
- Floating crystals.
- Cosmic particles.
- Starry environmental details.
- Unusual structures.
- Unique environmental sounds.

This zone contains some of the rarest Oddlings.

Unlock it through a clearly displayed progression requirement.

## 2.7 Player Base Neighborhood

Create individual player base plots arranged around the island.

Bases should be visible and recognizable to other players.

Each player must receive their own assigned base.

The system must:
- Assign available plots.
- Prevent two players from owning the same plot.
- Remember ownership during the session.
- Handle players joining and leaving.
- Release plots correctly.
- Support player respawning at their own base.
- Save base progression.
- Restore base progression when the player rejoins.

Bases must not look like empty rectangular platforms.

They should have attractive structures, display areas, entrances, decorative details, and space for security upgrades.

## 2.8 Environmental Quality Requirements

Use appropriate materials and surface detailing.

Examples:
- Grass should look like grass, not a flat green Part.
- Stone should have visual variation.
- Wood should have grain and suitable material variation.
- Metal should have believable reflections.
- Ice should look cold and translucent where appropriate.
- Water should have reflections and movement.
- Foliage should have layered depth.

Use Roblox terrain, meshes, textures, materials, particles, and lighting intelligently.

Where custom assets are needed and cannot be sourced, create the best practical original assets using available Roblox Studio tools.

Do not rely on unsupported asset IDs.

Do not insert random free models from unknown sources.

Every asset must be inspected and safe to use.

---

# SECTION 3 — ODDLING CREATURE SYSTEM

## 3.1 Creature Design Philosophy

Oddlings are the main attraction of the game.

They must be original, funny, memorable, visually appealing, and recognizable from a distance.

The design direction is **intentional hybrid creatures**.

Combine ideas such as:
- Animals.
- Food.
- Household objects.
- Technology.
- Nature.
- Toys.
- Everyday objects.
- Absurd combinations.

Do not simply create a normal animal and recolor it.

Each creature should look like a collectible toy brought to life.

Every creature needs:
- A distinctive silhouette.
- An expressive face.
- High-quality 3D geometry.
- Attractive materials.
- Unique proportions.
- Idle animations.
- Movement animations.
- Carrying animations.
- Reactions.
- Appropriate sounds.
- Rarity.
- Income value.
- Spawn territory.
- Spawn probability.
- Collection index entry.

Higher rarity creatures must have more impressive models, materials, effects, animations, and presentation.

Rarity must not be communicated through a colored outline alone.

## 3.2 Initial Creature Roster

Build the following launch roster.

COMMON:

1. Fridgito — A tiny penguin with a refrigerator body.
2. Blorbo — A bouncing purple slime creature.
3. Toasturtle — A turtle with a toasted bread shell.
4. Berryhop — A frog with a strawberry body.
5. Socktopus — An octopus wearing colorful socks.

UNCOMMON:

6. Donut Snail — A snail with a giant frosted donut shell.
7. Roboquack — A robotic duck.
8. Prickles — A hedgehog mixed with a cactus.
9. Sushi Cat — A cat with a sushi-inspired body.

RARE:

10. Mushmoose — A moose with mushroom antlers.
11. Channel-0 — A television-headed creature.
12. Bananasaur — A banana dinosaur.
13. Bubblejaw — A shark covered in floating bubbles.

EPIC:

14. Clockroach — A cockroach with a clock body.
15. Melonphant — An elephant with a watermelon body.
16. Glitchling — A creature with digital distortion effects.

LEGENDARY:

17. Goldfish Tank — A walking aquarium containing a goldfish.
18. Crownach — A royal snail with a giant crown.

MYTHIC:

19. Nebulamb — A cosmic lamb containing glowing galaxies.

SECRET:

20. Voidzilla — A massive floating shadow creature.

These creatures must have genuinely distinct models.

Do not reuse the same model with different colors.

## 3.3 Rarity Tiers

Implement:

- Common.
- Uncommon.
- Rare.
- Epic.
- Legendary.
- Mythic.
- Secret.

Each tier must have:
- A consistent rarity color.
- A display label.
- A spawn probability.
- An income multiplier.
- A visual presentation standard.
- Appropriate sound and particle effects.

Make rarity probabilities configurable in a centralized configuration module.

Never hardcode rarity chances throughout unrelated scripts.

## 3.4 Creature Income

Every owned Oddling generates passive cash.

Each creature must have a configurable income rate.

Income should be calculated server-side.

The player must see:
- Creature name.
- Rarity.
- Income per second or minute.
- Total collection income.
- Individual creature value.

The interface must update smoothly without creating excessive server traffic.

Add a clear collection income display.

## 3.5 Creature Models and Reuse

Create a centralized creature model system.

Where practical, reuse the same underlying model for:
- Wild creatures.
- Carried creatures.
- Base display creatures.
- Collection index previews.

Avoid creating separate inconsistent versions of the same creature.

Make sure creature models are correctly scaled and positioned.

All models must have appropriate collision settings, PrimaryParts or equivalent attachment references, and animation support.

---

# SECTION 4 — WILD CREATURE SPAWNING AND STEALING

## 4.1 Spawn System

Oddlings spawn throughout their assigned territories.

Create spawn locations that fit the environment.

Do not scatter creatures randomly across inaccessible or visually awkward locations.

The spawn system must:
- Respect territory restrictions.
- Respect rarity chances.
- Control the number of active creatures.
- Prevent overlapping spawns.
- Respawn creatures after successful theft or capture.
- Handle server performance.
- Avoid duplicate ownership.
- Support future creature additions.

## 4.2 Guardian System

Guardians protect wild Oddlings.

Each creature should have an associated guardian difficulty.

Guardians need:
- Idle behavior.
- Patrol behavior.
- Detection range.
- Chase behavior.
- Attack or capture range.
- Return behavior.
- Appropriate animations.
- Sound effects.
- Visual feedback.

Create several guardian behavior types:

1. Slow Guardian — predictable and easy to escape.
2. Fast Guardian — quick pursuit.
3. Ambush Guardian — waits before attacking.
4. Persistent Guardian — follows for longer.
5. Large Guardian — blocks paths and forces players to change direction.

Guardian difficulty should increase with territory progression.

Do not create impossible chases.

Players must always have a reasonable chance of escaping with good movement and stamina management.

## 4.3 Stealing Interaction

When a player interacts with an eligible wild Oddling:
- Start the stealing interaction.
- Play an appropriate pickup animation.
- Assign the creature to the player's temporary carried state.
- Trigger the guardian.
- Attach the creature visibly to the player.
- Apply the carrying movement penalty.
- Start the escape gameplay.

Only one stolen creature may be carried at a time unless a future upgrade explicitly changes that rule.

## 4.4 Guardian Capture Rules

This rule is mandatory.

If a guardian catches a player carrying a stolen wild Oddling:

- The attempted theft fails.
- The stolen creature is removed from the player's temporary possession.
- The creature returns to its original spawn system.
- The player receives a capture animation.
- The player is respawned at their own base.
- The player loses no previously collected creatures.
- The player loses no cash.
- The player loses no upgrades.
- A short respawn delay prevents repeated immediate capture.

Only the creature currently being stolen is lost.

---

# SECTION 5 — PLAYER MOVEMENT SYSTEM

Create polished movement mechanics.

Movement must include:

1. Normal movement.
2. Sprinting.
3. Stamina.
4. Stamina regeneration.
5. Carrying movement penalty.
6. Dash.
7. Slide.

## 5.1 Sprint

Sprint consumes stamina.

Stamina must regenerate when the player is not sprinting.

Carrying an Oddling should increase stamina consumption.

## 5.2 Carrying Penalty

Carrying slows the player.

Initial balancing targets:

- Small Oddling: 10% movement reduction.
- Medium Oddling: 20% movement reduction.
- Large Oddling: 30% movement reduction.

These values should be configurable.

## 5.3 Upgrades

Players can spend cash to improve:
- Running speed.
- Sprint power.
- Stamina capacity.
- Stamina recovery.
- Carrying strength.
- Dash cooldown.
- Luck.

All upgrades must have meaningful progression and reasonable maximum levels.

Do not make movement upgrades so powerful that guardians become irrelevant.

## 5.4 Mobile and Controller Support

All movement abilities must work on:
- PC.
- Mobile.
- Tablet.
- Supported controllers.

Create proper mobile controls.

Do not rely entirely on keyboard inputs.

---

# SECTION 6 — PLAYER-TO-PLAYER CREATURE THEFT

Players must be able to steal creatures from other players who are currently carrying them.

This creates unpredictable multiplayer moments.

Rules:

1. A player carrying an eligible creature can be targeted.
2. Another player can perform a theft interaction within a defined range.
3. The interaction must have an animation.
4. A successful interaction transfers temporary carrying possession.
5. The creature must remain visible during the transfer.
6. A short cooldown prevents instant repeated stealing.
7. A short protection period prevents immediate back-and-forth transfers.
8. The server validates every theft attempt.

The creature must not permanently change ownership merely because another player stole it from its carrier.

Ownership changes only when the carrier successfully reaches the appropriate destination and completes the delivery rules.

If a valid bat hit causes the carrier to lose the creature, return it to its rightful owner or original source according to its current ownership state.

---

# SECTION 7 — BASE RAIDING SYSTEM

This is one of the most important systems in ODDLINGS.

Players must be able to raid other players' bases and attempt to steal their displayed creatures.

The system must be exciting, understandable, competitive, and fair.

## 7.1 Starting a Raid

When an intruder enters another player's restricted base area:

- Detect the intruder.
- Trigger the base security system.
- Notify the owner.
- Start the raid sequence when a creature theft attempt begins.
- Display a clear raid timer.
- Show the targeted creature.

The owner should immediately receive a warning.

Example notification:

"YOUR BASE IS BEING RAIDED!"

Use:
- Red warning lights.
- Audible siren.
- Flashing security indicators.
- On-screen notification.
- Optional map or direction indicator when supported.

## 7.2 Raid Timer

The thief has a limited amount of time to steal one creature and escape.

Create configurable raid timings.

Recommended starting balance:
- Raid window: 30 seconds.
- Creature interaction: approximately 2 seconds.
- Post-pickup escape window: the remaining raid time.

Display the countdown prominently.

The timer must be server-controlled.

## 7.3 Stealing a Base Creature

When the thief grabs a displayed creature:

- Temporarily remove it from the owner's display.
- Mark it as being carried by the thief.
- Preserve its original owner information.
- Attach it visibly to the thief.
- Slow the thief down.
- Continue the raid timer.
- Notify the original owner that a creature has been taken.

The creature does not immediately become the thief's property.

## 7.4 Successful Raid

A raid only succeeds when the thief reaches their own base and completes the delivery interaction before the timer expires.

At that point:
- Transfer permanent ownership.
- Remove the creature from the previous owner's saved collection.
- Add it to the thief's saved collection.
- Restore it to an appropriate display slot.
- Start passive income for the new owner.
- Notify both players.
- End the raid.

This ownership transfer must be atomic and server-authoritative.

Do not duplicate creatures if a player disconnects during the transfer.

## 7.5 Failed Raid

A raid fails if:
- The thief is hit by a valid bat attack.
- The thief is caught by a guardian where applicable.
- The raid timer expires.
- The thief is otherwise successfully stopped by the raid system.

On failure:
- The stolen creature returns to its rightful owner.
- The thief loses temporary possession.
- The thief is sent back to their own base when appropriate.
- The raid ends.
- The original owner receives a successful defense notification.
- The creature's original income resumes.

The thief must not keep the creature after a failed raid.

## 7.6 Owner Defense

The base owner should be able to:
- Equip their free bat.
- Attack an intruder.
- Activate their base security systems.
- Use the base layout to their advantage.
- Upgrade their security over time.

Do not allow defenders to permanently trap an attacker without counterplay.

## 7.7 Raid Cooldowns and Anti-Abuse

Implement:
- Raid cooldowns.
- Repeat-raid prevention.
- New-player protection.
- Protection against disconnect exploitation.
- Protection against multiple simultaneous theft transactions.
- Server-side validation.
- Clear ownership tracking.

A player must not be able to repeatedly target the same beginner player.

Recommended starting rules:
- A short protection period after a successful defense.
- A longer cooldown after repeated raids against the same target.
- Beginner protection for newly joined or low-progression players.
- No raids while the owner is loading data or their base is unavailable.

Make these values configurable.

---

# SECTION 8 — FREE BASEBALL BATS

Every player receives a basic baseball bat for free.

This is a core game mechanic, not a Robux-exclusive item.

The bat must be available automatically and must work without requiring a purchase.

## 8.1 Bat Combat

Create:
- Equip animation.
- Swing animation.
- Hit detection.
- Hit effects.
- Knockback.
- Brief stun.
- Swing cooldown.
- Appropriate sound effects.
- Clear visual feedback.

The bat must feel responsive and satisfying.

Use server-authoritative hit validation.

Do not rely on client-reported hit claims.

## 8.2 Bat Effect Against Carriers

This rule is mandatory.

If a player carrying a stolen creature is successfully hit by a valid bat attack:

- The creature is immediately dropped or returned through the server-controlled recovery process.
- The thief loses temporary possession.
- The creature returns to its rightful owner or original source.
- The thief receives a short stun and knockback.
- If this happens during a base raid, the raid immediately fails.
- The owner receives a successful defense notification.

This applies to a valid attack against a player carrying a stolen creature.

## 8.3 Bat Balance

The basic bat must be fair.

Use:
- Visible swing animation.
- Defined attack window.
- Reasonable hit range.
- Cooldown.
- Valid target checks.
- No repeated stun-locking.
- No attacking in protected zones.

Do not make it possible to swing continuously without consequence.

A successful hit should require reasonable timing and positioning.

## 8.4 Safe Zones

Bat attacks must not work:
- In the central plaza.
- In protected beginner areas.
- Against players who are protected by a legitimate spawn shield.
- Outside permitted combat areas.

The owner must be able to defend their base, but safe zones must remain safe.

## 8.5 Bat Cosmetics

Create cosmetic bat variants.

Examples:
- Classic Bat — free default.
- Neon Bat — glowing appearance.
- Golden Bat — gold material and effects.
- Thunder Bat — electric visual effects.

Cosmetic bats must not provide unfair combat advantages.

All bats must use the same fundamental damage, range, cooldown, and hit rules unless a future balanced gameplay design explicitly requires otherwise.

---

# SECTION 9 — BASE SECURITY UPGRADE SYSTEM

Every base has a security system.

Players spend earned cash to upgrade their base defenses.

The system must have visible physical improvements, not just invisible stat increases.

Create five upgrade categories.

## 9.1 Security Doors

Door progression:

Level 1 — Basic wooden gate.

Level 2 — Reinforced metal gate.

Level 3 — Heavy security door.

Level 4 — Automated high-tech gate.

Level 5 — Advanced energy barrier.

Higher levels should increase entry resistance and make breaking through or bypassing the entrance more difficult.

The interaction must remain understandable and fair.

Do not make doors completely impossible to bypass.

## 9.2 Alarm System

Alarm progression:

Level 1 — Basic on-screen notification.

Level 2 — Audible alarm.

Level 3 — Flashing warning lights.

Level 4 — Stronger owner warning and improved visual feedback.

Level 5 — Full base-wide security alert.

Alarms must actually trigger when an eligible intruder enters the restricted area.

## 9.3 Laser Traps

Laser traps must:
- Have visible beams.
- Detect intruders.
- Apply a temporary slowdown.
- Have a cooldown.
- Show their active/inactive state.
- Avoid affecting the base owner.
- Avoid permanently trapping players.

Higher levels can improve slowdown strength or coverage.

Use readable warning colors and visual indicators.

## 9.4 Base Shields

Base shields provide temporary raid protection.

They must:
- Be activated through a real interaction.
- Show a visible energy barrier.
- Display remaining protection time.
- Have a cooldown.
- Prevent new raids while active.
- Not activate during an existing raid.
- Have clear expiration feedback.

Higher levels can improve shield duration.

The shield must not provide unlimited permanent protection.

## 9.5 Intruder Detection

Detection progression:

Level 1 — Detects entry into the base.

Level 2 — Larger detection range.

Level 3 — Improved warning accuracy.

Level 4 — Indicates the intruder's general location.

Level 5 — Advanced tracking indicator within the base.

The owner must receive actual information, not a decorative fake alert.

## 9.6 Security Upgrade UI

Create a dedicated security interface.

For every category, show:
- Name.
- Current level.
- Current effect.
- Next-level effect.
- Upgrade price.
- Upgrade button.
- Locked/maxed status.
- Visual preview where possible.

All purchases must be server-validated.

## 9.7 Security Economy

Security upgrades must have meaningful costs.

Early upgrades should be affordable.

Later upgrades should require meaningful progression.

Do not make the maximum level immediately affordable.

Use centralized configuration values so prices and effects can be balanced easily.

---

# SECTION 10 — BASE DESIGN AND COLLECTION DISPLAY

Every player must have a personal base.

Include:
- Main building.
- Creature display platforms.
- Entrance.
- Security door.
- Security equipment locations.
- Cash collection indicator.
- Base upgrade station.
- Owner name display.
- Creature count.
- Total income display.
- Customization areas.

Creatures must be displayed attractively.

Each display slot must:
- Hold one creature.
- Show the creature's name.
- Show rarity.
- Show income.
- Support interactions.
- Have a clear ownership reference.

The base must expand or unlock additional display capacity through progression.

Do not allow display capacity to exceed the player's actual saved collection capacity.

---

# SECTION 11 — ECONOMY SYSTEM

Create a reliable economy with server-controlled transactions.

## 11.1 Main Currency: Cash

Cash is earned through:
- Passive creature income.
- Gameplay rewards.
- Daily rewards.
- Selling creatures where permitted.
- Events.
- Progression rewards.

Cash is spent on:
- Movement upgrades.
- Security upgrades.
- Base upgrades.
- Territory unlocks.
- Shop items.
- Additional creature slots.
- Other gameplay conveniences.

## 11.2 Premium Currency: Gems

Gems are an optional secondary currency.

They can be earned through selected rewards, events, and Robux purchases.

Use gems for:
- Cosmetic items.
- Convenience items.
- Special customization.
- Selected premium offers.

Keep cash as the primary progression currency.

## 11.3 Income Collection

Create an attractive collection income display.

Players must understand how much their Oddlings earn.

Use server-side income calculation.

Do not create excessive RemoteEvent traffic or individual server loops for every creature.

Use an efficient centralized income update system.

## 11.4 Selling

Allow players to sell eligible creatures if the design permits.

Include:
- Clear sell value.
- Confirmation for valuable creatures.
- Protection against accidentally selling rare creatures.
- Server-side ownership verification.

Do not allow selling a creature that is currently being raided or temporarily carried.

---

# SECTION 12 — SHOP AND MONETIZATION

The game must support both in-game cash purchases and Robux purchases.

The shop must be a fully working system.

Do not make purchase buttons that only display messages.

## 12.1 Shop Categories

Create three main shop tabs:

1. Upgrades.
2. Gamepasses.
3. Items.

Each category must have appropriate icons and working buttons.

Show:
- Product name.
- Description.
- Price.
- Currency type.
- Purchase state.
- Confirmation feedback.
- Ownership state for permanent purchases.

## 12.2 Cash Purchases

Include:
- Speed upgrades.
- Sprint upgrades.
- Stamina upgrades.
- Carrying strength.
- Luck upgrades.
- Base capacity.
- Security upgrades.
- Other useful progression items.

## 12.3 Gamepasses

Suggested permanent gamepasses:

- VIP.
- 2x Cash.
- Extra Storage.
- Extra Base Slots.
- Premium Name Tag.
- Cosmetic VIP effects.

Any speed or convenience pass must be balanced.

Do not make free players feel completely incapable of competing.

Gamepasses must be verified through Roblox MarketplaceService.

## 12.4 Developer Products

Suggested repeat purchases:

- Cash bundles.
- Gem bundles.
- Temporary speed boost.
- Temporary luck boost.
- Stamina refill.
- Escape shield.
- Cosmetic bundles.

All developer products must use secure receipt processing.

Use ProcessReceipt correctly.

Never grant developer product rewards from a client-side purchase-completed event alone.

Prevent duplicate reward grants.

Save receipt-processing information reliably.

## 12.5 Monetization Rules

Do not create deceptive purchase interfaces.

Do not disguise Robux purchases as free purchases.

Clearly distinguish:
- Cash.
- Gems.
- Robux.

Do not make premium bats stronger than free bats.

Cosmetic monetization should be attractive.

Paid random reward mechanics must not be introduced without appropriate odds disclosure, safeguards, and Roblox policy compliance.

---

# SECTION 13 — PLAYER PROGRESSION

Create progression that rewards continued play.

Include:

- Player levels.
- Territory unlocks.
- Creature collection milestones.
- Base upgrades.
- Movement upgrades.
- Security upgrades.
- Titles.
- Daily rewards.
- Rebirth.

## 13.1 Rebirth

Players can reset eligible progression in exchange for permanent bonuses.

Rebirth should:
- Have a clear requirement.
- Display the reward.
- Require confirmation.
- Grant permanent progression benefits.
- Preserve appropriate permanent entitlements.
- Handle data safely.

Do not accidentally delete purchases or permanent entitlements.

## 13.2 Titles

Create collectible titles.

Examples:
- Oddling Hunter.
- Creature Collector.
- Master Thief.
- Base Defender.
- Rare Hunter.
- Island Legend.

Titles should be visible above players and in relevant profile interfaces.

They must be saved.

## 13.3 Daily Rewards

Create a daily login reward system.

Include:
- Consecutive-day streaks.
- Cash rewards.
- Gem rewards.
- Occasional cosmetics.
- Clear countdown.
- Server-side claim validation.

Prevent multiple claims through client manipulation.

## 13.4 Leaderboards

Create leaderboards for:
- Total cash earned.
- Rare creatures collected.
- Player level.
- Rebirths.
- Successful raids.

Make them visually attractive and readable.

---

# SECTION 14 — COLLECTION INDEX

Create a fully working Oddling collection book.

It must display all known creatures.

For each entry:
- Creature name.
- Model preview.
- Rarity.
- Territory.
- Income rate.
- Discovery state.
- Collection state.

Unknown creatures should have a mysterious silhouette or locked appearance.

Players should be able to see what they have not discovered.

Include completion rewards for collection milestones.

The collection interface must use the same centralized creature definitions as the spawning and base systems.

Do not maintain separate manually duplicated creature lists.

---

# SECTION 15 — RANDOM WORLD EVENTS

Create occasional world events that make the world feel alive.

Initial events:

1. Golden Oddling — A special golden creature appears somewhere in the world.
2. Creature Stampede — Creatures run through the central plaza.
3. Meteor Crash — A meteor lands in Cosmic Outlands.
4. Blackout — Plaza lights temporarily go out.
5. Rare Visitor — A special limited-time creature appears.

Events must have:
- Announcements.
- Visual effects.
- Sounds.
- Start and end conditions.
- Appropriate rewards.
- Server-controlled scheduling.
- Proper cleanup.

Do not allow overlapping events to break the world.

Make event settings configurable.

---

# SECTION 16 — USER INTERFACE DESIGN

The UI must look like a professionally designed Roblox simulator interface.

It must be visually consistent.

Use:
- Rounded cards.
- Attractive gradients where appropriate.
- Clear typography.
- Readable text.
- Consistent spacing.
- High-quality icons.
- Subtle animation.
- Proper responsive layouts.
- Clear button states.

Avoid default Roblox-looking interfaces.

## 16.1 Main HUD

Include:
- Cash display.
- Gem display.
- Player level.
- Current income.
- Sprint/stamina indicator.
- Current carried creature.
- Territory indicator.
- Shop button.
- Collection button.
- Base button.
- Upgrade button.
- Settings button.

## 16.2 Raid HUD

When a player is being raided:
- Prominent warning.
- Intruder information.
- Countdown.
- Creature theft status.
- Defense status.

When a player is raiding:
- Target owner.
- Remaining raid time.
- Carried creature.
- Escape status.

## 16.3 Carrying HUD

When carrying an Oddling:
- Show creature name.
- Show rarity.
- Show carrying state.
- Show movement penalty where useful.
- Show delivery destination.
- Show clear loss warning when appropriate.

## 16.4 Shop Interface

Create all three tabs.

Every button must be connected.

## 16.5 Base Security Interface

Create a separate interface for security upgrades.

## 16.6 Collection Interface

Create a complete creature index with model previews and discovery states.

## 16.7 Mobile UI

All interfaces must work on mobile.

Do not let the HUD cover essential gameplay controls.

Use appropriately sized touch targets.

## 16.8 UI Icons

Every icon must be appropriate to its function.

Use original, consistent iconography where possible.

Do not use random unrelated icons.

Do not leave missing image IDs or broken icon references.

If an external image asset is unavailable, create a suitable original visual alternative.

---

# SECTION 17 — AUDIO AND ANIMATION

The game must feel alive.

Create or implement appropriate sounds for:

- Collecting creatures.
- Creature idle behavior.
- Creature movement.
- Creature pickup.
- Guardian detection.
- Guardian chase.
- Guardian capture.
- Base alarm.
- Security door.
- Laser trap.
- Shield activation.
- Bat swing.
- Bat impact.
- Creature return.
- Successful raid.
- Failed raid.
- Cash collection.
- Shop purchase.
- Level-up.
- Territory unlock.
- Rebirth.
- World events.

Animations must include:
- Player carrying.
- Creature idle.
- Creature movement.
- Creature pickup.
- Creature drop.
- Guardian patrol.
- Guardian chase.
- Guardian capture.
- Bat swing.
- Hit reaction.
- Knockback.
- Security animations.
- Relevant UI transitions.

Do not use one generic animation for every creature.

Use distinct animation behavior appropriate to each creature's design.

Where custom animation assets are unavailable, build practical procedural animations using supported Roblox animation and movement systems.

---

# SECTION 18 — DATA SAVING AND MULTIPLAYER RELIABILITY

This section is critical.

Use a clean server-authoritative architecture.

## 18.1 Saved Player Data

Persist:
- Cash.
- Gems.
- Owned Oddlings.
- Creature ownership records.
- Creature display positions.
- Base ownership progression.
- Base capacity.
- Security levels.
- Movement upgrades.
- Player level.
- Experience.
- Titles.
- Daily reward streak.
- Rebirth count.
- Permanent purchases where appropriate.
- Other progression.

Use DataStoreService appropriately.

## 18.2 Data Safety

Implement:
- Safe loading.
- Safe saving.
- Retry logic.
- Error handling.
- Autosaving.
- PlayerRemoving handling.
- BindToClose handling.
- Session safety.
- Data versioning.
- Migration support where necessary.

Do not overwrite valid player data with empty defaults because a DataStore request failed.

Do not silently reset player progression.

## 18.3 Raid and Theft Data Integrity

This is especially important.

A creature must never be duplicated or permanently disappear due to:
- Player disconnecting.
- Server shutdown.
- Failed save.
- Raid timer ending.
- Bat hit.
- Guardian capture.
- Simultaneous theft requests.
- Two players interacting at the same time.

Use clear transaction states.

For a creature being stolen, track:
- Original owner.
- Current temporary carrier.
- Original source.
- Current transaction state.
- Intended destination.
- Transfer status.

Permanent ownership must only change after a successful delivery transaction.

If the transaction is interrupted, safely recover the creature to its rightful owner.

For cross-player transactions, use reliable server-side coordination and appropriate persistent recovery records.

Never rely on a client telling the server who owns a creature.

## 18.4 Exploit Prevention

The server must validate:
- Cash transactions.
- Gem transactions.
- Purchases.
- Creature ownership.
- Theft attempts.
- Base raid attempts.
- Bat hits.
- Guardian captures.
- Movement upgrade purchases.
- Security upgrade purchases.
- Rebirth.
- Daily rewards.

Clients may request actions but must never decide the result of important actions.

Add reasonable remote request limits.

Validate player distance, cooldowns, eligibility, state, and ownership.

Do not trust client-supplied prices, rewards, ownership, hit results, or movement values.

---

# SECTION 19 — TECHNICAL ARCHITECTURE

Build a clean and scalable Roblox project structure.

Use appropriately organized folders and ModuleScripts.

Suggested architecture:

ReplicatedStorage
- Remotes
- Shared
  - Config
  - CreatureDefinitions
  - RarityDefinitions
  - EconomyConfig
  - UpgradeConfig
  - SecurityConfig
  - GameSettings
  - SharedUtilities
  - UIAssets

ServerScriptService
- Server
  - PlayerDataService
  - CurrencyService
  - CreatureService
  - CreatureSpawnService
  - GuardianService
  - CarryService
  - TheftService
  - RaidService
  - BatCombatService
  - BaseService
  - BaseSecurityService
  - UpgradeService
  - ShopService
  - MonetizationService
  - DailyRewardService
  - RebirthService
  - EventService
  - LeaderboardService
  - AntiExploitService
  - MainServerBootstrap

ServerStorage
- CreatureModels
- GuardianModels
- BaseAssets
- EnvironmentAssets
- ItemAssets
- SecurityAssets

StarterPlayer
- StarterPlayerScripts
  - Client
    - InputController
    - MovementController
    - UIController
    - ShopController
    - CollectionController
    - CombatController
    - NotificationController
    - EffectsController

StarterGui
- MainHUD
- ShopUI
- CollectionUI
- BaseUI
- SecurityUI
- RaidUI
- NotificationsUI
- SettingsUI

Workspace
- Map
- Territories
- Bases
- CreatureSpawns
- ActiveCreatures
- ActiveGuardians
- WorldEvents
- InteractiveObjects

This is a suggested organizational structure, not an excuse to create empty folders.

Every created service must have a real purpose and working implementation.

You may improve the architecture if needed, but maintain clear separation between client, server, shared configuration, and assets.

Do not create one enormous script containing the entire game.

Do not create dozens of unnecessary scripts that depend on unclear global variables.

Use explicit dependencies and clear initialization order.

---

# SECTION 20 — PERFORMANCE AND QUALITY

The game must support a healthy multiplayer server population.

Optimize:
- Creature spawning.
- Guardian AI.
- Pathfinding.
- Income calculations.
- UI updates.
- Remote communication.
- Particle effects.
- Environmental animation.
- Base display models.

Do not create a separate constantly running loop for every creature if a centralized update system can handle the work.

Use appropriate network ownership and physics settings.

Avoid excessive physics calculations.

Avoid unnecessary object creation and destruction.

Use pooling where beneficial.

Make sure the game remains playable on lower-end mobile devices.

---

# SECTION 21 — IMPLEMENTATION REQUIREMENTS

You must implement the game in a structured, dependency-aware order.

However, this is ONE COMPLETE MASTER ASSIGNMENT.

Do not turn this into nine separate prompts.

Do not stop after creating a design document.

Do not finish only the first system and claim the entire game is complete.

Build the complete game in Roblox Studio.

Use the following implementation sequence internally:

1. Project architecture and world construction.
2. Player spawning and base assignment.
3. Creature definitions, models, and spawning.
4. Guardian AI and wild creature stealing.
5. Carrying and movement mechanics.
6. Cash economy and passive income.
7. Base displays and creature ownership.
8. Base raiding and raid timers.
9. Free bats and combat.
10. Base security upgrades.
11. Shop and monetization.
12. Collection index and progression.
13. Events and daily rewards.
14. UI, audio, animation, and polish.
15. Data integrity and multiplayer testing.

Systems that depend on other systems must be connected correctly.

If a required system is not yet implemented, do not create a fake UI for it and pretend it works.

Build the underlying functionality before marking the interface complete.

---

# SECTION 22 — REQUIRED TESTING

You must test the actual game in Roblox Studio.

Do not rely only on reading your own code.

Use multiplayer testing with multiple clients.

Test the following scenarios:

### Creature stealing
- Player steals a Common creature.
- Guardian detects the player.
- Player escapes successfully.
- Creature arrives at the base.
- Creature begins generating income.
- Player gets caught.
- Creature returns to the world.
- Player respawns at their own base.

### Player theft
- Player A carries a stolen creature.
- Player B attempts to steal it.
- Successful transfer works.
- Cooldowns work.
- Ownership is not duplicated.
- Bat interruption works.

### Base raiding
- Player A enters Player B's base.
- Player B receives an alarm.
- Player A grabs a creature.
- Raid timer appears.
- Player A successfully escapes.
- Ownership transfers.
- Income transfers.
- Player B is notified.

### Failed raids
- Timer expires.
- Thief gets hit by a bat.
- Thief disconnects.
- Owner disconnects.
- Server shutdown occurs during a raid.
- Creature is recovered correctly.

### Base security
- Door upgrades work.
- Alarm levels work.
- Laser traps detect intruders.
- Shields prevent new raids.
- Shields expire correctly.
- Detection systems display real intruder information.
- Owner is not affected by their own traps.

### Bat system
- Free bat is granted.
- Swing animation works.
- Hit detection works.
- Knockback works.
- Stun cooldown works.
- Bat cannot be abused in safe zones.
- A successful hit causes a carrier to lose the stolen creature.
- A hit during a raid ends the raid.

### Economy
- Passive income works.
- Purchases deduct the correct amount.
- Invalid purchases are rejected.
- Upgrades save.
- Rejoining preserves progression.

### Monetization
- Gamepasses verify correctly.
- Developer product receipts are processed securely.
- Duplicate receipt grants are prevented.
- Failed purchase attempts do not grant rewards.

### Data
- Join and leave.
- Rejoin.
- Save and load.
- Failed DataStore request.
- Interrupted transaction.
- Server shutdown.
- Data migration.

Do not claim a test passed unless you actually executed it and observed the result.

---

# SECTION 23 — FINAL QUALITY STANDARD

The finished game must feel like a complete Roblox experience, not a developer prototype.

The map must be visually attractive.

Creatures must be memorable.

The UI must be polished.

The shop must function.

The economy must work.

Base raids must work.

Bats must work.

Base security must work.

Creature ownership must be reliable.

Progression must save.

Multiplayer interactions must be validated.

The game must be playable on PC and mobile.

Every critical system must have appropriate error handling.

There must be no:
- Fake buttons.
- Broken interactions.
- Missing core scripts.
- Placeholder purchase systems.
- Unconnected UI.
- Duplicate creature ownership.
- Unrecoverable stolen creatures.
- Exploitable currency transactions.
- Missing essential gameplay states.
- Empty placeholder map areas.
- Random unverified asset dependencies.

## FINAL INSTRUCTION

Start from the completely empty Roblox Baseplate.

Inspect the current project.

Create the entire ODDLINGS game environment and architecture.

Then implement the actual systems described in this specification.

Do not ask me to manually create every folder, Part, RemoteEvent, ModuleScript, or interface.

Automate the construction through your available Roblox Studio tools wherever possible.

If an operation cannot be performed automatically, explain precisely what limitation prevents it and provide the smallest necessary manual action.

Do not replace a required feature with a placeholder simply because it is difficult.

Do not silently omit requirements.

If you encounter an implementation limitation, preserve the intended functionality through the best supported alternative.

Keep code modular, readable, and maintainable.

Use centralized configuration for balancing.

Prioritize reliable gameplay and data integrity over shortcuts.

When finished, provide a concise implementation report that identifies:
- What was actually built.
- Which systems are functional.
- Which systems were tested.
- Which tests passed.
- Which tests failed.
- Any remaining limitations.
- Any manual configuration still required, including DataStore and MarketplaceService setup.

**Your job is to BUILD ODDLINGS, not merely describe how ODDLINGS could be built.**