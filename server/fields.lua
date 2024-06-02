RegisterNetEvent("pls_companiees_job_take:server:harvestZone")
AddEventHandler("pls_companiees_job_take:server:harvestZone", function(zoneData)
    local src = source
    if CanTrustPlayer(src) then
        if zoneData then
            if zoneData.recivieItem then
                BRIDGE.AddItem(src, zoneData.recivieItem, math.random(zoneData.count.min, zoneData.count.max))
            end
        end
    end
end)
