local hasHeadphones = false
local headPhones = nil

if Config.Target == 'ox_target' then
    exports.ox_target:addGlobalPlayer({
        {
            icon = 'fas fa-headphones',
            label = Config.Language['target'],
            onSelect = function(data)
                local hasItem = lib.callback.await('wn_headphones:hasItem')
                if not hasItem then
                    Notify("error", "Server", Config.Language['no_item'], icon, 2000)
                    return
                end
                if lib.progressBar({
                    duration = Config.Duration,
                    label = Config.Language['progress'],
                    useWhileDead = false,
                    canCancel = true,
                    disable = {
                        move = true,
                        car = true,
                        combat = true,
                        mouse = false
                    },
                    anim = {
                        dict = "anim@amb@clubhouse@tutorial@bkr_tut_ig3@",
                        clip = 'machinic_loop_mechandplayer',
                    },

                }) then
                    TriggerServerEvent("wn_headphones:muteplayer", GetPlayerServerId(NetworkGetPlayerIndexFromPed(data.entity)))
                end
            end,
            distance = 2,
        }
    })
else
    exports['qb-target']:AddGlobalPlayer({
        options = {
          {
            num = 1,
            type = "client",
            icon = 'fas fa-headphones',
            label = Config.Language['target'],
            targeticon = 'fas fa-headphones',
            onSelect = function(data)
                local hasItem = lib.callback.await('wn_headphones:hasItem')
                if not hasItem then
                    Notify("error", "Server", Config.Language['no_item'], icon, 2000)
                    return
                end
                if lib.progressBar({
                    duration = Config.Duration,
                    label = Config.Language['progress'],
                    useWhileDead = false,
                    canCancel = true,
                    disable = {
                        move = true,
                        car = true,
                        combat = true,
                        mouse = false
                    },
                    anim = {
                        dict = "anim@amb@clubhouse@tutorial@bkr_tut_ig3@",
                        clip = 'machinic_loop_mechandplayer',
                    },

                }) then
                    TriggerServerEvent("wn_headphones:muteplayer", GetPlayerServerId(NetworkGetPlayerIndexFromPed(data.entity)))
                end
            end,
          }
        },
        distance = 2,
      })
end

RegisterNetEvent("wn_headphones:muteplayerC")
AddEventHandler("wn_headphones:muteplayerC", function()
    hasHeadphones = not hasHeadphones
    if hasHeadphones then
        local pedId = cache.ped
        local attachModel = GetHashKey(Config.Props)

        RequestModel(attachModel)
        while not HasModelLoaded(attachModel) do
            Wait(100)
        end
        headPhones = CreateObject(attachModel, 1.0, 1.0, 1.0, 1, 1, 0)
        AttachEntityToEntity(headPhones, pedId, GetPedBoneIndex(pedId, 12844), 0.1, 0.0, 0.0, 10.0, 90.0, 0.0, 1, 1, 0, 0, 2, 1)
        SetEntityCollision(headPhones, false, true)
        EnableSubmix()
    else
        DeleteEntity(headPhones)
        DisableSubmix()
    end
end)

function EnableSubmix()
    SetAudioSubmixEffectRadioFx(0, 0)
    SetAudioSubmixEffectParamInt(0, 0, `default`, 1)
    SetAudioSubmixEffectParamFloat(0, 0, `freq_low`, 1250.0)
    SetAudioSubmixEffectParamFloat(0, 0, `freq_hi`, 8500.0)
    SetAudioSubmixEffectParamFloat(0, 0, `fudge`, 0.5)
    SetAudioSubmixEffectParamFloat(0, 0, `rm_mix`, 19.0)
end

function DisableSubmix()
    SetAudioSubmixEffectRadioFx(0, 0)
end

function Notify(type, title, text, icon, time)
    if Config.Notify == "ESX" then
        ESX.ShowNotification(text)
    elseif Config.Notify == "ox_lib" then
        if type == "success" then
            lib.notify({
                title = title,
                duration = time,
                description = text,
                type = "success"
            })
        elseif type == "inform" then
            lib.notify({
                title = title,
                duration = time,
                description = text,
                type = "inform"
            })
        elseif type == "error" then
            lib.notify({
                title = title,
                duration = time,
                description = text,
                type = "error"
            })
        end
    elseif Config.Notify == "qbcore" then
        if type == "success" then
            QBCore.Functions.Notify(text, "success")
        elseif type == "info" then
            QBCore.Functions.Notify(text, "primary")
        elseif type == "error" then
            QBCore.Functions.Notify(text, "error")
        end
    end
end
