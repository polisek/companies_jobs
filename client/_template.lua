local start_coords = vector3(0,0,0)
BRIDGE.AddSphereTarget({ 
    coords = start_coords, 
    radius = 1,  
    options = {  
        {
            name = 'sphere',
            icon = 'fa-solid fa-user',
            label = 'YOUR TEXT HERE',
            canInteract = function(entity, distance, coords, name, bone)
                return not PlayerDoJob() 
            end,
            onSelect = function(data) 
                TriggerSecureEvent("companies:server:YOUREVENTNAME")
            end,
        },

    },
})