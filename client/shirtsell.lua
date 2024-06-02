
BRIDGE.AddSphereTarget({ 
    coords = Config.shirtsell.pos, 
    radius = 1,  
    options = {  
        {
            name = 'sphere',
            icon = 'fa-solid fa-user',
            label = locale("jobs_sell_shirt"),
            canInteract = function(entity, distance, coords, name, bone)
                return not PlayerDoJob() 
            end,
            onSelect = function(data) 
                if CanPlayerCompanyDo("cottonsell") then
                    local input = lib.inputDialog('Sell shirt', {'Enter count', })
                    local count = BRIDGE.GetItemCount(Config.shirtsell.itemsell)
                    if count >= tonumber(input[1]) then
                        TriggerSecureEvent("companies:server:sellshirt",input[1])
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
                        title = locales("script_title"),
                        description = locale("jobs_your_company_cant_do_this"),
                        type = 'inform'
                    })
                end
            end,
        }
    },
})
