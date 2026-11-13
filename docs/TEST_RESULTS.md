# Test results

All tests ran in Roblox Studio, **single-player Play mode**, driven through the Studio-only test hook
(`ServerStorage.__TestRunner`), which calls the same server functions the in-game prompts call.

| Test | Result |
|---|---|
| Server boot, no script errors | Pass |
| DataStore enabled in Studio (`SaveEnabled=true`) | Pass |
| Steal Common → guardian alerted → capture → creature returns, player respawns at base | Pass |
| Steal → deliver at drop zone → creature on pedestal → income starts | Pass |
| Progress persists after stopping and restarting play | Pass |
| Upgrade purchase deducts the correct cost; invalid id rejected | Pass |
| Security door upgrade changes door material; lasers + shield purchased | Pass |
| Shield activates; second activation refused | Pass |
| Capacity expansion | Pass |
| Daily reward claim; second claim refused | Pass |
| Speed potion boost applied | Pass |
| Bat purchase refused with insufficient gems / succeeds with enough | Pass |
| Unconfigured game pass prompt refused | Pass |
| Territory unlock refused below required level | Pass |
| Rebirth resets cash/upgrades/territories, keeps creatures/security | Pass |
| Same developer-product receipt processed twice → reward granted once; unknown product → NotProcessedYet | Pass |
| All 5 world events start and clean up | Pass |
| Global leaderboard board populated | Pass |
| Collection index previews render (after a fix) | Pass |
| Environment upgrade: gameplay regression (steal/deliver/purchases/security/shield) | Pass |

## Not tested
Raids, snatching, bat hits on players, laser/alarm/detection triggered by intruders, shield push-out,
real Robux purchases, mobile devices, controllers, failed DataStore, server shutdown mid-raid.
