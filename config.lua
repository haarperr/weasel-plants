Config = {
    Debug = true,
    DrawDistance = 50,
    MinSpace = 2,
    FarmersMarketSelling = vector3(1679.35, 4883.26, 42.04),
    Prices = {
        tomato = 2,
        corn   = 8
    },
    Selling = {
        "tomato", "corn"
    },
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
                {model = `prop_weed_01`, offset = vector3(0,0,-1.5), time = 60, yield = {100, 125}},
                {model = `prop_weed_01`, offset = vector3(0,0,-1), time = 520, yield = {130, 160}}
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
                {model = `p_int_jewel_plant_02`, offset = vector3(0,0,-1.54), time = 80, yield = {800, 1000}},
                {model = `p_int_jewel_plant_02`, offset = vector3(0,0,-1.45), time = 520, yield = {1100, 1700}}
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
            Name = "Corn Plant",
            Seed = "corn_seed",
            SeedYield = {0},
            Item = "corn",
            MaxAngle = 0.6,
            Stages = {
                {model = `prop_veg_corn_01`, offset = vector3(0,0,-3.6), time = 30},
                {model = `prop_veg_corn_01`, offset = vector3(0,0,-3.2), time = 30},
                {model = `prop_veg_corn_01`, offset = vector3(0,0,-2.6), time = 30},
                {model = `prop_veg_corn_01`, offset = vector3(0,0,-2.54), time = 30},
                {model = `prop_veg_corn_01`, offset = vector3(0,0,-2.05), time = 520, yield = {2, 5}}
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
            Name = "Tomato Plant",
            Seed = "tomato_seed",
            SeedYield = {1,4},
            Item = "tomato",
            MaxAngle = 0.6,
            Stages = {
                {model = `prop_pot_plant_03a`, offset = vector3(0,0,-3.6), time = 30},
                {model = `prop_pot_plant_03a`, offset = vector3(0,0,-2.98), time = 30},
                {model = `prop_pot_plant_03a`, offset = vector3(0,0,-2.15), time = 520, yield = {2, 8}}
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
