function Gesture_Capture(app)

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
    app.StatusScreenTextArea.Value = "Success: Preparing to Starts!";
    app.sarScenarioActive = true;
    pause(1);
end

if app.WaitBeforeStartCheckBox.Value
    app.StatusScreenTextArea.Value = "Waiting Before Starting Captures";
    % Countdown bar
    %------------------------------------------------------------------------------------------------------------------%
    countdownBar = waitbar(1,"GET READY FOR START!");
    for indTime = 1:64
        pause(10/64);
        waitbar(1-indTime/64,countdownBar);
    end
    delete(countdownBar)
end

% Start Looping through Captures
%----------------------------------------------------------------------------------------------------------------------%
for iC = 1:app.nGestureCaptures.Value
    % Check if Scenario has been Stopped
    %------------------------------------------------------------------------------------------------------------------%
    if ~app.sarScenarioActive
        pause(3);
        app.StatusScreenTextArea.Value = "Stopping Captures";
        return;
    end
    
    % Start the count-up bar
    %------------------------------------------------------------------------------------------------------------------%
    countupBar = waitbar(0,"Started Trigger");
    
    % Trigger the Frame
    %------------------------------------------------------------------------------------------------------------------%
    Lua_String = sprintf('ar1.StartFrame()');
    ErrStatus = RtttNetClientAPI.RtttNetClient.SendCommand(Lua_String);
    if (ErrStatus ~= 30000)
        app.RadarScreenTextArea.Value = 'Trigger Frame failed for device';
        app.sarScenarioActive = false;
        return;
    else
        app.RadarScreenTextArea.Value = ['Trigger Frame ', num2str(iC), ' is successful'];
    end
    
    app.StatusScreenTextArea.Value = "Capture " + iC + "/" + app.nGestureCaptures.Value + " started";
    
    % Update the count-up bar
    %------------------------------------------------------------------------------------------------------------------%
    for indTime = 1:64
        pause(app.CaptureTime_s.Value/64);
        waitbar(indTime/64,countupBar);
    end
    delete(countupBar)
    
    % Countdown bar
    %------------------------------------------------------------------------------------------------------------------%
    countdownBar = waitbar(1,"GET READY!");
    for indTime = 1:64
        pause(app.TimeBetweenCaptures_s.Value/64);
        waitbar(1-indTime/64,countdownBar);
    end
    delete(countdownBar)
    
    app.StatusScreenTextArea.Value = "Capture " + iC + "/" + app.nGestureCaptures.Value + " complete!";
    
    pause(app.BufferTime_s.Value)
    
end
% End Loop

app.sarScenarioActive = false;

end