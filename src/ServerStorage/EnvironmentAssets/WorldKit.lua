-- Environment construction kit used to build Oddling Island props.
local K = {}
local CF,V3,ANG = CFrame.new, Vector3.new, CFrame.Angles
local rad = math.rad
local function rgb(r,g,b) return Color3.fromRGB(r,g,b) end
K.rgb = rgb

function K.part(parent, shape, size, cf, color, mat, extra)
	local p
	if shape=="Wedge" then p=Instance.new("WedgePart") elseif shape=="Corner" then p=Instance.new("CornerWedgePart") else
		p=Instance.new("Part")
		if shape=="Ball" then p.Shape=Enum.PartType.Ball elseif shape=="Cyl" then p.Shape=Enum.PartType.Cylinder end
	end
	p.Anchored=true p.Size=size p.CFrame=cf p.Color=color p.Material=Enum.Material[mat or "SmoothPlastic"]
	p.TopSurface=Enum.SurfaceType.Smooth p.BottomSurface=Enum.SurfaceType.Smooth
	if shape=="Ell" then local m=Instance.new("SpecialMesh") m.MeshType=Enum.MeshType.Sphere m.Parent=p end
	if extra then for k,v in pairs(extra) do p[k]=v end end
	p.Parent=parent
	return p
end
local P = K.part
function K.vcyl(parent, pos, h, d, color, mat, extra) return P(parent,"Cyl",V3(h,d,d),CF(pos+V3(0,h/2,0))*ANG(0,0,rad(90)),color,mat,extra) end
function K.between(parent,a,b,d,color,mat,extra) local mid=(a+b)/2 return P(parent,"Cyl",V3((b-a).Magnitude,d,d),CFrame.lookAt(mid,b)*ANG(0,rad(90),0),color,mat,extra) end
function K.model(parent,name) local m=Instance.new("Model") m.Name=name m.Parent=parent return m end

function K.emitter(parent,color,rate,size,speed,tex,extra)
	local e=Instance.new("ParticleEmitter") e.Texture=tex or "rbxasset://textures/particles/sparkles_main.dds"
	e.Color=ColorSequence.new(color) e.Rate=rate e.Size=NumberSequence.new(size or 0.5) e.Speed=NumberRange.new(speed or 1)
	e.Lifetime=NumberRange.new(2,4) e.LightEmission=0.5
	e.Transparency=NumberSequence.new({NumberSequenceKeypoint.new(0,0.3),NumberSequenceKeypoint.new(1,1)})
	if extra then for k,v in pairs(extra) do e[k]=v end end
	e.Parent=parent return e
end
function K.light(parent,color,range,b,kind) local l=Instance.new(kind or "PointLight") l.Color=color l.Range=range l.Brightness=b or 1 l.Parent=parent return l end

function K.ground(x,z)
	local r = workspace:Raycast(V3(x,300,z),V3(0,-600,0),K.rayParams)
	if r then return r.Position.Y end
	return 0
end
K.rayParams = RaycastParams.new() K.rayParams.FilterType=Enum.RaycastFilterType.Include
K.rayParams.FilterDescendantsInstances={workspace.Terrain}

function K.tree(parent,pos,s,leaf)
	s=s or 1 local m=K.model(parent,"Tree")
	K.vcyl(m,pos-V3(0,1,0),9*s,1.6*s,rgb(110,75,45),"Wood")
	leaf = leaf or rgb(70,170,70)
	local r=Random.new(math.floor(pos.X*7+pos.Z))
	for i=1,4 do
		local o=V3(r:NextNumber(-2,2),r:NextNumber(0,2.5),r:NextNumber(-2,2))*s
		P(m,"Ball",V3(1,1,1)*r:NextNumber(5,7)*s,CF(pos+V3(0,9.5*s,0)+o),leaf:Lerp(rgb(150,220,90),r:NextNumber(0,0.35)),"Grass")
	end
	return m
end
function K.pine(parent,pos,s)
	s=s or 1 local m=K.model(parent,"Pine")
	K.vcyl(m,pos-V3(0,1,0),4*s,1.2*s,rgb(100,70,45),"Wood")
	for i=0,3 do
		local d=(9-i*2)*s
		P(m,"Cyl",V3(2.4*s,d,d),CF(pos+V3(0,(3.5+i*2.6)*s,0))*ANG(0,0,rad(90)),rgb(40,110,70),"Grass")
		P(m,"Cyl",V3(0.8*s,d*0.92,d*0.92),CF(pos+V3(0,(4.9+i*2.6)*s,0))*ANG(0,0,rad(90)),rgb(245,250,255),"Snow")
	end
	P(m,"Ball",V3(1.6,1.6,1.6)*s,CF(pos+V3(0,13.6*s,0)),rgb(245,250,255),"Snow")
	return m
end
function K.mushroom(parent,pos,s,capColor,glow)
	s=s or 1 local m=K.model(parent,"GiantMushroom")
	K.vcyl(m,pos-V3(0,1,0),8*s,2.4*s,rgb(245,235,215),"SmoothPlastic")
	local cap=P(m,"Ell",V3(11,5,11)*s,CF(pos+V3(0,8*s,0)),capColor or rgb(225,50,60),glow and "Neon" or "SmoothPlastic")
	P(m,"Cyl",V3(0.4*s,9.5*s,9.5*s),CF(pos+V3(0,6.6*s,0))*ANG(0,0,rad(90)),rgb(240,220,200))
	if not glow then
		for i=1,6 do local a=i/6*math.pi*2 P(m,"Ell",V3(1.6,0.5,1.6)*s,CF(pos+V3(math.cos(a)*3.2*s,9.9*s,math.sin(a)*3.2*s))*ANG(0,0,math.cos(a)*0.4),rgb(255,255,255)) end
	else
		K.light(cap,capColor,18*s,1.2) cap.Transparency=0.15
	end
	return m
end
function K.rock(parent,pos,s,color,mat,moss)
	s=s or 1 local r=Random.new(math.floor(pos.X*3+pos.Z*5))
	local m=K.model(parent,"Rock")
	for i=1,3 do
		P(m,"Block",V3(r:NextNumber(3,6),r:NextNumber(2,4),r:NextNumber(3,6))*s,CF(pos+V3(r:NextNumber(-1.5,1.5),r:NextNumber(0,1),r:NextNumber(-1.5,1.5))*s)*ANG(r:NextNumber(-0.4,0.4),r:NextNumber(0,6),r:NextNumber(-0.4,0.4)),color or rgb(130,130,135),mat or "Slate")
	end
	if moss then P(m,"Block",V3(4,0.6,4)*s,CF(pos+V3(0,2.4*s,0))*ANG(0.1,r:NextNumber(0,6),0.1),rgb(90,160,60),"Grass") end
	return m
end
function K.flowers(parent,pos,n,radius)
	local m=K.model(parent,"Flowers") local r=Random.new(math.floor(pos.X+pos.Z*13))
	local cols={rgb(255,90,120),rgb(255,220,60),rgb(150,110,255),rgb(255,255,255),rgb(255,150,60)}
	for i=1,n do
		local o=V3(r:NextNumber(-radius,radius),0,r:NextNumber(-radius,radius))
		K.vcyl(m,pos+o,1.2,0.15,rgb(60,150,50),"Grass")
		P(m,"Ball",V3(0.7,0.7,0.7),CF(pos+o+V3(0,1.3,0)),cols[r:NextInteger(1,#cols)])
	end
	return m
end
function K.crystal(parent,pos,s,color)
	local m=K.model(parent,"Crystal") local r=Random.new(math.floor(pos.X*11+pos.Z))
	for i=1,4 do
		local h=r:NextNumber(4,9)*s
		P(m,"Block",V3(1.4*s,h,1.4*s),CF(pos+V3(r:NextNumber(-1.5,1.5)*s,h/2-0.5,r:NextNumber(-1.5,1.5)*s))*ANG(r:NextNumber(-0.4,0.4),r:NextNumber(0,3),r:NextNumber(-0.4,0.4)),color,"Glass",{Transparency=0.25,Reflectance=0.2})
	end
	K.light(m:FindFirstChildWhichIsA("BasePart"),color,14*s,1)
	return m
end
function K.lamp(parent,pos,color)
	local m=K.model(parent,"Lamp")
	K.vcyl(m,pos,0.6,1.6,rgb(50,50,60),"Metal")
	K.vcyl(m,pos,10,0.5,rgb(50,50,60),"Metal")
	local bulb=P(m,"Ball",V3(1.6,1.6,1.6),CF(pos+V3(0,10.6,0)),color or rgb(255,230,170),"Neon",{Name="Bulb"})
	K.light(bulb,color or rgb(255,220,160),24,1.4)
	m:AddTag("PlazaLight")
	return m
end
function K.bench(parent,cf)
	local m=K.model(parent,"Bench")
	P(m,"Block",V3(6,0.4,2),cf*CF(0,1.8,0),rgb(170,110,60),"WoodPlanks")
	P(m,"Block",V3(6,1.6,0.3),cf*CF(0,2.8,0.9)*ANG(rad(-10),0,0),rgb(170,110,60),"WoodPlanks")
	for _,x in ipairs({-2.6,2.6}) do P(m,"Block",V3(0.4,1.8,2),cf*CF(x,0.9,0),rgb(50,50,60),"Metal") end
	return m
end
function K.signGui(partObj, face, text, bg, fg, font)
	local sg=Instance.new("SurfaceGui") sg.Face=face or Enum.NormalId.Front sg.PixelsPerStud=30 sg.LightInfluence=0.2 sg.Parent=partObj
	local fr=Instance.new("Frame") fr.Size=UDim2.fromScale(1,1) fr.BackgroundColor3=bg or rgb(40,30,80) fr.Parent=sg
	local g=Instance.new("UIGradient") g.Color=ColorSequence.new(fr.BackgroundColor3:Lerp(rgb(255,255,255),0.2),fr.BackgroundColor3:Lerp(rgb(0,0,0),0.3)) g.Rotation=90 g.Parent=fr
	local t=Instance.new("TextLabel") t.Name="Label" t.Size=UDim2.fromScale(0.94,0.86) t.Position=UDim2.fromScale(0.03,0.07) t.BackgroundTransparency=1 t.Text=text t.TextScaled=true
	t.Font=font or Enum.Font.FredokaOne t.TextColor3=fg or rgb(255,255,255) t.Parent=fr
	local st=Instance.new("UIStroke") st.Thickness=3 st.Color=rgb(20,10,40) st.Parent=t
	return sg
end
function K.arch(parent,pos,facingYaw,width,height,color,mat,label)
	local m=K.model(parent,"Gate")
	local cf=CF(pos)*ANG(0,facingYaw,0)
	for _,sx in ipairs({-1,1}) do
		P(m,"Block",V3(4,height,4),cf*CF(sx*(width/2+2),height/2,0),color,mat)
		P(m,"Block",V3(5,1.5,5),cf*CF(sx*(width/2+2),0.75,0),color:Lerp(rgb(0,0,0),0.3),mat)
		P(m,"Ball",V3(3,3,3),cf*CF(sx*(width/2+2),height+1.5,0),color:Lerp(rgb(255,255,255),0.3),"Neon")
	end
	local top=P(m,"Block",V3(width+8,5,3),cf*CF(0,height+2.5,0),color,mat,{Name="Header"})
	if label then K.signGui(top,Enum.NormalId.Front,label) K.signGui(top,Enum.NormalId.Back,label) end
	return m, cf
end
function K.bridge(parent,a,b,width,color,mat,rail)
	local m=K.model(parent,"Bridge")
	local mid=(a+b)/2 local len=(b-a).Magnitude local cf=CFrame.lookAt(mid,b)
	local n=math.floor(len/2.2)
	for i=0,n-1 do
		local t=(i+0.5)/n
		local arc=math.sin(t*math.pi)*1.5
		P(m,"Block",V3(width,0.6,2.0),cf*CF(0,arc,-len/2+t*len),color,mat)
	end
	if rail then for _,sx in ipairs({-1,1}) do
		for i=0,4 do local t=i/4 P(m,"Block",V3(0.5,3,0.5),cf*CF(sx*width/2,1.5+math.sin(t*math.pi)*1.5,-len/2+t*len),rail,mat) end
		P(m,"Block",V3(0.4,0.4,len),cf*CF(sx*width/2,3.4+0.75,0),rail,mat)
	end end
	return m
end
return K
