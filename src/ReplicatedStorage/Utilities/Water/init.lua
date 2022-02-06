local Water = {}
Water.__index = Water

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Package = ReplicatedStorage:WaitForChild("Package")
local Modules = Package:WaitForChild("Modules")
local CamTools = require(Modules:WaitForChild("CamTools"))
local DIMM = require(Modules:WaitForChild("DIMM"))
local FuncLib = require(Modules:WaitForChild("FuncLib"))
local Waves = require(script:WaitForChild("Waves"))

local RunService = game:GetService("RunService")
local camera = workspace.CurrentCamera

local WaterBodies = {}

function Water.new()
	--assert(("")) --Use to require certain inputs later on
	local self = setmetatable({
		WindDirection = Vector2.new();
		Position = Vector3.new();
		RenderRadius = 5000; --Water render radius in studs
		TileSize = 50; --Size of individual water tiles
		Waves = {};
		Geometry = {};
		Bones = {};
		WeatherConditions = nil; --I haven't yet determined how I want to approach this can of worms
		CullInterrupt = false;
		CachedPositions = {};
		WaterLevel = 0;
	}, Water)
	table.insert(WaterBodies, self)
	return self
end

function Water.GetWaterFromGeometry(geometry)
	for i, water in pairs(WaterBodies) do
		if water.Geometry[geometry] then
			return water
		end
	end
end

function Water:GetWaveCount()
	local count = 0
	for i, v in pairs(self.Waves) do
		count += 1
	end
	return count
end

--[[	Water:Simulation() description
		INPUT: None.
		
		//SECTION 1: Water height
		Step #1.1: For each step in the simulation loop, call Water:Cull() to get a table of culled elements and get the update rate of each bone.
		Step #1.2: Iterate through all bone elements, check if the bone is culled. If it is not culled, perform Step 3 for this bone.
		Step #1.3: If the bone is not culled, determine if the bone is able to be rendered at the current frame. If so, proceed to Step 4 for this bone.
		Step #1.4: If the bone is to be rendered, perform the Gerstner wave calculations to determine the height at the given WORLD POSITION. Then, adjust the Y position the bone.
		
		//Section 2: Collision detection
		Step #2.1: TBD
		
]]--

--Gets the summed wave height at the given position
--@param pos Vector2 position to sample the wave height.
function Water:GetWaveDataAt(pos)
	local height = 0
	local bPos2D = pos
	local xOffset, yOffset = 0, 0
	local BX, BY, BZ = 0, 0, 0
	local TX, TY, TZ = 0, 0, 0
	for w, wave in pairs(self.Waves) do
		local influence = 1
		if wave:GetRegion() ~= nil then
			influence = wave:GetRegion():SampleInfluence(bPos2D)
		end
		local t = (os.clock() + wave.Attributor:GetAttribute("TimeOffset")) --* wave.Attributor:GetAttribute("Rate")
		local amp = wave.Attributor:GetAttribute("Amplitude")
		local speed = wave.Attributor:GetAttribute("Speed")
		local wavelength = wave.Attributor:GetAttribute("Wavelength")
		local freq = 2 / wavelength
		local p = speed * freq
		local steep = wave.Attributor:GetAttribute("Steepness")
		local steepness = steep / (freq * amp * self:GetWaveCount())
		local WA = freq * amp
		--steepness = 1/(wave.Attributor:GetAttribute("Frequency") * wave.Attributor:GetAttribute("Amplitude"))
		--local direction = (bPos2D - wave.Attributor:GetAttribute("InitialPosition).Unit
		local angle = math.rad(wave.Attributor:GetAttribute("Direction"))
		local direction = Vector2.new(math.cos(angle), math.sin(angle))

		local S0 = math.sin(freq * ((direction):Dot(bPos2D)) + (p * t))
		local C0 = math.cos(freq * ((direction):Dot(bPos2D)) + (p * t))

		--local direction = (bPos2D - wave.Attributor:GetAttribute("InitialPosition")) / (bPos2D - wave.Attributor:GetAttribute("InitialPosition")).Magnitude

		local x = steepness * amp * direction.X * math.cos((freq * direction):Dot(bPos2D) + p * t) * influence
		local y = steepness * amp * direction.Y * math.cos((freq * direction):Dot(bPos2D) + p * t) * influence
		local z = amp * math.sin((freq * direction):Dot(bPos2D) + p * t) * influence

		--Calculate binormal
		BX += steepness * (direction.X^2) * WA * S0
		BY += steepness * direction.X * direction.Y * WA * S0
		BZ += direction.X * WA * C0

		--Calculate tangent (Derivative of Y)
		TX = steepness * direction.X * direction.Y * WA * S0
		TY = steepness * (direction.Y^2) * WA * S0
		TZ = direction.Y * WA * C0

		xOffset += x
		yOffset += y

		height += z

		
		
	end
	
	local binormal = Vector3.new(1 - BX, BZ, -BY)
	local tangent = Vector3.new(-TX, TZ, 1 - TY)
	local normal = tangent:Cross(binormal)
	
	return {
		Offset = Vector3.new(xOffset, height, yOffset);
		Binormal = binormal;
		Tangent = tangent;
		Normal = normal;
	}
end

function Water:Simulation()
	--Cache initial positions of each vertex
	local vertexPositions = self:CacheInitialPosition()
	
	--[[camera.Changed:Connect(function()
		self.CullInterrupt = true
		self.Bones = self:Cull(camera)
	end)]]--
	local lastX = 0
	local lastY = 0
	self.Bones = self:GetBones()
	
	local model = nil
	for i, v in pairs(self.Geometry) do
		model = v.Parent
	end
	
	for i, v in pairs(self) do
		if typeof(v) ~= "table" then
			model:SetAttribute(i, v)
		end
	end
	
	for i, wave in pairs(self.Waves) do
		local WaveConfig = Instance.new("Configuration")
		WaveConfig.Parent = model
		WaveConfig.Name = "Wave"..i
		for a, attribute in pairs(wave.Attributes) do
			WaveConfig:SetAttribute(a, attribute)
		end
		wave:SetAttributor(WaveConfig)
	end
	
	local simulation_thread = coroutine.wrap(function()
		--[[local t = os.clock()
		local totalDT = 0
		local avgDT = 0
		local iterations = 0]]--
		while true do
			--local bones = self:Cull(cam)
			--self.Bones = self:Cull(camera)
			for i, bone in pairs(self.Bones) do
				
				
				--bone.Position = Vector3.new(vertexPositions[bone].X + xOffset, height, vertexPositions[bone].Y + yOffset)
				--local pointer = Vector3.new(xOffset, yOffset, )
				
				local waveSample = self:GetWaveDataAt(Vector2.new(bone.WorldPosition.X, bone.WorldPosition.Z))
				--print(waveSample.Offset.Y)
				local absolute = Vector3.new(vertexPositions[bone].X + waveSample.Offset.X, waveSample.Offset.Y, vertexPositions[bone].Y + waveSample.Offset.Z)
				--local absolute = Vector3.new(vertexPositions[bone].X + xOffset, height, vertexPositions[bone].Y + yOffset)
				bone.CFrame = CFrame.fromMatrix(absolute, waveSample.Binormal, waveSample.Normal, waveSample.Tangent)
				--bone.CFrame = CFrame.new(absolute)
			end
			RunService.Heartbeat:Wait()
			--[[local dt = os.clock() - t
			t = os.clock()
			totalDT += dt
			iterations += 1
			avgDT = totalDT / iterations
			print(avgDT)]]--
		end
	end)
	simulation_thread()
end

--[[	Water:Cull() description
		INPUT: Camera object
		Step #1: Mark bones as culled or not culled based on camera position and view.
		Step #2: If not culled, return a "render rate" from 0 to 1 (0 being completely skipped, 1 being rendered every frame).
		OUTPUT: Generate a table whose elements are true or false. Their indexes match and correspond to the indexes of each element in the bone lookup table.
]]--

function Water:Cull()
	local bones = {}
	for i, plane in pairs(self.Geometry) do --For each tile in Geometry,
		--RunService.Heartbeat:Wait()
		for c, bone in pairs(plane:GetChildren()) do --For each instance in a tile,
			--[[if self.CullInterrupt == true then
				self.CullInterrupt = false
				return bones
			end]]--
			if bone:IsA("Bone") then --If instance is a bone, continue
				local boneCF = CFrame.new(bone.WorldPosition)
				local onScreen = CamTools.InFrustum(camera, boneCF, Vector3.new(0, 0, 0))
				local culled = (onScreen == false) or ((bone.WorldPosition - camera.CFrame.Position).Magnitude > self.RenderRadius)
				if culled == false then
					table.insert(bones, bone)
				end
			end
		end
	end
	return bones
end

function Water:GetBones()
	local bones = {}
	for i, plane in pairs(self.Geometry) do --For each tile in Geometry,
		for c, bone in pairs(plane:GetChildren()) do --For each instance in a tile,
			if bone:IsA("Bone") then --If instance is a bone, continue
				table.insert(bones, bone)
			end
		end
	end
	return bones
end

function Water:CacheInitialPosition()
	if FuncLib.CountElements(self.CachedPositions) == 0 then
		local cache = {}
		for i, v in pairs(self.Geometry) do
			for c, b in pairs(v:GetChildren()) do
				if b:IsA("Bone") then
					cache[b] = Vector2.new(b.Position.X, b.Position.Z)
					self.WaterLevel = b.WorldPosition.Y
				end
			end
		end
		self.CachedPositions = cache
	end
	return self.CachedPositions
end

return Water
