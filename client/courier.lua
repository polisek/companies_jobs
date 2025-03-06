local jobScore = 0
local ox_target = exports.ox_target
local job_dynamic_data = {
    target = nil,
    blip = nil,
}


local function GenerateJob()
    local jobPos = Config.courier.jobsPos[math.random(1,#Config.courier.jobsPos)]

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
    AddTextComponentString(locale("jobs_courier_blip"))
    EndTextCommandSetBlipName(job_dynamic_data.blip)

    job_dynamic_data.target = BRIDGE.AddSphereTarget({ 
        coords = vector3(jobPos.x, jobPos.y, jobPos.z), 
        radius = 1,  
        options = {  
            {
                name = 'sphere',
                icon = 'fa-solid fa-user',
                label = locale("jobs_deliver_to"),
                canInteract = function(entity, distance, coords, name, bone)
                    return PlayerDoJob() 
                end,
                onSelect = function(data) 
                    local count = BRIDGE.GetItemCount(Config.courier.jobItem)
                    if count > 0 then
                        GenerateJob()
                        playAnim()
                        jobScore = jobScore + 1
                        TriggerSecureEvent("pls_companies:server:jobCourier:removeBalikos")
                    else
                        BRIDGE.Notify( {
                            title = locale("script_title"),
                            description = locale("jobs_courier_you_dont_have_items"),
                            type = 'inform'
                        })
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
    coords = Config.courier.jobStart, 
    radius = 1,  
    options = {  
        {
            name = 'sphere',
            icon = 'fa-solid fa-user',
            label = locale("jobs_courier_start_job"),
            canInteract = function(entity, distance, coords, name, bone)
                return not PlayerDoJob() 
            end,
            onSelect = function(data) 
                if CanPlayerCompanyDo("courier") then
                    jobScore = 0
                    clearDynamicData()
                    StartJob("courier")
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
            label = locale("jobs_courier_take_boxes"),
            canInteract = function(entity, distance, coords, name, bone)
                return not PlayerDoJob() 
            end,
            onSelect = function(data) 
                if CanPlayerCompanyDo("courier") then
                    TriggerSecureEvent("pls_companies:server:jobCourier:takeBalikos")
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
            label = locale("jobs_courier_stop_working"),
            canInteract = function(entity, distance, coords, name, bone)

                if PlayerDoJob() then
                    if PlayerDoThisJob("courier") then
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
                    AddMoneyToPlayerCompany("Courier ",jobScore*Config.courier.jobPayByOneJob)
                end
                jobScore = 0
                clearDynamicData()
                StopJob("courier")
            end,
        }
    },
})



function LoadAnimDict( dict )
    while ( not HasAnimDictLoaded( dict ) ) do
        RequestAnimDict( dict )
        Wait( 5 )
    end
  end
  function playAnim()
    local hash = joaat("a_f_m_bodybuild_01")
    if not HasModelLoaded(hash) then
        RequestModel(hash)
        Wait(10)
    end
    while not HasModelLoaded(hash) do 
        Wait(10)
    end
    local heading = GetEntityHeading(cache.ped)
    local playerPos = GetEntityCoords(cache.ped)
    local frontx = GetEntityForwardX(cache.ped)
    local fronty = GetEntityForwardY(cache.ped)
    ped = CreatePed(5, hash, playerPos.x + (frontx), playerPos.y --[[+ (fronty * 1)]], playerPos.z - 1, (heading - 180), true, false)
    SetEntityInvincible(ped, true)
    SetBlockingOfNonTemporaryEvents(ped, true)
    Wait(1000)
    LoadAnimDict("mp_safehouselost@")
    TaskPlayAnim(cache.ped, "mp_safehouselost@", "package_dropoff", 8.0, 1.0, -1, 16, 0, 0, 0, 0 )
    TaskPlayAnim(ped, "mp_safehouselost@", "package_dropoff", 8.0, 1.0, -1, 16, 0, 0, 0, 0 )
    Wait(3000)
    DeleteEntity(ped)
    SetModelAsNoLongerNeeded(hash)
end
