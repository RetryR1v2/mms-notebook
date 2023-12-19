local RSGCore = exports['rsg-core']:GetCoreObject()

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


RSGCore.Functions.CreateUseableItem('notebook', function(source, item)
    local src = source
    local Player = RSGCore.Functions.GetPlayer(src)
    Player = RSGCore.Functions.GetPlayer(source)
    if Player.Functions.RemoveItem('notebook', 1) then
        TriggerClientEvent('mms-notebook:client:opennotebook', source, 'notebook')
        Player.Functions.AddItem('notebook', 1)
    end
end)

RegisterServerEvent('mms-notebook:server:saveeintrag', function(citizenid,inputTitel,inputText)
MySQL.insert('INSERT INTO `mms_notebook` (citizenid, titel, text) VALUES (?, ?, ?)', {
    citizenid, inputTitel, inputText
    }, function(id)
   -- print(id)
    end)
end)

RegisterServerEvent('mms-notebook:server:geteintrag', function(citizenid)
    local src = source
            exports.oxmysql:execute('SELECT * FROM mms_notebook WHERE citizenid = ?', {citizenid}, function(mails)
                if mails and #mails > 0 then
                    local eintraege = {}

                    for _, mail in ipairs(mails) do
                        table.insert(eintraege, mail)
                        
                    end
                    TriggerClientEvent('mms-notebook:client:createbuttonspage3', src, eintraege)
                else
            RSGCore.Functions.Notify(src, 'Du hast keine Einträge!', 'error', 5000)
            end
        end)
end)
RegisterServerEvent('mms-notebook:server:deleteeintrag', function(id)
    local src = source
    exports.oxmysql:execute('SELECT * FROM mms_notebook WHERE id = ?', {id}, function(result)
        if result ~= nil then
            MySQL.execute('DELETE FROM mms_notebook WHERE id = ?', { id }, function(result)
            end)
            RSGCore.Functions.Notify(src, 'Eintrag Gelöscht!', 'error', 5000)
        else
            RSGCore.Functions.Notify(src, 'Eintrag Existiert nicht!', 'error', 5000)
        end
    
        end)
end)




--------------------------------------------------------------------------------------------------
-- start version check
--------------------------------------------------------------------------------------------------
CheckVersion()