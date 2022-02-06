Perlin = {}
--Perlin.__index = Perlin
local Modules = script.Parent
local DIMM = require(Modules:WaitForChild("DIMM"))

--Returns a noise value with respect to 2-dimensional inputs (cross-section in the 3rd dimension, "seeded")
Perlin.Get2D = function(x, y, seed, amplitude, frequency)
	return math.noise(x / frequency, y / frequency, seed) * amplitude
end

--[[ fBm Section
		Given a number of iterations (octaves), intial amplitude, initial frequency, a frequency multiplier per iteration (lacunarity),
		an amplitude multiplier per iteration (persistence/gain), a seed, and a position x/y, use fractional Brownian motion
		to resolve the noise.
]]--

--Two-dimensional inplementation of fractional brownian motion

--One-dimensional fBm implementation
Perlin.fBm = function(x, y, octaves, amplitude, frequency, lacunarity, persistence, seed)
	local total = 0
	local amp = amplitude
	local freq = frequency
	local max = 0
	for o = 1, octaves do
		total += Perlin.Get2D(x, y, seed, amp, freq)
		freq *= lacunarity
		max += amp
		amp *= persistence
	end
	return total
end

--[[Domain warping implementation
		Using fBm calls, warp the domain such that f(p) becomes f(p + h(p)).
		In other words, domain warp the typical noise function by utilizing fBm as the h(p) warping function in 2 dimensions.
]]--

Perlin.fBmDomainWarp = function(x, y, octaves, amplitude, frequency, lacunarity, persistence, seed)
	--Domain warp #1
	local q = Vector2.new(
		Perlin.fBm(x, y, octaves, amplitude, frequency, lacunarity, persistence, seed),
		Perlin.fBm(x+5.2, y+1.3, octaves, amplitude, frequency, lacunarity, persistence, seed)
	)
	--Domain warp #2
	local r = Vector2.new(
		Perlin.fBm(x+(20 * q.X) + 1.7, y + (20 * q.Y) + 941.2, octaves, amplitude, frequency, lacunarity, persistence, seed),
		Perlin.fBm(x+(9 * q.X) + 80.3, y + (8 * q.Y) + 2.8, octaves, amplitude, frequency, lacunarity, persistence, seed)
	)
	--Return the fBm of the domain warped noise
	return Perlin.fBm(x + (6.25 * (r.X)), y + (6.25 * (r.Y)), octaves, amplitude, frequency, lacunarity, persistence, seed), q, r
end



--[[function Perlin.New(seed, size, resolution, frequency, amplitude, octaves, lacunarity, persistence)
	local self = setmetatable(DIMM.new(), Perlin)
	for x = 0, size, resolution do
		for y = 0, size, resolution do

		end
	end
	return self
end

function Perlin:GenerateBiomes()

end]]--

return Perlin
