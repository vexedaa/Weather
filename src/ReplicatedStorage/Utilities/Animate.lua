local Animate = {}
local RunService = game:GetService("RunService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

--Modules
--local Modules = ReplicatedStorage:WaitForChild("Modules")
local Debris = game:GetService("Debris")

Animate.GlobalCache = {}

Animate.PlayTrack = function(track)
	local weighted, faded = track.Weight, track.Fade
	local duration = track.Duration
	local speed
	
	if duration and duration > 0 then
		repeat RunService.Heartbeat:Wait() until track.Track.Length ~= 0 --Wait until the track has loaded.
		speed = track.Track.Length / duration
	else
		speed = track.Track.Length
	end
	
	track.Track:Play(faded, weighted, speed)
	return track
end

Animate.CreateAndPlayTrack = function(model, animation, propertiesToSet, weight, fade, duration, removeOnStop, cache)
	local track = Animate.CreateTrack(model, animation, propertiesToSet, weight, fade, duration, removeOnStop, cache)
	Animate.PlayTrack(track)
	return track
end

Animate.CreateTrack = function(model, animation, propertiesToSet, weight, fade, duration, removeOnStop, cache)
	local Controller = model:FindFirstChild("AnimationController")
	local pickCache = cache or Animate.GlobalCache
	if not Controller then
		Controller = model:FindFirstChild("Humanoid")
	end
	--local findTrack = Animate.GetTrack(model, animation)
	local track
	--if findTrack == nil then
		track = Controller:LoadAnimation(animation)
	--else
		--track = findTrack
	--end
	
	
	for index, value in pairs(propertiesToSet or {}) do
		pcall(function()
			track[index] = value
		end)
	end
	
	local connection
	if removeOnStop == true then
		connection = track.Stopped:Connect(function()
			connection:Disconnect()
			if track then
				pickCache[track] = nil
				track:Destroy()
			end
		end)
	end
	
	
	
	local toReturn = {Track = track; Connection = connection; Weight = weight or 1; Fade = fade or 0; Duration = duration or 0;}
	
	pickCache[track] = toReturn
	
	return toReturn
end


Animate.GetTrack = function(model, animation)
	--print(model)
	local Controller = model:FindFirstChild("AnimationController")
	if not Controller then
		Controller = model:FindFirstChild("Humanoid")
	end
	if Controller then
		local tracks = Controller:GetPlayingAnimationTracks()
		for _, track in pairs(tracks) do
			if track.Animation == animation then
				return track
			end
		end
	end
end

Animate.Stop = function(model, animation, pause, fade)
	local faded
	if fade then
		faded = fade
	else
		faded = .05
	end
	local track = Animate.GetTrack(model, animation)
	Animate.StopTrack(track, fade, pause)
end

Animate.StopTrack = function(track, fade, pause)
	if track and track.Animation then
		if pause == true then
			track:AdjustSpeed(0)
		else
			track:Stop(fade)
			Debris:AddItem(track, fade)
		end
	end
end

Animate.WeightFade = function(model, animation, targetWeight, fadeTime)
	local track = Animate.GetTrack(model, animation)
	if track then
		track:AdjustWeight(targetWeight, fadeTime)
	end
end

return Animate
