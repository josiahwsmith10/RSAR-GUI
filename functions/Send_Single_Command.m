function Send_Single_Command(app)


%             pulsePerRevolution = app.VerticalSpeedmmsEditField.Value;
%             revolutionPerMinute = app.HorizontalSpeedmmsEditField.Value;
%             distancePerRevolution = app.DistancePerRevolutionmmEditField.Value;

desiredMovementH_mm = app.DesiredHorizontalMovementmmEditField.Value;
desiredMovementV_mm = app.DesiredVerticalMovementmmEditField.Value;

%             nPulseH = round(desiredMovementH / distancePerRevolution * pulsePerRevolution);
%             nPulseV = round(desiredMovementV / distancePerRevolution * pulsePerRevolution);
%
%             if (app.isActuatorConnected)
%                 fprintf(app.serialPortActuator,['H' num2str(nPulseH)]);
%             end
%             disp(['H' num2str(nPulseH)])
%             pause(1/revolutionPerMinute*abs(nPulseH)/pulsePerRevolution * 60);
%
%             if (app.isActuatorConnected)
%                 fprintf(app.serialPortActuator,['V' num2str(nPulseV)]);
%             end
%             disp(['V' num2str(nPulseV)])
%             pause(1/revolutionPerMinute*abs(nPulseV)/pulsePerRevolution * 60);

% Do the movement using the AMC4030 Controller
if desiredMovementH_mm ~= 0 && 1 == COM_API_Jog(app.ScannerCOMPort,0,desiredMovementH_mm,app.HorizontalSpeedmmsEditField.Value)
    app.TotalHorizontalMovementmmEditField.Value = app.TotalHorizontalMovementmmEditField.Value + desiredMovementH_mm;
end
if desiredMovementV_mm ~= 0 && 1 == COM_API_Jog(app.ScannerCOMPort,1,desiredMovementV_mm,app.VerticalSpeedmmsEditField.Value)
    app.TotalVerticalMovementmmEditField.Value = app.TotalVerticalMovementmmEditField.Value + desiredMovementV_mm;
end

app.textMovementString = ['Horizontal:    ', num2str(app.TotalHorizontalMovementmmEditField.Value), ' mm', newline, newline, ...;
    'Vertical:        ', num2str(app.TotalVerticalMovementmmEditField.Value), ' mm'];
app.TotalMovementTextArea.Value = app.textMovementString;