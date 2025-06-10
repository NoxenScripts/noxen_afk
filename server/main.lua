if Config.core == "ESX" then
    ESX = exports["es_extended"]:getSharedObject()
elseif Config.core == "QB" then
    QBCore = exports['qb-core']:GetCoreObject()
end

local frozenPlayers = {}
local lastRewardTime = {}

local function GiveRandomReward(xPlayer, sourceId)
    local playerId = sourceId or (Config.core == "ESX" and xPlayer.source or xPlayer.PlayerData.source)
    
    if not playerId then
        DebugPrint("Error: playerId is nil, xPlayer:", xPlayer, "sourceId:", sourceId)
        return false
    end
    
    DebugPrint("playerId: ", playerId)

    local currentTime = os.time()
    local rewardCooldown = (Config.RewardInterval) * 60
    if lastRewardTime[playerId] and (currentTime - lastRewardTime[playerId]) < rewardCooldown then
        DebugPrint("Anti-spam kick for player:", playerId, "Time left:", rewardCooldown - (currentTime - lastRewardTime[playerId]), "seconds")
        DropPlayer(playerId, "Kick Auto - Anti-spam")
        return false
    end

    local totalChance = 0
    local rewards = {}

    if Config.Rewards[1].type == "money" then
        totalChance = totalChance + Config.Rewards[1].chance
        table.insert(rewards, {
            type = "money",
            chance = Config.Rewards[1].chance,
            min = Config.Rewards[1].min,
            max = Config.Rewards[1].max
        })
    end

    for _, item in ipairs(Config.Rewards[2].items) do
        totalChance = totalChance + item.chance
        table.insert(rewards, {
            type = "item",
            name = item.name,
            chance = item.chance,
            min = item.min,
            max = item.max
        })
    end

    local roll = math.random(1, totalChance)
    local currentChance = 0
    local selectedReward = nil

    for _, reward in ipairs(rewards) do
        currentChance = currentChance + reward.chance
        if roll <= currentChance then
            selectedReward = reward
            break
        end
    end

    if selectedReward then
        local amount = math.random(selectedReward.min, selectedReward.max)
        local rewardMessage = ""

        if selectedReward.type == "money" then
            if Config.core == "ESX" then
                xPlayer.addMoney(amount)
            elseif Config.core == "QB" then
                xPlayer.Functions.AddMoney('cash', amount)
            end
            rewardMessage = string.format(Config.Messages.money_reward, amount)
        else
            local itemExists = false
            local itemLabel = selectedReward.name
            
            if Config.core == "ESX" then
                itemLabel = ESX.GetItemLabel(selectedReward.name)
                itemExists = itemLabel ~= nil
                if itemExists then
                    xPlayer.addInventoryItem(selectedReward.name, amount)
                end
            elseif Config.core == "QB" then
                local itemData = QBCore.Shared.Items[selectedReward.name]
                itemExists = itemData ~= nil
                if itemExists then
                    itemLabel = itemData.label
                    xPlayer.Functions.AddItem(selectedReward.name, amount)
                else
                    DebugPrint("Item does not exist in QBCore:", selectedReward.name)
                end
            end
            
            if not itemExists then
                DebugPrint("Skipping invalid item reward:", selectedReward.name)
                return false
            end
            
            rewardMessage = string.format("%dx %s", amount, itemLabel)
        end

        DebugPrint("currentTime: ", currentTime)
        lastRewardTime[playerId] = currentTime
        
        local rewardMsg = Config.Messages and Config.Messages.reward_received or "You have received: %s"
        local finalMessage = string.format(rewardMsg, rewardMessage)
        
        if Config.core == "ESX" then
            TriggerClientEvent('esx:showNotification', playerId, finalMessage)
        elseif Config.core == "QB" then
            TriggerClientEvent('QBCore:Notify', playerId, finalMessage)
        end
        return true
    end

    return false
end

RegisterNetEvent('afk:freezeStats', function()
    local source = source
    local xPlayer = Config.core == "ESX" and ESX.GetPlayerFromId(source) or QBCore.Functions.GetPlayer(source)
    DebugPrint("FreezeStats for player: ", source)

    if xPlayer then
        frozenPlayers[source] = true
        DebugPrint("Player marked as AFK:", source, "FrozenPlayers:", json.encode(frozenPlayers))
    end
end)

RegisterNetEvent('afk:unfreezeStats', function()
    local source = source
    local xPlayer = Config.core == "ESX" and ESX.GetPlayerFromId(source) or QBCore.Functions.GetPlayer(source)
    DebugPrint("UnfreezeStats for player: ", source)

    if xPlayer and frozenPlayers[source] then
        frozenPlayers[source] = nil
        DebugPrint("Player removed from AFK:", source, "FrozenPlayers:", json.encode(frozenPlayers))
    end
end)

RegisterNetEvent('afk:giveReward', function()
    local source = source
    DebugPrint("Received afk:giveReward from: ", source)
    local xPlayer = Config.core == "ESX" and ESX.GetPlayerFromId(source) or QBCore.Functions.GetPlayer(source)
    DebugPrint("xPlayer found: ", xPlayer ~= nil)
    DebugPrint("frozenPlayers for source: ", frozenPlayers[source] ~= nil)

    if xPlayer and frozenPlayers[source] then
        DebugPrint("GiveReward for: ", source)
        DebugPrint("xPlayer.source: ", xPlayer.source)
        GiveRandomReward(xPlayer, source)
    else
        DebugPrint("Attempt to give reward not authorized for: ", source)
        DebugPrint("frozenPlayers stat: ", json.encode(frozenPlayers))
    end
end)

AddEventHandler('playerDropped', function()
    local source = source
    if frozenPlayers[source] then
        DebugPrint("Cleaning data for: ", source)
        frozenPlayers[source] = nil
    end

    if lastRewardTime[source] then
        lastRewardTime[source] = nil
    end
end)

Citizen.CreateThread(function()
    while true do
        for k,v in pairs(frozenPlayers) do
            if GetPlayerPing(k) == 0 then
                frozenPlayers[k] = nil
                if lastRewardTime[k] then
                    lastRewardTime[k] = nil
                end
            end
        end
        Wait(60*1000)
    end
end)
