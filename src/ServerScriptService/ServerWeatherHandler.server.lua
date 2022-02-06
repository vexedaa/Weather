local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Singletons = ReplicatedStorage:WaitForChild("Singletons")
local Weather = require(Singletons:WaitForChild("Weather"))

--Weather:SetFadedPreset("OvercastDay", "ClearSkiesNight", 0.75)