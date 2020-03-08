function Connect_AMC4030(app)

% Load the AMC4030 Library
if ~libisloaded('AMC4030')
    loadlibrary('AMC4030.dll', @ComInterfaceHeader);
end

% Establish the communication
calllib('AMC4030','COM_API_SetComType',2);
errorStatus = calllib('AMC4030','COM_API_OpenLink',app.ScannerCOMPort,115200);

if libisloaded('AMC4030') && errorStatus == 1
    app.ActuatorConnectionStatusLamp.Color = 'green';
    app.isActuatorConnected = true;
    app.RadarScreenTextArea.Value = "AMC 4030 Connection Successful!";
end

if errorStatus ~= 1
    app.ActuatorConnectionStatusLamp.Color = 'red';
    app.isActuatorConnected = false;
    app.RadarScreenTextArea.Value = "AMC4030 Connection Failed!";
end