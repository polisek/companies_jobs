BRIDGE.AddSphereTarget({ 
    coords = Config.cigarsell.pos, 
    radius = 1,  
    options = {  
        {
            name = 'sphere',
            icon = 'fa-solid fa-user',
            label = locale("jobs_sell_cigaretes"),
            canInteract = function(entity, distance, coords, name, bone)
                return not PlayerDoJob() 
            end,
            onSelect = function(data) 
                if CanPlayerCompanyDo("redwoodparner") then
                    local input = lib.inputDialog(locale("jobs_how_much_you_want_sell"), {locale("jobs_enter_count"), })
                    local count = BRIDGE.GetItemCount(Config.cigarsell.itemsell)
                    if count >= tonumber(input[1]) then
                        TriggerSecureEvent("companies:server:sellcigar",input[1])
                    else
                        BRIDGE.Notify( {
                            title = locale("script_title"),
                            description = locale("jobs_you_dont_have_required_count"),
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
