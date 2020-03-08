function Rotation_Continuous_SAR_Capture(app)

app.TotalRotationMovementdegEditField.Value = 0;

for i = 1:app.NumberofRotationStepsEditField.Value
    app.RotationSARTextArea.Value = "Starting Slice #" + i;
    pause(1);
    StartCapturingContSARCommandButtonPushed(app, event);
    app.RotationSARTextArea.Value = "Slice #" + i + " Complete";
    pause(1);
    
    app.RotationSARTextArea.Value = "Rotating";
    pause(0.5);
    if COM_API_Jog(app.ScannerCOMPort,2,app.RotationStepSizedegEditField.Value,app.RotationSpeeddegsEditField.Value)
        app.TotalRotationMovementdegEditField.Value = app.TotalRotationMovementdegEditField.Value + app.RotationStepSizedegEditField.Value;
        app.RotationSARTextArea.Value = "Rotation: " + app.TotalRotationMovementdegEditField.Value + " degrees" + newline + "Horizontal Movement: " + app.TotalHorizontalMovementmmEditField.Value + " mm" + newline + "Vertical Movment: " + app.TotalVerticalMovementmmEditField.Value + " mm";
    end
    pause(abs(app.RotationStepSizedegEditField.Value/app.RotationSpeeddegsEditField.Value) + 1);
    
    % Remove?
    %                 app.RotationSARTextArea.Value = "Homing the X and Y Axes";
    %                 pause(0.5);
    %                 % home the x and y axes
    %                 if 1 == calllib('AMC4030','COM_API_Home',1,1,0)
    %                     pause(app.TotalHorizontalMovementmmEditField.Value/10 + app.TotalVerticalMovementmmEditField.Value/10 + 1)
    %                     app.TotalHorizontalMovementmmEditField.Value = 0;
    %                     app.TotalVerticalMovementmmEditField.Value = 0;
    %                     app.RotationSARTextArea.Value = "Rotation: " + app.DegtoRotateEditField.Value + " degrees" + newline + "Horizontal Movement: " + app.TotalHorizontalMovementmmEditField.Value + " mm" + newline + "Vertical Movment: " + app.TotalVerticalMovementmmEditField.Value + " mm";
    %                 end
    %
    %                 pause(1);
    
    app.RotationSARTextArea.Value = "Moving X Axis to Starting Location";
    pause(0.5);
    horizontalMoveToStartingmm = app.StartingHorizontalPositionEditField.Value - app.TotalHorizontalMovementmmEditField.Value;
    if COM_API_Jog(app.ScannerCOMPort,0,horizontalMoveToStartingmm,app.HorizontalSpeedmmsEditField.Value)
        app.TotalHorizontalMovementmmEditField.Value = app.TotalHorizontalMovementmmEditField.Value + horizontalMoveToStartingmm;
        app.RotationSARTextArea.Value = "Rotation: " + app.DegtoRotateEditField.Value + " degrees" + newline + "Horizontal Movement: " + app.TotalHorizontalMovementmmEditField.Value + " mm" + newline + "Vertical Movment: " + app.TotalVerticalMovementmmEditField.Value + " mm";
    end
    pause(abs(horizontalMoveToStartingmm/app.HorizontalSpeedmmsEditField.Value) + 1);
    
    app.RotationSARTextArea.Value = "Moving Y Axis to Starting Location";
    pause(0.5);
    verticalMoveToStartingmm = app.StartingVerticalPositionEditField.Value - app.TotalVerticalMovementmmEditField.Value;
    if COM_API_Jog(app.ScannerCOMPort,1,verticalMoveToStartingmm,app.VerticalSpeedmmsEditField.Value)
        app.TotalVerticalMovementmmEditField.Value = app.TotalVerticalMovementmmEditField.Value + verticalMoveToStartingmm;
        app.RotationSARTextArea.Value = "Rotation: " + app.DegtoRotateEditField.Value + " degrees" + newline + "Horizontal Movement: " + app.TotalHorizontalMovementmmEditField.Value + " mm" + newline + "Vertical Movment: " + app.TotalVerticalMovementmmEditField.Value + " mm";
    end
    pause(abs(verticalMoveToStartingmm/app.VerticalSpeedmmsEditField.Value) + 1);
end