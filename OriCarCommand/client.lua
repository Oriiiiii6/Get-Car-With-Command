local QBCore = exports['qb-core']:GetCoreObject()

local function GeneratePlate()
    local plate = ""
    for i = 1, 3 do
        plate = plate .. string.char(math.random(65, 90))
    end
    plate = plate .. math.random(100, 999)
    return plate
end

RegisterNetEvent("OriCarCommand:SpawnVehicle")
AddEventHandler("OriCarCommand:SpawnVehicle", function(model, citizenid, defaultGarage)
    QBCore.Functions.SpawnVehicle(model, function(vehicle)
        if not vehicle then
            TriggerEvent('QBCore:Notify', "Vehicle spawn failed.", "error")
            return
        end
        local plate = GeneratePlate()
        local vehicleProps = QBCore.Functions.GetVehicleProperties(vehicle)
        vehicleProps.plate = plate
        SetVehicleNumberPlateText(vehicle, plate)
        vehicleProps.citizenid = citizenid
        TaskWarpPedIntoVehicle(PlayerPedId(), vehicle, -1)
        TriggerServerEvent("OriCarCommand:BuyVehicle", citizenid, vehicleProps, defaultGarage)
        TriggerEvent('QBCore:Notify', "The Vehicle Spawn Enjoy!", "success")
    end, GetEntityCoords(PlayerPedId()), true)
end)
