RegisterNetEvent("companies:server:sellcigar")
AddEventHandler("companies:server:sellcigar", function(count)
    local src = source
    if(CanTrustPlayer(src)) then
        if tonumber(count) >= 1 then
            local playerName = BRIDGE.GetPlayerFullName(src)
            BRIDGE.AddItem(src, Config.cigarsell.itemsell, count)
            AddMoneyToCompany(src, Config.cigarsell.priceforone * count, playerName..": Sell cigaretes")
            BRIDGE.Notify(src, {
                title = locale("warehouse"),
                description = 'Done! '..count.."x for $" ..Config.cigarsell.priceforone * count..".",
                type = 'inform'
            })
        end
    end
end)

