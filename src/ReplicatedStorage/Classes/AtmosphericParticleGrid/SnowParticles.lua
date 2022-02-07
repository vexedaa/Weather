local layers = {
    [1] = {
        {
            Color = ColorSequence.new(Color3.fromRGB(213, 241, 255));
            LightEmission = 0.7;
            LightInfluence = 1;
            Orientation = Enum.ParticleOrientation.FacingCamera;
            Size = NumberSequence.new{
                NumberSequenceKeypoint.new(0, 0.2, 0);
                NumberSequenceKeypoint.new(1, 1.4, 0.188);
            };
            Squash = NumberSequence.new(0);
            Texture = "rbxassetid://8074417285";
            Transparency = NumberSequence.new{
                NumberSequenceKeypoint.new(0, 0, 0);
                NumberSequenceKeypoint.new(0.548, 0.137, 0);
                NumberSequenceKeypoint.new(0.742, 0.356, 0);
                NumberSequenceKeypoint.new(1, 1, 0);
            };
            Name = "Snow";
            ZOffset = 0;
            EmissionDirection = Enum.NormalId.Bottom;
            Enabled = true;
            Lifetime = NumberRange.new(800);
            Rate = 1;
            Rotation = NumberRange.new(0);
            RotSpeed = NumberRange.new(0);
            Speed = NumberRange.new(15, 40);
            SpreadAngle = Vector2.new(5, 5);
            Shape = Enum.ParticleEmitterShape.Disc;
            ShapeInOut = Enum.ParticleEmitterShapeInOut.Outward;
            ShapePartial = 1;
            ShapeStyle = Enum.ParticleEmitterShapeStyle.Surface;
            Acceleration = Vector3.new(0.5, 0, -0.5);
            Drag = 0;
            LockedToPart = true;
            TimeScale = 1;
            VelocityInheritance = 1;
        };
    }
}

return layers