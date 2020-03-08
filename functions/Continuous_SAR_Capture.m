function Continuous_SAR_Capture(app)

if ~app.isTIRadarConnected
    app.StatusScreenContSARTextArea.Value = 'Please connect to TI Radar first';
elseif app.scanName == "noScanName"
    app.StatusScreenContSARTextArea.Value = "Please Enter a Name for the Scan First";
else
    % Total Horizontal Scanning Size
    horizontalScanSize_mm = app.HorizontalScanSizemmContSAREditField.Value;
    
    % Number of Vertical Steps and the Vertical Step Size
    numberOfVerticalSteps = app.VerticalScanStepsContSARSpinner.Value;
    stepVerticalMovement_mm = app.VerticalStepSizemmEditField.Value;
    
    app.TotalMovementContSARTextArea.Value = "Vertical Step Size: " + stepVerticalMovement_mm + "mm";
    
    waitDuration = app.WaitTimeBeforeCapturingContSAREditField.Value;
    
    % Initial Horizontal and Vertical Starting Positions
    initialHorizontalPosition_mm = app.TotalHorizontalMovementmmEditField.Value;
    initialVerticalPosition_mm = app.TotalVerticalMovementmmEditField.Value;
    
    % Start SAR Scenario
    app.sarScenarioActive = true;
    
    % Initialize Counter
    nSteps = 1;
    
    % Make Directory to Hold All the Scans if DCA
    if app.RadarTypeDropDown.Value == "DCA" && app.DeviceDropDown.Value == "Lab Desktop"
        scanStr = sprintf('C:\\Users\\jws160130\\Box\\ISAR Rotation\\SAR Scanner\\SAR Scanner Codes\\SAR Scans\\%s\\',app.scanName);
        if mkdir(scanStr)
            app.StatusScreenContSARTextArea.Value = "Successfully Created Directory to Store Scans";
        else
            app.StatusScreenContSARTextArea.Value = "Failed to Create Directory to Store Scans";
            return;
        end
    elseif app.RadarTypeDropDown.Value == "DCA" && app.DeviceDropDown.Value == "Josiah Laptop"
        app.StatusScreenContSARTextArea.Value = "NOT YET COMPLETED";
        return;
    end
    
    % Start Loop!
    for nV = 1:numberOfVerticalSteps
        % Update Text Areas
        app.textMovementString = ['Hor: ', num2str(app.TotalHorizontalMovementmmEditField.Value), ' mm', newline, newline, ...;
            'Ver: ', num2str(app.TotalVerticalMovementmmEditField.Value), ' mm'];
        app.TotalMovementContSARTextArea.Value = app.textMovementString;
        
        contSARStatusUpdate = ['Starting Iteration ',num2str(nV),'/',num2str(numberOfVerticalSteps), newline,...;
            'Horizontal Motion: ',num2str(horizontalScanSize_mm),' mm', newline,...;
            'Verical Motion:    ',num2str(stepVerticalMovement_mm),' mm'];
        app.StatusScreenContSARTextArea.Value = contSARStatusUpdate;
        
        % Check to make sure sarScenarioActive,
        % isActuatorConnected, and isTIRadarConnected are all
        % true
        if (~app.sarScenarioActive) && (~app.isActuatorConnected) && (~app.isTIRadarConnected)
            break;
        end
        
        % Prep if Radar is DCA Type
        if app.RadarTypeDropDown.Value == "DCA" && app.DeviceDropDown.Value == "Lab Desktop"
            % Do DCA Work
            Lua_String = sprintf('ar1.CaptureCardConfig_StartRecord(\"C:\\\\Users\\\\jws160130\\\\Box\\\\ISAR Rotation\\\\SAR Scanner\\\\SAR Scanner Codes\\\\SAR Scans\\\\%s\\\\%s_%i.bin\",1)',app.scanName,app.scanName,nV);
            ErrStatus = RtttNetClientAPI.RtttNetClient.SendCommand(Lua_String);
            if (ErrStatus ~=30000)
                app.StatusScreenContSARTextArea.Value = 'Failed to Setup for DCA';
                return;
            else
                app.StatusScreenContSARTextArea.Value = 'Setup for DCA Success';
                pause(1);
            end
        elseif app.RadarTypeDropDown.Value == "DCA" && app.DeviceDropDown.Value == "Josiah Laptop"
            app.StatusScreenContSARTextArea.Value = 'NOT COMPLETED YET';
        end
        
        % If waitDuration is positive: start movement then
        % start triggering
        if (waitDuration >= 0)
            
            % Start horizontal movement
            if 1 == COM_API_Jog(app.ScannerCOMPort,0,horizontalScanSize_mm,app.HorizontalSpeedmmsEditField.Value)
                % Successful Movement of Horizontal Axis
                app.TotalHorizontalMovementmmEditField.Value = app.TotalHorizontalMovementmmEditField.Value + horizontalScanSize_mm;
            end
            
            % Then wait before triggering
            pause(waitDuration)
        end
        
        % Trigger Frame
        Lua_String = sprintf('ar1.StartFrame()');
        ErrStatus = RtttNetClientAPI.RtttNetClient.SendCommand(Lua_String);
        if (ErrStatus ~=30000)
            app.StatusScreenContSARTextArea.Value = 'Trigger Frame failed for device';
            return;
        else
            app.StatusScreenContSARTextArea.Value = ['Trigger Frame ', num2str(nSteps), ' is successful']; nSteps = nSteps + 1;
        end
        
        % If waitDuration is negative: start triggering then
        % start the movement
        if (waitDuration < 0)
            % Wait
            pause(abs(waitDuration))
            
            if 1 == COM_API_Jog(app.ScannerCOMPort,0,horizontalScanSize_mm,app.HorizontalSpeedmmsEditField.Value)
                % Successful Movement of Horizontal Axis
                app.TotalHorizontalMovementmmEditField.Value = app.TotalHorizontalMovementmmEditField.Value + horizontalScanSize_mm;
            end
        end
        
        % wait for the amount of time it takes for
        % the horizontal axis to travel horizontalScanSize_mm
        % minus waitDuration because we have already waited for
        % waitDuration seconds in one of the two if statements
        % above
        
        %         pause(abs(200)/app.HorizontalSpeedmmsEditField.Value + abs(waitDuration))
        pause(abs(horizontalScanSize_mm)/app.HorizontalSpeedmmsEditField.Value + abs(waitDuration))
        
        % Update Text Areas
        app.textMovementString = ['Hor: ', num2str(app.TotalHorizontalMovementmmEditField.Value), ' mm', newline, newline, ...;
            'Ver: ', num2str(app.TotalVerticalMovementmmEditField.Value), ' mm'];
        app.TotalMovementContSARTextArea.Value = app.textMovementString;
        
        if app.RadarTypeDropDown.Value == "DCA"
            % Not yet implemented
            % tempFileName = fileName + "_" + nV + "_Raw_0.bin";
            % Check the existence and size of each file
            
            pause(2) % Extra wait for tolerance
        end
        
        if (app.sarScenarioActive) && (app.isActuatorConnected) && (app.isTIRadarConnected)
            if nV ~= numberOfVerticalSteps
                % Do vertical Movement
                if 1 == COM_API_Jog(app.ScannerCOMPort,1,stepVerticalMovement_mm,app.VerticalSpeedmmsEditField.Value)
                    % Successful Movement of Vertical Axis
                    app.TotalVerticalMovementmmEditField.Value = app.TotalVerticalMovementmmEditField.Value + stepVerticalMovement_mm;
                end
                
                % pause for the amount of time it takes for
                % the vertical axis to travel to its next
                % position
                if app.BackandForthScanningCheckBox.Value
                    pause(abs(stepVerticalMovement_mm)/app.VerticalSpeedmmsEditField.Value + 1)
                end
                
                % Update Text Area
                app.textMovementString = ['Hor: ', num2str(app.TotalHorizontalMovementmmEditField.Value), ' mm', newline, newline, ...;
                    'Ver: ', num2str(app.TotalVerticalMovementmmEditField.Value), ' mm'];
                app.TotalMovementContSARTextArea.Value = app.textMovementString;
                
                if app.BackandForthScanningCheckBox.Value
                    % Reverse the horizontal direction
                    horizontalScanSize_mm = -1*horizontalScanSize_mm;
                else
                    % Move the horizontal axis back to its
                    % starting position
                    if 1 == COM_API_Jog(app.ScannerCOMPort,0,initialHorizontalPosition_mm - app.TotalHorizontalMovementmmEditField.Value,app.HorizontalSpeedmmsEditField.Value)
                        % Successful Movement of Horizontal Axis
                    end
                    
                    % pause for the amount of time it takes for
                    % the horizontal axis to travel back to its
                    % starting position
                    pause(abs(initialHorizontalPosition_mm - app.TotalHorizontalMovementmmEditField.Value)/app.HorizontalSpeedmmsEditField.Value + 2)
                    app.TotalHorizontalMovementmmEditField.Value = initialHorizontalPosition_mm;
                end
                
                pause(1) % Extra wait for tolerance
                
            else
                % If the last iteration (only difference is
                % don't move up vertically since we don't need
                % to because we don't have another horizontal
                % scan)
                
                if app.TotalHorizontalMovementmmEditField.Value ~= initialHorizontalPosition_mm
                    
                    % Move the horizontal axis back to its
                    % starting position
                    if 1 == COM_API_Jog(app.ScannerCOMPort,0,initialHorizontalPosition_mm - app.TotalHorizontalMovementmmEditField.Value,app.HorizontalSpeedmmsEditField.Value)
                        % Successful Movement of Horizontal Axis
                    end
                    
                    % pause for the amount of time it takes for
                    % the horizontal axis to travel back to its
                    % starting position
                    pause(abs(initialHorizontalPosition_mm - app.TotalHorizontalMovementmmEditField.Value)/app.HorizontalSpeedmmsEditField.Value + 2)
                    app.TotalHorizontalMovementmmEditField.Value = initialHorizontalPosition_mm;
                end
                
                % Move the vertical axis back to its starting
                % position
                if 1 == COM_API_Jog(app.ScannerCOMPort,1,initialVerticalPosition_mm - app.TotalVerticalMovementmmEditField.Value,app.VerticalSpeedmmsEditField.Value)
                    % Successful Movement of Vertical Axis
                end
                
                % pause for the amount of time it takes for
                % the vertical axis to travel to its starting
                % position
                pause(abs(initialVerticalPosition_mm - app.TotalVerticalMovementmmEditField.Value)/app.VerticalSpeedmmsEditField.Value + 1)
                app.TotalVerticalMovementmmEditField.Value = initialVerticalPosition_mm;
                
                % Update Text Area
                app.textMovementString = ['Hor: ', num2str(app.TotalHorizontalMovementmmEditField.Value), ' mm', newline, newline, ...;
                    'Ver: ', num2str(app.TotalVerticalMovementmmEditField.Value), ' mm'];
                app.TotalMovementContSARTextArea.Value = app.textMovementString;
                
                pause(1) % Extra wait for tolerance
            end
        end
    end
end