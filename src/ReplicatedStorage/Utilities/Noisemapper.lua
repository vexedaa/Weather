Noisemapper = {}
local Modules = script.Parent
local DIMM = require(Modules:WaitForChild("DIMM"))
local Perlin = require(Modules:WaitForChild("Perlin"))
local FuncLib = require(Modules:WaitForChild("FuncLib"))
local StarterGui = game:GetService("StarterGui")
local RunService = game:GetService("RunService")
local pause = false
local TweenService = game:GetService("TweenService")
local Colors = require(Modules:WaitForChild("Colors"))

--Auto-seed randomize solution?

--[[ Noisemap generator
		Takes a noise function and applies it to a position X and Y.
		Arguments: Noise function and any required inputs ordered correctly in a table, map size, and map resolution
		Possible inputs: seed, size, resolution, frequency, amplitude, octaves, lacunarity, persistence

]]--

function Noisemapper.new(noiseFunction, inputs, size, resolution, start)
	local map = {
		Map = DIMM.new();
		Min = 0;
		Max = 0;
		MinQ = 0;
		MaxQ = 0;
		MinR = 0;
		MaxR = 0;
		
		Inputs = inputs
	}
	
	
	for x = start.X, start.X + size, resolution do
		RunService.Heartbeat:Wait()
		----print("run forrest run")
		for y = start.Y, start.Y + size, resolution do
			local val, q, r = noiseFunction(x, y, table.unpack(inputs))
			if val > map.Max then map.Max = val elseif val < map.Min then map.Min = val end
			map.Map[x][y].Noise = val
			if q ~= nil and r ~= nil then
				if q.Magnitude > map.MaxQ then map.MaxQ = q.Magnitude elseif q.Magnitude < map.MinQ then map.MinQ = q.Magnitude end
				if r.Y > map.MaxR then map.MaxR = r.Y elseif r.Y < map.MinR then map.MinR = r.Y end
				map.Map[x][y].Q = q.Magnitude
				map.Map[x][y].R = r.Y
			end
		end
	end
	return map
end

--[[	Given a skinned mesh, return a size which is the square root of the number of bones, determine a starting X and Y,
		and determine the common interval (lowest difference X and Y), which should be equal in both axes as it is assumed that the mesh is a perfect square containing equidistant bones.
]]--

function Noisemapper.GetSkinnedMeshParameters(mesh) 
	local NoisemapParams = {}
	--local size = math.sqrt(#mesh:GetChildren())
	local size = 0
	local sx, sy = 0, 0
	local resolution = 1
	local boneCache = DIMM.new()
	for i, bone in pairs(mesh:GetChildren()) do
		if bone:IsA("Bone") then
			bone.Position = Vector3.new(math.floor(bone.Position.X), 0, math.floor(bone.Position.Z)) --Make bone positions whole numbers (consequentially perfectly aligns bones along their axes)
			size += 1
			boneCache[math.floor(bone.Position.X)][math.floor(bone.Position.Z)] = bone
			if bone.Position.X < sx then sx = bone.Position.X end
			if bone.Position.Z < sy then sy = bone.Position.Z end
			for c, compare in pairs(mesh:GetChildren()) do
				if compare:IsA("Bone") then
					local diff = math.abs(math.floor(compare.Position.X) - bone.Position.X)
					if compare ~= bone and diff ~= 0 then
						if diff < resolution then resolution = diff end
					end
				end
			end
		end
	end
	
	size = math.sqrt(size)
	local start = Vector2.new(sx, sy)
	NoisemapParams.Size = size
	NoisemapParams.Start = start
	NoisemapParams.Resolution = resolution
	NoisemapParams.BoneCache = boneCache
	--print("Start",start,"Resolution",resolution,"Size",size)
	return NoisemapParams
end

--[[ Noisemap visualizer section
		Draw2D: Given a noisemap, draw a 2D black and white representation of the noise data,
		where height is normalized between 0 and 1 and the resulting number is used to determine the shade
		from black (0) to white (1).
]]--

RunService.Heartbeat:Connect(function(dt)
	if dt > 2 then
		pause = true
	end
end)

Noisemapper.Draw2D = function(map, size, resolution, printSize)
	--Setup
	local gridLayout = Instance.new("UIGridLayout")
	gridLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
	gridLayout.VerticalAlignment = Enum.VerticalAlignment.Center
	local aspect = Instance.new("UIAspectRatioConstraint")
	aspect.Parent = gridLayout
	gridLayout.CellSize = UDim2.new(printSize, 0, printSize, 0)
	local screen = Instance.new("ScreenGui")
	local holder = Instance.new("Frame")
	holder.Size = UDim2.new(1, 0, 1, 0)
	holder.BackgroundTransparency = 1
	local container = Instance.new("Frame")
	container.BackgroundTransparency = 1
	container.Size = UDim2.new(1, 0, 1, 0)
	holder.Parent = screen
	gridLayout.Parent = holder
	screen.Parent = StarterGui
	container.Parent = holder
	
	for x = 0, size, resolution do
		RunService.Heartbeat:Wait()
		for y = 0, size, resolution do
			local val = map.Map[x][y].Noise
			local color = FuncLib.Normalize(map.Min, map.Max, val)
			local qComp, rComp
			if map.MinQ == 0 and map.MaxQ == 0 and map.MinR == 0 and map.MaxR == 0 then
				qComp = color
				rComp = color
			else
				qComp = FuncLib.Normalize(map.MinQ, map.MaxQ, map.Map[x][y].Q)
				rComp = FuncLib.Normalize(map.MinR, map.MaxR, map.Map[x][y].R)
			end
			local pixel = Instance.new("Frame"); pixel.BackgroundColor3 = Color3.new(color, color,color)
			--pixel.BackgroundColor3 = Color3.new(color, color, color)
			pixel.BorderSizePixel = 0
			pixel.Size = UDim2.new(resolution / size, 0, resolution / size, 0)
			pixel.Position = UDim2.new(x / size, 0, y / size, 0)
			pixel.Parent = container
			----print((x*y / ((size/resolution)^2)) / 100, "% rendered")
		end
	end
end

Noisemapper.DrawParts = function(map, size, resolution, origin, stretch)
	local extend = stretch or Vector3.new(1, 1, 1)
	local cache = DIMM.new()
	local model = Instance.new("Model")
	for x = 0, size, resolution do
		RunService.Heartbeat:Wait()
		for y = 0, size, resolution do
			local p = Instance.new("Part")
			p.CastShadow = false
			p.Material = Enum.Material.SmoothPlastic
			p.TopSurface = Enum.SurfaceType.Smooth
			p.BottomSurface = Enum.SurfaceType.Smooth
			local val = map.Map[x][y].Noise
			local color = FuncLib.Normalize(map.Min, map.Max, val)
			local qComp = FuncLib.Normalize(map.MinQ, map.MaxQ, map.Map[x][y].Q)
			local rComp = FuncLib.Normalize(map.MinR, map.MaxR, map.Map[x][y].R)
			
			--Take an initial color
			local initialColor = Color3.new(rComp or color, color, ((qComp + rComp) - 1)/2 or color)

			--And blend it into a final color
			local finalColor = Color3.new(0.180392, 0.592157, 0.905882)
			local interpolated = Colors.Lerp(initialColor, finalColor, 0.6) --Randomize the alpha?
			p.Color = interpolated
			
			p.Anchored = true
			p.Position = (origin + Vector3.new(x * extend.X, val * extend.Y, y * extend.Z))
			p.Size = Vector3.new(resolution * extend.X, extend.Y * (resolution / 2), resolution * extend.Z)
			p.Parent = model
			cache[x][y] = p
		end
	end
	model.Parent = workspace
	return cache
end

Noisemapper.DrawMesh = function(mesh, inputs)
	local cache = DIMM.new()
	--local model = Instance.new("Model")
	for i, bone in pairs(mesh:GetChildren()) do
		if bone:IsA("Bone") then
			local x = math.floor(bone.Position.X)
			local y = math.floor(bone.Position.Z)
			cache[x][y] = bone
			bone.Position = Vector3.new(x, Perlin.fBmDomainWarp(x, y, table.unpack(inputs)), y)
		end
	end
	
	--[[for x = start.X, start.X + size, resolution do
		RunService.Heartbeat:Wait()
		for y = start.Y, start.Y + size, resolution do
			local p = boneCache[x][y]
			print(p)
			local val = map.Map[x][y].Noise
			local color = FuncLib.Normalize(map.Min, map.Max, val)
			local qComp = FuncLib.Normalize(map.MinQ, map.MaxQ, map.Map[x][y].Q)
			local rComp = FuncLib.Normalize(map.MinR, map.MaxR, map.Map[x][y].R)

			--Take an initial color
			local initialColor = Color3.new(rComp or color, color, ((qComp + rComp) - 1)/2 or color)

			--And blend it into a final color
			local finalColor = Color3.new(0.180392, 0.592157, 0.905882)
			local interpolated = Colors.Lerp(initialColor, finalColor, 0.6) --Randomize the alpha?
			p.Color = interpolated

			p.Anchored = true
			p.Position = (origin + Vector3.new(x * extend.X, val * extend.Y, y * extend.Z))
			p.Size = Vector3.new(resolution * extend.X, extend.Y * (resolution / 2), resolution * extend.Z)
			p.Parent = model
			p.Position = Vector3.new(x, map.Map[x][y].Noise, y)
		end
	end]]--
	return cache
	--model.Parent = workspace
end

Noisemapper.AnimateMesh = function(mesh, octaves, amplitude, frequency, lacunarity, persistence, seed)
	local Seed = seed
	local noiseOffset = 0
	local noiseAvg = 0
	local noiseSum = 0
	local count = 0
	local animateThread = coroutine.wrap(function()
		while true do
			RunService.Heartbeat:Wait()
			Seed += .004
			noiseOffset += 4
			--print(noiseAvg)
			for i, bone in pairs(mesh:GetChildren()) do
				if bone:IsA("Bone") then
					count += 1
					local x = math.floor(bone.Position.X)
					local y = math.floor(bone.Position.Z)
					local noise = Perlin.fBm(x + noiseOffset, y + noiseOffset, octaves, amplitude, frequency, lacunarity, persistence, Seed)
					noiseSum += noise
					bone.Position = Vector3.new(x, noise , y)
				end
			end
			noiseAvg = noiseSum / count
		end
	end)
	animateThread()
end

Noisemapper.DrawTerrain = function(map, size, resolution, material)
	for x = 0, size, resolution do
		RunService.Heartbeat:Wait()
		for y = 0, size, resolution do
			local position = Vector3.new(x, map.Map[x][y].Noise, y)
			workspace.Terrain:FillBall(position, 8, material)
			workspace.Terrain:FillBlock(CFrame.new(position), Vector3.new(resolution, resolution, resolution), material)
		end
	end
	--workspace.Terrain:FillCylinder(CFrame.new(position), Increment, Increment, material)
	--workspace.Terrain:FillWedge(CFrame.new(position), Vector3.new(Increment, Increment,Increment), material)
end

Noisemapper.AnimateParts = function(map, partMap, size, resolution, origin, stretch, seed)
	local extend = stretch or Vector3.new(1, 1, 1)
	local Seed = seed
	local inputs = map.Inputs
	local minq, maxq, minr, maxr, minval, maxval = map.MinQ, map.MaxQ, map.MinR, map.MaxR, map.Min, map.Max
	--local waveInfo = TweenInfo.new(0.1, Enum.EasingStyle.Linear, Enum.EasingDirection.Out, 0, false, 0)
	local noiseOffset = 0
	local animationThread = coroutine.wrap(function()
		while true do
			Seed += .04
			noiseOffset += 14
			inputs[#inputs] = Seed
			--print(inputs[#inputs])
			for x = 0, size, resolution do
				for y = 0, size, resolution do
					local noiseSample, q, r = Perlin.fBmDomainWarp(x + noiseOffset, y, table.unpack(inputs))
					if noiseSample > map.Max then map.Max = noiseSample elseif noiseSample < map.Min then map.Min = noiseSample end
					if q.Magnitude > map.MaxQ then map.MaxQ = q.Magnitude elseif q.Magnitude < map.MinQ then map.MinQ = q.Magnitude end
					if r.Y > map.MaxR then map.MaxR = r.Y elseif r.Y < map.MinR then map.MinR = r.Y end
					local color = FuncLib.Normalize(map.Min, map.Max, noiseSample)
					local qComp = FuncLib.Normalize(map.MinQ, map.MaxQ, q.Magnitude)
					local rComp = FuncLib.Normalize(map.MinR, map.MaxR, r.Y)
					--local posTween =TweenService:Create(partMap[x][y], waveInfo, {Position = (origin + Vector3.new(x * extend.X, noiseSample * extend.Y, y * extend.Z))})
					--posTween:Play()
					local p = partMap[x][y]
					p.Position = (origin + Vector3.new(x * extend.X, noiseSample * extend.Y, y * extend.Z))
					
					--Take an initial color
					local initialColor = Color3.new(rComp or color, color, ((qComp + rComp) - 1)/2 or color)
					
					--And blend it into a final color
					local finalColor = Color3.new(0.180392, 0.592157, 0.905882)
					
					local interpolated = Colors.Lerp(initialColor, finalColor, 0.7) --Randomize the alpha?
					
					p.Color = interpolated
				end
			end
			FuncLib.Pause()
		end
	end)
	animationThread()
end

return Noisemapper
