local Waves = {}
Waves.__index = Waves

function Waves.new(parent)
	local self = setmetatable({
		Parent = parent; --Referring to the Water object container
		Region = nil;
		Attributor = nil;
		Name = nil;
		Attributes = {
			InitialPosition = Vector2.new(5, 5);
			--Position = Vector2.new();
			InitialVelocity = Vector2.new(4, 4);
			Direction = 45; --Degrees
			Intensity = 1.5;
			Amplitude = 15;
			Speed = 120;
			TimeOffset = 0;
			Wavelength = 5;
			Steepness = 0.5;
		};
	}, Waves)
	return self
end

function Waves:GetWavelength() --Returns wavelength based on frequency
	return ((2 * math.pi()) / self.Attributes.Frequency)
end

-- Assigns the wave to a Region
-- @param region Region associated with the wave
function Waves:SetRegion(region)
	self.Region = region
end

function Waves:GetRegion()
	return self.Region
end

function Waves:GetPhaseConstant() --Returns phase constant based on wavelength
	return (self.Attributor:GetAttribute("Frequency") * self.Attributor:GetAttribute("Speed"))
end

function Waves:GetHeight(position)
	local t = os.clock() --Note: Should use synchronized clock eventually
	local height = self.Attributes.Amplitude * math.sin((self.Attributes.InitialDirection:Dot(position - self.Attributes.InitialPosition) * self.Attributes.Frequency) + (t * self:GetPhaseConstant()))
end

function Waves:SetAttributor(attributor)
	self.Attributor = attributor
	self.Name = attributor.Name
	local function attributeChange()
		for i, v in pairs(self.Attributes) do
			local attribute = attributor:GetAttribute(i)
			if attribute then
				self.Attributes[i] = v
			end
		end
	end
	attributeChange()
	attributor.AttributeChanged:Connect(attributeChange)
end

return Waves
