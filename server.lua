ESX = nil

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

RegisterNetEvent('kParachute:GiveItemParachute')
AddEventHandler('kParachute:GiveItemParachute', function(item)
    local _source = source
    local xPlayer = ESX.GetPlayerFromId(_source)
    local playerMoney = xPlayer.getMoney()

    if playerMoney >= Config.Price then
        xPlayer.addInventoryItem(item, 1)
        TriggerClientEvent('esx:showNotification', source, "Vous avez bien achetez un parachute pour ~g~"..Config.Price.." $")
    else
        TriggerClientEvent('esx:showNotification', source, "Vous n'avez pas assez ~r~d'argent ~s~!")
    end
end)

RegisterNetEvent('kParachute:GiveWeaponsParachute')
AddEventHandler('kParachute:GiveWeaponsParachute', function(weapon)
    local _source = source
    local xPlayer = ESX.GetPlayerFromId(_source)
    local playerMoney = xPlayer.getMoney()

    if playerMoney >= Config.Price then
        TriggerClientEvent('esx:showNotification', source, "Vous avez bien achetez un parachute pour ~g~"..Config.Price.." $")
        xPlayer.addWeapon(weapon, 1)
    else
        TriggerClientEvent('esx:showNotification', source, "Vous n'avez pas assez ~r~d'argent ~s~!")
    end
end)