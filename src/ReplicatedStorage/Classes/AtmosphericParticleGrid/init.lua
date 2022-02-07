local TweenService = game:GetService("TweenService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local AtmosphericParticleGrid = {}
AtmosphericParticleGrid.__index = AtmosphericParticleGrid
local camera = workspace.CurrentCamera

function AtmosphericParticleGrid.new(gridSize, cellSize, verticalSize, centerHeight, particleLayers)
    local self = {
        _GridSize = gridSize;
        _CellSize = cellSize;
        _VerticalSize = verticalSize;
        _CenterHeight = centerHeight;
        _ParticleLayers = particleLayers or require(script:WaitForChild("DefaultParticleLayers"));
        _Grid = nil;
        _GridLayers = {};
        _Running = true;
    }
    setmetatable(self, AtmosphericParticleGrid)
    self:_Initialize()
    if particleLayers then
        self:LayerParticles(particleLayers)
        self:Run()
    end
    return self
end

function AtmosphericParticleGrid:_Initialize()
    local grid = self:GenerateGrid()
    self._Grid = grid
end

function AtmosphericParticleGrid:Run()
    self._Running = true
    self._Grid.Parent = camera
    game:GetService("RunService").RenderStepped:Connect(function()
        if self._Grid == nil or self.Running == false then
            return
        end
		-- local x, y, z = camera.CFrame:ToEulerAnglesXYZ()
        self._Grid:PivotTo(CFrame.new(camera.CFrame.Position.X, camera.CFrame.Position.Y, camera.CFrame.Position.Z) * CFrame.new(0, self._CenterHeight, 0))-- * CFrame.Angles(0, y, 0))
    end)
end

function AtmosphericParticleGrid:Stop()
    self._Running = false
    self._Grid.Parent = ReplicatedStorage
end

function AtmosphericParticleGrid:LayerParticles(particleLayers)
    local gridLayers = self._GridLayers
    for layer, particleConfigs in pairs(particleLayers) do
        for _, particleConfig in pairs(particleConfigs) do
            local getLayerParticleSources = gridLayers[layer]
            if getLayerParticleSources then
                for _, particleSource in pairs(getLayerParticleSources) do
                    local particleEmitter = Instance.new("ParticleEmitter");
                    for property, value in pairs(particleConfig) do
                        particleEmitter[property] = value
                    end
                    particleEmitter.Parent = particleSource;
                end
            end
        end
    end
end

function AtmosphericParticleGrid:GetGrid()
    return self._Grid
end

function AtmosphericParticleGrid:GenerateGrid()
    local model = Instance.new("Model")
    for y = 1, self._VerticalSize, 1 do
        self._GridLayers[y] = {}
        for x = 1, self._GridSize, 1 do
            for z = 1, self._GridSize, 1 do
                local p = Instance.new("Part")
                p.Size = Vector3.new(self._CellSize, self._CellSize, self._CellSize)
                p.Position = Vector3.new(x * self._CellSize, y * self._CellSize, z * self._CellSize)
                p.Anchored = true
                p.Transparency = 1
                p.CanCollide = false
                p.CastShadow = false;

                --For debugging purposes:
                --p.Transparency = .7

                p.Parent = model
                if y == math.ceil(self._VerticalSize / 2) and x == math.ceil(self._GridSize / 2) and z == math.ceil(self._GridSize / 2) then
                    model.PrimaryPart = p
                end
                table.insert(self._GridLayers[y], p)
            end
        end
    end
    self._Grid = model
    return model
end

function AtmosphericParticleGrid:Decimate(fade)
    if self:GetGrid() then
        for i, emitter in pairs(self:GetGrid():GetDescendants()) do
            if emitter:IsA("ParticleEmitter") then
                emitter.LockedToPart = false
                if fade then
                    local numberValue = Instance.new("NumberValue")
                    numberValue.Value = emitter.Transparency.Keypoints[1]
                    local tween = TweenService:Create(numberValue, fade, {Value = 1})
                    numberValue.Changed:Connect(function()
                        if emitter then
                            emitter.Transparency = NumberSequence.new(numberValue.Value)
                        end
                    end)
                    tween:Play()
                    game:GetService("Debris"):AddItem(emitter, fade.Time)
                    game:GetService("Debris"):AddItem(numberValue, fade.Time)
                end
            end
        end
        task.spawn(function()
            local waitTime = 0
            if fade then
                waitTime = fade.Time
            end
            task.wait(waitTime)
            self:GetGrid():Destroy()
            self = nil
        end)
    end
    self._Running = false
    self._GridLayers = nil
end

return AtmosphericParticleGrid