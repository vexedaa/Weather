local ArrowButton = {}
ArrowButton.__index = ArrowButton

local TweenService = game:GetService("TweenService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Services = ReplicatedStorage:WaitForChild("Services")
local TagService = require(Services:WaitForChild("TagService"))

--ArrowButton: When clicked, it gives the illusion of a horizontal scroll between frames.
function ArrowButton.new(button, target, container, direction)
    local self = {
        _Button = button;
        _Target = target;
        _Direction = direction;
        _Container = container;
        _TweenInfo = TweenInfo.new(.2, Enum.EasingStyle.Linear, Enum.EasingDirection.Out, 0, false, 0)
    }
    setmetatable(self, ArrowButton)
    self:_Initialize()
    return self
end

function ArrowButton:_Initialize()
    local button = self._Button
    local target = self._Target
    local container = self._Container
    local direction = self._Direction
    --AnchorPoint must be Vector2.new(0.5, 0.5)
    target.AnchorPoint =  Vector2.new(0.5, 0.5)
    container.AnchorPoint = Vector2.new(0.5, 0.5)

    button.MouseButton1Click:Connect(function()
        if direction == "Left" then
            --Place target container to the left of button's container
            target.Position = UDim2.new(-2, 0, 0.5, 0)
            target.Visible = true
            --Tween container to the right, and target to the center
            local containerTween = TweenService:Create(container, self._TweenInfo, {Position = UDim2.new(2, 0, .5, 0)})
            local targetTween = TweenService:Create(target, self._TweenInfo, {Position = UDim2.new(.5, 0, .5, 0)})
            containerTween:Play()
            targetTween:Play()
            task.spawn(function()
                task.wait(self._TweenInfo.Time)
                container.Visible = false
            end)

        elseif direction == "Right" then
            --Place target container to the right of button's container
            target.Position = UDim2.new(2, 0, 0.5, 0)
            target.Visible = true
            --Tween container to the left, and target to the center
            local containerTween = TweenService:Create(container, self._TweenInfo, {Position = UDim2.new(-2, 0, .5, 0)})
            local targetTween = TweenService:Create(target, self._TweenInfo, {Position = UDim2.new(.5, 0, .5, 0)})
            containerTween:Play()
            targetTween:Play()
            task.spawn(function()
                task.wait(self._TweenInfo.Time)
                container.Visible = false
            end)
        end
    end)
end

repeat task.wait()
until game:IsLoaded() == true

TagService.HookAddedSignal("ArrowButton", function(element)
    task.spawn(function()
        if element:IsDescendantOf(game.Players.LocalPlayer) then
            local getTarget = element:FindFirstChild("Target")
            local getContainer = element:FindFirstChild("Container")
            local getDirection = element:FindFirstChild("Direction")
            if getTarget then
                repeat task.wait()
                until getTarget.Value ~= nil
                getTarget = getTarget.Value
            end
            if getContainer then
                repeat task.wait()
                until getContainer.Value ~= nil
                getContainer = getContainer.Value
            end
            if getDirection then
                getDirection = getDirection.Value
            end
            print("Element:", element, "Target:", getTarget, "Container:", getContainer, "Direction:", getDirection)
            --Create new arrow button
            local success, result = pcall(function()
                ArrowButton.new(element, getTarget, getContainer, getDirection)
            end)
            if success == false then
                warn(result)
            end
        end
    end)
end)



return ArrowButton