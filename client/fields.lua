local spawnedObjects = {}
local ZoneData = {
    inZone = false,
    zone = nil
}
local isBusy = false


AddEventHandler("onResourceStop", function(resource) 
    if resource == GetCurrentResourceName() then
        for _, v in pairs(spawnedObjects) do 
            if v then
                if v.object then
                    DeleteEntity(v.object)
                end
                if v.zone then
                    BRIDGE.RemoveSphereTarget(v.target)
                end
            end
        end
    end
end)

CreateThread(function()
    while true do
        if not ZoneData.zone then
            local playerCoords = GetEntityCoords(cache.ped)
            for _, v in pairs(Config.Fields) do
                if #(playerCoords - v.pos) < Config.FieldsDistanceLoad then
                    ZoneData.zone = v
                end
            end
        else
            local playerCoords = GetEntityCoords(cache.ped)
            if #(playerCoords - ZoneData.zone.pos) <  Config.FieldsDistanceLoad then
                CheckCreatedObject(ZoneData.zone.spawnModel)
            else
                ZoneData.zone = nil
                for _, v in pairs(spawnedObjects) do 
                    if v then
                        if v.object then
                            DeleteEntity(v.object)
                        end
                        if v.zone then
                           BRIDGE.RemoveSphereTarget(v.target)
                        end
                    end
                end
                spawnedObjects = {}
            end
        end
       Wait(Config.FieldsLoadTime) 
    end
end)

local function getRandomCoords(coords, radius)
    local x = coords.x + math.random(-radius, radius)
    local y = coords.y + math.random(-radius, radius)

    local spawnOnPavement = false

    local foundSafeCoords, safeCoords = GetSafeCoordForPed(x, y, coords.z, spawnOnPavement , 16)

    if not foundSafeCoords then 
        local z = 0

        repeat
            local onGround, safeZ = GetGroundZFor_3dCoord(coords)
            if not onGround then
                z = z + 0.1
            end
        until onGround

        safeCoords = vector3(x, y, safeZ)
    end
    return safeCoords
end

local function RemoveFieldPlant(targetID)
    for i, v in pairs(spawnedObjects) do
        if v then
            if v.target then
                if v.target == targetID then
                    BRIDGE.RemoveSphereTarget(v.target)
                    if v.object then
                        DeleteEntity(v.object)
                    end
                    table.remove(spawnedObjects, i)
                end
            end
        end
    end
end

function CheckCreatedObject(model)
    if #spawnedObjects < ZoneData.zone.spawnLimit then
        for i = 1, ZoneData.zone.spawnLimit, 1 do
            if not spawnedObjects[i] then
                local objectID = nil
                local targetID = 0
                local harvestPoint = getRandomCoords(ZoneData.zone.pos, ZoneData.zone.spawnRadius)
                local modelHash = model
                RequestModel(modelHash)
                while not HasModelLoaded(modelHash) do
                    Wait(0)
                end
                if modelHash == "prop_veg_corn_01" then
                        harvestPoint = vector3(harvestPoint.x,harvestPoint.y,harvestPoint.z-1)
                end
                objectID = CreateObject(joaat(modelHash), harvestPoint.x,harvestPoint.y,harvestPoint.z, false, false)
                if objectID ~= 0 then
                    FreezeEntityPosition(objectID, true)
                    PlaceObjectOnGroundProperly(objectID)
                    targetID = BRIDGE.AddSphereTarget({
                        coords = vector3(harvestPoint.x,harvestPoint.y,harvestPoint.z),
                        radius = 1.0,
                        debug = false,
                        options = {
                            {
                                name = 'sphere',
                                icon = 'fa-solid fa-hand',
                                label = locale("take"),
                                onSelect = function()
                                    if not isBusy then
                                        isBusy = true
                                        if lib.progressCircle({
                                            duration = 5000,
                                            position = 'bottom',
                                            useWhileDead = false,
                                            canCancel = true,
                                            anim = {
                                                dict = 'amb@world_human_gardener_plant@female@idle_a',
                                                clip = 'idle_a_female'
                                            },
                                            disable = {
                                                car = true,
                                                move = true,
                                                mouse = false,
                                                combat = true,
                                            },
                                        }) then 
                                            TriggerSecureEvent("pls_moonshine:server:fieldItem",ZoneData.zone)
                                            RemoveFieldPlant(targetID)
                                            isBusy = false
                                        else
                                            isBusy = false
                                        end
                                    end
                                end,
                            },
                        }}
                    )
                    spawnedObjects[i] = {
                        object = objectID,
                        target = targetID
                    }
                else
                    print("SELHÁNÍ SYSTÉMU: Nelze vytvořit objekt " .. modelHash)
                end
                Wait(500)
                
            end

        end
    end
end

