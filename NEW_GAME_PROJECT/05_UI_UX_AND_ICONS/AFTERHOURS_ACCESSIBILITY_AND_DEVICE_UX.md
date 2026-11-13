# AFTERHOURS Accessibility and Device UX Specification

## Goal
Make the experience usable and comfortable across keyboard/mouse, touch and controller without reducing the intended atmosphere for players who want the full horror presentation.

## Input support
Keyboard and mouse:
- Rebindable or clearly documented movement and interaction keys.
- Mouse sensitivity and invert options.
- Hold/toggle options for crouch, sprint and interaction where practical.

Controller:
- Full navigation through menus and shop.
- Clear focus states.
- Consistent button prompts.
- Adjustable camera sensitivity and invert.
- Avoid requiring precise simultaneous button combinations for essential actions.

Touch:
- Responsive action buttons with safe spacing.
- Adjustable HUD layout and scale.
- Avoid placing critical controls under system gestures.
- Support landscape layout and different aspect ratios.
- Provide a clear interact prompt and accessible inventory selection.
- Test on low and high screen density devices.

## Comfort settings
- Camera shake: Off / Reduced / Full.
- Sprint camera movement: Off / Reduced / Full.
- Motion blur: Off / Reduced / Full, with Off as a supported option.
- Flash intensity: Reduced / Full.
- Jumpscare presentation: Standard / Reduced motion and flash. Never remove critical gameplay information.
- Screen effects: reduced mode.
- Subtitle size: small / medium / large.
- Subtitle background and contrast options.
- Master, music, ambience, effects and voice/audio sliders where applicable.
- Color/contrast options for objective and danger indicators.

## Horror communication
Do not communicate danger only through color, flashing or audio. Pair cues with readable symbols, text or directional information where appropriate. Provide subtitles for meaningful Creature vocalizations and environmental audio clues when those clues are gameplay relevant.

## UI standards
- Maintain readable text at common device sizes.
- Use scalable layouts and safe-area constraints.
- Avoid tiny text, dense information and hover-only interactions.
- Use clear selected, focused, disabled, loading, error and confirmation states.
- Avoid excessive screen shake or forced camera movement.
- Do not hide important controls behind decorative effects.

## Testing matrix
Test:
- Small phone screens.
- Large phone screens.
- Tablet.
- 16:9 desktop.
- Ultrawide desktop.
- Controller navigation.
- Low graphics quality.
- Reduced effects mode.
- Large subtitles.
- High contrast.
- Touch controls while moving and interacting.

## Acceptance criteria
A player can complete the core expedition, interact with objects, understand objectives, manage inventory, escape or spectate, and navigate all essential menus on every supported input family.