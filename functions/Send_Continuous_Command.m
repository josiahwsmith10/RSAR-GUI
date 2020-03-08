function Send_Continuous_Command(app)

%             pulsePerRevolution = app.VerticalSpeedmmsEditField.Value;
%             revolutionPerMinute = app.HorizontalSpeedmmsEditField.Value;
%             distancePerRevolution = app.DistancePerRevolutionmmEditField.Value;

%             numberOfSteps = app.NumberofStepsEditField.Value;
%             stepMovement_mm = app.MovementforEachStepmmEditField.Value;
%             movementDirection = app.DirectionSwitchContinous.Value;
%             movementDirectionItems = app.DirectionSwitchContinous.Items;
%             waitDuration = app.WaitTimeBetweenStepsEditField.Value;
%
%             %             nPulse = round(stepMovement / distancePerRevolution * pulsePerRevolution);
%
%             if strcmp(movementDirection,movementDirectionItems(1))
%                 %                 command = 'V';
%                 contAxis = 1;
%             else
%                 %                 command = 'H';
%                 contAxis = 0;
%             end
%
%             for n = 1:numberOfSteps
%                 if (app.isActuatorConnected)
%                     %                     fprintf(app.serialPortActuator,[command num2str(nPulse)]);
%                     if 1 == COM_API_Jog(app.ScannerCOMPort,contAxis,app.HorizontalSpeedmmsEditField.Value)
%                     end
%                 end
%                 % disp([command num2str(nPulse)])
%                 %                 pause(1/revolutionPerMinute*abs(nPulse)/pulsePerRevolution * 60);
%                 pause(waitDuration)
%             end