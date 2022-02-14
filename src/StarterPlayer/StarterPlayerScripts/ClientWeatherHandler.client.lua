local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Singletons = ReplicatedStorage:WaitForChild("Singletons")
local Services = ReplicatedStorage:WaitForChild("Services")
local Weather = require(Singletons:WaitForChild("Weather"))
local Wind = require(Singletons:WaitForChild("Wind"))
local TagService = require(Services:WaitForChild("TagService"))
local RunService = game:GetService("RunService")
local localPlayer = game:GetService("Players").LocalPlayer
local PlayerScripts = localPlayer:WaitForChild("PlayerScripts")
local UI = PlayerScripts:WaitForChild("UI")
local ArrowButton = require(UI:WaitForChild("ArrowButton"))
local SetWeatherPreset = require(UI:WaitForChild("SetWeatherPreset"))
local FadeWeatherPresets = require(UI:WaitForChild("FadeWeatherPresets"))
local Classes = ReplicatedStorage:WaitForChild("Classes")
local m_AtmosphericParticleGrid = Classes:WaitForChild("AtmosphericParticleGrid")
--local AtmosphericParticleGrid = require(m_AtmosphericParticleGrid)
--local DefaultParticleLayers = require(m_AtmosphericParticleGrid:WaitForChild("DefaultParticleLayers"))

--local grid = AtmosphericParticleGrid.new(9, 15, 1, 50, DefaultParticleLayers)

--Weather:SetPreset("SnowstormDay")

local originCFrames = {}
local function storeGrassCFrame(grassObject)
    originCFrames[grassObject] = grassObject:GetPivot()
end

TagService.HookAddedSignal("WeatherPresetListener", function(element)
    element.FocusLost:Connect(function(enterPressed)
        if enterPressed == true then
            local presetName = element.Text
            Weather:SetPreset(presetName)
        end
    end)
end)

RunService.RenderStepped:Connect(function()
    for _, object in pairs(TagService.GetTagged("WavyGrass")) do
        for _, g in pairs(object:GetChildren()) do
            if (g.PrimaryPart.Position - workspace.CurrentCamera.CFrame.Position).Magnitude <= 20 then
                if originCFrames[g] == nil then 
                    storeGrassCFrame(g)
                end
                local x, y, z = Wind:GetGlobalWindAt(g:GetPivot())
                local disp = math.deg(Wind:GetViewDisplacement(g))
                disp -= 90
                disp *= .1
                disp = math.rad(disp)
    
                --g:PivotTo(originCFrames[g] * CFrame.Angles(disp, 0, disp) * CFrame.Angles((x / 100), (y / 100), (z / 100)))
                g:PivotTo(originCFrames[g] * CFrame.fromAxisAngle(workspace.CurrentCamera.CFrame.RightVector, disp) * CFrame.Angles((x / 80), (y / 80), (z / 80)))
            end
        end
    end
end)