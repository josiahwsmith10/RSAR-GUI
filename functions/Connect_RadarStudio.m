function Connect_RadarStudio(app)

app.RadarScreenTextArea.Value = "Remember to Choose the Correct Device from the List!";

%% Do TI Work
% Initialize Radarstudio .NET connection
ErrStatus = Init_RSTD_Connection(app.RSTD_DLL_Path); % At Radar Studio v1.9.2.1, there is a bug, so we need to call this fucntion twice
ErrStatus = Init_RSTD_Connection(app.RSTD_DLL_Path);
if (ErrStatus ~= 30000)
    app.RadarScreenTextArea.Value = 'Error inside Init_RSTD_Connection';
    app.RadarConnectionStatusLamp.Color = 'red';
    return;
else
    app.RadarScreenTextArea.Value = 'RSTD connection is successful';
    app.RadarConnectionStatusLamp.Color = 'green';
    app.isTIRadarConnected = true;
end