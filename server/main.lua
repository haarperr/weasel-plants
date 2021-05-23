ESX = nil
Instance = {isReady = false, Plants = {}}


Citizen.CreateThread(function()
	while ESX == nil do
		TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
		Citizen.Wait(0)
	end
end)

RegisterNetEvent("weasel-plants:plantSeed")
AddEventHandler("weasel-plants:plantSeed", function(plant)
    while not Instance.isReady do
        Wait(0)
    end

    plantSeed(plant, source)
end)

RegisterNetEvent("weasel-plants:requestFullSync")
AddEventHandler("weasel-plants:requestFullSync", function()
    TriggerClientEvent("weasel-plants:fullSync", source, Instance.Plants)
end)

RegisterNetEvent("weasel-plants:harvestPlant")
AddEventHandler("weasel-plants:harvestPlant", function(plant)
    harvestPlant(source, plant)
end)

RegisterNetEvent("weasel-plants:updatePlants")
AddEventHandler("weasel-plants:updatePlants", function(clientPlants)
    for x = 1, #clientPlants, 1 do
        for i = 1, #Instance.Plants, 1 do
            if Instance.Plants[i].ID == clientPlants[x] then
                checkForUpdate(Instance.Plants[i])
            end
        end
    end
end)

AddEventHandler('onResourceStart', function(resourceName)
    loadPlants()
    while not Instance.isReady do
        Wait(0)
    end
    TriggerClientEvent("weasel-plants:fullSync", -1, Instance.Plants)
    mainLoop()
end)
  
Instance.insert = function(plant)
    table.insert(Instance.Plants, plant)
end

mainLoop = function()
    Citizen.CreateThread(function() 
        Citizen.Wait(10*60000) -- Every 10 minutes
        for i = 1, #Instance.Plants, 1 do
            checkForUpdate(Instance.Plants[i])
        end
    end)
end