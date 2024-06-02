

Config.FieldsLoadTime = 5000
Config.FieldsDistanceLoad = 50.0


Config.Fields = {
    {
        label="Cotton field",
        pos = vector3(2346.1650, 4616.8052, 34.5884),
        spawnModel = "h4_prop_tree_frangipani_med_01",
        spawnLimit = 10,
        spawnRadius = 30.0,
        recivieItem = "cotton",
        count = {
            min = 1,
            max = 3,
        }
    },

    {
        label="Tobbaco field",
        pos = vector3(780.6815, 3143.5151, 43.4126),
        spawnModel = "prop_plant_01a",
        spawnRadius = 25.0,
        spawnLimit = 10,
        recivieItem = "tobbaco_leaf",
        count = {
            min = 1,
            max = 2,
        }
    },
    --[[
    {
        label="Barley field",
        pos = vector3(2916.6855, 507.1559, 39.5250),
        spawnModel = "prop_plant_cane_01a",
        spawnRadius = 30.0,
        spawnLimit = 10,
        recivieItem = "barley",
        count = {
            min = 1,
            max = 2,
        }
    },
    ]]--


    ----- ILEGAL SHIT
    {
        label="Weed field",
        pos = vector3(5342.5898, -5247.1162, 32.4545),
        spawnModel = "prop_weed_02",
        spawnRadius = 25.0,
        spawnLimit = 10,
        recivieItem = "weed_seed",
        count = {
            min = 1,
            max = 2,
        }
    },

}