local VORPcore = exports.vorp_core:GetCore()

-- Register Notebook Item

exports.vorp_inventory:registerUsableItem(Config.NotebookItem, function(data)
    local source = data.source
    TriggerClientEvent('mms-notebook:client:opennotebook',source)
end)

-- Create New Entry in Database

RegisterServerEvent('mms-notebook:server:saveeintrag', function(inputTitel,inputText)
    local src = source
    local Character = VORPcore.getUser(src).getUsedCharacter
    local identifier = Character.identifier
    local charIdent = Character.charIdentifier
    local Name = Character.firstname .. ' ' .. Character.lastname
    MySQL.insert('INSERT INTO `mms_notebook` (identifier,charidentifier, creator, titel, text) VALUES (?, ?, ?, ?, ?)',
    {identifier, charIdent, Name, inputTitel, inputText}, function() end)
end)

-- Get Entrys from DB

RegisterServerEvent('mms-notebook:server:GetEntrys', function()
    local src = source
    local Character = VORPcore.getUser(src).getUsedCharacter
    local charIdent = Character.charIdentifier
    local YourEntrys = MySQL.query.await("SELECT * FROM mms_notebook WHERE charidentifier=@charidentifier", { ["charidentifier"] = charIdent})
    if #YourEntrys > 0 then
        TriggerClientEvent('mms-notebook:client:ReciveEntrys', src, YourEntrys)
    else
        VORPcore.NotifyTip(src, 'Du hast keine Einträge!',  5000)
    end
end)

-- Edit Entry

RegisterServerEvent('mms-notebook:server:EditEntry', function(CurrentEntry , inputText)
    MySQL.update('UPDATE `mms_notebook` SET text = ?  WHERE id = ?',{inputText, CurrentEntry.id})
end)

-- Delete Entry

RegisterServerEvent('mms-notebook:server:DeleteEntry', function(CurrentEntry)
    local src = source
    MySQL.execute('DELETE FROM mms_notebook WHERE id = ?', { CurrentEntry.id }, function()end)
    VORPcore.NotifyTip(src, _U('EntryDeleted'),  5000)
end)

-- GiveEntry

RegisterServerEvent('mms-notebook:server:GetClosestPlayer',function(CurrentEntry)
    local src = source
    local ClosestCharacters = {}
    local myPed = GetPlayerPed(src)
    local myCoords = GetEntityCoords(myPed)
    for h,v in ipairs(GetPlayers()) do
        local PlayerPed = GetPlayerPed(v)
        local PlayerCoords = GetEntityCoords(PlayerPed)
        local Distance = #(myCoords - PlayerCoords)
        if Distance > - 0.3 and Distance < 15 then
            local CloseCharacter = VORPcore.getUser(v).getUsedCharacter
            local CloseName = CloseCharacter.firstname .. ' ' .. CloseCharacter.lastname
            local PlayerData = { Name = CloseName, ServerID = v }
            table.insert(ClosestCharacters,PlayerData)
        end
    end
    TriggerClientEvent('mms-notebook:client:GiveEntry',src,ClosestCharacters,CurrentEntry)
end)

RegisterServerEvent('mms-notebook:server:GiveEntryToPlayer',function(CurrentEntry,CloseChar)
    local src = source
    local CloseCharacter = VORPcore.getUser(CloseChar.ServerID).getUsedCharacter
    local CloseIdentifier = CloseCharacter.identifier
    local CharIdent = CloseCharacter.charIdentifier
    MySQL.insert('INSERT INTO `mms_notebook` (identifier,charidentifier, creator, titel, text) VALUES (?, ?, ?, ?, ?)',
    {CloseIdentifier, CharIdent, CurrentEntry.creator, CurrentEntry.titel, CurrentEntry.text}, function() end)
    VORPcore.NotifyTip(src, 'Notiz Weitergegeben!',  5000)
    VORPcore.NotifyTip(CloseChar.ServerID, 'Dir wurde eine Notiz zugesteckt!',  5000)
end)
