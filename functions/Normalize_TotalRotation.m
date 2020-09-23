function Normalize_TotalRotation(app)
app.TotalRotationMovementdegEditField.Value = mod(app.TotalRotationMovementdegEditField.Value,360);
while app.TotalRotationMovementdegEditField.Value > 180
    app.TotalRotationMovementdegEditField.Value = app.TotalRotationMovementdegEditField.Value - 360;
end
while app.TotalRotationMovementdegEditField.Value < -180
    app.TotalRotationMovementdegEditField.Value = app.TotalRotationMovementdegEditField.Value + 360;
end