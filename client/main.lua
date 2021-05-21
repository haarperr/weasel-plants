ESX = nil
Instance = {Started = false, Plants = {}, ClosePlants = {}}

Citizen.CreateThread(function()
	while ESX == nil do
		TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
		Citizen.Wait(0)
	end
    TriggerServerEvent("weasel-plants:requestFullSync") -- request a full sync on startup
end)


RegisterNetEvent("weasel-plants:plantSeed") -- Triggered when item is used from linden_inventory
AddEventHandler("weasel-plants:plantSeed", function(item) 
    local type = 0
    for i = 1, #Config.Plants, 1 do
        if Config.Plants[i].Seed == item.name then
            type = i
            break
        end
    end
    if type == 0 then
        if Config.Debub then
            print("Unable to find type for seed "..item.name)
        end
        return
    end
    Citizen.Wait(500)
    TriggerEvent("mythic_progbar:client:progress", {
        name = "plant_seed",
        duration = 10000,
        label = "Planting Seed",
        useWhileDead = false,
        canCancel = false,
        controlDisables = {
            disableMovement = true,
            disableCarMovement = true,
            disableMouse = false,
            disableCombat = true,
        },
        animation = {
            animDict = "amb@world_human_gardener_plant@male@base",
            anim = "base",
        }
    }, function(status)
        if not status then
            plantSeed(type)
        end
    end)
end)

RegisterNetEvent("weasel-plants:addPlant") -- addPLant will add a plant to the table
AddEventHandler("weasel-plants:addPlant", function(plant)
    table.insert( Instance.Plants, plant )
end)

RegisterNetEvent("weasel-plants:removePlant") -- RemovePlant will remvoe a plant with a matching id from table and delete its object
AddEventHandler("weasel-plants:removePlant", function(plant)
    for i = 1, #Instance.Plants, 1 do
        if Instance.Plants[i] and Instance.Plants[i].ID == plant.ID then
            DeleteObject(Instance.Plants[i].Object)
            table.remove(Instance.Plants, i)
        end
    end
end)

RegisterNetEvent("weasel-plants:sync") -- sync will just sync 1 plant and delete its object
AddEventHandler("weasel-plants:sync", function(plant)
    for i = 1, #Instance.Plants, 1 do
        if Instance.Plants[i].ID == plant.ID then
            DeleteObject(Instance.Plants[i].Object)
            Instance.Plants[i] = plant
        end
    end
end)

RegisterNetEvent("weasel-plants:fullSync") -- full sync will overwrite the Plants table and start the main loop
AddEventHandler("weasel-plants:fullSync", function(plants)
    Instance.Plants = plants
    mainLoop()
end)

AddEventHandler('onResourceStop', function(resourceName) -- delete all objects when the resource stops
    for i = 1, #Instance.Plants, 1 do
        if Instance.Plants[i].Object ~= nil then
            DeleteObject(Instance.Plants[i].Object)
        end
    end
end)


closeLoop = function() -- close loop, for performance find plants that are close and add them to clsoe plants every 3 secounds
    Citizen.CreateThread(function() 
        while true do
            Citizen.Wait(3000)
            local coords = GetEntityCoords(GetPlayerPed(-1))
            for i = 1, #Instance.Plants, 1 do
                if not Instance.Plants[i] then
                    break
                end

                if not Instance.Plants[i].Close then 
                    local dist = #(Instance.Plants[i].Coords - coords)
                    if dist <= 100 then
                        Instance.Plants[i].Close = true
                        table.insert( Instance.ClosePlants, i )
                    end
                end
            end
        end
    end)
end

mainLoop = function() -- the main loop 
    if Instance.Started then return end -- if main loop already started dont start it again
    Instance.Started = true -- set main loop as started

    closeLoop()

    Citizen.CreateThread(function() 
        while true do
            Wait(0)
            if Instance.ClosePlants and #Instance.ClosePlants > 0 then
                local coords = GetEntityCoords(GetPlayerPed(-1))
                for i = 1, #Instance.ClosePlants, 1 do
                    if not Instance.Plants[Instance.ClosePlants[i]] then
                        table.remove( Instance.ClosePlants, i )
                        Instance.Plants[i].Close = false
                        break
                    end
                    local dist = #(Instance.Plants[Instance.ClosePlants[i]].Coords - coords)

                    if dist > 100 then -- if we are far remove it
                        table.remove( Instance.ClosePlants, i )
                        Instance.Plants[i].Close = false
                        break
                    end

                    if dist <= Config.DrawDistance then
                        if Instance.Plants[Instance.ClosePlants[i]].Object == nil then -- If there is no object for the plant create one
                            addObject(Instance.ClosePlants[i])
                        end
                    else
                        if Instance.Plants[Instance.ClosePlants[i]].Object ~= nil then -- If there is a object for the plant delete it
                            DeleteObject(Instance.Plants[i].Object)
                            Instance.Plants[Instance.ClosePlants[i]].Object = nil
                        end
                    end
                    
                    if dist <= 1.5 and not Instance.Plants[Instance.ClosePlants[i]].Harvesting then
                        DrawMarker(27, Instance.Plants[Instance.ClosePlants[i]].Coords.x, 
                        Instance.Plants[Instance.ClosePlants[i]].Coords.y, 
                        Instance.Plants[Instance.ClosePlants[i]].Coords.z-0.95, 0.0, 0.0, 0.0, 0.0, 180.0, 0.0, 1.0, 1.0, 1.0, 0, 255, 0, 50, false, true, 2, nil, nil, false)

                        if dist <= 0.7 then
                            local infoLoc = vector3(Instance.Plants[Instance.ClosePlants[i]].Coords.x, 
                            Instance.Plants[Instance.ClosePlants[i]].Coords.y, Instance.Plants[Instance.ClosePlants[i]].Coords.z-0.15)

                            DrawText3D(Instance.Plants[Instance.ClosePlants[i]].Coords, 
                            "Stage ~g~"..Instance.Plants[Instance.ClosePlants[i]].Stage.."~w~/"..#Config.Plants[Instance.Plants[Instance.ClosePlants[i]].Type].Stages)

                            DrawText3D(infoLoc, "Press [~g~E~w~] to harvest")
                            if IsControlJustReleased(0, 153) then
                                Instance.Plants[Instance.ClosePlants[i]].Harvesting = true
                                TriggerEvent("mythic_progbar:client:progress", {
                                    name = "harvesting_Plant",
                                    duration = 10000,
                                    label = "Harvesting plant",
                                    useWhileDead = false,
                                    canCancel = false,
                                    controlDisables = {
                                        disableMovement = true,
                                        disableCarMovement = true,
                                        disableMouse = false,
                                        disableCombat = true,
                                    },
                                    animation = {
                                        animDict = "amb@world_human_gardener_plant@male@base",
                                        anim = "base",
                                    }
                                }, function(status)
                                    if not status then
                                        TriggerServerEvent("weasel-plants:harvestPlant", Instance.Plants[Instance.ClosePlants[i]])  -- trigger the server event to harvest a plant   
                                    end
                                end)
                            end
                        end
                    end 
                end
            end
        end
    end)
end