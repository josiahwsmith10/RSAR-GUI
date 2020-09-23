function [err,verWaitTime_s] = Move_Vertical(app,desiredMovementV_mm)
% Outputs
%   1   :   Successful Movement
%   0   :   No Movement Required
%   -1  :   Error in Movement

verWaitTime_s = 0;

% Do the movement using the AMC4030 Controller
if desiredMovementV_mm ~= 0 && 1 == COM_API_Jog(app.ScannerCOMPort,1,desiredMovementV_mm,app.VerticalSpeedmmsEditField.Value)
    app.TotalVerticalMovementmmEditField.Value = app.TotalVerticalMovementmmEditField.Value + desiredMovementV_mm;
    err = 1;
    verWaitTime_s = abs(desiredMovementV_mm/app.VerticalSpeedmmsEditField.Value);
    return;
elseif desiredMovementV_mm == 0
    err = 0;
    return;
else
    err = -1;
    return;
end