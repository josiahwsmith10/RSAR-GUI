function [err,horWaitTime_s] = Move_Horizontal(app,desiredMovementH_mm)
% Outputs
%   1   :   Successful Movement
%   0   :   No Movement Required
%   -1  :   Error in Movement

horWaitTime_s = 0;

% Do the movement using the AMC4030 Controller
if desiredMovementH_mm ~= 0 && 1 == COM_API_Jog(app.ScannerCOMPort,0,desiredMovementH_mm,app.HorizontalSpeedmmsEditField.Value)
    app.TotalHorizontalMovementmmEditField.Value = app.TotalHorizontalMovementmmEditField.Value + desiredMovementH_mm;
    err = 1;
    horWaitTime_s = abs(desiredMovementH_mm/app.HorizontalSpeedmmsEditField.Value);
    return;
elseif desiredMovementH_mm == 0
    err = 0;
    return;
else
    err = -1;
    return;
end