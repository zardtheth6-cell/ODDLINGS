-- Builds every Oddling and Guardian model procedurally from parts.
-- One central builder is used for wild creatures, carried creatures, base displays, and collection previews.
local Config = require(script.Parent.Config)
local B = {}

local CF, V3, ANG = CFrame.new, Vector3.new, CFrame.Angles
local rad = math.rad
local function rgb(r,g,b) return Color3.fromRGB(r,g,b) end

local function part(m, shape, size, cf, color, mat, extra)
	local p
	if shape == "Wedge" then p = Instance.new("WedgePart")
	elseif shape == "Corner" then p = Instance.new("CornerWedgePart")
	else
		p = Instance.new("Part")
		if shape == "Ball" then p.Shape = Enum.PartType.Ball
		elseif shape == "Cyl" then p.Shape = Enum.PartType.Cylinder end
	end
	p.Size = size
	p.CFrame = cf
	p.Color = color
	p.Material = Enum.Material[mat or "SmoothPlastic"]
	p.TopSurface = Enum.SurfaceType.Smooth
	p.BottomSurface = Enum.SurfaceType.Smooth
	if shape == "Ell" then
		local sm = Instance.new("SpecialMesh") sm.MeshType = Enum.MeshType.Sphere sm.Parent = p
	end
	if extra then for k,v in pairs(extra) do p[k] = v end end
	p.Parent = m
	return p
end
B.part = part

local function eyes(m, pos, spacing, r, pupilColor)
	for _,sx in ipairs({-1,1}) do
		local c = pos + V3(sx*spacing,0,0)
		part(m,"Ell",V3(r,r,r*0.7),CF(c),rgb(255,255,255))
		part(m,"Ell",V3(r*0.55,r*0.6,r*0.3),CF(c+V3(0,-r*0.03,-r*0.28)),pupilColor or rgb(20,20,30),nil,{Name="Pupil"})
		part(m,"Ell",V3(r*0.18,r*0.18,r*0.1),CF(c+V3(r*0.12,r*0.14,-r*0.42)),rgb(255,255,255),"Neon")
	end
end
local function smile(m, pos, w, color)
	color = color or rgb(40,20,25)
	part(m,"Block",V3(w*0.5,w*0.09,0.06),CF(pos),color)
	part(m,"Block",V3(w*0.3,w*0.09,0.06),CF(pos+V3(-w*0.33,w*0.07,0))*ANG(0,0,rad(-30)),color)
	part(m,"Block",V3(w*0.3,w*0.09,0.06),CF(pos+V3(w*0.33,w*0.07,0))*ANG(0,0,rad(30)),color)
end
local function cylBetween(m, a, b, d, color, mat)
	local mid = (a+b)/2
	local len = (b-a).Magnitude
	return part(m,"Cyl",V3(len,d,d),CFrame.lookAt(mid,b)*ANG(0,rad(90),0),color,mat)
end
local function emitter(parent, color, rate, size, speed, tex, extra)
	local e = Instance.new("ParticleEmitter")
	e.Texture = tex or "rbxasset://textures/particles/sparkles_main.dds"
	e.Color = ColorSequence.new(color)
	e.Rate = rate
	e.Size = NumberSequence.new(size or 0.4)
	e.Speed = NumberRange.new(speed or 1)
	e.Lifetime = NumberRange.new(1,2)
	e.SpreadAngle = Vector2.new(180,180)
	e.LightEmission = 0.6
	e.Transparency = NumberSequence.new({NumberSequenceKeypoint.new(0,0.2),NumberSequenceKeypoint.new(1,1)})
	if extra then for k,v in pairs(extra) do e[k]=v end end
	e.Parent = parent
	return e
end
local function light(parent, color, range, brightness)
	local l = Instance.new("PointLight") l.Color = color l.Range = range l.Brightness = brightness or 1 l.Parent = parent return l
end
local function spin(p, axis, rate) p:SetAttribute("Spin", rate) p:SetAttribute("SpinAxis", axis) return p end

local Build = {}

Build.Fridgito = function(m)
	local white = rgb(236,242,248)
	part(m,"Block",V3(1.8,2.2,1.5),CF(0,1.35,0),white)
	part(m,"Block",V3(1.7,0.06,0.06),CF(0,1.65,-0.76),rgb(150,160,175))
	part(m,"Cyl",V3(0.7,0.13,0.13),CF(0.62,1.05,-0.82)*ANG(0,0,rad(90)),rgb(190,195,205),"Metal")
	part(m,"Cyl",V3(0.4,0.13,0.13),CF(0.62,2.0,-0.82)*ANG(0,0,rad(90)),rgb(190,195,205),"Metal")
	part(m,"Block",V3(0.32,0.32,0.06),CF(-0.45,1.0,-0.78)*ANG(0,0,rad(12)),rgb(255,80,90))
	part(m,"Ball",V3(0.25,0.25,0.25),CF(-0.1,0.75,-0.77),rgb(90,200,255))
	part(m,"Ell",V3(1.6,1.35,1.45),CF(0,2.95,0),rgb(28,30,40))
	part(m,"Ell",V3(1.15,0.95,0.45),CF(0,2.88,-0.55),rgb(250,250,250))
	eyes(m,V3(0,3.05,-0.74),0.24,0.34)
	part(m,"Ell",V3(0.45,0.25,0.55),CF(0,2.72,-0.85),rgb(255,160,40))
	part(m,"Ell",V3(0.22,0.12,0.05),CF(-0.45,2.75,-0.74),rgb(255,150,170))
	part(m,"Ell",V3(0.22,0.12,0.05),CF(0.45,2.75,-0.74),rgb(255,150,170))
	part(m,"Ell",V3(0.3,1.2,0.75),CF(-1.02,1.5,0)*ANG(0,0,rad(-18)),rgb(28,30,40),nil,{Name="LimbL"})
	part(m,"Ell",V3(0.3,1.2,0.75),CF(1.02,1.5,0)*ANG(0,0,rad(18)),rgb(28,30,40),nil,{Name="LimbR"})
	part(m,"Ell",V3(0.6,0.22,0.85),CF(-0.45,0.12,-0.25),rgb(255,160,40))
	part(m,"Ell",V3(0.6,0.22,0.85),CF(0.45,0.12,-0.25),rgb(255,160,40))
	part(m,"Block",V3(1.86,0.25,1.56),CF(0,0.35,0),rgb(170,185,200),"Metal")
	return 3.7
end

Build.Blorbo = function(m)
	local purple = rgb(150,70,235)
	part(m,"Ell",V3(2.6,2.2,2.6),CF(0,1.1,0),purple,"Glass",{Transparency=0.12})
	part(m,"Ell",V3(1.3,1.1,1.3),CF(0.1,1.0,0.2),rgb(220,120,255),"Neon",{Transparency=0.45})
	for i=1,6 do
		local a = i/6*math.pi*2
		part(m,"Ell",V3(0.55,0.45,0.55),CF(math.cos(a)*1.05,0.18,math.sin(a)*1.05),purple,"Glass",{Transparency=0.12})
	end
	part(m,"Ell",V3(0.5,0.6,0.5),CF(0.3,2.3,0.1),purple,"Glass",{Transparency=0.12})
	part(m,"Ell",V3(0.3,0.3,0.3),CF(0.38,2.62,0.1),rgb(255,180,255),"Neon")
	eyes(m,V3(0,1.45,-1.12),0.45,0.62)
	part(m,"Ell",V3(0.7,0.35,0.12),CF(0,0.85,-1.25),rgb(60,10,70))
	part(m,"Ell",V3(0.35,0.15,0.06),CF(0,0.78,-1.28),rgb(255,120,160))
	return 2.8
end

Build.Toasturtle = function(m)
	local green = rgb(110,190,80)
	part(m,"Ell",V3(0.95,0.85,1.05),CF(0,0.85,-1.35),green)
	eyes(m,V3(0,1.0,-1.8),0.22,0.3)
	smile(m,V3(0,0.72,-1.85),0.4)
	for _,p in ipairs({{-0.85,-0.7},{0.85,-0.7},{-0.85,0.75},{0.85,0.75}}) do
		part(m,"Ell",V3(0.55,0.55,0.6),CF(p[1],0.28,p[2]),green,nil,{Name="Leg"})
	end
	part(m,"Ell",V3(0.3,0.25,0.5),CF(0,0.5,1.3),green)
	part(m,"Block",V3(2.5,0.55,2.35),CF(0,0.95,0),rgb(150,90,40),"Sand")
	part(m,"Ell",V3(2.3,0.95,2.15),CF(0,1.3,0),rgb(232,186,112),"Sand")
	part(m,"Block",V3(0.65,0.16,0.65),CF(0.1,1.8,-0.05)*ANG(0,rad(25),0),rgb(255,235,130))
	for i=-1,1 do part(m,"Block",V3(1.7,0.05,0.12),CF(0,1.76,i*0.5)*ANG(0,rad(-15),0),rgb(150,90,40)) end
	return 2.0
end

Build.Berryhop = function(m)
	local red = rgb(235,40,60)
	part(m,"Ell",V3(1.95,2.15,1.95),CF(0,1.15,0),red)
	local n=0
	for lat=-2,2 do for lon=0,5 do
		n+=1
		local th = rad(lat*28) local ph = lon/6*math.pi*2 + lat*0.4
		local p = V3(math.cos(th)*math.cos(ph)*0.98, 1.15+math.sin(th)*1.07, math.cos(th)*math.sin(ph)*0.98)
		part(m,"Ell",V3(0.12,0.18,0.12),CF(p),rgb(255,230,90))
	end end
	for i=1,5 do
		local a = i/5*math.pi*2
		part(m,"Ell",V3(1.0,0.14,0.42),CF(0,2.2,0)*ANG(0,a,0)*CF(0.45,0,0)*ANG(0,0,rad(-12)),rgb(60,170,60))
	end
	part(m,"Cyl",V3(0.4,0.14,0.14),CF(0,2.4,0)*ANG(0,0,rad(90)),rgb(60,140,50))
	for _,sx in ipairs({-1,1}) do
		part(m,"Ell",V3(0.62,0.62,0.62),CF(sx*0.42,2.05,-0.55),rgb(90,200,90))
	end
	eyes(m,V3(0,2.08,-0.82),0.42,0.42)
	part(m,"Block",V3(1.0,0.08,0.06),CF(0,0.95,-0.97),rgb(90,10,20))
	part(m,"Ell",V3(0.5,0.42,1.1),CF(-0.85,0.25,0.15),rgb(90,200,90),nil,{Name="LimbL"})
	part(m,"Ell",V3(0.5,0.42,1.1),CF(0.85,0.25,0.15),rgb(90,200,90),nil,{Name="LimbR"})
	return 2.6
end

Build.Socktopus = function(m)
	local pink = rgb(240,120,170)
	part(m,"Ell",V3(2.0,2.1,2.0),CF(0,2.0,0),pink)
	part(m,"Ell",V3(0.5,0.5,0.5),CF(0.5,2.8,0.2),rgb(250,160,200))
	eyes(m,V3(0,2.15,-0.88),0.42,0.5)
	part(m,"Ell",V3(0.35,0.25,0.12),CF(0,1.65,-0.95),rgb(120,30,70))
	local sockColors = {{rgb(255,80,80),rgb(255,255,255)},{rgb(80,140,255),rgb(255,230,80)},{rgb(120,220,120),rgb(255,255,255)},{rgb(255,170,40),rgb(130,60,200)},{rgb(255,255,255),rgb(255,80,160)},{rgb(60,200,220),rgb(30,30,60)}}
	for i=1,6 do
		local a = (i-0.5)/6*math.pi*2
		local base = V3(math.cos(a)*0.65,1.3,math.sin(a)*0.65)
		local tip = V3(math.cos(a)*1.45,0.45,math.sin(a)*1.45)
		cylBetween(m,base,tip,0.38,pink)
		local sc = sockColors[i]
		local dir = (V3(math.cos(a)*1.8,0.15,math.sin(a)*1.8)-tip)
		for k=0,2 do
			local a1 = tip + dir*(k/3)
			local a2 = tip + dir*((k+1)/3)
			cylBetween(m,a1,a2,0.46,k%2==0 and sc[1] or sc[2],"Fabric")
		end
		part(m,"Ell",V3(0.55,0.4,0.55),CF(V3(math.cos(a)*1.9,0.2,math.sin(a)*1.9)),sc[1],"Fabric")
	end
	return 3.1
end

Build.DonutSnail = function(m)
	local skin = rgb(195,225,150)
	part(m,"Ell",V3(1.05,0.7,2.8),CF(0,0.35,-0.25),skin)
	part(m,"Ell",V3(0.95,0.95,0.95),CF(0,0.85,-1.35),skin)
	for _,sx in ipairs({-1,1}) do
		cylBetween(m,V3(sx*0.2,1.2,-1.4),V3(sx*0.35,1.85,-1.5),0.12,skin)
		part(m,"Ell",V3(0.34,0.34,0.34),CF(sx*0.36,1.95,-1.52),rgb(255,255,255))
		part(m,"Ell",V3(0.18,0.2,0.1),CF(sx*0.36,1.95,-1.68),rgb(20,20,30))
	end
	smile(m,V3(0,0.75,-1.82),0.45)
	part(m,"Cyl",V3(0.9,2.3,2.3),CF(0,1.55,0.35),rgb(222,170,100),"Sand")
	part(m,"Cyl",V3(1.0,1.95,1.95),CF(0,1.6,0.35),rgb(255,135,195))
	part(m,"Cyl",V3(1.06,0.6,0.6),CF(0,1.55,0.35),rgb(95,55,25))
	local cols = {rgb(255,255,255),rgb(90,200,255),rgb(255,230,60),rgb(120,230,120),rgb(255,80,80)}
	local rng = Random.new(7)
	for i=1,18 do
		local a = rng:NextNumber()*math.pi*2 local r = rng:NextNumber(0.45,0.85)
		local sx = (i%2==0) and 0.52 or -0.52
		part(m,"Block",V3(0.06,0.08,0.24),CF(sx,1.6+math.sin(a)*r,0.35+math.cos(a)*r)*ANG(rng:NextNumber()*3,0,0),cols[(i%#cols)+1])
	end
	return 2.8
end

Build.Roboquack = function(m)
	local metal = rgb(185,195,210)
	part(m,"Ell",V3(1.6,1.35,2.0),CF(0,1.0,0.1),metal,"Metal")
	part(m,"Cyl",V3(0.6,0.5,0.5),CF(0,1.6,-0.5)*ANG(0,0,rad(90)),rgb(120,125,140),"DiamondPlate")
	part(m,"Ell",V3(1.05,1.0,1.05),CF(0,2.1,-0.6),metal,"Metal")
	part(m,"Block",V3(0.7,0.18,0.65),CF(0,1.95,-1.25),rgb(255,150,30),"Metal")
	part(m,"Block",V3(0.6,0.12,0.55),CF(0,1.8,-1.2),rgb(230,120,20),"Metal")
	part(m,"Block",V3(0.85,0.24,0.12),CF(0,2.25,-1.06),rgb(60,240,255),"Neon",{Name="Visor"})
	cylBetween(m,V3(0,2.55,-0.6),V3(0,3.05,-0.6),0.07,rgb(80,80,90),"Metal")
	part(m,"Ball",V3(0.25,0.25,0.25),CF(0,3.1,-0.6),rgb(255,40,40),"Neon")
	for _,sx in ipairs({-1,1}) do
		part(m,"Ell",V3(0.22,0.75,1.25),CF(sx*0.86,1.15,0.15)*ANG(rad(20),0,0),rgb(140,150,165),"DiamondPlate",{Name=sx<0 and "LimbL" or "LimbR"})
		part(m,"Ball",V3(0.15,0.15,0.15),CF(sx*0.55,2.1,-0.95),rgb(70,70,80),"Metal")
		part(m,"Block",V3(0.5,0.12,0.7),CF(sx*0.4,0.08,-0.2),rgb(255,150,30),"Metal")
		cylBetween(m,V3(sx*0.4,0.15,-0.1),V3(sx*0.4,0.5,0.0),0.12,rgb(90,90,100),"Metal")
	end
	part(m,"Wedge",V3(0.8,0.5,0.6),CF(0,1.35,1.15)*ANG(rad(-30),0,0),metal,"Metal")
	return 3.3
end

Build.Prickles = function(m)
	part(m,"Ell",V3(2.0,1.6,2.2),CF(0,0.9,0.1),rgb(150,100,60))
	part(m,"Ell",V3(1.15,1.0,0.65),CF(0,0.85,-0.95),rgb(240,210,170))
	part(m,"Ell",V3(0.3,0.25,0.3),CF(0,0.85,-1.32),rgb(20,20,20))
	eyes(m,V3(0,1.12,-1.18),0.28,0.3)
	smile(m,V3(0,0.62,-1.25),0.35)
	local rng = Random.new(3)
	for i=1,20 do
		local th = rng:NextNumber(rad(10),rad(80)) local ph = rng:NextNumber(rad(-20),rad(200))
		local dir = V3(math.cos(th)*math.cos(ph), math.sin(th), math.cos(th)*math.sin(ph)+0.25).Unit
		local base = V3(0,0.95,0.15) + dir*0.85
		cylBetween(m,base,base+dir*0.55,0.3,rgb(70,160,70),"Grass")
		part(m,"Ball",V3(0.3,0.3,0.3),CF(base+dir*0.55),rgb(70,160,70),"Grass")
		if i%4==0 then part(m,"Ell",V3(0.3,0.2,0.3),CF(base+dir*0.72),rgb(255,110,170)) end
	end
	for _,p in ipairs({{-0.6,-0.6},{0.6,-0.6},{-0.6,0.7},{0.6,0.7}}) do part(m,"Ell",V3(0.35,0.3,0.45),CF(p[1],0.12,p[2]),rgb(120,80,50),nil,{Name="Leg"}) end
	return 2.3
end

Build.SushiCat = function(m)
	part(m,"Cyl",V3(1.6,2.3,2.3),CF(0,0.8,0)*ANG(0,0,rad(90)),rgb(30,48,38),"Fabric")
	part(m,"Cyl",V3(0.12,2.1,2.1),CF(0,1.62,0)*ANG(0,0,rad(90)),rgb(250,250,245),"Sand")
	part(m,"Block",V3(1.9,0.38,1.0),CF(0,1.85,0.3)*ANG(0,rad(8),0),rgb(255,135,80))
	for i=-2,2 do part(m,"Block",V3(0.08,0.4,1.02),CF(i*0.35,1.86,0.3)*ANG(0,rad(8),rad(10)),rgb(255,215,190)) end
	part(m,"Ell",V3(1.45,1.25,1.25),CF(0,2.6,-0.45),rgb(250,250,250))
	for _,sx in ipairs({-1,1}) do
		part(m,"Wedge",V3(0.18,0.6,0.45),CF(sx*0.42,3.35,-0.45)*ANG(0,sx*rad(90),0),rgb(250,250,250))
		part(m,"Wedge",V3(0.19,0.4,0.28),CF(sx*0.42,3.3,-0.48)*ANG(0,sx*rad(90),0),rgb(255,170,190))
		for k=-1,1 do part(m,"Block",V3(0.6,0.03,0.03),CF(sx*0.75,2.45+k*0.08,-0.95)*ANG(0,0,sx*k*rad(10)),rgb(60,60,60)) end
		part(m,"Ell",V3(0.4,0.3,0.5),CF(sx*0.45,0.15,-1.05),rgb(250,250,250),nil,{Name=sx<0 and "LimbL" or "LimbR"})
	end
	eyes(m,V3(0,2.72,-1.02),0.3,0.38,rgb(40,120,60))
	part(m,"Ell",V3(0.16,0.12,0.08),CF(0,2.5,-1.08),rgb(255,130,150))
	smile(m,V3(0,2.36,-1.06),0.3)
	cylBetween(m,V3(0,1.0,1.1),V3(0,1.9,1.5),0.3,rgb(250,250,250))
	part(m,"Ball",V3(0.36,0.36,0.36),CF(0,2.0,1.5),rgb(255,135,80))
	return 3.5
end

Build.Mushmoose = function(m)
	local brown, dark = rgb(125,82,50), rgb(80,50,30)
	part(m,"Ell",V3(2.3,2.0,3.6),CF(0,2.7,0.3),brown,"Fabric")
	for _,p in ipairs({{-0.7,-0.8},{0.7,-0.8},{-0.7,1.3},{0.7,1.3}}) do
		part(m,"Cyl",V3(1.9,0.5,0.5),CF(p[1],1.0,p[2])*ANG(0,0,rad(90)),dark,nil,{Name="Leg"})
		part(m,"Cyl",V3(0.3,0.6,0.6),CF(p[1],0.15,p[2])*ANG(0,0,rad(90)),rgb(40,30,25))
	end
	cylBetween(m,V3(0,3.0,-1.0),V3(0,3.6,-1.7),0.9,brown)
	part(m,"Ell",V3(1.35,1.3,1.9),CF(0,3.8,-1.9),brown,"Fabric")
	part(m,"Ell",V3(1.05,0.9,1.0),CF(0,3.5,-2.75),rgb(190,150,110))
	part(m,"Ball",V3(0.18,0.18,0.18),CF(-0.22,3.6,-3.22),rgb(30,20,20))
	part(m,"Ball",V3(0.18,0.18,0.18),CF(0.22,3.6,-3.22),rgb(30,20,20))
	eyes(m,V3(0,4.05,-2.5),0.45,0.36)
	for _,sx in ipairs({-1,1}) do
		cylBetween(m,V3(sx*0.45,4.4,-1.8),V3(sx*0.8,5.3,-1.7),0.32,rgb(245,235,210))
		local cap = part(m,"Ell",V3(1.5,0.75,1.5),CF(sx*0.85,5.45,-1.7),rgb(225,45,60))
		for k=1,4 do local a=k/4*math.pi*2 part(m,"Ell",V3(0.25,0.12,0.25),CF(sx*0.85+math.cos(a)*0.45,5.72,-1.7+math.sin(a)*0.45),rgb(255,255,255)) end
		cylBetween(m,V3(sx*0.7,4.7,-1.75),V3(sx*1.4,5.0,-1.4),0.2,rgb(245,235,210))
		part(m,"Ell",V3(0.75,0.4,0.75),CF(sx*1.45,5.15,-1.4),rgb(110,230,255),"Neon")
		light(cap,rgb(255,120,140),8,0.8)
	end
	cylBetween(m,V3(0,3.0,2.0),V3(0,2.6,2.4),0.25,brown)
	return 6.0
end

Build.Channel0 = function(m)
	part(m,"Block",V3(2.3,1.8,1.5),CF(0,2.75,0),rgb(70,65,80),"SmoothPlastic")
	part(m,"Block",V3(2.4,0.15,1.6),CF(0,3.7,0),rgb(50,45,60))
	local screen = part(m,"Block",V3(1.75,1.3,0.1),CF(0,2.75,-0.76),rgb(110,230,255),"Neon",{Name="Screen"})
	local sg = Instance.new("SurfaceGui") sg.Face = Enum.NormalId.Front sg.PixelsPerStud = 60 sg.LightInfluence = 0 sg.Parent = screen
	local t = Instance.new("TextLabel") t.Name = "Face" t.Size = UDim2.fromScale(1,1) t.BackgroundTransparency = 1 t.Text = "◕‿◕" t.TextScaled = true t.Font = Enum.Font.GothamBlack t.TextColor3 = rgb(20,30,60) t.Parent = sg
	part(m,"Cyl",V3(0.1,0.3,0.3),CF(1.0,2.2,-0.76)*ANG(0,rad(90),0),rgb(200,200,210),"Metal")
	part(m,"Cyl",V3(0.1,0.3,0.3),CF(1.0,2.6,-0.76)*ANG(0,rad(90),0),rgb(200,200,210),"Metal")
	part(m,"Ball",V3(0.14,0.14,0.14),CF(-0.95,2.1,-0.77),rgb(255,40,40),"Neon")
	for _,sx in ipairs({-1,1}) do
		cylBetween(m,V3(sx*0.2,3.75,0),V3(sx*0.9,4.9,0.1),0.07,rgb(170,170,180),"Metal")
		part(m,"Ball",V3(0.2,0.2,0.2),CF(sx*0.9,4.92,0.1),rgb(255,220,60),"Neon")
		cylBetween(m,V3(sx*0.7,2.2,0),V3(sx*1.35,1.45,-0.2),0.18,rgb(60,60,70),nil)
		part(m,"Ball",V3(0.32,0.32,0.32),CF(sx*1.38,1.4,-0.2),rgb(240,240,240),nil,{Name=sx<0 and "LimbL" or "LimbR"})
		cylBetween(m,V3(sx*0.35,1.4,0),V3(sx*0.4,0.25,0),0.2,rgb(60,60,70))
		part(m,"Ell",V3(0.45,0.25,0.65),CF(sx*0.4,0.13,-0.12),rgb(240,240,240),nil,{Name="Leg"})
	end
	part(m,"Block",V3(1.1,0.9,0.8),CF(0,1.5,0),rgb(90,85,100))
	emitter(screen,rgb(200,240,255),3,0.2,2)
	return 5.0
end

Build.Bananasaur = function(m)
	local yel = rgb(255,225,60)
	local segs = {{V3(0,1.0,1.7),1.0},{V3(0,1.3,0.9),1.25},{V3(0,1.75,0.1),1.35},{V3(0,2.35,-0.5),1.15},{V3(0,2.85,-0.85),1.0}}
	for i,s in ipairs(segs) do part(m,"Ell",V3(s[2],s[2]*1.05,s[2]*1.2),CF(s[1]),yel) end
	part(m,"Ell",V3(0.4,0.35,0.6),CF(0,0.85,2.35),rgb(110,75,30))
	part(m,"Ell",V3(1.25,1.0,1.6),CF(0,3.15,-1.3),yel)
	part(m,"Ell",V3(0.25,0.2,0.25),CF(0,3.75,-1.0),rgb(110,75,30))
	eyes(m,V3(0,3.4,-1.9),0.32,0.34)
	part(m,"Block",V3(0.9,0.08,0.08),CF(0,2.9,-2.05),rgb(80,40,20))
	for i=-2,2 do part(m,"Wedge",V3(0.1,0.18,0.1),CF(i*0.17,2.84,-2.06)*ANG(rad(180),0,0),rgb(255,255,255)) end
	for _,sp in ipairs({V3(0.55,1.9,0.2),V3(-0.5,1.4,0.9),V3(0.45,2.5,-0.6)}) do part(m,"Ell",V3(0.12,0.22,0.22),CF(sp),rgb(140,100,40)) end
	for i=1,4 do
		local a = (i-0.5)/4*math.pi*2
		part(m,"Wedge",V3(0.15,0.9,0.6),CF(math.cos(a)*0.6,0.5,0.6+math.sin(a)*0.6)*ANG(0,-a+rad(90),0)*ANG(rad(-15),0,0),rgb(245,210,50))
	end
	for _,sx in ipairs({-1,1}) do
		part(m,"Ell",V3(0.6,1.0,0.65),CF(sx*0.6,0.5,0.0),yel,nil,{Name="Leg"})
		cylBetween(m,V3(sx*0.45,2.2,-0.9),V3(sx*0.65,1.9,-1.25),0.18,yel)
	end
	return 3.9
end

Build.Bubblejaw = function(m)
	local blue = rgb(100,140,185)
	part(m,"Ell",V3(1.6,1.5,3.3),CF(0,2.3,0),blue)
	part(m,"Ell",V3(1.3,1.0,2.7),CF(0,2.05,-0.05),rgb(240,245,250))
	part(m,"Wedge",V3(0.2,1.0,1.1),CF(0,3.25,0.25),blue)
	part(m,"Wedge",V3(0.18,0.9,0.7),CF(0,2.75,2.0)*ANG(rad(-35),0,0),blue)
	part(m,"Wedge",V3(0.18,0.9,0.7),CF(0,1.85,2.0)*ANG(rad(215),0,0),blue)
	for _,sx in ipairs({-1,1}) do part(m,"Wedge",V3(0.15,0.4,0.8),CF(sx*0.85,1.95,-0.3)*ANG(0,0,sx*rad(60)),blue,nil,{Name=sx<0 and "LimbL" or "LimbR"}) end
	part(m,"Block",V3(0.95,0.22,0.1),CF(0,1.95,-1.6),rgb(60,20,30))
	for i=-3,3 do part(m,"Wedge",V3(0.08,0.14,0.08),CF(i*0.13,2.0,-1.62)*ANG(rad(180),0,0),rgb(255,255,255)) end
	eyes(m,V3(0,2.55,-1.35),0.42,0.32)
	local rng = Random.new(11)
	for i=1,7 do
		local a = i/7*math.pi*2
		local b = part(m,"Ball",V3(1,1,1)*rng:NextNumber(0.35,0.7),CF(math.cos(a)*1.6,2.3+math.sin(a*2)*0.9,math.sin(a)*1.9),rgb(180,230,255),"Glass",{Transparency=0.55,Name="Bubble"})
	end
	emitter(m:FindFirstChildWhichIsA("BasePart"),rgb(200,240,255),4,0.3,1.5)
	return 3.8
end

Build.Clockroach = function(m)
	local brown = rgb(85,45,25)
	part(m,"Ell",V3(1.9,0.8,2.6),CF(0,0.75,0.1),brown,nil,{Reflectance=0.15})
	part(m,"Cyl",V3(0.12,1.65,1.65),CF(0,1.12,0.15)*ANG(0,0,rad(90)),rgb(240,200,80),"Foil")
	part(m,"Cyl",V3(0.14,1.45,1.45),CF(0,1.16,0.15)*ANG(0,0,rad(90)),rgb(252,250,240))
	for i=1,12 do local a=i/12*math.pi*2 part(m,"Block",V3(0.06,0.04,i%3==0 and 0.2 or 0.1),CF(0,1.24,0.15)*ANG(0,a,0)*CF(0,0,-0.6),rgb(30,30,30)) end
	spin(part(m,"Block",V3(0.08,0.05,0.42),CF(0,1.27,0.15-0.18),rgb(20,20,20),nil,{Name="HandH"}),"Y",0.5)
	spin(part(m,"Block",V3(0.05,0.05,0.6),CF(0,1.29,0.15-0.27),rgb(200,30,30),nil,{Name="HandM"}),"Y",3)
	part(m,"Ball",V3(0.12,0.12,0.12),CF(0,1.3,0.15),rgb(240,200,80),"Foil")
	part(m,"Ell",V3(0.95,0.65,0.75),CF(0,0.75,-1.35),rgb(65,35,20))
	eyes(m,V3(0,0.9,-1.68),0.25,0.3)
	for _,sx in ipairs({-1,1}) do
		cylBetween(m,V3(sx*0.2,1.0,-1.55),V3(sx*0.9,1.9,-2.6),0.05,rgb(50,30,20))
		for k=-1,1 do
			cylBetween(m,V3(sx*0.8,0.65,k*0.7),V3(sx*1.4,0.05,k*0.9),0.1,rgb(60,35,20),nil).Name="Leg"
		end
	end
	return 1.6
end

Build.Melonphant = function(m)
	local green = rgb(70,170,60)
	part(m,"Ell",V3(3.2,2.8,3.6),CF(0,2.7,0.3),green)
	for i=-3,3 do part(m,"Ell",V3(0.28,2.82,3.62),CF(0,2.7,0.3)*ANG(0,0,rad(i*22)),rgb(30,100,35)) end
	part(m,"Ell",V3(1.9,1.85,1.65),CF(0,3.5,-1.95),rgb(255,95,105))
	for i=1,5 do local a=i/5*math.pi*2 part(m,"Ell",V3(0.12,0.2,0.08),CF(math.cos(a)*0.55,3.6+math.sin(a)*0.5,-2.72),rgb(30,20,20)) end
	part(m,"Ell",V3(1.95,0.35,1.7),CF(0,4.35,-1.95),rgb(70,170,60))
	eyes(m,V3(0,3.8,-2.68),0.4,0.36)
	for _,sx in ipairs({-1,1}) do
		part(m,"Ell",V3(0.25,1.7,1.5),CF(sx*1.15,3.6,-1.6)*ANG(0,sx*rad(-25),0),rgb(70,170,60),nil,{Name=sx<0 and "LimbL" or "LimbR"})
		part(m,"Ell",V3(0.27,1.3,1.1),CF(sx*1.17,3.6,-1.65)*ANG(0,sx*rad(-25),0),rgb(255,95,105))
		cylBetween(m,V3(sx*0.45,2.9,-2.5),V3(sx*0.7,2.6,-3.2),0.18,rgb(255,255,240))
	end
	cylBetween(m,V3(0,3.1,-2.7),V3(0,2.4,-3.0),0.55,rgb(255,95,105))
	cylBetween(m,V3(0,2.4,-3.0),V3(0,1.8,-2.9),0.45,rgb(255,95,105))
	part(m,"Ball",V3(0.5,0.5,0.5),CF(0,1.65,-2.85),rgb(70,170,60))
	for _,p in ipairs({{-0.9,-0.8},{0.9,-0.8},{-0.9,1.3},{0.9,1.3}}) do
		part(m,"Cyl",V3(1.5,0.85,0.85),CF(p[1],0.75,p[2])*ANG(0,0,rad(90)),rgb(70,170,60),nil,{Name="Leg"})
		part(m,"Cyl",V3(0.1,0.88,0.88),CF(p[1],0.05,p[2])*ANG(0,0,rad(90)),rgb(255,95,105))
	end
	cylBetween(m,V3(0,2.6,2.0),V3(0,1.9,2.3),0.15,rgb(30,100,35))
	return 5.0
end

Build.Glitchling = function(m)
	part(m,"Block",V3(1.6,1.6,1.6),CF(0,1.3,0),rgb(255,60,200))
	spin(part(m,"Block",V3(1.62,1.62,1.62),CF(0.14,1.32,0),rgb(0,255,255),"Neon",{Transparency=0.65,Name="GlitchA"}),"G",1)
	spin(part(m,"Block",V3(1.62,1.62,1.62),CF(-0.12,1.24,0.05),rgb(255,40,120),"Neon",{Transparency=0.7,Name="GlitchB"}),"G",1)
	for _,sx in ipairs({-1,1}) do
		part(m,"Block",V3(0.4,0.4,0.05),CF(sx*0.38,1.5,-0.82),rgb(255,255,255),"Neon")
		part(m,"Block",V3(0.2,0.2,0.06),CF(sx*0.38,1.45,-0.84),rgb(10,10,20))
		part(m,"Block",V3(0.3,0.5,0.3),CF(sx*0.45,0.25,0),rgb(255,60,200),nil,{Name="Leg"})
	end
	for i=-2,2 do part(m,"Block",V3(0.18,0.12,0.05),CF(i*0.18,0.95+(i%2)*0.08,-0.82),rgb(10,10,20)) end
	local rng = Random.new(5)
	for i=1,8 do
		part(m,"Block",V3(0.22,0.22,0.22),CF(rng:NextNumber(-1.3,1.3),rng:NextNumber(0.5,2.6),rng:NextNumber(-1.3,1.3)),i%2==0 and rgb(0,255,255) or rgb(255,60,200),"Neon",{Name="Pixel"})
	end
	emitter(m:FindFirstChildWhichIsA("BasePart"),rgb(0,255,255),8,0.25,2,nil,{Shape=Enum.ParticleEmitterShape.Box})
	return 2.4
end

Build.GoldfishTank = function(m)
	local metal = rgb(70,75,90)
	part(m,"Block",V3(2.8,2.2,2.0),CF(0,2.55,0),rgb(200,235,255),"Glass",{Transparency=0.6})
	part(m,"Block",V3(2.6,1.7,1.8),CF(0,2.35,0),rgb(60,150,255),"Glass",{Transparency=0.55})
	part(m,"Block",V3(2.62,0.28,1.82),CF(0,1.6,0),rgb(230,200,140),"Pebble")
	for _,x in ipairs({-1.4,1.4}) do for _,z in ipairs({-1,1}) do part(m,"Block",V3(0.15,2.3,0.15),CF(x,2.55,z),metal,"Metal") end end
	part(m,"Block",V3(3.0,0.18,2.2),CF(0,3.7,0),metal,"Metal")
	part(m,"Block",V3(3.0,0.25,2.2),CF(0,1.4,0),metal,"Metal")
	for i=1,3 do cylBetween(m,V3(-0.9+i*0.4,1.7,0.5),V3(-0.9+i*0.45,2.6+i*0.15,0.55),0.12,rgb(40,170,80)) end
	local fish = part(m,"Ell",V3(0.75,0.6,1.1),CF(0,2.5,-0.1),rgb(255,140,30),nil,{Name="Fish"})
	part(m,"Wedge",V3(0.08,0.6,0.5),CF(0,2.5,0.6),rgb(255,170,60))
	part(m,"Ball",V3(0.18,0.18,0.18),CF(-0.25,2.6,-0.48),rgb(10,10,10))
	part(m,"Ball",V3(0.18,0.18,0.18),CF(0.25,2.6,-0.48),rgb(10,10,10))
	part(m,"Block",V3(0.3,0.4,0.1),CF(0,3.0,-0.1),rgb(40,40,50))
	part(m,"Cyl",V3(0.08,0.6,0.6),CF(0,2.82,-0.1)*ANG(0,0,rad(90)),rgb(40,40,50))
	for _,p in ipairs({{-1.1,-0.7},{1.1,-0.7},{-1.1,0.7},{1.1,0.7}}) do
		cylBetween(m,V3(p[1],1.35,p[2]),V3(p[1]*1.15,0.2,p[2]*1.2),0.3,metal,"Metal").Name="Leg"
		part(m,"Ell",V3(0.55,0.25,0.7),CF(p[1]*1.15,0.12,p[2]*1.2-0.1),rgb(255,200,60),"Foil")
	end
	emitter(fish,rgb(220,245,255),5,0.25,1.2,nil,{Acceleration=V3(0,3,0),SpreadAngle=Vector2.new(20,20)})
	light(fish,rgb(120,200,255),10,1.2)
	return 3.9
end

Build.Crownach = function(m)
	local purple = rgb(120,55,175)
	part(m,"Ell",V3(1.25,0.9,3.1),CF(0,0.45,-0.15),purple,"Fabric")
	part(m,"Ell",V3(1.15,1.15,1.15),CF(0,1.05,-1.5),purple,"Fabric")
	for _,sx in ipairs({-1,1}) do
		cylBetween(m,V3(sx*0.2,1.45,-1.6),V3(sx*0.35,2.1,-1.75),0.12,purple)
		part(m,"Ell",V3(0.34,0.34,0.34),CF(sx*0.36,2.2,-1.78),rgb(255,255,255))
		part(m,"Ell",V3(0.16,0.2,0.1),CF(sx*0.36,2.2,-1.94),rgb(20,20,30))
	end
	part(m,"Block",V3(0.7,0.12,0.1),CF(0,0.9,-2.05),rgb(60,30,20))
	part(m,"Cyl",V3(1.0,2.4,2.4),CF(0,1.75,0.45),rgb(255,200,60),"Foil")
	part(m,"Cyl",V3(1.06,1.7,1.7),CF(0,1.75,0.5),rgb(230,170,40),"Foil")
	part(m,"Cyl",V3(1.12,1.0,1.0),CF(0,1.75,0.55),rgb(255,215,90),"Foil")
	part(m,"Block",V3(1.3,1.6,0.1),CF(0,1.3,1.75)*ANG(rad(-10),0,0),rgb(200,30,50),"Fabric")
	local crown = part(m,"Cyl",V3(0.65,1.5,1.5),CF(0,3.2,0.45)*ANG(0,0,rad(90)),rgb(255,205,50),"Foil")
	for i=1,6 do
		local a = i/6*math.pi*2
		part(m,"Wedge",V3(0.2,0.6,0.35),CF(math.cos(a)*0.62,3.75,0.45+math.sin(a)*0.62)*ANG(0,-a-rad(90),0),rgb(255,205,50),"Foil")
		part(m,"Ball",V3(0.18,0.18,0.18),CF(math.cos(a)*0.7,3.25,0.45+math.sin(a)*0.7),i%2==0 and rgb(255,40,60) or rgb(60,120,255),"Neon")
	end
	part(m,"Ball",V3(0.35,0.35,0.35),CF(0,3.55,0.45),rgb(255,255,255),"Glass")
	emitter(crown,rgb(255,230,120),6,0.35,1)
	light(crown,rgb(255,210,90),9,1)
	return 4.2
end

Build.Nebulamb = function(m)
	local core = part(m,"Ell",V3(2.4,1.9,2.8),CF(0,2.0,0.1),rgb(35,15,80))
	local rng = Random.new(9)
	for i=1,10 do
		local a=i/10*math.pi*2
		part(m,"Ball",V3(1,1,1)*rng:NextNumber(1.0,1.4),CF(math.cos(a)*0.85,2.1+math.sin(a*3)*0.45,0.1+math.sin(a)*1.0),rgb(150,100,255),"ForceField")
	end
	for i=1,16 do part(m,"Ball",V3(1,1,1)*rng:NextNumber(0.08,0.18),CF(rng:NextNumber(-0.9,0.9),rng:NextNumber(1.4,2.7),rng:NextNumber(-0.9,1.1)),i%3==0 and rgb(255,220,120) or rgb(220,240,255),"Neon",{Name="Star"}) end
	part(m,"Ell",V3(1.05,1.0,1.15),CF(0,2.35,-1.55),rgb(20,15,45))
	for _,sx in ipairs({-1,1}) do
		part(m,"Ell",V3(0.7,0.25,0.4),CF(sx*0.65,2.6,-1.4)*ANG(0,0,sx*rad(-20)),rgb(20,15,45),nil,{Name=sx<0 and "LimbL" or "LimbR"})
		part(m,"Ell",V3(0.28,0.3,0.1),CF(sx*0.25,2.45,-2.1),rgb(120,255,255),"Neon")
	end
	part(m,"Ell",V3(0.25,0.12,0.08),CF(0,2.15,-2.12),rgb(255,150,220),"Neon")
	for _,p in ipairs({{-0.6,-0.7},{0.6,-0.7},{-0.6,0.9},{0.6,0.9}}) do cylBetween(m,V3(p[1],1.3,p[2]),V3(p[1],0.15,p[2]),0.3,rgb(20,15,45)).Name="Leg" end
	part(m,"Cyl",V3(0.08,1.4,1.4),CF(0,3.4,-0.3)*ANG(0,0,rad(90)),rgb(255,240,150),"Neon",{Name="Halo"})
	emitter(core,rgb(200,170,255),10,0.35,1.5)
	light(core,rgb(170,120,255),14,1.6)
	return 3.6
end

Build.Voidzilla = function(m)
	local body = part(m,"Ell",V3(4,4.4,4),CF(0,4.8,0),rgb(15,10,25))
	part(m,"Ell",V3(4.6,5.0,4.6),CF(0,4.8,0),rgb(130,40,220),"ForceField",{Name="Aura"})
	for _,sx in ipairs({-1,1}) do
		part(m,"Ell",V3(0.9,0.45,0.2),CF(sx*0.8,5.6,-1.92)*ANG(0,0,sx*rad(-15)),rgb(255,40,120),"Neon")
		part(m,"Wedge",V3(0.5,1.8,0.9),CF(sx*1.2,7.3,0)*ANG(0,0,sx*rad(-25)),rgb(25,15,40))
		cylBetween(m,V3(sx*1.8,4.8,-0.5),V3(sx*2.9,3.6,-1.3),0.5,rgb(20,12,35)).Name = sx<0 and "LimbL" or "LimbR"
		part(m,"Ball",V3(0.7,0.7,0.7),CF(sx*2.95,3.5,-1.35),rgb(80,30,140),"Neon")
	end
	part(m,"Wedge",V3(0.5,1.5,0.9),CF(0,7.55,0.3),rgb(25,15,40))
	for i=-3,3 do part(m,"Wedge",V3(0.2,0.3,0.15),CF(i*0.28,4.2+math.abs(i)*0.05,-1.95)*ANG(rad(180),0,0),rgb(200,120,255),"Neon") end
	for i=1,6 do
		local a=i/6*math.pi*2
		cylBetween(m,V3(math.cos(a)*1.2,3.0,math.sin(a)*1.2),V3(math.cos(a)*1.6,1.0,math.sin(a)*1.6),0.35,rgb(20,12,35)).Name="Tendril"
	end
	emitter(body,rgb(60,20,90),14,1.2,1,"rbxasset://textures/particles/smoke_main.dds",{LightEmission=0})
	emitter(body,rgb(190,100,255),8,0.4,3)
	light(body,rgb(160,60,255),18,2)
	return 8.0
end

-- Guardians -----------------------------------------------------------------
local GBuild = {}
GBuild.Mushroom = function(m)
	part(m,"Ell",V3(2.6,3.2,2.4),CF(0,2.0,0),rgb(245,232,205))
	local cap = part(m,"Ell",V3(4.6,2.0,4.6),CF(0,4.1,0),rgb(220,50,60))
	for i=1,7 do local a=i/7*math.pi*2 part(m,"Ell",V3(0.7,0.3,0.7),CF(math.cos(a)*1.6,4.6,math.sin(a)*1.6),rgb(255,255,255)) end
	eyes(m,V3(0,2.8,-1.12),0.5,0.55)
	for _,sx in ipairs({-1,1}) do
		part(m,"Block",V3(0.6,0.14,0.1),CF(sx*0.5,3.25,-1.18)*ANG(0,0,sx*rad(20)),rgb(60,30,20))
		part(m,"Ell",V3(0.7,1.6,0.7),CF(sx*1.5,2.0,-0.2)*ANG(0,0,sx*rad(25)),rgb(245,232,205),nil,{Name=sx<0 and "LimbL" or "LimbR"})
		part(m,"Ell",V3(0.9,0.5,1.2),CF(sx*0.7,0.25,-0.2),rgb(120,80,50),nil,{Name="Leg"})
	end
	part(m,"Block",V3(0.8,0.15,0.1),CF(0,2.15,-1.2),rgb(60,20,20))
	light(cap,rgb(255,120,120),10,0.6)
	return 5.2
end
GBuild.Frostbite = function(m)
	local snow = rgb(240,248,255)
	part(m,"Ball",V3(3.4,3.4,3.4),CF(0,1.9,0),snow,"Snow")
	part(m,"Ball",V3(2.4,2.4,2.4),CF(0,4.0,-0.2),snow,"Snow")
	part(m,"Ell",V3(1.6,1.2,0.5),CF(0,4.0,-1.15),rgb(130,190,255))
	eyes(m,V3(0,4.15,-1.38),0.35,0.4,rgb(20,40,120))
	part(m,"Block",V3(0.7,0.14,0.1),CF(0,3.7,-1.42),rgb(30,40,90))
	for _,sx in ipairs({-1,1}) do
		part(m,"Wedge",V3(0.4,1.2,0.6),CF(sx*0.8,5.4,-0.2)*ANG(0,0,sx*rad(-20)),rgb(160,220,255),"Ice",{Transparency=0.2})
		part(m,"Ball",V3(1.2,1.2,1.2),CF(sx*1.9,2.4,-0.4),snow,"Snow",{Name=sx<0 and "LimbL" or "LimbR"})
		part(m,"Ball",V3(1.0,1.0,1.0),CF(sx*0.8,0.4,-0.3),snow,"Snow",{Name="Leg"})
	end
	emitter(m:FindFirstChildWhichIsA("BasePart"),rgb(230,245,255),6,0.3,1)
	return 5.6
end
GBuild.Molten = function(m)
	local rock = rgb(55,40,40)
	local body = part(m,"Block",V3(3.0,2.6,2.2),CF(0,2.8,0)*ANG(0,0,rad(3)),rock,"Basalt")
	part(m,"Block",V3(1.8,1.4,1.6),CF(0,4.7,-0.1),rock,"Basalt")
	for i=1,6 do part(m,"Block",V3(0.12,1.0+i%3*0.3,0.08),CF(-1.0+i*0.3,2.8+(i%2)*0.3,-1.12)*ANG(0,0,rad(i*25)),rgb(255,110,20),"Neon") end
	for _,sx in ipairs({-1,1}) do
		part(m,"Block",V3(0.45,0.25,0.1),CF(sx*0.4,4.8,-0.92),rgb(255,200,40),"Neon")
		part(m,"Block",V3(1.1,2.2,1.1),CF(sx*2.1,2.4,-0.2)*ANG(0,0,sx*rad(10)),rock,"Basalt",{Name=sx<0 and "LimbL" or "LimbR"})
		part(m,"Block",V3(1.4,1.2,1.4),CF(sx*2.25,1.0,-0.3),rgb(70,45,40),"Basalt")
		part(m,"Block",V3(1.1,1.4,1.2),CF(sx*0.8,0.7,0),rock,"Basalt",{Name="Leg"})
	end
	emitter(body,rgb(255,140,40),10,0.3,3,"rbxasset://textures/particles/fire_main.dds")
	light(body,rgb(255,120,40),14,2)
	return 5.4
end
GBuild.Cosmic = function(m)
	local crystal = part(m,"Ell",V3(2.4,4.2,2.4),CF(0,3.2,0),rgb(150,90,255),"Glass",{Transparency=0.15})
	part(m,"Ell",V3(1.6,1.6,0.4),CF(0,3.6,-1.05),rgb(255,255,255))
	part(m,"Ell",V3(0.9,0.9,0.3),CF(0,3.6,-1.2),rgb(255,60,200),"Neon")
	part(m,"Ell",V3(0.4,0.4,0.2),CF(0,3.6,-1.33),rgb(20,10,30))
	spin(part(m,"Cyl",V3(0.15,4.0,4.0),CF(0,3.2,0)*ANG(0,0,rad(90))*ANG(rad(20),0,0),rgb(255,220,120),"Neon",{Name="Ring"}),"Y",1.5)
	for _,sx in ipairs({-1,1}) do part(m,"Ell",V3(0.8,1.6,0.8),CF(sx*1.8,3.0,0),rgb(110,60,220),"Glass",{Transparency=0.2,Name=sx<0 and "LimbL" or "LimbR"}) end
	part(m,"Ell",V3(1.2,0.8,1.2),CF(0,0.9,0),rgb(110,60,220),"Glass",{Transparency=0.3,Name="Leg"})
	emitter(crystal,rgb(220,180,255),12,0.3,2)
	light(crystal,rgb(180,120,255),14,1.6)
	return 5.6
end

local function finalize(m, height, attrs)
	local root = Instance.new("Part")
	root.Name = "Root"
	root.Size = V3(3, height, 3)
	root.CFrame = CF(0, height/2, 0)
	root.Transparency = 1
	root.Anchored = true
	root.CanCollide = false
	root.CanTouch = false
	root.CanQuery = true
	root.PivotOffset = CF(0,-height/2,0)
	root.Parent = m
	local body = Instance.new("Part")
	body.Name = "Body" body.Size = V3(0.2,0.2,0.2) body.CFrame = CF(0,0,0) body.Transparency = 1
	body.CanCollide = false body.CanTouch = false body.CanQuery = false body.Massless = true body.Parent = m
	local bj = Instance.new("Motor6D") bj.Name = "BodyJoint" bj.Part0 = root bj.Part1 = body
	bj.C0 = root.CFrame:Inverse() bj.C1 = CFrame.identity bj.Parent = root
	for _,p in ipairs(m:GetDescendants()) do
		if p:IsA("BasePart") and p ~= root and p ~= body then
			p.Anchored = false p.CanCollide = false p.CanTouch = false p.CanQuery = false p.Massless = true
			if p:GetAttribute("Spin") then
				local j = Instance.new("Motor6D") j.Name = "SpinJoint" j.Part0 = body j.Part1 = p
				j.C0 = body.CFrame:Inverse()*p.CFrame j.Parent = p
				p:SetAttribute("BaseC0", j.C0)
			else
				local w = Instance.new("WeldConstraint") w.Part0 = body w.Part1 = p w.Parent = p
			end
		end
	end
	m.PrimaryPart = root
	if attrs then for k,v in pairs(attrs) do m:SetAttribute(k,v) end end
	return m
end

local function rarityFX(m, def, golden)
	local r = Config.RarityById[def.rarity]
	local root = m.PrimaryPart
	if r.order >= 3 then
		emitter(root, r.color, r.order*2, 0.25, 0.6, nil, {Lifetime=NumberRange.new(1,1.6)})
	end
	if r.order >= 4 then light(root, r.color, 8+r.order*2, 0.8) end
	if r.order >= 5 then
		local a0 = Instance.new("Attachment") a0.Position = V3(0,-root.Size.Y/2+0.1,0) a0.Parent = root
		local e = emitter(a0, r.color, 20, 0.6, 3, nil, {Shape=Enum.ParticleEmitterShape.Disc, EmissionDirection=Enum.NormalId.Top, SpreadAngle=Vector2.new(5,5)})
		e.ShapeStyle = Enum.ParticleEmitterShapeStyle.Surface
		a0.Name = "AuraRing"
	end
	if golden then
		for _,p in ipairs(m:GetDescendants()) do
			if p:IsA("BasePart") and p.Transparency < 1 and p.Material ~= Enum.Material.Neon then
				p.Material = Enum.Material.Foil
				p.Color = p.Color:Lerp(rgb(255,200,40),0.75)
			end
		end
		emitter(root, rgb(255,230,100), 25, 0.5, 2)
		light(root, rgb(255,210,80), 16, 2)
	end
end

-- Public: build a creature model. opts.golden
function B.BuildCreature(id, opts)
	opts = opts or {}
	local def = Config.CreatureById[id]
	assert(def, "Unknown creature "..tostring(id))
	local m = Instance.new("Model")
	m.Name = def.id
	local h = Build[def.id](m)
	finalize(m, h, {CreatureId=def.id, Rarity=def.rarity, Size=def.size, Anim=def.anim, Height=h, Golden=opts.golden or false})
	rarityFX(m, def, opts.golden)
	m:AddTag("Oddling")
	return m
end

-- Public: build a guardian (theme by territory, scale for Large type)
function B.BuildGuardian(territory, gtype)
	local m = Instance.new("Model")
	m.Name = territory.."Guardian"
	local h = GBuild[territory](m)
	finalize(m, h, {Territory=territory, GuardianType=gtype, Anim="Stomp", Height=h})
	local scale = Config.GuardianTypes[gtype].scale
	if scale ~= 1 then m:ScaleTo(scale) m:SetAttribute("Height", h*scale) end
	m:AddTag("Guardian")
	return m
end

function B.Silhouette(m)
	for _,d in ipairs(m:GetDescendants()) do
		if d:IsA("BasePart") then d.Color = rgb(20,20,30) d.Material = Enum.Material.SmoothPlastic
		elseif d:IsA("ParticleEmitter") or d:IsA("Light") or d:IsA("SurfaceGui") then d:Destroy() end
	end
end

return B
