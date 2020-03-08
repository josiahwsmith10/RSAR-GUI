function Disconnect_ESP32(app)

fclose(app.serialPortActuator);
delete(app.serialPortActuator);
app.ActuatorConnectionStatusLamp.Color = 'red';
app.isActuatorConnected = false;