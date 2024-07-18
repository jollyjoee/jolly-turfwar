Zones = {
    ["Config"] = {
        debug = false,
        minScore = 600,
    },

    ["Territories"] = {
        [1] = {
            centre = vector3(1467.97, -1507.18, 64.09), 
            pedspawn = vector3(1397.31, -1535.72, 56.73),
            pedheading = 37.61,
            radius = 130.0,
            winner = "neutral",
            occupants = {},
            blip = 437,
            winnerblip = 84,
            name = "El Burro Heights",
            captured = false,
            shop = {
                label = "El Burro Black Market",
                slots = 20,
                items = { 
                    [1] = { name = 'weapon_pistol50', price = 2500, amount = 200, info = {}, type = 'weapon', slot = 1, },
                    [2] = { name = 'weapon_appistol', price = 4000, amount = 200, info = {}, type = 'weapon', slot = 2, },
                    [3] = { name = 'weapon_pistol', price = 1200, amount = 200, info = {}, type = 'weapon', slot = 3, },
                },
            },
        },
        [2] = {
            centre = vector3(61.35, 3687.8, 39.83), 
            pedspawn = vector3(56.59, 3689.86, 38.92),
            pedheading = 323.13,
            radius = 120.0,
            winner = "neutral",
            occupants = {},
            blip = 437,
            winnerblip = 84,
            name = "Stab City",
            captured = false,
            shop = {
                label = "Stab City Black Market",
                slots = 20,
                items = { 
                    [1] = { name = 'heavyarmor', price = 1200, amount = 200, info = {}, type = 'item', slot = 1, },
                    [2] = { name = 'thermite', price = 150, amount = 200, info = {}, type = 'item', slot = 2, },
                    [3] = { name = 'advancedlockpick', price = 150, amount = 200, info = {}, type = 'item', slot = 3, },
                    [4] = { name = 'weapon_pistol', price = 1200, amount = 200, info = {}, type = 'weapon', slot = 4, },
                },
            },
        },
        [3] = {
            centre = vector3(369.81, -2015.8, 23.1), 
            pedspawn = vector3(387.97, -2026.47, 22.4),
            pedheading = 57.73,
            radius = 120.0,
            winner = "neutral",
            occupants = {},
            blip = 437,
            winnerblip = 84,
            name = "Jamestown Street",
            captured = false,
            shop = {
                label = "Jamestown Black Market",
                slots = 20,
                items = { 
                    [1] = { name = 'weapon_pistol', price = 1200, amount = 200, info = {}, type = 'weapon', slot = 1, },
                    [2] = { name = 'pistol_ammo', price = 20, amount = 1000, info = {}, type = 'item', slot = 2, },
                    [3] = { name = 'smg_ammo', price = 300, amount = 1000, info = {}, type = 'item', slot = 3, },
                    [4] = { name = 'rifle_ammo', price = 370, amount = 1000, info = {}, type = 'item', slot = 4, },
                },
            },
        },
        [4] = {
            centre = vector3(-961.02, -1532.41, 5.33), 
            pedspawn = vector3(-961.02, -1532.41, 4.33),
            pedheading = 106.17,
            radius = 120.0,
            winner = "neutral",
            occupants = {},
            blip = 437,
            winnerblip = 84,
            name = "Rub Street",
            captured = false,
            shop = {
                label = "Rub Street Black Market",
                slots = 20,
                items = { 
                    [1] = { name = 'weapon_pistol50', price = 2500, amount = 200, info = {}, type = 'weapon', slot = 1, },
                    [2] = { name = 'coke', price = 1500, amount = 1000, info = {}, type = 'item', slot = 2, },
                    [4] = { name = 'joint', price = 200, amount = 1000, info = {}, type = 'item', slot = 3, },
                    [5] = { name = 'oxy', price = 1000, amount = 1000, info = {}, type = 'item', slot = 4, },
                },
            },
        },
    },

    ["Default"] = { --DO NOT TOUCH
        ["neutral"] = {
            color = 0,
            name = "Turf War",
        },
    },
}
