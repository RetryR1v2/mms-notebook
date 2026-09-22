local vorpCore = exports.vorp_core:GetCore()

--- Register usable Item Notebook

exports.vorp_inventory:registerUsableItem(Config.notebookItem, function(data)
    local src = data.source
    TriggerClientEvent('openNotebook',src)
    exports.vorp_inventory:closeInventory(src)
end)

--- Eintrag Speichern

RegisterNetEvent('saveMessageToDatabase',function(title,message)
    local src = source
    local character = vorpCore.getUser(src).getUsedCharacter
    local charIdentifier = character.charIdentifier
    MySQL.insert('INSERT INTO `mms_notebook` (charID, title, message) VALUES (?, ?, ?)', {charIdentifier,title,message}, function()end)
end)

--- Callbacks ---

vorpCore.Callback.Register('readDataFromDatabase', function(source,cb)
    local src = source
    local character = vorpCore.getUser(src).getUsedCharacter
    local charIdentifier = character.charIdentifier
    MySQL.query('SELECT * FROM mms_notebook WHERE charID = ?', {charIdentifier}, function(messageData)
        if messageData ~= nil and #messageData > 0 then
            cb ({success = true, messageData = messageData})
        else
            cb ({success = false})
        end
    end)
end)

vorpCore.Callback.Register('deleteMessageFromDB', function(source,cb,id)
    local src = source
    MySQL.query('SELECT * FROM mms_notebook WHERE id = ?', {id}, function(result)
        if result ~= nil then
            MySQL.execute('DELETE FROM mms_notebook WHERE id = ?', { id }, function()end)
            cb ({success = true})
        else
            cb ({success = false})
        end
    end)
end)

vorpCore.Callback.Register('giveMessageToPlayer', function(source,cb,id)
    local src = source
    local MyPed = GetPlayerPed(src)
    local MyCoords = GetEntityCoords(MyPed)
    local CloseUsers = {}
    local UserData = {}
    for h,v in ipairs(GetPlayers()) do
        local Ped = GetPlayerPed(v)
        local Coords = GetEntityCoords(Ped)
        local Distance = #(MyCoords - Coords)
        local Chars = vorpCore.getUser(v).getUsedCharacter
        local Name = Chars.firstname .. ' ' .. Chars.lastname
        local charID = Chars.charIdentifier
        UserData = {name = Name, charID = charID}
        if Distance > 0.1 and Distance < 5.0 then
            table.insert(CloseUsers, UserData)
        end
    end
    if #CloseUsers > 0 then
        cb ({success= true, id = id, userData = CloseUsers})
    else
        cb ({success= false})
    end
end)

vorpCore.Callback.Register('giveFinalMessageToPlayer', function(source,cb,id,charID,name)
    local src = source
    MySQL.query('SELECT * FROM mms_notebook WHERE id = ?', {id}, function(messageData)
        if messageData ~= nil then
            MySQL.insert('INSERT INTO `mms_notebook` (charID, title, message) VALUES (?, ?, ?)', {charID,messageData[1].title,messageData[1].message}, function()end)
            cb ({success = true, name = name})
        else
            cb ({success = false})
        end
    end)

end)

vorpCore.Callback.Register('editMessage', function(source,cb,id,title,message)
    local src = source
    MySQL.query('SELECT * FROM mms_notebook WHERE id = ?', {id}, function(result)
        if result ~= nil then
            MySQL.update('UPDATE `mms_notebook` SET title = ? WHERE id = ?',{title, id})
            MySQL.update('UPDATE `mms_notebook` SET message = ? WHERE id = ?',{message, id})
            cb ({success = true})
        else
            cb ({success = false})
        end
    end)
end)