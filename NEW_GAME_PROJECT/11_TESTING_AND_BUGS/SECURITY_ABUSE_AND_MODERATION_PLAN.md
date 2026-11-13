# AFTERHOURS Security, Abuse and Moderation Plan

## Security objective
Protect fair play, progression, purchases and player experience. No client request should be trusted merely because it came from a running game client.

## Threat model
Consider:
- Speed, stamina and movement manipulation.
- Teleporting, noclip and wall traversal.
- Remote spam and malformed remote payloads.
- Inventory duplication and impossible item use.
- Objective and extraction spoofing.
- Fake capture, revive or rescue requests.
- Currency and XP injection.
- Purchase receipt replay.
- Matchmaking and party abuse.
- AFK farming and intentional team sabotage.
- Harassment, exploit advertising and inappropriate user-generated content.

## Server validation checklist
For every remote:
- Is the player in the correct round and phase?
- Is the player alive and eligible?
- Is the requested action valid for their role?
- Is the target a valid server-known instance or ID?
- Is the player within a plausible distance?
- Is line of sight required and checked?
- Is the action off cooldown?
- Is the payload typed, bounded and allowlisted?
- Is the request rate-limited?
- Is the resulting state transition legal?
- Is the action idempotent where duplicate delivery is possible?

## Movement checks
Use server-observed position and movement state to detect impossible travel, speed, repeated jumps, clipping and invalid traversal. Account for latency and legitimate physics. Do not permanently punish from one noisy signal. Combine evidence, use graduated responses and preserve logs sufficient for review.

## Economy and inventory checks
All grants, spending, pickups, item consumption and reward calculations are server-side. Use unique pickup claims and transaction IDs. Reject unknown IDs and impossible stack sizes. Never accept a client-supplied balance or reward amount.

## Moderation and reporting
Provide an accessible in-game report path. Let players report harassment, cheating, inappropriate behavior and other abuse categories. Do not promise immediate action. Provide clear feedback that reports are reviewed through appropriate platform processes. Follow Roblox moderation and privacy requirements.

## Anti-grief safeguards
- AFK detection with warnings and fair removal rules.
- Role rotation to avoid one player monopolizing Creature.
- Disconnect handling that does not unfairly punish remaining players.
- Prevent intentional round stalls.
- Limit repeated targeting or spawn pressure where relevant.
- Do not expose player report details to the reported player.
- Avoid systems that encourage harassment or public shaming.

## Admin tooling
Admin actions must be permission-gated server-side, logged and auditable. Never rely on a hidden client button or client-side allowlist. Keep privileged identifiers in server-only configuration and never publish secrets. Add a development-only test mode that cannot be enabled in production by a client.

## Incident response
1. Reproduce the issue in a controlled test server.
2. Determine affected systems and data.
3. Disable the narrowest vulnerable feature if necessary.
4. Preserve logs and transaction IDs.
5. Correct server validation.
6. Test exploit regression.
7. Restore the feature gradually.
8. Document impact and player remediation.

## Abuse testing
Test forged remotes, remote floods, duplicate interactions, impossible distances, invalid role actions, simultaneous objective claims, duplicate receipts, stale party membership and reconnect races.

## Policy guardrails
No deceptive purchases, gambling-style paid random rewards, inappropriate horror content, unsafe user-generated content, or systems that encourage sharing personal contact details. Keep horror effects configurable and age-appropriate.