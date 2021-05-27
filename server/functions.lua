
error = function(source, msg)
    TriggerClientEvent('mythic_notify:client:SendAlert', source, { type = 'error', text = msg, length = 4500 })
end

success = function(source, msg)
    TriggerClientEvent('mythic_notify:client:SendAlert', source, { type = 'success', text = msg, length = 4500 })
end

plantSeed = function(plant, source) -- Add plant to DB and to all clients
    local xPlayer = ESX.GetPlayerFromId(source)
    if not xPlayer then return end

    MySQL.Async.insert("INSERT INTO `plants` (`coords`, `type`, `stage`, `soil`) VALUES (@coords, @type, @stage, @soil);",
    {
        ['@coords'] = json.encode(plant.Coords),
        ['@soil'] = plant.Soil,
        ['@stage'] = plant.Stage,
        ['@type'] = plant.Type
    },function(id)
        plant.ID = id
        plant.Time = os.time()
        Instance.insert(plant)
        if Config.Debug then
            print("New plant has been planted at "..plant.Coords.." With a ID of ".. plant.ID)
        end

        xPlayer.removeInventoryItem(Config.Plants[plant.Type].Seed, 1)
        TriggerClientEvent("weasel-plants:addPlant", -1, plant)
    end)
end

loadPlants = function() -- Load all plants from DB
    MySQL.Async.fetchAll("SELECT `id`, `coords`, `type`, `stage`, UNIX_TIMESTAMP(`time`) AS `time`, `soil` FROM `plants`",
    {},function(results)
        for rownum,row in ipairs(results) do
            local coords = json.decode(row.coords)
            local plant = {
                ID = row.id, 
                Coords = vector3(coords.x, coords.y, coords.z),
                Type = row.type, 
                Stage = row.stage, 
                Time = row.time, 
                Soil = row.soil
            }
            Instance.insert(plant)
        end
        Instance.isReady = true
    end)
end

deletePlant = function(plant) -- delete a plant off the face of the earth and then some
    MySQL.Async.execute("DELETE FROM `plants` WHERE id = @id",
    {
        ['@id'] = plant.ID 
    },function(affectedRows)
        for i = 1, #Instance.Plants, 1 do
            if Instance.Plants[i].ID == plant.ID then
                table.remove( Instance.Plants, i)
                TriggerClientEvent("weasel-plants:removePlant", -1, plant)
                break
            end
        end
    end)
end

harvestPlant = function(source, plant) -- server function to harvest a plant
    local xPlayer = ESX.GetPlayerFromId(source)
    if xPlayer == nil then return end
    
    deletePlant(plant)
    if Config.Plants[plant.Type].Stages[plant.Stage].yield then
        success(source, "You harvested a ".. Config.Plants[plant.Type].Name)
        xPlayer.addInventoryItem(Config.Plants[plant.Type].Item, math.random(Config.Plants[plant.Type].Stages[plant.Stage].yield[1], Config.Plants[plant.Type].Stages[plant.Stage].yield[2]))
        xPlayer.addInventoryItem(Config.Plants[plant.Type].Seed, math.random(Config.Plants[plant.Type].SeedYield[1], Config.Plants[plant.Type].SeedYield[2]))
    else
        print("Plant destroyed at stage: "..plant.Stage.." with type: "..plant.Type.." by ID:"..source)
        success(source, "You destroyed a ".. Config.Plants[plant.Type].Name)
    end
end

checkForUpdate = function(plant)
    if plant == nil then return end
    local now = os.time()
    local plantConfig = Config.Plants[plant.Type]
    local plantStage = plantConfig.Stages[plant.Stage]
    if plantStage == nil then return end
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

updatePlant = function(plant)
    MySQL.Async.execute("UPDATE `plants` SET `stage`=@stage WHERE id = @id;",
    {
        ['@stage'] = plant.Stage,
        ['@id'] = plant.ID
    },function(affectedRows)
        TriggerClientEvent("weasel-plants:sync", -1, plant)
    end)
end