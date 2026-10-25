-- Passenger Q camera.
--
-- Drivers cycle FPP / TPPClose / TPPMedium / TPPFar through ToggleVehCamera.
-- Passengers need the same native vehicleRequestCameraPerspectiveEvent path --
-- not F7 chase / follow approximations. That cycle lives in redscript
-- (client/redscript/CvPassengerCamera.reds + Open77VehicleCamera.reds).
--
-- This Lua only makes sure we never block VehicleCamera, which would stop the
-- real ToggleVehCamera action from reaching that redscript.

local NATIVE_ACTIONS = {
    "VehicleCamera", "VehicleCam", "CameraVehicle", "CycleCamera",
    "VehicleCinematicCamera", "ToggleVehCamera",
}

local function say(message)
    print("[cv_passenger_camera] " .. message)
    if type(Open77.log) == "table" and type(Open77.log.info) == "function" then
        Open77.log.info("cv_passenger_camera: " .. message)
    end
end

local function setNativeBlocked(blocked)
    if type(Open77.input) ~= "table" then return end
    local setter = Open77.input.setNativeActionBlocked or Open77.input.setActionBlocked
    if type(setter) ~= "function" then return end
    for index = 1, #NATIVE_ACTIONS do
        pcall(setter, NATIVE_ACTIONS[index], blocked == true)
    end
end

AddEventHandler("onClientResourceStart", function(name)
    if name ~= GetCurrentResourceName() then return end
    -- Clear any leftover block from older builds of this resource.
    setNativeBlocked(false)
    say("native vehicle camera left open for passengers (Q = driver angles)")
end)

AddEventHandler("onClientResourceStop", function(name)
    if name ~= GetCurrentResourceName() then return end
    setNativeBlocked(false)
end)
