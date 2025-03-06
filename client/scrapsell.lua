
BRIDGE.AddSphereTarget({ 
    coords = Config.scrapsell.pos, 
    radius = 1,  
    options = {  
        {
            name = 'sphere',
            icon = 'fa-solid fa-user',
            label = locale("jobs_sell_scrap"),
            canInteract = function(entity, distance, coords, name, bone)
                return not PlayerDoJob() 
            end,
            onSelect = function(data) 
                if CanPlayerCompanyDo("scrapsell") then
                    local input = lib.inputDialog('Sell scrap', {'Enter count', })
                    local count = BRIDGE.GetItemCount(Config.scrapsell.itemsell)
                    if count >= tonumber(input[1]) then
                        TriggerSecureEvent("companies:server:sellscrap",input[1])
                    else
                        BRIDGE.Notify( {
                            title = locale("script_title"),
                            description = locale("jobs_courier_you_dont_have_items"),
                            type = 'inform'
                        })
                    end
                if not input then return end
                else
                    BRIDGE.Notify( {
                        title = locale("script_title"),
                        description = locale("jobs_your_company_cant_do_this"),
                        type = 'inform'
                    })
                end
            end,
        }
    },
})
