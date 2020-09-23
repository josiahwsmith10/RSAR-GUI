function Send_Single_Command(app)

desiredMovementH_mm = app.DesiredHorizontalMovementmmEditField.Value;
desiredMovementV_mm = app.DesiredVerticalMovementmmEditField.Value;
desiredMovementR_deg = app.DesiredRotationMovementdegEditField.Value;

[err,horWaitTime_s] = Move_Horizontal(app,desiredMovementH_mm);
if err == -1
    app.StatusScreenTextArea.Value = "Error with Horizontal Movement";
end
[err,verWaitTime_s] = Move_Vertical(app,desiredMovementV_mm);
if err == -1
    app.StatusScreenTextArea.Value = "Error with Vertical Movement";
end
[err,rotWaitTime_s] = Move_Rotational(app,desiredMovementR_deg);
if err == -1
    app.StatusScreenTextArea.Value = "Error with Rotation Movement";
end

pause(horWaitTime_s + verWaitTime_s + rotWaitTime_s);

app.StatusScreenTextArea.Value = "Finished Single Command";