if Config.Framework == "ESX" then
    ESX = exports["es_extended"]:getSharedObject()
    RegisterUsable = ESX.RegisterUsableItem
elseif Config.Framework == "qbcore" then
    QBCore = nil
    QBCore = exports['qb-core']:GetCoreObject()
    RegisterUsable = QBCore.Functions.CreateUseableItem
end

RegisterNetEvent('wn_headphones:muteplayer')
AddEventHandler('wn_headphones:muteplayer', function(player)
    local src = source

    local playerPed = GetPlayerPed(src)
    local targetPed = GetPlayerPed(player)
    local distance = #(GetEntityCoords(playerPed) - GetEntityCoords(targetPed))

    if distance > 15.0 then
        KickCheater(src, "The ped is too far away, the player is cheating (Executor) ^7")
        return false
    end

    TriggerClientEvent('wn_headphones:muteplayerC', player)
end)

RegisterCommand("removeheadphones", function(source, args, rawCommand)
    local src = source
    local player = ""
    
    if not IsAdmin(src) then return end

    for _, v in ipairs(args) do
        player = v
    end

    player = player:match("^%s*(.-)%s*$")

    if player:len() == 0 then 
        return
    end

    if player:match("^%d+$") then
        TriggerClientEvent('wn_headphones:muteplayerC', player)
    end
end)

lib.callback.register('wn_headphones:hasItem', function(source)
    local src = source
    local hasItem = GetItem(Config.Item, 1, src)

    if hasItem then
        return true
    end
    return false
end)

function KickCheater(src, message)
	print("Cheater ".. src .. " " .. message)
    DropPlayer(src, message)
end

function IsAdmin(source)
    local src = source

    if Config.Framework == "ESX" then
        local xPlayer = ESX.GetPlayerFromId(src)
        if xPlayer.getGroup() == "admin" then
            return true
        else
            return false
        end
    elseif Config.Framework == "qbcore" then
        local xPlayer = QBCore.Functions.GetPlayer(src)
        if QBCore.Functions.HasPermission(source, 'admin') then
            return true
        else
            return false
        end
    end
end

function GetItem(name, count, source)
    local src = source

    if Config.Framework == "ESX" then
        local xPlayer = ESX.GetPlayerFromId(src)
        if xPlayer.getInventoryItem(name).count >= count then
            return true
        else
            return false
        end
    elseif Config.Framework == "qbcore" then
        local xPlayer = QBCore.Functions.GetPlayer(src)
        if xPlayer.Functions.GetItemByName(name) ~= nil then
            if xPlayer.Functions.GetItemByName(name).amount >= count then
                return true
            else
                return false
            end
        else
            return false
        end
    end
end
