function Connect_HSDC(app)

%addpath(genpath(app.HSDC_DLL_Path));
% Load the Automation DLL
if ~libisloaded('HSDCProAutomation_64Bit')
    [notfound,warnings]=loadlibrary('./lib/HSDCProAutomation_64Bit.dll', @HSDCProAutomationHeader);
end

if libisloaded('HSDCProAutomation_64Bit')
    app.HSDCConnectionStatusLamp.Color = 'green';
    app.HSDCScreenTextArea.Value = 'HSDCPro Automation Library Loaded Successfully';
    app.isHSDCloaded = true;
else
    app.HSDCConnectionStatusLamp.Color = 'red';
    app.HSDCScreenTextArea.Value = sprintf('HSDCPro Automation Library Loading Failed\nWarnings: %s\nNot Found = %d',warnings,notfound);
    app.isHSDCloaded = false;
end