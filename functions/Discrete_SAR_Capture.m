function Discrete_SAR_Capture(app)

pulsePerRevolution = app.VerticalSpeedmmsEditField.Value;
revolutionPerMinute = app.HorizontalSpeedmmsEditField.Value;
distancePerRevolution = app.DistancePerRevolutionmmEditField.Value;

numberOfHorizontalSteps = app.NumberofStepsatHorizontalAxisSpinner.Value;
stepHorizontalMovement = app.HorizontalMovementforEachStepmmEditField.Value;

numberOfVerticalSteps = app.NumberofStepsatVerticalAxisSpinner.Value;
% Get the numerical array includes movements in scenario
stepVerticalMovement = str2num(app.VerticalMovementScenariommEditField.Value);
stepVerticalMovement = repmat(stepVerticalMovement,1,ceil(numberOfVerticalSteps/length(stepVerticalMovement)));
stepVerticalMovement = stepVerticalMovement(1:numberOfVerticalSteps);
% disp(stepVerticalMovement);

waitDuration = app.WaitTimeBetweenStepsSAREditField.Value;

nPulseHorizontal = round(stepHorizontalMovement / distancePerRevolution * pulsePerRevolution);
nPulseVertical = round(stepVerticalMovement / distancePerRevolution * pulsePerRevolution);

app.sarScenarioActive = true;

nSteps = 1;

for nV = 1:numberOfVerticalSteps
    
    if (~app.sarScenarioActive)
        break;
    end
    
    %% Do TI Work
    Lua_String = sprintf('ar1.StartFrame()');
    ErrStatus = RtttNetClientAPI.RtttNetClient.SendCommand(Lua_String);
    if (ErrStatus ~=30000)
        app.StatusScreenSARTextArea.Value = 'Trigger Frame failed for device';
        return;
    else
        app.StatusScreenSARTextArea.Value = ['Trigger Frame ', num2str(nSteps), ' is successful']; nSteps = nSteps + 1;
    end
    
    pause(waitDuration/2)
    
    for nH = 1:numberOfHorizontalSteps-1
        
        if (~app.sarScenarioActive)
            break;
        end
        
        nPulse = nPulseHorizontal;
        command = ['H' num2str(nPulse)];
        
        if (app.isActuatorConnected)
            fprintf(app.serialPortActuator,command);
        end
        disp(command)
        
        pause(1/revolutionPerMinute*abs(nPulse)/pulsePerRevolution * 60);
        app.TotalHorizontalMovementmmEditField.Value = app.TotalHorizontalMovementmmEditField.Value + stepHorizontalMovement;
        app.textMovementString = ['Horizontal:    ', num2str(app.TotalHorizontalMovementmmEditField.Value), ' mm', newline, newline, ...;
            'Vertical:        ', num2str(app.TotalVerticalMovementmmEditField.Value), ' mm'];
        app.TotalMovementSARTextArea.Value = app.textMovementString;
        
        pause(waitDuration/2)
        
        %% Do TI Work
        Lua_String = sprintf('ar1.StartFrame()');
        ErrStatus = RtttNetClientAPI.RtttNetClient.SendCommand(Lua_String);
        if (ErrStatus ~=30000)
            app.StatusScreenSARTextArea.Value = 'Trigger Frame failed for device';
            return;
        else
            app.StatusScreenSARTextArea.Value = ['Trigger Frame ', num2str(nSteps), ' is successful']; nSteps = nSteps + 1;
        end
        
        pause(waitDuration/2)
        
    end
    
    if (app.sarScenarioActive)
        
        if nV ~= numberOfVerticalSteps
            nPulse = nPulseVertical(nV);
            command = ['V' num2str(nPulse)];
            
            if (app.isActuatorConnected)
                fprintf(app.serialPortActuator,command);
            end
            disp(command)
            
            pause(1/revolutionPerMinute*abs(nPulse)/pulsePerRevolution * 60);
            app.TotalVerticalMovementmmEditField.Value = app.TotalVerticalMovementmmEditField.Value + stepVerticalMovement(nV);
            app.textMovementString = ['Horizontal:    ', num2str(app.TotalHorizontalMovementmmEditField.Value), ' mm', newline, newline, ...;
                'Vertical:        ', num2str(app.TotalVerticalMovementmmEditField.Value), ' mm'];
            app.TotalMovementSARTextArea.Value = app.textMovementString;
            
            nPulseHorizontal = -1*nPulseHorizontal;
            stepHorizontalMovement = -1*stepHorizontalMovement;
            
            pause(waitDuration/2)
            
        else
            if (app.TotalHorizontalMovementmmEditField.Value ~=0)
                nPulse = -1 * round(app.TotalHorizontalMovementmmEditField.Value / distancePerRevolution * pulsePerRevolution);
                command = ['H' num2str(nPulse)];
                
                if (app.isActuatorConnected)
                    fprintf(app.serialPortActuator,command);
                end
                disp(command)
                
                pause(1/revolutionPerMinute*abs(nPulse)/pulsePerRevolution * 60);
                app.TotalHorizontalMovementmmEditField.Value = 0;
            end
            
            nPulse = -1 * round(app.TotalVerticalMovementmmEditField.Value / distancePerRevolution * pulsePerRevolution);
            command = ['V' num2str(nPulse)];
            
            if (app.isActuatorConnected)
                fprintf(app.serialPortActuator,command);
            end
            disp(command)
            
            pause(1/revolutionPerMinute*abs(nPulse)/pulsePerRevolution * 60);
            app.TotalVerticalMovementmmEditField.Value = 0;
            
            app.textMovementString = ['Horizontal:    ', num2str(app.TotalHorizontalMovementmmEditField.Value), ' mm', newline, newline, ...;
                'Vertical:        ', num2str(app.TotalVerticalMovementmmEditField.Value), ' mm'];
            app.TotalMovementContSARTextArea.Value = app.textMovementString;
            
            pause(waitDuration/2)
        end
    end
    
end