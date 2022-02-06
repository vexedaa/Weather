local CamTools = {}
local Modules = script.Parent
local VectorMath = require(Modules:WaitForChild("VectorMath"))

--SIMPLIFIED frustum view implementation using WorldToScreenPoint

CamTools.InFrustum = function(camera, objCF, objSize)
	local corners = VectorMath.Corners(objCF, objSize + Vector3.new(40, 40, 40))
	for i, corner in pairs(corners) do
		local screenSpacePos, inView = camera:WorldToViewportPoint(corner)
		if inView == true then return true end
	end
	return false
end

--[[CamTools.InFrustum = function(camera, interestPosition, interestSize) --Given a camera instance and the position and size of a particular interest, determine if said interest is within the camera's view frustum.
	--Get camera field of view to establish plane normals:
	local angle = CamTools.GetHorizontalFOV(camera)
	----print("Angle",angle)
	local right_plane = (camera.CFrame * CFrame.fromAxisAngle(camera.CFrame.UpVector, math.rad(-angle))).p.Unit
	local left_plane = (camera.CFrame * CFrame.fromAxisAngle(camera.CFrame.UpVector, math.rad((-angle + 90)))).p.Unit
	
	--Given a plane, add the magnitude of the interest position's vector projected to the normal of the plane to the plane's position to get the interest position's distance from the plane
	----print("Planes:", right_plane, left_plane)
	local cR = VectorMath.Project(interestPosition, right_plane) - right_plane
	local cL = VectorMath.Project(interestPosition, left_plane) - left_plane
	
	--print("C",cR, cL)
end]]--

CamTools.GetHorizontalFOV = function(camera)
	local verticalFov = math.rad(camera.FieldOfView)
	local aspectRatio = camera.ViewportSize.X / camera.ViewportSize.Y
	return math.deg(2 * math.atan(math.tan(verticalFov / 2) * aspectRatio))
end

return CamTools
