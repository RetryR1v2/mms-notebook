local VORPcore = exports.vorp_core:GetCore()

-----------------------------------------------------------------------
-- version checker
-----------------------------------------------------------------------
local function versionCheckPrint(_type, log)
    local color = _type == 'success' and '^2' or '^1'

    print(('^5['..GetCurrentResourceName()..']%s %s^7'):format(color, log))
end

local function CheckVersion()
    PerformHttpRequest('https://raw.githubusercontent.com/RetryR1v2/mms-notebook/main/version.txt', function(err, text, headers)
        local currentVersion = GetResourceMetadata(GetCurrentResourceName(), 'version')

        if not text then 
            versionCheckPrint('error', 'Currently unable to run a version check.')
            return 
        end

      
        if text == currentVersion then
            versionCheckPrint('success', 'You are running the latest version.')
        else
            versionCheckPrint('error', ('Current Version: %s'):format(currentVersion))
            versionCheckPrint('success', ('Latest Version: %s'):format(text))
            versionCheckPrint('error', ('You are currently running an outdated version, please update to version %s'):format(text))
        end
    end)
end

exports.vorp_inventory:registerUsableItem('notebook', function(data)
    local source = data.source
    TriggerClientEvent('mms-notebook:client:opennotebook',source)
end)



RegisterServerEvent('mms-notebook:server:saveeintrag', function(inputTitel,inputText)
    local src = source
    local Character = VORPcore.getUser(src).getUsedCharacter
    local identifier = Character.identifier
MySQL.insert('INSERT INTO `mms_notebook` (identifier, titel, text) VALUES (?, ?, ?)', {
    identifier, inputTitel, inputText
    }, function(id)
   -- print(id)
    end)
end)

RegisterServerEvent('mms-notebook:server:giveeintrag', function(id , serverId)
    local src = source
    local titel = nil
    local text = nil
    local reciver = serverId
    local ClosestCharacter = VORPcore.getUser(serverId).getUsedCharacter
    local Closestidentifier = ClosestCharacter.identifier
    MySQL.query('SELECT * FROM `mms_notebook` WHERE `id` = ? ', {id}, function(result)
        if result and #result > 0 then
            for i = 1, #result do
                local row = result[i]
                titel = row.titel
                text = row.text
            end
            MySQL.insert('INSERT INTO `mms_notebook` (identifier, titel, text) VALUES (?, ?, ?)', {
                Closestidentifier, titel, text
                }, function(id)
               -- print(id)
            end)
            VORPcore.NotifyTip(src, 'Notiz Weitergegeben!',  5000)
            VORPcore.NotifyTip(reciver, 'Dir wurde eine Notiz zugesteckt!',  5000)
        else
            VORPcore.NotifyTip(src, 'Eintrag mit Id ! ' .. id .. ' nicht Gefunden!',  5000)
        end
    end)
end)


RegisterServerEvent('mms-notebook:server:geteintrag', function()
    local src = source
    local Character = VORPcore.getUser(src).getUsedCharacter
    local identifier = Character.identifier
            exports.oxmysql:execute('SELECT * FROM mms_notebook WHERE identifier = ?', {identifier}, function(mails)
                if mails and #mails > 0 then
                    local eintraege = {}

                    for _, mail in ipairs(mails) do
                        table.insert(eintraege, mail)
                        
                    end
                    TriggerClientEvent('mms-notebook:client:createbuttonspage3', src, eintraege)
                else
                    VORPcore.NotifyTip(src, 'Du hast keine Einträge!',  5000)
            end
        end)
end)
RegisterServerEvent('mms-notebook:server:deleteeintrag', function(id)
    local src = source
    exports.oxmysql:execute('SELECT * FROM mms_notebook WHERE id = ?', {id}, function(result)
        if result ~= nil then
            MySQL.execute('DELETE FROM mms_notebook WHERE id = ?', { id }, function(result)
            end)
            VORPcore.NotifyTip(src, 'Eintrag Gelöscht!',  5000)
        else
            VORPcore.NotifyTip(src, 'Eintrag Existiert nicht!',  5000)
        end
    end)
end)




--------------------------------------------------------------------------------------------------
-- start version check
--------------------------------------------------------------------------------------------------
CheckVersion()