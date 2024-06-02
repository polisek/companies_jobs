local jobScore = 0
local job_dynamic_data = {
    target = nil,
    blip = nil,
}


local function GenerateJob()
    local jobPos = Config.windowcleaner.jobsPos[math.random(1,#Config.windowcleaner.jobsPos)]

    if job_dynamic_data.blip then
        RemoveBlip(job_dynamic_data.blip)
    end
    if job_dynamic_data.target then
        BRIDGE.RemoveSphereTarget(job_dynamic_data.target)
    end

    job_dynamic_data.blip = AddBlipForCoord(jobPos.x, jobPos.y, jobPos.z)

    SetBlipSprite(job_dynamic_data.blip, 1)
    SetBlipDisplay(job_dynamic_data.blip, 4) 
    SetBlipScale(job_dynamic_data.blip, 1.0)
    SetBlipColour(job_dynamic_data.blip, 1)
    SetBlipAsShortRange(job_dynamic_data.blip, false) 

    BeginTextCommandSetBlipName("STRING")
    AddTextComponentString("Job - Firma")
    EndTextCommandSetBlipName(job_dynamic_data.blip)

    job_dynamic_data.target = BRIDGE.AddSphereTarget({ 
        coords = vector3(jobPos.x, jobPos.y, jobPos.z), 
        radius = 1,  
        options = {  
            {
                name = 'sphere',
                icon = 'fa-solid fa-user',
                label = locale("jobs_cleaner"),
                canInteract = function(entity, distance, coords, name, bone)
                    return PlayerDoJob() 
                end,
                onSelect = function(data) 
                    TaskStartScenarioInPlace(cache.ped, "WORLD_HUMAN_MAID_CLEAN", 0, true)
                    local success = lib.skillCheck({'easy', 'easy','medium','easy'})
                    if success then
                        ClearPedTasks(cache.ped)
                        jobScore = jobScore + 1
                        GenerateJob()
                    else
                        ClearPedTasks(cache.ped)
                    end
                end,
            }
        },
    })
    
    BRIDGE.Notify( {
        title = locale("script_title"),
        description = locale("jobs_marked_on_map"),
        type = 'inform'
    })
    
end

local function clearDynamicData()
    if job_dynamic_data.blip then
        RemoveBlip(job_dynamic_data.blip)
    end
    if job_dynamic_data.target then
        BRIDGE.RemoveSphereTarget(job_dynamic_data.target)
    end
end

BRIDGE.AddSphereTarget({ 
    coords = Config.windowcleaner.jobStart, 
    radius = 1,  
    options = {  
        {
            name = 'sphere',
            icon = 'fa-solid fa-user',
            label = locale("jobs_start_work"),
            canInteract = function(entity, distance, coords, name, bone)
                return not PlayerDoJob() 
            end,
            onSelect = function(data) 
                if CanPlayerCompanyDo("windowcleaner") then
                    jobScore = 0
                    clearDynamicData()
                    StartJob("windowcleaner")
                    GenerateJob()
                else
                    BRIDGE.Notify( {
                        title = locales("script_title"),
                        description = locale("jobs_your_company_cant_do_this"),
                        type = 'inform'
                    })
                end
            end,
        },
        {
            name = 'sphere',
            icon = 'fa-solid fa-user',
            label = locale("jobs_stop_work"),
            canInteract = function(entity, distance, coords, name, bone)

                if PlayerDoJob() then
                    if PlayerDoThisJob("windowcleaner") then
                        return true
                    end
                end
            end,
            onSelect = function(data) 
                if jobScore == 0 then
                    BRIDGE.Notify( {
                        title = locale("script_title"),
                        description = locale("jobs_you_do_nothing"),
                        type = 'inform'
                    })
                else
                    BRIDGE.Notify( {
                        title = locale("script_title"),
                        description = locale("jobs_courier_complete"),
                        type = 'inform'
                    })
                    AddMoneyToPlayerCompany("Window cleaner",jobScore*Config.windowcleaner.jobPayByOneJob)
                end
                jobScore = 0
                clearDynamicData()
                StopJob("windowcleaner")
            end,
        }
    },
})