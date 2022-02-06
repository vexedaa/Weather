local TagService = {}
TagService.GameService = game:GetService("CollectionService")


TagService.GetTagged = function(tag) --Returns all the instances that have a tag, as well as the signal listeners.
	return TagService.GameService:GetTagged(tag)
end

TagService.GetTaggedDescendantOf = function(object, tag) --Returns all the instances of a given tag who are descendants of the given instance.
	local taggedDescendants = {}
	for i, v in pairs(object:GetDescendants()) do
		if TagService.HasTag(v, tag) then
			table.insert(taggedDescendants, v)
		end
	end
	return taggedDescendants
end

TagService.GetFirstTagged = function(tag) --Returns the first instance with a tag in a table of instances with that tag
	return TagService.GetTagged(tag)[1]
end

TagService.ConnectEventToFunction = function(tag, events, func)
	
end

TagService.GetSharedTagged = function(tags) --Returns all the instances that share n tags
	local target = #tags
	local storage = {}
	for i, tag in pairs(tags) do --Get all objects with each tag
		local list = TagService.GetTagged(tag)
		storage[tag] = list
	end

	local objects = {}

	for i, tag in pairs(storage) do --Unpack the objects contained within storage 
		for b, object in pairs(tag) do
			if objects[object] == nil then --If the object is not stored yet,
				objects[object] = object --Put the object inside the tracked objects table
			end
		end
	end

	local result = {}

	for i, object in pairs(objects) do --For every object in the tracked objects table,
		local total = 0
		for b, tag in pairs(tags) do
			if TagService.HasTag(object, tag) == true then --If the object has a given tag, add 1 to the total
				total += 1
			end
		end
		if total == target then --If the total is equal to the target # of tags, insert it into the results table
			table.insert(result, object)
		end
	end

	return result --Return the result

end

TagService.AddTag = function(object, tag)
	TagService.GameService:AddTag(object, tag)
end

TagService.RemoveTag = function(object, tag)
	TagService.GameService:RemoveTag	(object, tag)
end

TagService.ReadTags = function(object) --Returns a table of tags applied to a given object
	return TagService.GameService:GetTags(object)
end

TagService.HasTag = function(object, tag) --Returns whether or not a given object has a particular tag
	return TagService.GameService:HasTag(object, tag)
end

TagService.AddedSignal = function(tag) --Returns the RBXScriptSignal that indicates when a new object is assigned a particular tag
	return TagService.GameService:GetInstanceAddedSignal(tag)
end

TagService.RemovedSignal = function(tag) --Returns the RBXScriptSignal that indicates when a tag is revoked from an object
	return TagService.GameService:GetInstanceRemovedSignal(tag)
end

--Hook functionality 
TagService.HookAddedSignal = function(tag, hook)
	for i, v in pairs(TagService.GetTagged(tag)) do
		hook(v)
	end
	return TagService.AddedSignal(tag):Connect(hook)
end

TagService.HookRemovedSignal = function(tag, hook)
	for i, v in pairs(TagService.GetTagged(tag)) do
		hook(v)
	end
	return TagService.RemovedSignal(tag):Connect(hook)
end

return TagService
