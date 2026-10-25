-- Passengers cycle the in-car camera with Q using the same native vehicle
-- perspectives as the driver (FPP / close / medium / far).
--
-- The cycle itself is redscript (client/redscript/CvPassengerCamera.reds).
-- Lua only keeps ToggleVehCamera unblocked so that action can fire.
resource "cv_passenger_camera"
version "1.2.0"
open77_version ">=0.0.1"
auto_start true
reload_policy "local"

client_script "client/main.lua"

permissions { "input.actions" }
