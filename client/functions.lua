error = function(msg)
    exports['mythic_notify']:SendAlert('error', msg)
end

success = function(msg)
    exports['mythic_notify']:SendAlert('success', msg)
end

inform = function(msg)
    exports['mythic_notify']:SendAlert('inform', msg)
end

addObject = function(index) -- Add the plants object to the game
    local model = Config.Plants[Instance.Plants[index].Type].Stages[Instance.Plants[index].Stage].model
    if not model or not IsModelValid(model) then
        Citizen.Trace(tostring(model).." is not a valid model!\n")
        model = `prop_mp_cone_01`
    end
    if not HasModelLoaded(model) then
        RequestModel(model)
        local begin = GetGameTimer()
        while not HasModelLoaded(model) and GetGameTimer() < begin + 2500 do
            Citizen.Wait(0)
        end
    end
    if not HasModelLoaded(model) then
        Citizen.Trace("Failed to load model for growth stage, but will retry shortly!\n")
        Citizen.Wait(2500)
    else
        local offset = Config.Plants[Instance.Plants[index].Type].Stages[Instance.Plants[index].Stage].offset or vector3(0,0,0)
        local object = CreateObject(model, Instance.Plants[index].Coords + offset, false, false, false)
        local heading = math.random(0,359) * 1.0
        SetEntityHeading(object, heading)
        FreezeEntityPosition(object, true)
        SetEntityCollision(object, false, true)
        SetEntityLodDist(object, math.floor(Config.DrawDistance))
        Instance.Plants[index].Object = object
        SetModelAsNoLongerNeeded(model)
    end
end

flatEnough = function(surfaceNormal, type) -- Check if the surface normal is flat enough
    local x = math.abs(surfaceNormal.x)
    local y = math.abs(surfaceNormal.y)
    local z = math.abs(surfaceNormal.z)
    return (
        x <= Config.Plants[type].MaxAngle
        and
        y <= Config.Plants[type].MaxAngle
        and
        z >= 1.0 - Config.Plants[type].MaxAngle
    )
end

DrawText3D = function(coords, text)
    SetDrawOrigin(coords)
    SetTextScale(0.35, 0.35)
    SetTextFont(4)
    SetTextEntry('STRING')
    SetTextCentre(1)
    AddTextComponentString(text)
    DrawText(0.0, 0.0)
    DrawRect(0.0, 0.0125, 0.015 + text:gsub('~.-~', ''):len() / 370, 0.03, 45, 45, 45, 150)
    ClearDrawOrigin()
end

plantSeed = function(type) -- Check for soil type and slope angle before planting a seed and sending it to server.
    local ped = GetPlayerPed(-1)
    for i, v in pairs(Instance.Plants) do -- Check spacing between plants
        if #(Instance.Plants[i].Coords - GetEntityCoords(ped)) <= Config.MinSpace then
            error("Plants need more space!")
            return
        end
    end

    local plant = {
        Type = type,
        Stage = 1,
        Coords = GetEntityCoords(ped)
    }
    local target = GetOffsetFromEntityInWorldCoords(ped, vector3(0,2,-3)) -- What going on here
    local testRay = StartShapeTestRay(GetEntityCoords(ped), target, 17, ped, 7)
    local _, hit, hitLocation, surfaceNormal, material, _ = GetShapeTestResultIncludingMaterial(testRay)

    if hit == 1 then -- Was the material type found?
        if Config.Plants[type].Soil[material] and flatEnough(surfaceNormal, type) then
            plant.Soil = material
            TriggerServerEvent("weasel-plants:plantSeed", plant)
            success("You planted a ".. Config.Plants[type].Name)
        else
            error("You can't plant here")
        end
    else
        if Config.Debug then
            print("Unable to find soil HIT: "..hit)
        end
    end
end