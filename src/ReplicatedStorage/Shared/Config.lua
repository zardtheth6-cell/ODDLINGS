-- ODDLINGS central configuration. All balancing lives here.
local C = {}

C.Version = 1

C.Rarities = {
	{id="Common",    label="COMMON",    color=Color3.fromRGB(205,210,220), weight=60,   incomeMult=1,    sellMult=40, xp=10},
	{id="Uncommon",  label="UNCOMMON",  color=Color3.fromRGB(90,215,100),  weight=26,   incomeMult=1,    sellMult=45, xp=20},
	{id="Rare",      label="RARE",      color=Color3.fromRGB(60,150,255),  weight=10,   incomeMult=1,    sellMult=50, xp=45},
	{id="Epic",      label="EPIC",      color=Color3.fromRGB(175,85,255),  weight=3.2,  incomeMult=1,    sellMult=55, xp=100},
	{id="Legendary", label="LEGENDARY", color=Color3.fromRGB(255,195,40),  weight=0.65, incomeMult=1,    sellMult=60, xp=250},
	{id="Mythic",    label="MYTHIC",    color=Color3.fromRGB(255,75,150),  weight=0.13, incomeMult=1,    sellMult=60, xp=600},
	{id="Secret",    label="SECRET",    color=Color3.fromRGB(30,255,230),  weight=0.02, incomeMult=1,    sellMult=60, xp=1500},
}
C.RarityById = {}
for i,r in ipairs(C.Rarities) do r.order=i C.RarityById[r.id]=r end
C.ConfirmSellFrom = 3 -- Rare and above need confirmation

-- size: Small/Medium/Large -> carry penalty
C.CarryPenalty = {Small=0.10, Medium=0.20, Large=0.30}

-- income is cash per second
C.Creatures = {
	{id="Fridgito",     name="Fridgito",      rarity="Common",    income=2,     size="Small",  territories={"Frostbite"},          anim="Waddle",  desc="A tiny penguin with a refrigerator body. Keeps snacks cold."},
	{id="Blorbo",       name="Blorbo",        rarity="Common",    income=2,     size="Small",  territories={"Mushroom","Cosmic"},  anim="Bounce",  desc="A bouncing purple slime. Squishes when happy."},
	{id="Toasturtle",   name="Toasturtle",    rarity="Common",    income=3,     size="Small",  territories={"Mushroom","Molten"},  anim="Waddle",  desc="A turtle with a perfectly toasted bread shell."},
	{id="Berryhop",     name="Berryhop",      rarity="Common",    income=3,     size="Small",  territories={"Mushroom"},           anim="Hop",     desc="A frog with a juicy strawberry body."},
	{id="Socktopus",    name="Socktopus",     rarity="Common",    income=4,     size="Small",  territories={"Mushroom","Frostbite"},anim="Wiggle", desc="An octopus wearing mismatched socks on every arm."},
	{id="DonutSnail",   name="Donut Snail",   rarity="Uncommon",  income=9,     size="Small",  territories={"Mushroom","Molten"},  anim="Slide",   desc="A snail with a giant frosted donut shell."},
	{id="Roboquack",    name="Roboquack",     rarity="Uncommon",  income=10,    size="Small",  territories={"Frostbite"},          anim="Waddle",  desc="A robotic duck. Quacks in binary."},
	{id="Prickles",     name="Prickles",      rarity="Uncommon",  income=11,    size="Small",  territories={"Mushroom","Molten"},  anim="Hop",     desc="Half hedgehog, half cactus. Do not hug."},
	{id="SushiCat",     name="Sushi Cat",     rarity="Uncommon",  income=12,    size="Medium", territories={"Frostbite"},          anim="Sway",    desc="A cat rolled up in rice and nori."},
	{id="Mushmoose",    name="Mushmoose",     rarity="Rare",      income=32,    size="Large",  territories={"Mushroom"},           anim="Sway",    desc="A moose whose antlers are glowing mushrooms."},
	{id="Channel0",     name="Channel-0",     rarity="Rare",      income=36,    size="Medium", territories={"Frostbite","Cosmic"}, anim="Glitch",  desc="A television-headed creature. Always on."},
	{id="Bananasaur",   name="Bananasaur",    rarity="Rare",      income=40,    size="Medium", territories={"Molten"},             anim="Stomp",   desc="A banana that evolved into a dinosaur."},
	{id="Bubblejaw",    name="Bubblejaw",     rarity="Rare",      income=44,    size="Medium", territories={"Frostbite"},          anim="Float",   desc="A shark that swims through the air in bubbles."},
	{id="Clockroach",   name="Clockroach",    rarity="Epic",      income=125,   size="Small",  territories={"Molten"},             anim="Scuttle", desc="A cockroach with a ticking clock body."},
	{id="Melonphant",   name="Melonphant",    rarity="Epic",      income=145,   size="Large",  territories={"Molten"},             anim="Stomp",   desc="An elephant with a watermelon body."},
	{id="Glitchling",   name="Glitchling",    rarity="Epic",      income=160,   size="Small",  territories={"Molten","Cosmic"},    anim="Glitch",  desc="A creature made of corrupted pixels."},
	{id="GoldfishTank", name="Goldfish Tank", rarity="Legendary", income=650,   size="Large",  territories={"Cosmic"},             anim="Stomp",   desc="A walking aquarium with a goldfish captain."},
	{id="Crownach",     name="Crownach",      rarity="Legendary", income=780,   size="Medium", territories={"Molten","Cosmic"},    anim="Slide",   desc="A royal snail with a giant crown."},
	{id="Nebulamb",     name="Nebulamb",      rarity="Mythic",    income=3000,  size="Medium", territories={"Cosmic"},             anim="Float",   desc="A cosmic lamb full of swirling galaxies."},
	{id="Voidzilla",    name="Voidzilla",     rarity="Secret",    income=12000, size="Large",  territories={"Cosmic"},             anim="Float",   desc="A massive floating shadow. Nobody knows where it came from."},
}
C.CreatureById = {}
for i,c in ipairs(C.Creatures) do c.order=i C.CreatureById[c.id]=c end
C.GoldenIncomeMult = 5

C.Territories = {
	{id="Mushroom",  name="Mushroom Woods",   cost=0,       level=1,  maxActive=8, color=Color3.fromRGB(110,200,90)},
	{id="Frostbite", name="Frostbite Fields", cost=7500,    level=3,  maxActive=8, color=Color3.fromRGB(140,210,255)},
	{id="Molten",    name="Molten Valley",    cost=90000,   level=8,  maxActive=8, color=Color3.fromRGB(255,110,40)},
	{id="Cosmic",    name="Cosmic Outlands",  cost=1500000, level=15, maxActive=8, color=Color3.fromRGB(170,90,255)},
}
C.TerritoryById = {}
for i,t in ipairs(C.Territories) do t.order=i C.TerritoryById[t.id]=t end

-- Guardian behaviour types
C.GuardianTypes = {
	Slow       = {speed=12, detect=34, capture=5,  leash=70,  chaseTime=8,  scale=1.0},
	Fast       = {speed=20, detect=40, capture=5,  leash=85,  chaseTime=6,  scale=0.9},
	Ambush     = {speed=22, detect=26, capture=5,  leash=60,  chaseTime=3.5,scale=1.0, windup=1.2},
	Persistent = {speed=15, detect=42, capture=5,  leash=140, chaseTime=16, scale=1.05},
	Large      = {speed=11, detect=38, capture=10, leash=70,  chaseTime=10, scale=1.8},
}
C.GuardianLayout = {
	Mushroom  = {"Slow","Slow","Ambush"},
	Frostbite = {"Fast","Persistent","Slow"},
	Molten    = {"Fast","Large","Ambush","Persistent"},
	Cosmic    = {"Persistent","Large","Fast","Ambush"},
}
C.CaptureRespawnDelay = 3
C.SpawnShieldTime = 6

C.Movement = {
	walk=16, sprintMult=1.45, stamina=100, drain=16, carryDrainMult=1.25,
	regen=16, regenDelay=0.8, dashCooldown=3.0, dashPower=60, dashCost=20,
	slideTime=0.65, slidePower=42, slideCooldown=1.6,
}

C.Upgrades = {
	{id="Speed",    name="Running Speed",   icon="👟", max=10, base=250,  growth=1.75, desc="+0.6 walk speed per level", per=0.6},
	{id="Sprint",   name="Sprint Power",    icon="💨", max=10, base=400,  growth=1.75, desc="+4% sprint speed per level", per=0.04},
	{id="Stamina",  name="Stamina Capacity",icon="🔋", max=10, base=300,  growth=1.7,  desc="+15 max stamina per level", per=15},
	{id="Recovery", name="Stamina Recovery",icon="❤️", max=10, base=300,  growth=1.7,  desc="+3 stamina/sec regen per level", per=3},
	{id="Carry",    name="Carry Strength",  icon="💪", max=10, base=600,  growth=1.8,  desc="-6% carry slowdown per level", per=0.06},
	{id="Dash",     name="Dash Cooldown",   icon="⚡", max=8,  base=500,  growth=1.8,  desc="-0.2s dash cooldown per level", per=0.2},
	{id="Luck",     name="Luck",            icon="🍀", max=10, base=1000, growth=1.9,  desc="+8% rare spawn luck per level", per=0.08},
}
C.UpgradeById = {}
for _,u in ipairs(C.Upgrades) do C.UpgradeById[u.id]=u end
function C.UpgradeCost(id, level) local u=C.UpgradeById[id] return math.floor(u.base*u.growth^level) end

C.Capacity = {start=6, step=2, max=18, base=1500, growth=2.0} -- cash expansions
function C.CapacityCost(cap) local n=(cap-C.Capacity.start)/C.Capacity.step return math.floor(C.Capacity.base*C.Capacity.growth^n) end
C.MaxDisplaySlots = 30

C.Security = {
	Door   = {name="Security Door", icon="🚪", min=1, max=5, costs={0,2500,20000,150000,900000},
		names={"Wooden Gate","Reinforced Metal Gate","Heavy Security Door","Automated High-Tech Gate","Energy Barrier"},
		breach={1.0,2.0,3.2,4.5,6.0}, openTime=5},
	Alarm  = {name="Alarm System", icon="🚨", min=1, max=5, costs={0,1500,12000,80000,500000},
		names={"On-screen alert","Audible siren","Flashing warning lights","Owner warning + screen flash","Full base-wide alert"}},
	Laser  = {name="Laser Traps", icon="🔴", min=0, max=5, costs={4000,18000,90000,350000,1200000},
		slow={0.30,0.38,0.45,0.52,0.60}, duration={2,2.5,3,3.5,4}, beams={1,2,2,3,3}, cooldown=6},
	Shield = {name="Base Shield", icon="🛡️", min=0, max=5, costs={6000,30000,120000,450000,1500000},
		duration={60,90,120,180,240}, cooldown=420},
	Detect = {name="Intruder Detection", icon="📡", min=1, max=5, costs={0,3000,25000,160000,700000},
		range={0,25,25,40,60}, names={"Detects base entry","Wider detection range","Identifies intruder + cargo","Shows intruder location","Live tracking through walls"}},
}
C.SecurityOrder = {"Door","Alarm","Laser","Shield","Detect"}

C.Raid = {
	window=30, grabTime=2, thiefCooldown=20, sameTargetCooldown=240,
	repeatWindow=1800, repeatLimit=3, repeatLockout=900,
	defenseProtection=60, beginnerSeconds=600, beginnerCreatures=3,
}

C.Bat = {cooldown=0.85, range=8, windup=0.12, stun=1.1, immunity=3, knockback=55, angleDot=0.25}
C.Bats = {
	{id="Classic", name="Classic Bat", price=0, currency="Free", color=Color3.fromRGB(170,120,70), material="Wood"},
	{id="Neon",    name="Neon Bat",    price=150, currency="Gems", color=Color3.fromRGB(0,255,200), material="Neon"},
	{id="Golden",  name="Golden Bat",  price=500, currency="Gems", color=Color3.fromRGB(255,200,50), material="Foil"},
	{id="Thunder", name="Thunder Bat", price=900, currency="Gems", color=Color3.fromRGB(110,170,255), material="Neon", fx="Thunder"},
}
C.BatById = {} for _,b in ipairs(C.Bats) do C.BatById[b.id]=b end
C.SafeZones = { {center=Vector3.new(0,0,0), radius=75} }

-- Robux. IDs MUST be filled in from the Creator Dashboard. 0 = not configured (button shows as unavailable).
C.GamePasses = {
	{id="VIP",         name="VIP",               assetId=0, robux=299, icon="👑", desc="VIP title, golden name tag, +10% cash"},
	{id="DoubleCash",  name="2x Cash",           assetId=0, robux=499, icon="💰", desc="Double all passive income"},
	{id="ExtraStorage",name="Extra Storage",     assetId=0, robux=199, icon="📦", desc="+6 collection capacity"},
	{id="ExtraSlots",  name="Extra Base Slots",  assetId=0, robux=249, icon="🏠", desc="+6 display slots at your base"},
	{id="NameTag",     name="Premium Name Tag",  assetId=0, robux=99,  icon="🏷️", desc="Rainbow animated name tag"},
	{id="VIPEffects",  name="VIP Effects",       assetId=0, robux=149, icon="✨", desc="Sparkle trail cosmetic"},
}
C.Products = {
	{id="CashS",   name="Cash Pouch",     assetId=0, robux=49,  icon="💵", desc="+5,000 Cash",           grant={cash=5000}},
	{id="CashM",   name="Cash Bag",       assetId=0, robux=199, icon="💰", desc="+40,000 Cash",          grant={cash=40000}},
	{id="CashL",   name="Cash Vault",     assetId=0, robux=799, icon="🏦", desc="+250,000 Cash",         grant={cash=250000}},
	{id="GemsS",   name="Gem Handful",    assetId=0, robux=99,  icon="💎", desc="+120 Gems",             grant={gems=120}},
	{id="GemsL",   name="Gem Chest",      assetId=0, robux=399, icon="💠", desc="+600 Gems",             grant={gems=600}},
	{id="Speed",   name="Speed Boost",    assetId=0, robux=29,  icon="⚡", desc="+15% speed for 10 min", grant={boost="speed",time=600}},
	{id="Luck",    name="Luck Boost",     assetId=0, robux=39,  icon="🍀", desc="2x luck for 15 min",    grant={boost="luck",time=900}},
	{id="Stamina", name="Stamina Refill", assetId=0, robux=15,  icon="🔋", desc="Infinite stamina 60s",  grant={boost="stamina",time=60}},
	{id="Escape",  name="Escape Shield",  assetId=0, robux=25,  icon="🛡️", desc="Ignore the next catch or bat hit (5 min)", grant={boost="escape",time=300}},
	{id="Cosmetic",name="Bat Bundle",     assetId=0, robux=149, icon="🎁", desc="Unlocks Neon + Thunder bats", grant={bats={"Neon","Thunder"}}},
}
C.ProductById = {} for _,p in ipairs(C.Products) do C.ProductById[p.id]=p end
C.PassById = {} for _,p in ipairs(C.GamePasses) do C.PassById[p.id]=p end

-- Items bought with cash/gems
C.Items = {
	{id="SpeedPotion", name="Speed Potion", icon="🧪", price=3000,  currency="Cash", desc="+10% speed for 5 minutes",   boost="speed", time=300},
	{id="LuckPotion",  name="Luck Potion",  icon="🍀", price=8000,  currency="Cash", desc="2x luck for 5 minutes",      boost="luck",  time=300},
	{id="Capacity",    name="Base Expansion",icon="🧱",price=0,     currency="Cash", desc="+2 collection capacity (price scales)"},
	{id="GemSpeed",    name="Super Sprint", icon="💨", price=40,    currency="Gems", desc="Infinite stamina 90s",       boost="stamina", time=90},
	{id="GemEscape",   name="Escape Charm", icon="🛡️", price=60,    currency="Gems", desc="Ignore next catch or bat hit (5 min)", boost="escape", time=300},
}
C.ItemById = {} for _,i in ipairs(C.Items) do C.ItemById[i.id]=i end

C.Daily = {
	cooldown=20*3600, resetAfter=48*3600,
	rewards={ {cash=500}, {cash=1500}, {gems=25}, {cash=5000}, {gems=50}, {cash=15000}, {gems=120, bat="Neon"} },
}

C.Rebirth = {
	baseCost=1000000, growth=3, incomeBonus=0.25, gems=100,
	-- Rebirth resets: cash, movement upgrades, territory unlocks. Keeps: creatures, security, gems, titles, purchases.
}
function C.RebirthCost(r) return math.floor(C.Rebirth.baseCost*C.Rebirth.growth^r) end

function C.XPForLevel(l) return math.floor(100*l^1.5) end

C.Titles = {
	{id="Newcomer",     name="Newcomer",          color=Color3.fromRGB(220,220,220), req="Join the island"},
	{id="Hunter",       name="Oddling Hunter",    color=Color3.fromRGB(120,220,120), req="Collect 5 Oddlings"},
	{id="Collector",    name="Creature Collector",color=Color3.fromRGB(90,170,255),  req="Discover 10 species"},
	{id="Thief",        name="Master Thief",      color=Color3.fromRGB(255,120,60),  req="Win 5 raids"},
	{id="Defender",     name="Base Defender",     color=Color3.fromRGB(80,200,255),  req="Defend 5 raids"},
	{id="RareHunter",   name="Rare Hunter",       color=Color3.fromRGB(190,100,255), req="Collect 5 Rare+ Oddlings"},
	{id="Legend",       name="Island Legend",     color=Color3.fromRGB(255,200,40),  req="Rebirth once"},
	{id="VIP",          name="VIP",               color=Color3.fromRGB(255,215,0),   req="Own the VIP pass"},
}
C.TitleById = {} for _,t in ipairs(C.Titles) do C.TitleById[t.id]=t end

C.CollectionMilestones = { {count=5, gems=25}, {count=10, gems=75}, {count=15, gems=200}, {count=20, gems=1000} }

C.Events = {
	interval={300,480}, -- seconds between events
	list={
		{id="Golden",   name="Golden Oddling!",   duration=150, desc="A golden Oddling appeared somewhere on the island! 5x income!"},
		{id="Stampede", name="Creature Stampede!",duration=45,  desc="Oddlings are stampeding through the plaza! Touch them for cash!"},
		{id="Meteor",   name="Meteor Crash!",     duration=120, desc="A meteor crashed in the Cosmic Outlands! Grab the space gems!"},
		{id="Blackout", name="Blackout!",         duration=60,  desc="The plaza lights went out... find the glowing coins!"},
		{id="Visitor",  name="Rare Visitor!",     duration=120, desc="A rare Oddling is visiting the plaza outskirts!"},
	},
}

C.Leaderboards = {
	{id="TotalEarned", name="Total Cash Earned", icon="💰"},
	{id="Rares",       name="Rare Oddlings",     icon="💎"},
	{id="Level",       name="Player Level",      icon="⭐"},
	{id="Rebirths",    name="Rebirths",          icon="🔁"},
	{id="Raids",       name="Successful Raids",  icon="🏴"},
}

C.Sounds = { -- built-in Roblox client sounds (verified to load)
	Pickup="rbxasset://sounds/electronicpingshort.wav", Swing="rbxasset://sounds/swordslash.wav",
	Hit="rbxasset://sounds/hit.wav", Click="rbxasset://sounds/button.wav", Hover="rbxasset://sounds/switch.wav",
	Cash="rbxasset://sounds/clickfast.wav", Capture="rbxasset://sounds/uuhhh.mp3", Alarm="rbxasset://sounds/HalloweenGhost.wav",
	Door="rbxasset://sounds/unsheath.wav", Laser="rbxasset://sounds/SWITCH3.wav", Shield="rbxasset://sounds/Launching rocket.wav",
	Success="rbxasset://sounds/victory.wav", Fail="rbxasset://sounds/glassbreak.wav", Return="rbxasset://sounds/Kerplunk.wav",
	Purchase="rbxasset://sounds/paintball.wav", LevelUp="rbxasset://sounds/victory.wav", Rebirth="rbxasset://sounds/Rocket shot.wav",
	Event="rbxasset://sounds/bass.wav", Guardian="rbxasset://sounds/collide.wav", Squish="rbxasset://sounds/splat.wav",
	Snap="rbxasset://sounds/snap.mp3", Flash="rbxasset://sounds/flashbulb.wav", Swing2="rbxasset://sounds/swordlunge.wav",
	Splash="rbxasset://sounds/impact_water.mp3", Jump="rbxasset://sounds/action_jump.mp3",
}

function C.FormatNumber(n)
	n = math.floor(n or 0)
	local abs = math.abs(n)
	local suf = {{1e15,"Q"},{1e12,"T"},{1e9,"B"},{1e6,"M"},{1e3,"K"}}
	for _,s in ipairs(suf) do if abs >= s[1] then return string.format("%.2f",n/s[1]):gsub("%.?0+$","")..s[2] end end
	return tostring(n)
end

return C
