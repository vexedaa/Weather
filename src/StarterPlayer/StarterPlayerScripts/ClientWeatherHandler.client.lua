local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Singletons = ReplicatedStorage:WaitForChild("Singletons")
local Services = ReplicatedStorage:WaitForChild("Services")
local Weather = require(Singletons:WaitForChild("Weather"))
local TagService = require(Services:WaitForChild("TagService"))
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

TagService.HookAddedSignal("WeatherPresetListener", function(element)
    element.FocusLost:Connect(function(enterPressed)
        if enterPressed == true then
            local presetName = element.Text
            Weather:SetPreset(presetName)
        end
    end)
end)