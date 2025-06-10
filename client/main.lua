local isInAfk = false
local originalPosition = nil
local currentZone = nil
local controlsThread = nil
local spawnedPeds = {}
local lastInteractionTime = 0
local isProcessingAfk = false
local deathMonitorThread = nil

if Config.core == "ESX" then
    ESX = exports['es_extended']:getSharedObject()
elseif Config.core == "QB" then
    QBCore = exports['qb-core']:GetCoreObject()
end

function StartDisablingControls()
    if controlsThread then
        return
    end

    controlsThread = Citizen.CreateThread(function()
        while isInAfk do
            DisableControlAction(0, 24, true) -- Attaque
            DisableControlAction(0, 25, true) -- Viser
            DisableControlAction(0, 37, true) -- Sélection d'arme
            DisableControlAction(0, 157, true) -- Arme 1
            DisableControlAction(0, 158, true) -- Arme 2
            DisableControlAction(0, 160, true) -- Arme 3
            DisableControlAction(0, 164, true) -- Arme 5
            DisableControlAction(0, 165, true) -- Arme 6
            DisableControlAction(0, 159, true) -- Arme 7
            DisableControlAction(0, 161, true) -- Arme 8
            DisableControlAction(0, 162, true) -- Arme 9
            DisableControlAction(0, 163, true) -- Arme 10
            DisableControlAction(0, 45, true) -- Recharger
            DisableControlAction(0, 140, true) -- Coup de poing
            DisableControlAction(0, 141, true) -- Coup de poing lourd
            DisableControlAction(0, 142, true) -- Coup de pied
            DisableControlAction(0, 143, true) -- Coup de pied lourd

            SetCurrentPedWeapon(PlayerPedId(), GetHashKey("WEAPON_UNARMED"), true)

            Citizen.Wait(0)
        end

        controlsThread = nil
    end)
end

Citizen.CreateThread(function()
    local markerAlpha = 0
    local textAlpha = 0
    local exactCoords = Config.AfkExitPed.exactCoords
    local exactHeading = Config.AfkExitPed.exactHeading
    local chairCoords = vector3(exactCoords.x, exactCoords.y, exactCoords.z - 0.97)
    local afkExitPedId = "afkExitPed"
    local afkExitBlip = nil
    local chair = nil

    while true do
        local sleep = 1500
        local playerPed = PlayerPedId()
        local playerCoords = GetEntityCoords(playerPed)
        local isNearAnyPed = false

        local distance = #(playerCoords - chairCoords)
        
        if distance < 20.0 then
            isNearAnyPed = true
            sleep = 0

            if not spawnedPeds[afkExitPedId] then
                local pedModel = Config.AfkExitPed.pedModel
                local chairModel = Config.AfkExitPed.chairModel
                
                RequestModel(GetHashKey(pedModel))
                while not HasModelLoaded(GetHashKey(pedModel)) do
                    Wait(1)
                end

                RequestModel(GetHashKey(chairModel))
                while not HasModelLoaded(GetHashKey(chairModel)) do
                    Wait(1)
                end

                chair = CreateObject(GetHashKey(chairModel), chairCoords.x, chairCoords.y, chairCoords.z, false, false, false)
                SetEntityHeading(chair, exactHeading + 180)
                FreezeEntityPosition(chair, true)

                local ped = CreatePed(4, GetHashKey(pedModel), chairCoords.x, chairCoords.y, chairCoords.z - 0.97, 0, false, true)
                FreezeEntityPosition(ped, false)
                SetEntityInvincible(ped, true)
                SetBlockingOfNonTemporaryEvents(ped, true)
                TaskStartScenarioAtPosition(ped, "PROP_HUMAN_SEAT_CHAIR", chairCoords.x, chairCoords.y, chairCoords.z + 0.5, exactHeading, -1, true, true)
                
                Citizen.Wait(1000)
                FreezeEntityPosition(ped, true)
                
                afkExitBlip = AddBlipForEntity(ped)
                SetBlipSprite(afkExitBlip, 280)
                SetBlipColour(afkExitBlip, 2)
                SetBlipScale(afkExitBlip, 0.8)
                SetBlipAsShortRange(afkExitBlip, true)
                BeginTextCommandSetBlipName("STRING")
                AddTextComponentString(isInAfk and "Sortie AFK" or "Retour en ville")
                EndTextCommandSetBlipName(afkExitBlip)
                
                spawnedPeds[afkExitPedId] = ped
            end

            if distance <= 10.0 then
                if distance <= 10.0 then
                    markerAlpha = math.min(255, markerAlpha + 5)
                else
                    markerAlpha = math.max(0, markerAlpha - 5)
                end

                if markerAlpha > 0 then
                    local markerRot = GetGameTimer() * 0.1
                    DrawMarker(31, chairCoords.x, chairCoords.y, chairCoords.z + 1.5,
                        0.0, 0.0, 0.0,
                        0.0, 0.0, markerRot,
                        0.4, 0.4, 0.4,
                        66, 135, 245, markerAlpha,
                        false, false, 2, false, nil, nil, false)
                end

                if distance <= 5.0 then
                    textAlpha = math.min(255, textAlpha + 5)
                else
                    textAlpha = math.max(0, textAlpha - 5)
                end

                if textAlpha > 0 then
                    SetDrawOrigin(chairCoords.x, chairCoords.y, chairCoords.z + 1.8, 0)
                    SetTextCentre(true)
                    SetTextFont(4)
                    SetTextScale(0.4, 0.4)
                    SetTextColour(255, 255, 255, textAlpha)
                    BeginTextCommandDisplayText('STRING')
                    AddTextComponentSubstringPlayerName(isInAfk and Config.Messages.quit_afk or Config.Messages.return_city)
                    EndTextCommandDisplayText(0.0, 0.0)
                    ClearDrawOrigin()
                end

                if distance < 3.0 then
                    if IsControlJustReleased(0, 38) then
                        local currentTime = GetGameTimer()
                        if currentTime - lastInteractionTime > 3000 and not isProcessingAfk then
                            lastInteractionTime = currentTime
                            if isInAfk then
                                StopAfk()
                            else
                                local crashCoords = Config.AfkExitCrash.coords
                                SetEntityCoords(playerPed, crashCoords.x, crashCoords.y, crashCoords.z)
                                SetEntityHeading(playerPed, crashCoords.w)
                                if Config.core == "ESX" then
                                    ESX.ShowNotification(Config.Messages.teleport_city)
                                elseif Config.core == "QB" then
                                    QBCore.Functions.Notify(Config.Messages.teleport_city)
                                end
                            end
                        end
                    end
                end
            end
        else
            if spawnedPeds[afkExitPedId] and distance > 20.0 then
                if chair ~= nil then
                    DeleteEntity(chair)
                    chair = nil
                end
                if afkExitBlip ~= nil then
                    RemoveBlip(afkExitBlip)
                    afkExitBlip = nil
                end
                DeleteEntity(spawnedPeds[afkExitPedId])
                spawnedPeds[afkExitPedId] = nil
            end
        end

        for _, pedInfo in ipairs(Config.AfkPeds) do
            local distance = #(playerCoords - pedInfo.coords)
            local pedId = pedInfo.coords.x .. pedInfo.coords.y .. pedInfo.coords.z

            if distance < 20.0 then
                isNearAnyPed = true
                sleep = 0

                if not spawnedPeds[pedId] then
                    RequestModel(GetHashKey(pedInfo.model))
                    while not HasModelLoaded(GetHashKey(pedInfo.model)) do
                        Wait(1)
                    end

                    local ped = CreatePed(4, GetHashKey(pedInfo.model), pedInfo.coords.x, pedInfo.coords.y, pedInfo.coords.z - 1.0, pedInfo.heading, false, true)
                    FreezeEntityPosition(ped, true)
                    SetEntityInvincible(ped, true)
                    SetBlockingOfNonTemporaryEvents(ped, true)
                    spawnedPeds[pedId] = ped
                end

                if distance <= 10.0 then
                    markerAlpha = math.min(255, markerAlpha + 5)
                else
                    markerAlpha = math.max(0, markerAlpha - 5)
                end

                if markerAlpha > 0 then
                    local markerRot = GetGameTimer() * 0.1
                    DrawMarker(31, pedInfo.coords.x, pedInfo.coords.y, pedInfo.coords.z + 1.0,
                        0.0, 0.0, 0.0,
                        0.0, 0.0, markerRot,
                        0.4, 0.4, 0.4,
                        66, 135, 245, markerAlpha,
                        false, false, 2, false, nil, nil, false)
                end

                if distance <= 10.0 then
                    textAlpha = math.min(255, textAlpha + 5)
                else
                    textAlpha = math.max(0, textAlpha - 5)
                end

                if textAlpha > 0 then
                    SetDrawOrigin(pedInfo.coords.x, pedInfo.coords.y, pedInfo.coords.z + 1.3, 0)
                    SetTextCentre(true)
                    SetTextFont(4)
                    SetTextScale(0.4, 0.4)
                    SetTextColour(255, 255, 255, textAlpha)
                    BeginTextCommandDisplayText('STRING')
                    AddTextComponentSubstringPlayerName(isInAfk and Config.Messages.quit_afk or Config.Messages.zone_afk)
                    EndTextCommandDisplayText(0.0, 0.0)
                    ClearDrawOrigin()
                end

                if distance < 5.0 then
                    if IsControlJustReleased(0, 38) then
                        local currentTime = GetGameTimer()
                        if currentTime - lastInteractionTime > 3000 and not isProcessingAfk then
                            lastInteractionTime = currentTime
                            if isInAfk then
                                StopAfk()
                            else
                                StartAfk()
                            end
                        end
                    end
                end
            else
                if spawnedPeds[pedId] then
                    DeleteEntity(spawnedPeds[pedId])
                    spawnedPeds[pedId] = nil
                end
            end
        end

        if not isNearAnyPed then
            markerAlpha = 0
            textAlpha = 0
            sleep = 1500
        end

        Citizen.Wait(sleep)
    end
end)

function StartAfk()
    if not isInAfk and not isProcessingAfk then
        isProcessingAfk = true
        DebugPrint("Starting AFK")
        if Config.core == "ESX" then
            ESX.ShowNotification(Config.Messages.starting_afk)
        elseif Config.core == "QB" then
            QBCore.Functions.Notify(Config.Messages.starting_afk)
        end

        originalPosition = GetEntityCoords(PlayerPedId())

        Citizen.SetTimeout(Config.TeleportDelay * 60 * 1000, function()
            DebugPrint("After teleport delay")
            isInAfk = true
            isProcessingAfk = false
            currentZone = next(Config.AfkZones)
            local zone = Config.AfkZones[currentZone]

            SendNUIMessage({
                type = "fadeOut"
            })

            Citizen.Wait(500)
            EnablePositionSaving(false)
            TriggerServerEvent('afk:freezeStats')
            SetEntityCoords(PlayerPedId(), zone.coords.x, zone.coords.y, zone.coords.z)
            SetEntityHeading(PlayerPedId(), zone.heading)

            SetCurrentPedWeapon(PlayerPedId(), GetHashKey("WEAPON_UNARMED"), true)
            StartDisablingControls()
            StartDeathMonitor()

            exports["pma-voice"]:toggleMutePlayer(true)

            SendNUIMessage({
                type = "showTimer",
                duration = Config.RewardInterval * 60,
                message = Config.Messages.afk,
                reward = Config.Messages.reward,
                position = {
                    bottom = Config.UI.timer.bottom,
                    left = Config.UI.timer.left
                }
            })

            Citizen.Wait(500)

            SendNUIMessage({
                type = "fadeIn"
            })

            if Config.core == "ESX" then
                ESX.ShowNotification(Config.Messages.teleported)
            elseif Config.core == "QB" then
                QBCore.Functions.Notify(Config.Messages.teleported)
            end
            PauseAllStatus(true)

            StartRewardTimer()
        end)
    end
end

function StopAfk()
    if isInAfk and not isProcessingAfk then
        isProcessingAfk = true
        DebugPrint("Stopping AFK")
        SendNUIMessage({
            type = "fadeOut"
        })

        Citizen.Wait(500)

        isInAfk = false
        isProcessingAfk = false
        DebugPrint("isInAfk set to false")
        PauseAllStatus(false)
        TriggerServerEvent('afk:unfreezeStats')
        if originalPosition then
            EnablePositionSaving(true)
            SetEntityCoords(PlayerPedId(), originalPosition.x, originalPosition.y, originalPosition.z)
        end

        exports["pma-voice"]:toggleMutePlayer(false)

        SendNUIMessage({
            type = "hideTimer"
        })
        Citizen.Wait(500)
        SendNUIMessage({
            type = "fadeIn"
        })

        if Config.core == "ESX" then
            ESX.ShowNotification(Config.Messages.stopped_afk)
        elseif Config.core == "QB" then
            QBCore.Functions.Notify(Config.Messages.stopped_afk)
        end
    end
end

function StartRewardTimer()
    DebugPrint("Starting StartRewardTimer")
    Citizen.CreateThread(function()
        DebugPrint("Thread StartRewardTimer created")
        while isInAfk do
            DebugPrint("In StartRewardTimer loop", isInAfk)
            Citizen.Wait(Config.RewardInterval * 60 * 1000)
            if isInAfk then
                DebugPrint("Sending reward")
                TriggerServerEvent('afk:giveReward')

                SendNUIMessage({
                    type = "showTimer",
                    duration = Config.RewardInterval * 60
                })
            end
        end
        DebugPrint("Exiting StartRewardTimer loop")
    end)
end

RegisterNetEvent('afk:rewardReceived')
AddEventHandler('afk:rewardReceived', function(amount, rewardType)
    SendNUIMessage({
        type = "showReward",
        amount = amount,
        rewardType = rewardType
    })
end)

RegisterCommand('afk', function()
    if isInAfk then
        if Config.core == "ESX" then
            ESX.ShowNotification(Config.Messages.already_afk)
        elseif Config.core == "QB" then
            QBCore.Functions.Notify(Config.Messages.already_afk)
        end
        return
    end

    local playerCoords = GetEntityCoords(PlayerPedId())
    local closestPed = nil
    local closestDistance = 999999.0

    for _, pedInfo in ipairs(Config.AfkPeds) do
        local pedCoords = vector3(pedInfo.coords.x, pedInfo.coords.y, pedInfo.coords.z)
        local distance = #(playerCoords - pedCoords)

        if distance < closestDistance then
            closestDistance = distance
            closestPed = pedInfo
        end
    end

    if closestPed then
        SetNewWaypoint(closestPed.coords.x, closestPed.coords.y)
        if Config.core == "ESX" then
            ESX.ShowNotification(Config.Messages.point_gps)
        elseif Config.core == "QB" then
            QBCore.Functions.Notify(Config.Messages.point_gps)
        end
    else
        if Config.core == "ESX" then
            ESX.ShowNotification(Config.Messages.no_afk_zone)
        elseif Config.core == "QB" then
            QBCore.Functions.Notify(Config.Messages.no_afk_zone)
        end
    end
end, false)

RegisterCommand('stopafk', function()
    StopAfk()
end, false)

function StartDeathMonitor()
    if deathMonitorThread then
        return
    end

    deathMonitorThread = Citizen.CreateThread(function()
        while isInAfk do
            local playerPed = PlayerPedId()
            
            if IsEntityDead(playerPed) or IsPedDeadOrDying(playerPed, 1) then
                DebugPrint("Player dead detected, exiting AFK")
                if Config.core == "ESX" then
                    ESX.ShowNotification(Config.Messages.your_died)
                elseif Config.core == "QB" then
                    QBCore.Functions.Notify(Config.Messages.your_died)
                end
                StopAfk()
                break
            end
            
            Citizen.Wait(1000)
        end
        
        deathMonitorThread = nil
    end)
end