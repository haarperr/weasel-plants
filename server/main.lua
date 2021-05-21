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

mainLoop = function() -- Scarry server main loop
    Citizen.CreateThread(function() 
        while true do
            Citizen.Wait(0)
            local now = os.time()
            local plantsHandled = 0
            for i = 1, #Instance.Plants, 1 do
                Citizen.Wait(0)
                if plant = nil then break end 
                local plant = Instance.Plants[i] -- all tables in lua are handled as pointers so changes to these local vars will effect main Instance
                local plantConfig = Config.Plants[plant.Type]
                local plantStage = plantConfig.Stages[plant.Stage]
                local growthTime = (plantStage.time * 60)
                local soilQuality = plantConfig.Soil[plant.Soil] or 1.0 -- if not found set to 1.0
                local nextStageTime = plant.Time + growthTime
                if now >= nextStageTime then
                    if plant.Stage < #plantConfig.Stages then
                        plant.Stage = plant.Stage + 1
                        plant.Time = now
                        updatePlant(plant)
                    else
                        deletePlant(plant) -- last stage is death stage
                    end
                end
            end
            Citizen.Wait(1000)
        end
    end)
end