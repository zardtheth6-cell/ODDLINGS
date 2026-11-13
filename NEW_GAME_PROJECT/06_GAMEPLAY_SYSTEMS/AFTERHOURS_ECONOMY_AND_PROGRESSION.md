# AFTERHOURS Economy and Progression Specification

## Design goals
The economy should create long-term goals and optional spending opportunities without making paid players substantially stronger in competitive rounds. Monetization must be transparent, age-appropriate, and compliant with Roblox policies. The game must remain enjoyable without Robux purchases.

## Currency model
Use one primary earnable soft currency, provisionally named Credits. The name can be changed during branding. Credits are earned through completed expeditions, objectives, contracts, exploration milestones and fair-play participation. Avoid excessive currencies in the first release.

Optional premium currency should not be introduced unless it solves a real UX need. Robux purchases can use approved game passes and developer products with clear descriptions and confirmation flows.

## Reward principles
- Reward successful participation, not only extraction, so captured players are not made to feel their time was wasted.
- Give meaningful bonuses for objective contribution, optional discoveries and team support.
- Avoid rewarding AFK time, repeated trivial actions or exploit loops.
- Scale rewards by mission difficulty and completion quality, not by paid status.
- Cap or diminish repeatable farming sources where necessary.
- Show a clear reward breakdown after every expedition.

## Progression tracks
1. Account level: broad long-term account progression; primarily a prestige and access indicator.
2. Titles: earned through milestones, contracts, mastery and seasonal achievements.
3. Cosmetics: outfits, masks where appropriate, backpack appearances, flashlight skins, lobby poses, banners, profile frames and Creature visual variants.
4. Creature mastery: role-specific challenges and cosmetic rewards, never mandatory power.
5. Contracts: rotating short and medium-term objectives that encourage varied play.
6. Collection records: discovered evidence, locations, Creature observations and lore entries.

## Competitive fairness
Paid products must not provide:
- Higher sprint speed or stamina.
- Better stealth or quieter footsteps.
- Stronger capture range or faster Creature cooldowns.
- Better objective odds or extraction priority.
- Exclusive gameplay-critical items.
- Extra revives or paid escape from capture.
- Paid access to stronger Creature abilities.

If consumable utility items are sold, ensure equivalent gameplay access is earnable and balance remains fair. Prefer selling cosmetics, convenience that does not affect match outcomes, private-server options where permitted, and clearly disclosed optional progression convenience.

## Shop categories
- Explorer cosmetics.
- Creature cosmetics.
- Flashlight and equipment appearance variants.
- Backpack appearance variants.
- Emotes and lobby poses.
- Profile banners, frames and title effects.
- Rotating featured cosmetic collection.
- Optional game pass features that do not create competitive advantage.

Do not sell fear intensity advantages, pay-to-win tools or loot-box style randomized paid rewards. Clearly display item contents and prices before purchase.

## Pricing and value research
Do not invent final Robux prices during implementation. Build configurable catalog entries and test price points with player research. Prices should be visible before confirmation. Do not use deceptive countdowns, fake scarcity, misleading discounts or pressure tactics.

## Reward formula
Create a server-side configurable reward function with separate components:
- Base participation reward.
- Objective completion reward.
- Optional objective reward.
- Discovery reward.
- Extraction reward.
- Team support reward.
- Difficulty modifier.
- Anti-farm adjustment.

All values are server-owned. Display the breakdown to the player. Avoid hidden multipliers that make outcomes difficult to understand.

## Contracts
Contract examples:
- Restore power to a named zone.
- Recover a specific evidence category.
- Complete an expedition without using a consumable.
- Assist a teammate with a rescue interaction.
- Survive a Creature encounter.
- Find a hidden route.
- Complete an expedition as Creature using a defined playstyle.

Contracts must support solo and multiplayer where reasonable. Do not require voice chat or griefing another player.

## Account progression and prestige
Level progression should be paced through normal play and should not require purchases. Titles should communicate achievements and identity. Prestige resets, if ever added, must be optional, clearly explained and never erase paid cosmetics or purchased entitlements.

## Persistence and transaction safety
Currency changes must be atomic at the application level and recorded with unique transaction IDs. Purchase receipts must be processed idempotently. A player rejoining after a failed save must not lose a completed purchase. Never grant a Robux product based only on a client event.

## Economy analytics
Track aggregate metrics such as:
- Currency earned per match.
- Currency spent by catalog category.
- Time to first purchase.
- Contract acceptance and completion.
- Cosmetic equip rate.
- Reward distribution by mode and skill band.
- Refund/support issue rate.

Use the metrics to detect runaway inflation and unfair reward disparities. Do not optimize solely for spend or pressure.

## Launch economy scope
For the first vertical slice, implement only:
- Credits.
- End-of-round reward breakdown.
- A small cosmetic shop with placeholder catalog data.
- Profile level and a few earnable titles.
- Reliable save/load.
Defer premium currency, seasonal passes, gifting and complex bundles until the core loop is stable.