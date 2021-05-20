Config = {
    Debug = true,
    DrawDistance = 50,
    MinSpace = 2,
    Plants = {
        {
            Name = "Weed Plant",
            Seed = "weed_seed",
            SeedYield = {1, 5},
            Item = "weed",
            MaxAngle = 0.6,
            Stages = {
                {model = `prop_weed_02`, offset = vector3(0,0,-2), time = 60},
                {model = `prop_weed_02`, offset = vector3(0,0,-1.8), time = 60},
                {model = `prop_weed_02`, offset = vector3(0,0,-1.4), time = 60},
                {model = `prop_weed_02`, offset = vector3(0,0,-1), time = 60},
                {model = `prop_weed_01`, offset = vector3(0,0,-1.5), time = 60, yield = {15, 25}},
                {model = `prop_weed_01`, offset = vector3(0,0,-1), time = 520, yield = {20, 30}}
            },
            Soil = {
                [2409420175] = 1.0,
                [3008270349] = 0.8,
                [3833216577] = 1.0,
                [223086562] = 1.1,
                [1333033863] = 0.9,
                [4170197704] = 1.0,
                [3594309083] = 0.8,
                [2461440131] = 0.8,
                [1109728704] = 1.5,
                [2352068586] = 1.1,
                [1144315879] = 0.9,
                [581794674] = 1.1,
                [2128369009] = 0.8,
                [-461750719] = 1.0,
                [-1286696947] = 1.0,
            }
        },
        {
            Name = "Coke Plant",
            Seed = "coke_seed",
            SeedYield = {1, 5},
            Item = "coca_leaf",
            MaxAngle = 0.6,
            Stages = {
                {model = `p_int_jewel_plant_02`, offset = vector3(0,0,-2.3), time = 80},
                {model = `p_int_jewel_plant_02`, offset = vector3(0,0,-2.1), time = 80},
                {model = `p_int_jewel_plant_02`, offset = vector3(0,0,-1.8), time = 80},
                {model = `p_int_jewel_plant_02`, offset = vector3(0,0,-1.6), time = 80},
                {model = `p_int_jewel_plant_02`, offset = vector3(0,0,-1.54), time = 80, yield = {15, 25}},
                {model = `p_int_jewel_plant_02`, offset = vector3(0,0,-1.45), time = 520, yield = {20, 30}}
            },
            Soil = {
                [2409420175] = 1.0,
                [3008270349] = 0.8,
                [3833216577] = 1.0,
                [223086562] = 1.1,
                [1333033863] = 0.9,
                [4170197704] = 1.0,
                [3594309083] = 0.8,
                [2461440131] = 0.8,
                [1109728704] = 1.5,
                [2352068586] = 1.1,
                [1144315879] = 0.9,
                [581794674] = 1.1,
                [2128369009] = 0.8,
                [-461750719] = 1.0,
                [-1286696947] = 1.0,
            }
        }
    }
}
