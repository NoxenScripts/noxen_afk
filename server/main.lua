ESX = nil
ESX = exports['es_extended']:getSharedObject()

local frozenPlayers = {}
local lastRewardTime = {}

local function GiveRandomReward(xPlayer)
    local playerId = xPlayer.source

    local currentTime = os.time()
    if lastRewardTime[playerId] and (currentTime - lastRewardTime[playerId]) < 300 then
        DropPlayer(playerId, "????") -- Passer en ban auto si pas de faux kick
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
            xPlayer.addMoney(amount)
            rewardMessage = string.format("%d$ en espèces", amount)
        else
            xPlayer.addInventoryItem(selectedReward.name, amount)
            local itemLabel = ESX.GetItemLabel(selectedReward.name)
            rewardMessage = string.format("%dx %s", amount, itemLabel)
        end

        lastRewardTime[playerId] = currentTime
        TriggerClientEvent('afk:rewardReceived', playerId, amount, selectedReward.type)
        TriggerClientEvent('esx:showNotification', playerId, string.format(Config.Messages.reward_received, rewardMessage))
        return true
    end

    return false
end

RegisterNetEvent('afk:freezeStats', function()
    local source = source
    local xPlayer = ESX.GetPlayerFromId(source)
    --print("FreezeStats pour", source)

    if xPlayer then
        frozenPlayers[source] = true
        --print("Joueur marqué comme AFK:", source, "FrozenPlayers:", json.encode(frozenPlayers))
    end
end)

RegisterNetEvent('afk:unfreezeStats', function()
    local source = source
    local xPlayer = ESX.GetPlayerFromId(source)
    --print("UnfreezeStats pour", source)

    if xPlayer and frozenPlayers[source] then
        frozenPlayers[source] = nil
        --print("Joueur retiré de l'AFK:", source, "FrozenPlayers:", json.encode(frozenPlayers))
    end
end)

RegisterNetEvent('afk:giveReward', function()
    local source = source
    --print("Réception de afk:giveReward de", source)
    local xPlayer = ESX.GetPlayerFromId(source)
    --print("xPlayer trouvé:", xPlayer ~= nil)
    --print("frozenPlayers pour source:", frozenPlayers[source] ~= nil)

    if xPlayer and frozenPlayers[source] then
        --print("GiveReward pour", source)
        GiveRandomReward(xPlayer)
    else
        --print("Tentative de récompense non autorisée pour", source)
        --print("État frozenPlayers:", json.encode(frozenPlayers))
    end
end)

AddEventHandler('playerDropped', function()
    local source = source
    if frozenPlayers[source] then
        --print("Nettoyage des données pour", source)
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
