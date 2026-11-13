# AFTERHOURS Release Checklist and Rollback Plan

## Release rule
A release is permitted only when the build is reproducible, tested, monitored and recoverable. A polished screenshot is not release evidence.

## Pre-release checklist
### Gameplay
- [ ] Solo expedition completes end-to-end.
- [ ] Co-op expedition completes end-to-end.
- [ ] Human Creature round completes end-to-end.
- [ ] All win, loss, capture and extraction outcomes resolve correctly.
- [ ] No softlocks or broken objective chains.
- [ ] Rejoin and disconnect behavior verified.

### Security and data
- [ ] Server validates all important actions.
- [ ] Remote abuse tests pass.
- [ ] Data load/save and migration tests pass.
- [ ] Purchase receipt replay tests pass.
- [ ] No client-trusted currency or reward path.
- [ ] No secrets committed to source control.

### UX and accessibility
- [ ] Keyboard/mouse, touch and controller tested.
- [ ] Settings persist correctly.
- [ ] Reduced effects and subtitle options work.
- [ ] Menus have loading, empty, error and confirmation states.
- [ ] Shop descriptions and prices are clear.

### Performance and reliability
- [ ] Client profiling completed on representative devices.
- [ ] Server profiling completed under expected player load.
- [ ] Streaming and memory behavior reviewed.
- [ ] No critical errors or repeated warnings.
- [ ] Telemetry and crash/error reporting verified.

### Publishing
- [ ] Experience title, description, icon and thumbnails reviewed.
- [ ] Content and age-appropriateness reviewed against platform requirements.
- [ ] All asset permissions and provenance documented.
- [ ] Support and reporting route available.
- [ ] Known issues documented.
- [ ] Rollback owner and steps assigned.

## Staged rollout
1. Private development testing.
2. Small closed external test.
3. Limited public release or controlled launch.
4. Monitor crashes, disconnects, exploit signals, progression and purchase failures.
5. Expand exposure only when metrics and player reports are stable.

## Rollback triggers
Consider rollback or disabling the affected feature if:
- Players lose saved data.
- Purchases are not fulfilled reliably.
- Critical exploit allows currency or match manipulation.
- A round cannot reliably finish.
- Severe crash or performance regression affects a broad device class.
- Moderation or safety issue requires immediate mitigation.

## Rollback procedure
1. Identify the last known good published version and associated source commit.
2. Preserve logs and affected transaction/session identifiers.
3. Disable the narrowest broken feature if safe.
4. Restore the last known good build or configuration.
5. Verify matchmaking, data, purchases and round completion.
6. Communicate known issues through appropriate channels.
7. Fix and regression-test before re-release.

## Release notes template
- Version:
- Release date:
- New content:
- Gameplay changes:
- Balance changes:
- Fixes:
- Known issues:
- Data/schema changes:
- Rollback notes:

## Post-release monitoring
Review daily during the initial launch window:
- Crash/error rate.
- Match start and completion rate.
- Average round duration.
- Extraction and capture outcomes.
- Queue time and matchmaking failures.
- Disconnect rate.
- Data load/save failures.
- Purchase fulfillment failures.
- Reports and moderation escalations.
- Device-specific performance.