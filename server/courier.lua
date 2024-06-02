RegisterNetEvent("companies:server:finishjobCourier")
AddEventHandler("companies:server:finishjobCourier", function(count)
    local src = source
    if(CanTrustPlayer(src)) then
        BRIDGE.RemoveItem(src, Config.scrapsell.itemsell, count)
        local playerName = BRIDGE.GetPlayerFullName(src)
        AddMoneyToCompany(src, Config.scrapsell.priceforone * count, playerName..": Courier")
        BRIDGE.Notify(src, {
            title = locale("script_title"),
            description = locale("jobs_courier_complete"),
            type = 'inform'
        })
    end
end)

--- THIS IS FOR COURIERS
RegisterNetEvent("pls_companies:server:jobCourier:takeBalikos")
AddEventHandler("pls_companies:server:jobCourier:takeBalikos", function(count)
    local src = source
    if(CanTrustPlayer(src)) then
        BRIDGE.AddItem(src, Config.courier.jobItem, 5)
        BRIDGE.Notify(src, {
            title = locale("script_title"),
            description = locale("jobs_courier_complete"),
            type = 'inform'
        })
    end
end)

RegisterNetEvent("pls_companies:server:jobCourier:removeBalikos")
AddEventHandler("pls_companies:server:jobCourier:removeBalikos", function(count)
    local src = source
    if(CanTrustPlayer(src)) then
        BRIDGE.RemoveItem(src, Config.courier.jobItem, 1)
        BRIDGE.Notify(src, {
            title = locale("script_title"),
            description = locale("jobs_courier_complete"),
            type = 'inform'
        })
    end
end)