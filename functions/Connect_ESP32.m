function Connect_ESP32(app)

Used for ESP32 Controller
serialPortList = seriallist;
if (isempty(serialPortList))
    msgbox('No Available Serial Ports');
else
    [selectedPort,~] = listdlg('PromptString','Select Serial Port:',...
        'SelectionMode','single',...
        'ListString',serialPortList);
    app.serialPortActuator = serial(serialPortList(selectedPort),'BaudRate',115200);
    fopen(app.serialPortActuator);
    app.ActuatorConnectionStatusLamp.Color = 'green';
    app.isActuatorConnected = true;
end