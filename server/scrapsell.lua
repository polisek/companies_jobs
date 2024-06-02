RegisterNetEvent("companies:server:sellscrap")
AddEventHandler("companies:server:sellscrap", function(count)
    local src = source
    if CanTrustPlayer(src) then
        if tonumber(count) >= 1 then
            local playerName = BRIDGE.GetPlayerFullName(src)
            BRIDGE.RemoveItem(src, Config.scrapsell.itemsell, count)
            AddMoneyToCompany(src, Config.scrapsell.priceforone * count, playerName..": Sell scrap")
            BRIDGE.Notify(src, {
                title = locale("script_title"),
                description = 'Prodáno!',
                type = 'inform'
            })
        end
    end
end)
