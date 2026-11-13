# Roblox Source Code

This folder is the home of the actual AFTERHOURS implementation source and setup documentation.

## Current status
The design package is in pre-production. Do not assume that source code exists or that any feature is implemented merely because a specification exists.

## Architecture
Use the service boundaries in 06_GAMEPLAY_SYSTEMS/AFTERHOURS_TECHNICAL_ARCHITECTURE.md.
- Shared: types, constants, configuration schemas and safe utility modules.
- Server: bootstrap, services, AI, data and security.
- Client: controllers, UI, camera, audio and effects.
- Tests: unit tests, integration tests and test fixtures.

## Rules
- Keep code modular and grouped by service/controller responsibility.
- The server owns gameplay outcomes, saved data, inventory, objectives, captures, rewards and purchases.
- Shared modules must not contain secrets or privileged server-only logic.
- Client code is for input, camera, interface and presentation.
- Every remote must be documented and validated.
- Do not paste unrelated ODDLINGs scripts into this project.
- Keep source code separate from generated Studio instances and documentation.

## Before committing code
- Confirm the script is in the correct execution context.
- Check dependencies and startup order.
- Check all remote arguments and server validation.
- Test player join/leave and round restart behavior.
- Check errors and warnings in Studio output.
- Update architecture and test documentation.
- Never claim a script is tested unless it was executed.

## Required delivery
Each implementation phase must include exact Studio setup steps, files created/modified, systems connected, tests run, test results, known issues and evidence.