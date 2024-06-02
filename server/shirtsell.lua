RegisterNetEvent("companies:server:sellshirt")
AddEventHandler("companies:server:sellshirt", function(count)
    local src = source
    if(CanTrustPlayer(src)) then
        if tonumber(count) >= 1 then
            BRIDGE.RemoveItem(src, Config.shirtsell.itemsell, count)
            local playerName = BRIDGE.GetPlayerFullName(src)
            AddMoneyToCompany(src, Config.shirtsell.priceforone * count, playerName..": Prodej oblečení")
            BRIDGE.Notify(src, {
                title = 'Firemní práce',
                description = 'Prodáno! '..count.."x za $" ..Config.shirtsell.priceforone * count.." do vaší firmy.",
                type = 'inform'
            })
        end
    end
end)
