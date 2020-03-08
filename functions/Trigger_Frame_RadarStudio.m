function ErrStatus = Trigger_Frame_RadarStudio()

%% Do TI Work
Lua_String = sprintf('ar1.StartFrame()');
ErrStatus = RtttNetClientAPI.RtttNetClient.SendCommand(Lua_String);