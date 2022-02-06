local FuncLib = {}
local RunService = game:GetService("RunService")

--Takes a given array and runs recursively through each element, copying each element to a newly created array. Returns the new array.
FuncLib.DeepCopy = function(array)
	local copy = {}
	for i, v in pairs(array) do
		local c = v
		if typeof(v) == "table" then
			c = FuncLib.DeepCopy(v)
		end
		copy[i] = c
	end
	return copy
end

FuncLib.Pause = function(dt)
	local start = os.clock()
	RunService.Heartbeat:Wait() --Wait at least one frame
	while os.clock() - start < (dt or 0) do
		RunService.Heartbeat:Wait()
	end
end

FuncLib.MergeTables = function(tables)
	local final = {}
	local memory = {}
	for i, array in pairs(tables) do
		for m, element in pairs(array) do
			if typeof(element) == "table" then
				for p, part in pairs(element) do
					
				end
				if memory[element] == nil then
					memory[element] = element
					--final[
				end
			end
		end
	end
end

FuncLib.SumElements = function(array)
	local sum = nil
	for i, v in pairs(array) do
		if sum == nil then
			sum = v
		else
			sum += v
		end
	end
	return sum
end

FuncLib.BinarySearch = function(array, toFind)
	local min = 0
	local max = #array
	local _guess
	local middle = math.ceil((min + max) / 2)
	for i = min, middle, 1 do
		
	end
	
	for i = middle + 1, max, 1 do
		
	end
	return nil
end

FuncLib.Normalize = function(Min, Max, Val)
	local Normal = (Val - Min) / (Max - Min)
	return Normal
end

FuncLib.Denormalize = function(Min, Max, Val)
	local Denormal = (Val * (Max - Min)) + Min
	return Denormal
end

FuncLib.TableNormalize = function(array)
	local min = 0
	local max = 0
	local normaled = {}
	for i, v in pairs(array) do --Traverse the given array
		if v < min then min = v elseif v > max then max = v end --Get min and max values in the array
	end
	
	for i, v in pairs(array) do --Traverse the array
		normaled[i] = FuncLib.Normalize(min, max, v) --Normalize the data
	end
end

FuncLib.CountElements = function(array)
	local count = 0
	for i, v in pairs(array) do
		count += 1
	end
	return count
end

return FuncLib
