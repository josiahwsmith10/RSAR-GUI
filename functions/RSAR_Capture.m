function RSAR_Capture(app)

% TODO: add DCA functionality

% Check if controller is connected
%----------------------------------------------------------------------------------------------------------------------%
if ~app.isActuatorConnected
    app.StatusScreenTextArea.Value = "Error: Connect to Controller and Try Again";
    app.sarScenarioActive = false;
    return;
    
    
    % Check if TI radar is connected
    %------------------------------------------------------------------------------------------------------------------%
elseif ~app.isTIRadarConnected
    app.RadarScreenTextArea.Value = "Error: Connect to mmWave Studio and Try Again";
    app.sarScenarioActive = false;
    return;
    
    
    % Check if scan is already in progress
    %------------------------------------------------------------------------------------------------------------------%
elseif app.sarScenarioActive
    app.StatusScreenTextArea.Value = "Error: Scan Already in Progress";
    return;
    
    % Otherwise start scan
    %------------------------------------------------------------------------------------------------------------------%
else
    app.StatusScreenTextArea.Value = "Success: Starting Scan!";
    app.sarScenarioActive = true;
    pause(1);
end

% Initial Horizontal, Vertical, and Rotation Starting Positions
%----------------------------------------------------------------------------------------------------------------------%
Normalize_TotalRotation(app)
initialHorizontalPosition_mm = app.TotalHorizontalMovementmmEditField.Value;
initialVerticalPosition_mm = app.TotalVerticalMovementmmEditField.Value;
initialRotationPosition_deg = app.TotalRotationMovementdegEditField.Value;

% Start Loop
%----------------------------------------------------------------------------------------------------------------------%
for iV = 1:app.nVerticalSteps.Value
    % Check if SAR Scenario has been Stopped
    %------------------------------------------------------------------------------------------------------------------%
    if ~app.sarScenarioActive
        pause(3);
        app.StatusScreenTextArea.Value = "Stopping Scan";
        return;
    end
    
    
    % Update Status Screen with Iteration Number
    %------------------------------------------------------------------------------------------------------------------%
    app.StatusScreenTextArea.Value = ['Starting Iteration ',num2str(iV),'/',num2str(app.nVerticalSteps.Value)];
    
    
    % If app.WaitTime.Value is positive: start rotation movement then
    % start triggering
    %------------------------------------------------------------------------------------------------------------------%
    if (app.WaitTime.Value >= 0)
        
        % Start Rotation Movement
        [err,rotWaitTime_s] = Move_Rotational(app,app.RotationSize.Value);
        if err == -1
            warning("First Rotation Movement Failure")
            % First, try again
            [err,rotWaitTime_s] = Move_Rotational(app,app.RotationSize.Value);
            if err == -1
                warning("Second Rotation Movement Failure")
                % If another failure, try a third time
                [err,rotWaitTime_s] = Move_Rotational(app,app.RotationSize.Value);
                if err == -1
                    warning("Third Rotation Movement Failure. Exiting Scan!")
                    % Then, exit the program
                    app.StatusScreenTextArea.Value = "Error with Rotation Movement";
                    beep()
                    pause(5);
                    app.sarScenarioActive = false;
                    return;
                end
            end
        end
        
        % Then wait before triggering
        pause(app.WaitTime.Value)
    end
    
    % Trigger the Frame
    %------------------------------------------------------------------------------------------------------------------%
    Lua_String = sprintf('ar1.StartFrame()');
    ErrStatus = RtttNetClientAPI.RtttNetClient.SendCommand(Lua_String);
    if (ErrStatus ~= 30000)
        app.RadarScreenTextArea.Value = 'Trigger Frame failed for device';
        app.sarScenarioActive = false;
        return;
    else
        app.RadarScreenTextArea.Value = ['Trigger Frame ', num2str(iV), ' is successful'];
    end
    
    
    % If app.WaitTime.Value is negative: start triggering then
    % start the rotation movement
    %------------------------------------------------------------------------------------------------------------------%
    if (app.WaitTime.Value < 0)
        % Wait
        pause(abs(app.WaitTime.Value))
        
        % Start Rotation Movement
        [err,rotWaitTime_s] = Move_Rotational(app,app.RotationSize.Value);
        if err == -1
            warning("First Rotation Movement Failure")
            % First, try again
            [err,rotWaitTime_s] = Move_Rotational(app,app.RotationSize.Value);
            if err == -1
                warning("Second Rotation Movement Failure")
                % If another failure, try a third time
                [err,rotWaitTime_s] = Move_Rotational(app,app.RotationSize.Value);
                if err == -1
                    warning("Third Rotation Movement Failure. Exiting Scan!")
                    % Then, exit the program
                    app.StatusScreenTextArea.Value = "Error with Rotation Movement";
                    beep()
                    pause(5);
                    app.sarScenarioActive = false;
                    return;
                end
            end
        end
    end
    
    % Wait for the time it takes for the rotation to complete +
    % app.WaitTime.Value.
    pause(rotWaitTime_s + abs(app.WaitTime.Value));
    
    % Now we have waited rotWaitTime_s + 2*abs(app.WaitTime.Value)
    
    
    % Move Rotator Back to Original Position
    %------------------------------------------------------------------------------------------------------------------%
    Normalize_TotalRotation(app);
    [err,rotWaitTime_s] = Move_Rotational(app,initialRotationPosition_deg - app.TotalRotationMovementdegEditField.Value);
    if err == -1
        warning("First Rotation Movement Failure")
        % First, try again
        [err,rotWaitTime_s] = Move_Rotational(app,app.RotationSize.Value);
        if err == -1
            warning("Second Rotation Movement Failure")
            % If another failure, try a third time
            [err,rotWaitTime_s] = Move_Rotational(app,app.RotationSize.Value);
            if err == -1
                warning("Third Rotation Movement Failure back to Initial Position. Exiting Scan!")
                % Then, exit the program
                app.StatusScreenTextArea.Value = "Error with Rotation Movement";
                beep()
                pause(5);
                app.sarScenarioActive = false;
                return;
            end
        end
    end
    % Wait for Rotation to Complete
    pause(rotWaitTime_s);
    
    
    % If Iteration is not Final Iteration
    %------------------------------------------------------------------------------------------------------------------%
    if iV ~= app.nVerticalSteps.Value
        
        % Start Vertical Movement
        [err,verWaitTime_s] = Move_Vertical(app,app.VerticalStepSize.Value);
        if err == -1
            app.StatusScreenTextArea.Value = "Error with Vertical Movement";
            pause(5);
            app.sarScenarioActive = false;
            return;
        end
        
        % Wait for Vertical Movement to Complete
        pause(verWaitTime_s);
        
        % Extra Pause for Tolerance
        pause(1);
        
    end
    
end
% End Loop

% Restore Initial Position
%----------------------------------------------------------------------------------------------------------------------%
[err,horWaitTime_s] = Move_Horizontal(app,initialHorizontalPosition_mm - app.TotalHorizontalMovementmmEditField.Value);
if err == -1
    app.StatusScreenTextArea.Value = "Error with Horizontal Movement to Initial Position";
    pause(1);
end
[err,verWaitTime_s] = Move_Vertical(app,initialVerticalPosition_mm - app.TotalVerticalMovementmmEditField.Value);
if err == -1
    app.StatusScreenTextArea.Value = "Error with Vertical Movement to Initial Position";
    pause(1);
end
[err,rotWaitTime_s] = Move_Rotational(app,initialRotationPosition_deg - app.TotalRotationMovementdegEditField.Value);
if err == -1
    app.StatusScreenTextArea.Value = "Error with Rotation Movement to Initial Position";
    pause(1);
end

% Wait for Movement to Complete
%----------------------------------------------------------------------------------------------------------------------%
pause(horWaitTime_s + verWaitTime_s + rotWaitTime_s);

% Pause for Tolerance
%----------------------------------------------------------------------------------------------------------------------%
pause(1);

% End SAR Scenario
%----------------------------------------------------------------------------------------------------------------------%
app.sarScenarioActive = false;

end