Config = {}

Config.core = 'QB' -- ESX or QB
Config.debug = false -- true or false

-- AFK Peds Coords (You can add more peds if you want)
Config.AfkPeds = { 
    {
        model = "a_m_m_soucent_01",
        coords = vector3(1095.1377, 2633.0056, 38.0120-0.97), -- Route 68
        heading = 92.0273,
        name = "AFK Point Route 68"
    },
    {
        model = "a_m_m_soucent_03",
        coords = vector3(694.3072, 73.7141, 83.8567), -- Bennys 
        heading = 116.3604,
        name = "AFK Point Bennys"
    },
    {
        model = "a_m_m_soucent_01",
        coords = vector3(-1821.2596, -405.3518, 46.6492), -- Hospital
        heading = 139.0503,
        name = "AFK Point Hospital"
    },
    {
        model = "a_m_m_soucent_03",
        coords = vector3(-1253.8062744141, -1535.2080078125, 4.29620885849), -- Beach
        heading = 82.033973693848,
        name = "AFK Point Beach"
    },
    {
        model = "a_m_m_soucent_03",
        coords = vector3(136.57731628418, 6643.2241210938, 31.741104125977), -- Paleto
        heading = 225.60958862305,
        name = "AFK Point Paleto"
    },
    {
        model = "a_m_m_soucent_01",
        coords = vector3(-306.8768, 7073.5747, 12.1890), -- Roxwood
        heading = 274.0924,
        name = "AFK Point Roxwood"
    }
}

-- AFK Zones Coords (You can add more zones if you want)
Config.AfkZones = { 
    main = {
        coords = vector3(-1266.0729, -3013.6370, -46.8537),
        heading = 0.0,
        ipl = "ba_int_placement_ba_interior_0_dlc_int_01_ba_milo_",
        name = "VIP AFK Zone"
    }
}

-- AFK Exit Crash Coords (You can add more crash if you want)
Config.AfkExitCrash = { 
    coords = vector4(256.7451171875, -784.67425537109, 30.492626190186, 60.892784118652),
}

-- AFK Exit Ped Configuration (Doctor sitting on chair in AFK zone)
Config.AfkExitPed = {
    exactCoords = vector3(-1267.0229, -3009.6909, -48.4902),  -- Position of the exit ped
    exactHeading = 102.4224,                                   -- Heading direction
    pedModel = "s_m_m_doctor_01",                             -- Ped model (doctor)
    chairModel = "prop_chair_01a"                             -- Chair model
}

-- Rewards (You can add more rewards if you want)
Config.Rewards = { 
    {
        type = "money",
        min = 100,
        max = 300,
        chance = 85  -- 85% chance to get money
    },
    {
        type = "item",
        items = {
            {name = "beer", min = 1, max = 2, chance = 15},  -- 15% chance to get an item
        }
    }
}

Config.RewardInterval = 10 -- Reward interval in minutes
Config.TeleportDelay = 1 -- Teleport delay in minutes

-- UI Position Configuration
Config.UI = {
    timer = {
        bottom = "18.75vw",  -- Position from bottom
        left = "0.73vw"      -- Position from left
    }
}

-- Translations
Config.Messages = {
    afk = "AFK",
    reward = "REWARD IN",
    teleport_city = "Vous avez été téléporté en ville",
    starting_afk = "You will be teleported to the AFK zone in 1 minute...",
    teleported = "You are now in AFK mode",
    reward_received = "You received %s",
    stopped_afk = "You are no longer in AFK mode",
    point_gps = "~g~GPS ~w~point created to the nearest AFK zone",
    no_afk_zone = "No ~r~AFK zone ~w~found",
    already_afk = "You are already in AFK mode",
    afk_exit_blip = "A ~g~doctor~s~ is sitting on a chair. Talk to him to exit the AFK zone.",
    your_died = "You died, you're left the AFK zone",
    money_reward = "%d$ in cash",
    quit_afk = "Leave AFK ~b~[E]~s~",
    zone_afk = "AFK Zone ~b~[E]~s~",
    return_city = "Return to city ~b~[E]~s~"
} 

-- Debug Print
function DebugPrint(text, ...)
    if Config.debug then
        print(text, ...)
    end
end