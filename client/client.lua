local RSGCore = exports['rsg-core']:GetCoreObject()
local FeatherMenu =  exports['feather-menu'].initiate()
local eintragabgerufen = 0

RegisterNetEvent('mms-notebook:client:opennotebook',function()
    Notebook:Open({
        startupPage = NotebookPage1,
    })
end)
--- Menu Part

------ Seite 1 Notebook Startseite
Citizen.CreateThread(function()  --- RegisterFeather Menu
    Notebook = FeatherMenu:RegisterMenu('feather:character:notebookmenu', {
        top = '50%',
        left = '50%',
        ['720width'] = '500px',
        ['1080width'] = '600px',
        ['2kwidth'] = '700px',
        ['4kwidth'] = '900px',
        style = {
        },
        contentslot = {
            style = {
                ['height'] = '550px',
                ['min-height'] = '550px'
            }
        },
        draggable = true,
    })
    NotebookPage1 = Notebook:RegisterPage('first:page')
    NotebookPage1:RegisterElement('header', {
        value = 'Notizbuch',
        slot = "header",
        style = {}
    })
    NotebookPage1:RegisterElement('line', {
        slot = "header",
        style = {}
    })
    NotebookPage1:RegisterElement('button', {
        label = "Eintrag schreiben",
        style = {
        },
    }, function()
        NotebookPage2:RouteTo()
    end)
    NotebookPage1:RegisterElement('button', {
        label = "Deine Einträge",
        style = {
        },
    }, function()
        if eintragabgerufen == 1 then
            NotebookPage3:UnRegister()
        TriggerEvent('mms-notebook:client:geteintrag')
        eintragabgerufen = 1
        else
            TriggerEvent('mms-notebook:client:geteintrag')
            eintragabgerufen = 1
        end
    end)
    NotebookPage1:RegisterElement('button', {
        label = "Notizbuch Schließen",
        style = {
        },
    }, function()
        Notebook:Close({ 
        })
    end)
    NotebookPage1:RegisterElement('subheader', {
        value = "Notizbuch",
        slot = "footer",
        style = {}
    })
    NotebookPage1:RegisterElement('line', {
        slot = "footer",
        style = {}
    })


    ------ Seite 2 Eintrag Schreiben

    NotebookPage2 = Notebook:RegisterPage('first:page2')
    NotebookPage2:RegisterElement('header', {
        value = 'Eintrag Schreiben',
        slot = "header",
        style = {}
    })
    NotebookPage2:RegisterElement('line', {
        slot = "header",
        style = {}
    })
    local inputTitel = ''
    NotebookPage2:RegisterElement('input', {
    label = "Eintrag Titel!",
    placeholder = "Titel!",
    persist = false,
    style = {
    }
    }, function(data)
        inputTitel = data.value
    end)
    local inputText = ''
    NotebookPage2:RegisterElement('textarea', {
    label = "Eintrag!",
    placeholder = "Eintrag",
    rows = "7",
    resize = false,
    persist = false,
    style = {
    }
    }, function(data)
    
    inputText = data.value
end)
    NotebookPage2:RegisterElement('button', {
        label = "Eintrag Speichern",
        style = {
        },
    }, function()
            TriggerEvent('mms-notebook:client:saveeintrag',inputTitel,inputText)
            
end)
    NotebookPage2:RegisterElement('button', {
        label = "Zurück zum Notizbuch",
        style = {
        },
    }, function()
        NotebookPage1:RouteTo()
    end)
    NotebookPage2:RegisterElement('button', {
        label = "Notizbuch Schließen",
        style = {
        },
    }, function()
        Notebook:Close({
        })
    end)
    NotebookPage2:RegisterElement('subheader', {
        value = "Eintrag Schreiben",
        slot = "footer",
        style = {}
    })
    NotebookPage2:RegisterElement('line', {
        slot = "footer",
        style = {}
    })

end)

RegisterNetEvent('mms-notebook:client:saveeintrag',function(inputTitel,inputText)
    if inputTitel ~= '' and inputText ~= '' then
        local PlayerData = RSGCore.Functions.GetPlayerData()
        local citizenid = PlayerData.citizenid
        TriggerServerEvent('mms-notebook:server:saveeintrag', citizenid,inputTitel,inputText)
        RSGCore.Functions.Notify('Eintrag Gespeichert!', 'success')
        NotebookPage1:RouteTo()
    else
        RSGCore.Functions.Notify('Du musst deine Eingaben mit Enter bestätigen', 'error')
    end
end)

RegisterNetEvent('mms-notebook:client:geteintrag',function()
    local PlayerData = RSGCore.Functions.GetPlayerData()
    local citizenid = PlayerData.citizenid
    TriggerServerEvent('mms-notebook:server:geteintrag', citizenid)
end)





RegisterNetEvent('mms-notebook:client:createbuttonspage3')
AddEventHandler('mms-notebook:client:createbuttonspage3', function(eintraege)
    NotebookPage3 = Notebook:RegisterPage('first:page3')
    NotebookPage3:RegisterElement('header', {
        value = 'Deine Einträge',
        slot = "header",
        style = {}
    })
    NotebookPage3:RegisterElement('line', {
        slot = "header",
        style = {}
    })
    for _, mail in ipairs(eintraege) do
        local buttonLabel = 'ID:  '.. mail.id ..' Titel:  '.. mail.titel
        pagelabel = mail.titel
        local textlabel = mail.text
        NotebookPage3:RegisterElement('button', {
            label = buttonLabel,
            style = {
                -- Button styling
            }
        }, function()
            Text:update({
                value = mail.text,
                style = {}
            })
        end)
    end
    Text = NotebookPage3:RegisterElement('textdisplay', {
        value = "",
        style = {}
    })
    local inputid = ''
    NotebookPage3:RegisterElement('input', {
    label = "ID!",
    placeholder = "ID",
    persist = false,
    style = {
    }
    }, function(data)
        inputid = data.value
    end)
    NotebookPage3:RegisterElement('button', {
        label = "Eintrag Löschen!",
        style = {
        },
    }, function()
        if inputid ~= nil then
        local id = tonumber(inputid)
        TriggerEvent('mms-notebook:client:deleteeintrag',id)
        Citizen.Wait(500)
        NotebookPage1:RouteTo()
        else
            RSGCore.Functions.Notify('Du musst deine Eingaben mit Enter bestätigen', 'error')
        end
    end)
    NotebookPage3:RegisterElement('button', {
        label = "Zurück zum Notizbuch",
        style = {
        },
    }, function()
        NotebookPage1:RouteTo()
    end)
    NotebookPage3:RegisterElement('button', {
        label = "Notizbuch Schließen",
        style = {
        },
    }, function()
        Notebook:Close({
        })
    end)
    NotebookPage3:RouteTo()
    NotebookPage3:RegisterElement('subheader', {
        value = "Deine Einträge",
        slot = "footer",
        style = {}
    })
    NotebookPage3:RegisterElement('line', {
        slot = "footer",
        style = {}
    })
end)

RegisterNetEvent('mms-notebook:client:GetTextFromDB',function ()
    local PlayerData = RSGCore.Functions.GetPlayerData()
    local citizenid = PlayerData.citizenid
    print('geht')
    TriggerServerEvent('mms-notebook:server:gettext',citizenid)
end)

RegisterNetEvent('mms-notebook:client:deleteeintrag',function(id)
    TriggerServerEvent('mms-notebook:server:deleteeintrag', id)
end)