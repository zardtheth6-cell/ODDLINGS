# AFTERHOURS Data Schema and Persistence Plan

## Principles
All persistent data is server-owned. Treat saved data as untrusted input because schemas evolve and old or malformed records can exist. Use versioned schemas, safe defaults, retry policies and migration tests.

## Proposed profile schema
Profile
- schemaVersion: integer
- createdAt: server timestamp
- lastSeenAt: server timestamp
- accountLevel: integer
- accountXP: integer
- credits: integer
- lifetimeStats: map of approved aggregate counters
- explorerStats: map
- creatureStats: map
- ownedCosmetics: array or set keyed by stable catalog IDs
- equippedCosmetics: map by cosmetic slot
- ownedTitles: set of stable title IDs
- equippedTitle: stable title ID or null
- completedContracts: map of contract IDs and completion metadata
- discoveries: set of stable discovery IDs
- settings: validated accessibility and preference values
- purchaseEntitlements: set of fulfilled product IDs
- transactionReceipts: bounded idempotency records where required

Do not store display names as identity keys. Use Roblox UserId as the profile key. Do not store sensitive personal information.

## Data ownership
- DataService loads and owns the authoritative profile session.
- Other services request validated mutations through DataService or a dedicated transaction API.
- Clients receive only the fields required for their UI.
- Never replicate the entire raw profile if a compact public summary will do.

## Load flow
1. Player joins.
2. DataService acquires a session lock or equivalent ownership mechanism.
3. Load profile with bounded retries and backoff.
4. Validate schema and sanitize fields.
5. Run ordered migrations.
6. Apply defaults for missing optional fields.
7. Mark profile ready.
8. Only then permit rewardable gameplay or purchases that depend on the profile.

If loading fails, do not silently create a blank profile over existing data. Use a safe restricted state, communicate the issue, and retry or return the player gracefully.

## Save flow
- Save on meaningful milestones and at controlled intervals.
- Save on PlayerRemoving and BindToClose, but do not rely only on shutdown events.
- Use session ownership to prevent two servers writing conflicting profiles.
- Use bounded retries and preserve the last known good state.
- Do not spam DataStore writes.
- Record save failures with safe diagnostics.
- Do not tell players a purchase or reward was saved until persistence is confirmed.

## Migration rules
- Increment schemaVersion for structural changes.
- Migrations must be deterministic and safe to rerun.
- Preserve unknown cosmetic IDs for later recovery where possible.
- Clamp invalid numeric values and reject impossible balances.
- Never infer paid entitlements from client data.
- Keep migration fixtures for every released schema version.
- Test interrupted migration and repeated migration.

## Transaction ledger
Every currency or entitlement change should include:
- Unique transaction ID.
- UserId.
- Transaction type.
- Catalog/product/contract identifier.
- Amount and currency.
- Server timestamp.
- Reason/source.
- Resulting balance where safe.
- Idempotency key.

Ledger retention should be bounded and designed around support/audit needs. Do not expose internal transaction metadata to clients.

## Purchase processing
Use the Roblox receipt-processing flow for developer products. Fulfillment must be idempotent: repeated receipt callbacks must not duplicate grants. Validate product IDs against a server catalog. Save entitlement before acknowledging fulfillment. Handle temporary data failures by retrying according to platform guidance. Game pass ownership should be checked through trusted platform APIs, not client claims.

## Data integrity tests
- New player profile.
- Existing profile load.
- Missing optional field.
- Unknown future field.
- Negative or absurd numeric values.
- Duplicate receipt.
- Simultaneous server session.
- Save failure and retry.
- Player leaves during save.
- Server shutdown during save.
- Migration from each prior schema.
- Rejoin after purchase.
- Rejoin after extraction reward.
- Profile recovery path.

## Privacy and retention
Collect only information needed to operate the game. Avoid storing private chat, voice data, real names, addresses or external account details. Provide a support process for data issues consistent with Roblox platform rules.