local QBCore = exports['qb-core']:GetCoreObject()

RegisterNetEvent('c2k_apilogs:client:slackSend', function(name, message)
    print("LOGS CLIENT RICEVUTO")
    TriggerServerEvent('c2k_apilogs:server:slackSend', name, message)
end)

local insideVehicle = false

Citizen.CreateThread(function()
    while true do
        Wait(200)
        if IsPedInAnyVehicle(PlayerPedId(), false) and insideVehicle == false then
            local playerId = NetworkGetPlayerIndexFromPed(PlayerPedId())
            local playerName = GetPlayerName(playerId) .. " " .. "[ID: "..GetPlayerServerId(playerId).."]"
            local veicolo = GetVehiclePedIsIn(PlayerPedId())
            local modelloVeicolo = GetDisplayNameFromVehicleModel(GetEntityModel(veicolo)) or "MODELLO SCONOSCIUTO"
            local targaVeicolo = GetVehicleNumberPlateText(veicolo)
            local playerCoords = GetEntityCoords(PlayerPedId())
            TriggerServerEvent("c2k_apilogs:server:slackSend", "veicoli_rubati", playerName.." è entrato in un veicolo. \nMODELLO VEICOLO: "..modelloVeicolo.."\nTARGA VEICOLO: "..targaVeicolo.."\nCOORDINATE: "..playerCoords.x..", "..playerCoords.y..", "..playerCoords.z)
            insideVehicle = true
        elseif not IsPedInAnyVehicle(PlayerPedId(), false) and insideVehicle == true then
            local playerId = NetworkGetPlayerIndexFromPed(PlayerPedId())
            local playerName = GetPlayerName(playerId) .. " " .. "[ID: "..GetPlayerServerId(playerId).."]"
            local veicolo = GetVehiclePedIsIn(PlayerPedId())
            local modelloVeicolo = GetDisplayNameFromVehicleModel(GetEntityModel(veicolo)) or "MODELLO SCONOSCIUTO"
            local targaVeicolo = GetVehicleNumberPlateText(veicolo)
            local playerCoords = GetEntityCoords(PlayerPedId())
            TriggerServerEvent("c2k_apilogs:server:slackSend", "veicoli_rubati", playerName.." è uscito da un veicolo. \nCOORDINATE: "..playerCoords.x..", "..playerCoords.y..", "..playerCoords.z)
            insideVehicle = false
        end
    end
end)