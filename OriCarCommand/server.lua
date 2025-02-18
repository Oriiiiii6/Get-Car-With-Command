local QBCore = exports['qb-core']:GetCoreObject()

QBCore.Commands.Add(Config.Command, "Get a free car!", {}, false, function(source, args)
    local playerId = source
    local player = QBCore.Functions.GetPlayer(playerId)
    if not player then return end
    local citizenid = player.PlayerData.citizenid
    exports.oxmysql:execute('SELECT has_used FROM used_car_commands WHERE identifier = ?', { citizenid }, function(result)
        if result[1] and result[1].has_used then
            TriggerClientEvent('QBCore:Notify', playerId, "You have already received your vehicle.", "error")
            return
        end
        TriggerClientEvent("OriCarCommand:SpawnVehicle", playerId, Config.VehicleToGive, citizenid)
        exports.oxmysql:execute('INSERT INTO used_car_commands (identifier, has_used) VALUES (?, 1) ON DUPLICATE KEY UPDATE has_used = 1', { citizenid })
    end)
end, false)

RegisterCommand("resetVehicles", function(source)
    exports.oxmysql:execute('UPDATE used_car_commands SET has_used = 0', {})
    TriggerClientEvent('QBCore:Notify', source, "Free car usage has been reset.", "success")
end, true)

RegisterNetEvent("OriCarCommand:BuyVehicle")
AddEventHandler("OriCarCommand:BuyVehicle", function(citizenid, vehicleProps, garage)
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    if Player then
        exports.oxmysql:insert('INSERT INTO player_vehicles (citizenid, plate, vehicle, state, garage) VALUES (?, ?, ?, ?, ?)', { citizenid, vehicleProps.plate, json.encode(vehicleProps), 0, garage }, function(insertId)
            if insertId then
                TriggerClientEvent('QBCore:Notify', src, "The Vehicle Spawn Enjoy!", "success")
            else
                TriggerClientEvent('QBCore:Notify', src, "Failed to store your vehicle.", "error")
            end
        end)
    else
        TriggerClientEvent('QBCore:Notify', src, "Player not found.", "error")
    end
end)
