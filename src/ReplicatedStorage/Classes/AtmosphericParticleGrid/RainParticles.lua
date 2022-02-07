local layers = {
    [1] = {
        {
            Color = ColorSequence.new(Color3.fromRGB(213, 241, 255));
            LightEmission = 0;
            LightInfluence = 1;
            Orientation = Enum.ParticleOrientation.FacingCameraWorldUp;
            Size = NumberSequence.new{
                NumberSequenceKeypoint.new(0, 0.2, 0);
                NumberSequenceKeypoint.new(1, 1.4, 0.188);
            };
            Squash = NumberSequence.new(2);
            Texture = "rbxassetid://8074417285";
            Transparency = NumberSequence.new{
                NumberSequenceKeypoint.new(0, .2, 0);
                NumberSequenceKeypoint.new(0.548, 0.337, 0);
                NumberSequenceKeypoint.new(0.742, 0.656, 0);
                NumberSequenceKeypoint.new(1, 1, 0);
            };
            Name = "Rain";
            ZOffset = 0;
            EmissionDirection = Enum.NormalId.Bottom;
            Enabled = true;
            Lifetime = NumberRange.new(4);
            Rate = 25;
            Rotation = NumberRange.new(0);
            RotSpeed = NumberRange.new(0);
            Speed = NumberRange.new(58, 58);
            SpreadAngle = Vector2.new(0, 0);
            Shape = Enum.ParticleEmitterShape.Disc;
            ShapeInOut = Enum.ParticleEmitterShapeInOut.Outward;
            ShapePartial = 1;
            ShapeStyle = Enum.ParticleEmitterShapeStyle.Volume;
            Acceleration = Vector3.new(0, 0, 0);
            Drag = 0;
            LockedToPart = true;
            TimeScale = 1;
            VelocityInheritance = 0;
        };
    }
}

return layers