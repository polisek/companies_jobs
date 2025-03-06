local jobScore = 0
local job_dynamic_data = {
    target = nil,
    blip = nil,
    object = nil,
    jobPos = nil,
}

local RandomObjects = {"ng_proc_food_bag02a", "ng_proc_food_burg01a", "ng_proc_food_chips01a", "ng_proc_food_chips01b", "prop_food_bs_burg3"}

local function GenerateJob()
    local jobPos = Config.cleaner.jobsPos[math.random(1,#Config.cleaner.jobsPos)]
    job_dynamic_data.jobPos = jobPos
    if job_dynamic_data.blip then
        RemoveBlip(job_dynamic_data.blip)
    end
    if job_dynamic_data.target then
        BRIDGE.RemoveSphereTarget(job_dynamic_data.target)
    end

    if job_dynamic_data.object then
        DeleteEntity(job_dynamic_data.object)
    end
    job_dynamic_data.blip = AddBlipForCoord(jobPos.x, jobPos.y, jobPos.z)
    job_dynamic_data.object = CreateObject(joaat(RandomObjects[math.random(1,#RandomObjects )]), jobPos.x, jobPos.y, jobPos.z-1, false, false, false)

    SetBlipSprite(job_dynamic_data.blip, 1)
    SetBlipDisplay(job_dynamic_data.blip, 4) 
    SetBlipScale(job_dynamic_data.blip, 1.0)
    SetBlipColour(job_dynamic_data.blip, 1)
    SetBlipAsShortRange(job_dynamic_data.blip, false) 

    BeginTextCommandSetBlipName("STRING")
    AddTextComponentString("Cleaner")
    EndTextCommandSetBlipName(job_dynamic_data.blip)

    job_dynamic_data.target = BRIDGE.AddSphereTarget({ 
        coords = vector3(jobPos.x, jobPos.y, jobPos.z-1), 
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
                    if lib.progressCircle({
                        duration = 5000,
                        position = 'center',
                        useWhileDead = false,
                        canCancel = true,
                        disable = {
                            car = true,
                        },
                        anim = {
                            dict = 'missheistfbisetup1leadinoutah_1_mcs_1',
                            clip = 'leadin_janitor_idle_action',
                        },
                        prop = {
                            model = `prop_tool_broom`,
                            pos = vec3(0.03, 0.03, 0.02),
                            rot = vec3(90.0, -90.0, 270.5)
                        },
                    }) then 
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
    job_dynamic_data.jobPos = nil
    if job_dynamic_data.blip then
        RemoveBlip(job_dynamic_data.blip)
    end
    if job_dynamic_data.target then
        BRIDGE.RemoveSphereTarget(job_dynamic_data.target)
    end
    if job_dynamic_data.object then
        DeleteEntity(job_dynamic_data.object)
    end
    lib.hideTextUI()
end

BRIDGE.AddSphereTarget({ 
    coords = Config.cleaner.jobStart, 
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
                if CanPlayerCompanyDo("cleaner") then
                    jobScore = 0
                    clearDynamicData()
                    StartJob("cleaner")
                    GenerateJob()
                else
                    BRIDGE.Notify( {
                        title = locale("script_title"),
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
                    if PlayerDoThisJob("cleaner") then
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
                    AddMoneyToPlayerCompany("Cleaner ",jobScore*Config.cleaner.jobPayByOneJob)
                end
                jobScore = 0
                clearDynamicData()
                StopJob("cleaner")
            end,
        }
    },
})

CreateThread(function()
    local playerPed = cache.ped
	while true do
		Wait(700)
        if PlayerDoThisJob("cleaner")  then
            lib.showTextUI('')
            local coords = GetEntityCoords(playerPed)
            if ob_dynamic_data.jobPos then
                lib.showTextUI(string.format("%.1f",#(job_dynamic_data.jobPos - coords)).." m")
            end
        end
    end
end)