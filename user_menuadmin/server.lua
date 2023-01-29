ESX = nil


TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

-- menu de admin by shr

ESX.RegisterServerCallback('admin:grupo', function(source, cb)
    local xPlayer = ESX.GetPlayerFromId(source)
    local grupo = xPlayer.getGroup()
    cb(grupo)
end)