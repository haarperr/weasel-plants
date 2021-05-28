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
    plantSeed(plant, source)
end)

RegisterNetEvent("weasel-plants:requestFullSync")
AddEventHandler("weasel-plants:requestFullSync", function()
    TriggerClientEvent("weasel-plants:fullSync", source, Instance.Plants)
end)

RegisterNetEvent("weasel-plants:harvestPlant")
AddEventHandler("weasel-plants:harvestPlant", function(id)
    harvestPlant(source, id)
end)

RegisterNetEvent("weasel-plants:sell")
AddEventHandler("weasel-plants:sell", function()
	local xPlayer = ESX.GetPlayerFromId(source)
	local tomatoCount = xPlayer.getInventoryItem('tomato')
	local cornCount = xPlayer.getInventoryItem('corn')

    if tomatoCount.count == nil then tomatoCount.count = 0 end
    if cornCount.count == nil then cornCount.count = 0 end

    if tomatoCount.count > 0 then 
        xPlayer.removeInventoryItem('tomato', tomatoCount.count)
        xPlayer.addInventoryItem('money', tomatoCount.count*Config.Prices.tomato)
        
    elseif cornCount.count > 0 then 
        xPlayer.removeInventoryItem('corn', cornCount.count)
        xPlayer.addInventoryItem('money', cornCount.count*Config.Prices.corn)
    else 
        xPlayer.showNotification('You do not have anymore produce')
        xPlayer.exports['mythic_notify']:SendAlert('error', 'You dont have anything to sell')
    end
end)

RegisterNetEvent("weasel-plants:updatePlants")
AddEventHandler("weasel-plants:updatePlants", function(clientPlants)
    for x = 1, #clientPlants, 1 do
        if Instance.Plants[clientPlants[x]] ~= nil then
            checkForUpdate(Instance.Plants[clientPlants[x]])
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
    Instance.Plants[plant.ID] = plant
end

mainLoop = function()
    Citizen.CreateThread(function() 
        Citizen.Wait(10*60000) -- Every 10 minutes
        for i, v in pairs(Instance.Plants) do
            Citizen.Wait(0)
            checkForUpdate(Instance.Plants[i])
        end
    end)
end