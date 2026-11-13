# AFTERHOURS — Creature Bible

## Shared production requirements
Each Creature must have a unique silhouette, anatomy, material treatment, rig, locomotion, sound, perception model, AI behavior, player-control feel and capture animation. Produce front/side/back turnarounds, human scale comparison, face detail, material sheet, silhouette tests at 5m/15m/30m, idle, patrol, stalk, walk, sprint, crawl/climb where relevant, attack, capture, recovery and victory animations. Create audio cues for idle, movement, detection, ability, chase, attack and capture.

## THE WATCHER
Role: observation, stealth, ambush and pressure. Tall unnaturally still humanoid with distinctive proportions; not a generic shadow. Observes from doorways, balcony edges and long corridors. Prefers to pressure isolated players. Uses visual line-of-sight and limited short-range motion awareness. It must not have permanent wall vision.
Prototype abilities: Observe (brief limited awareness of movement, not exact permanent outlines); Fade (short repositioning concealment with a tell and cooldown); Ambush (short lunge with wind-up and counterplay).
Counterplay: break line of sight, change route, use landmarks and coordinate pings.
Capture: distant motionless figure abruptly closes distance, then unique face reveal/lunge and sharp sound transient.

## THE CRAWLER
Role: pursuit, vent routes and sound tracking. Low long-limbed quadrupedal/crawling body with distinctive gait. Uses approved vents and maintenance passages, investigates loud noise and commits to short pursuits. Cannot pass through arbitrary walls or sealed doors.
Senses: strong audio/noise perception, limited visual detection.
Prototype abilities: Listen (direction/rough proximity of recent noise, not exact player outlines); Burst (short speed burst with recovery); Vent Route (approved connected vent nodes with visible/fair transition).
Counterplay: move quietly, use environmental noise, break route predictability and exploit recovery windows.
Capture: low-to-high sudden pounce, camera impact, close-up lunge and distinctive vocalization.

## THE EMPLOYEE
Role: deception, disguise, misdirection and ambush. Human-like staff silhouette/uniform that becomes visibly unnatural at close range. Never impersonate real players or use deceptive player names.
Behavior: stands in plausible staff positions and performs limited routines; reveals true movement/face when committing to attack.
Prototype abilities: Blend (limited disguise at approved staff locations with detectable tells); Lure (brief environmental sound/announcement with cooldown); Reveal (short rush after a readable transformation tell).
Counterplay: observe inconsistent behavior, keep distance, use pings and avoid blindly following suspicious cues.
Capture: uncanny close approach, subtle facial distortion, sudden reveal and close camera attack.

## Player-controlled Creature mode
Dedicated camera and controls; not the normal human camera with a monster mesh. Unique locomotion acceleration, turning, step cadence, camera height and collision. Small contextual cooldown UI. Server owns capture validation, cooldowns, hitboxes, movement limits and perception. Client must not receive exact Explorer positions except through a balanced ability. Must work on PC, mobile and controller.

## Capture / jumpscare pipeline
1. Server validates distance, facing/attack window, line of sight or ability, state and cooldown.
2. Server changes Explorer state to Captured and prevents duplicate requests.
3. Server broadcasts world-visible capture animation to nearby clients.
4. Caught player's client plays the creature-specific camera sequence, animation/audio and accessibility settings.
5. Other Explorers see world-space attack/capture and teammate status change; their cameras are not hijacked.
6. Creature player sees responsive attack animation and confirmed result.
7. Round state determines eliminated/carried/rescued/spectate outcome.
8. All clients return to stable state; no stuck camera, invisible avatar or repeated trigger.

## Fairness and accessibility
Provide reduced camera shake, reduced sudden camera movement and lower-intensity effects. Preserve the scare through timing, animation and sound. Avoid intense flashing patterns. Give clear audio/visual tells before high-impact attacks. No excessive gore.