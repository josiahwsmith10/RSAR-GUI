function [err,rotWaitTime_s] = Move_Rotational(app,desiredMovementR_deg)
% Outputs
%   1   :   Successful Movement
%   0   :   No Movement Required
%   -1  :   Error in Movement

rotWaitTime_s = 0;

% Do the movement using the AMC4030 Controller
if desiredMovementR_deg ~= 0 && 1 == COM_API_Jog(app.ScannerCOMPort,2,desiredMovementR_deg,app.RotationSpeeddegsEditField.Value)
    app.TotalRotationMovementdegEditField.Value = app.TotalRotationMovementdegEditField.Value + desiredMovementR_deg;
    err = 1;
    rotWaitTime_s = abs(desiredMovementR_deg/app.RotationSpeeddegsEditField.Value);
    return;
elseif desiredMovementR_deg == 0
    err = 0;
    return;
else
    err = -1;
    return;
end