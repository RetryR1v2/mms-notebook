local vorpCore = exports.vorp_core:GetCore()

RegisterNetEvent('openNotebook',function()
    SetNuiFocus(true, true)

    SendNUIMessage({
        action = 'open'
    })
end)

RegisterNuiCallback('sendMessage',function(data,cb)
    local title = data.title
    local message = data.message
    TriggerServerEvent('saveMessageToDatabase', title, message)
    
    cb({success = true, message = 'Nachricht wurde gespeichert'})
end)

RegisterNuiCallback('close',function(data,cb)
    SetNuiFocus(false, false)

    SendNUIMessage({
        action = 'close'
    })
end)

-- Get Database Message Data

RegisterNuiCallback('readData',function(data,cb)
    local messageData = vorpCore.Callback.TriggerAwait('readDataFromDatabase')
    cb(messageData)
end)

-- Delete Database Entry

RegisterNuiCallback('deleteMessageFromDB',function(data,cb)
    local id = data.id
    local getData = vorpCore.Callback.TriggerAwait('deleteMessageFromDB',id)

    cb(getData)

end)

-- give Message to Player

RegisterNuiCallback('giveMessageToPlayer',function(data,cb)
    local id = data.id
    local userData = vorpCore.Callback.TriggerAwait('giveMessageToPlayer',id)

    cb(userData)
end)

RegisterNuiCallback('giveFinalMessageToPlayer',function(data,cb)
    local id = data.id
    local charID = data.charID
    local name = data.name
    local data = vorpCore.Callback.TriggerAwait('giveFinalMessageToPlayer',id,charID,name)

    cb(data)
end)
