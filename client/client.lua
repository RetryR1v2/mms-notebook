local RSGCore = exports['rsg-core']:GetCoreObject()
local FeatherMenu =  exports['feather-menu'].initiate()


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
        TriggerEvent('mms-notebook:client:geteintrag')
        --NotebookPage3:RouteTo()
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
        Notebook:Close({ })
    else
        RSGCore.Functions.Notify('Du musst deine Eingaben mit Enter bestätigen', 'error')
    end
end)

RegisterNetEvent('mms-notebook:client:geteintrag',function()
    local PlayerData = RSGCore.Functions.GetPlayerData()
    local citizenid = PlayerData.citizenid
    TriggerServerEvent('mms-notebook:server:geteintrag', citizenid)
end)

RegisterNetEvent('mms-notebook:client:youreintrag',function(id,titel,text)
    
    
    print(id)
    print(titel)
    print(text)
    
      
    
     ------ Seite 3 Deine Einträge

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

    for k ,v  in pairs(id,titel) do    ----- Should Create More than 1 Button but overrides them 
    NotebookPage3:RegisterElement('button', {     --- But Creates only 1 Button then Override it with 2 should id 1 id 2 id 3 but overrides the button id1 with id2 
        label = 'ID:  ' ..id[k] .. ' Titel:  ' .. titel[k],
        style = {
        },
    }, function()
        --TriggerEvent('mms-notebook:client'..v,incomingtitel,incomingtext)
    end)

    end
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

RegisterNetEvent('mms-notebook:client:openpage3',function()
    NotebookPage3:RouteTo()
end)


