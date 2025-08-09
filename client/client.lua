local VORPcore = exports.vorp_core:GetCore()
local FeatherMenu =  exports['feather-menu'].initiate()

local ReciveEntryPageOpen = false
local EntryOpened = false
local GiveEntryOpened = false

RegisterNetEvent('mms-notebook:client:opennotebook')
    AddEventHandler('mms-notebook:client:opennotebook',function()
    local ped = PlayerPedId()
    Citizen.InvokeNative(0xB31A277C1AC7B7FF, ped, 0, 0, -1169051375, 1, 1, 0, 0)
    --Citizen.InvokeNative(0xB31A277C1AC7B7FF, ped, 0, 0, -919436740, 1, 1, 0, 0)
    Notebook:Open({
        startupPage = NotebookPage1,
    })
end)
--- Menu Part

------ Seite 1 Notebook Startseite
Citizen.CreateThread(function()  --- RegisterFeather Menu
    Notebook = FeatherMenu:RegisterMenu('feather:character:notebookmenu', {
        top = '20%',
        left = '20%',
        ['720width'] = '500px',
        ['1080width'] = '700px',
        ['2kwidth'] = '700px',
        ['4kwidth'] = '800px',
        style = {
            ['border'] = '5px solid orange',
            -- ['background-image'] = 'none',
            ['background-color'] = '#FF8C00'
        },
        contentslot = {
            style = {
                ['height'] = '550px',
                ['min-height'] = '550px'
            }
        },
        draggable = true,
    --canclose = false
}, {
    opened = function()
        --print("MENU OPENED!")
    end,
    closed = function()
        --print("MENU CLOSED!")
    end,
    topage = function(data)
        --print("PAGE CHANGED ", data.pageid)
    end
})
    NotebookPage1 = Notebook:RegisterPage('Page1')
    NotebookPage1:RegisterElement('header', {
        value = _U('NotebookHeader'),
        slot = "header",
        style = {
        ['color'] = 'orange',
        }
    })
    NotebookPage1:RegisterElement('line', {
        slot = "header",
        style = {
        ['color'] = 'orange',
        }
    })
    NotebookPage1:RegisterElement('button', {
        label = _U('NewEntry'),
        style = {
            ['background-color'] = '#FF8C00',
        ['color'] = 'orange',
        ['border-radius'] = '6px'
        },
    }, function()
        NotebookPage2:RouteTo()
    end)
    NotebookPage1:RegisterElement('button', {
        label = _U('YourEntrys'),
        style = {
            ['background-color'] = '#FF8C00',
            ['color'] = 'orange',
            ['border-radius'] = '6px'
        },
    }, function()
        TriggerServerEvent('mms-notebook:server:GetEntrys')
    end)
    NotebookPage1:RegisterElement('button', {
        label = _U('CloseNotebook'),
        style = {
            ['background-color'] = '#FF8C00',
            ['color'] = 'orange',
            ['border-radius'] = '6px'
        },
    }, function()
        Notebook:Close({ 
        })
    end)
    NotebookPage1:RegisterElement('subheader', {
        value = _U('NotebookSubHeader'),
        slot = "footer",
        style = {
        ['color'] = 'orange',
        }
    })
    NotebookPage1:RegisterElement('line', {
        slot = "footer",
        style = {
        ['color'] = 'orange',
        }
    })


    ------ Seite 2 Eintrag Schreiben

    NotebookPage2 = Notebook:RegisterPage('Page2')
    NotebookPage2:RegisterElement('header', {
        value = _U('CreateEntryHeader'),
        slot = "header",
        style = {
        ['color'] = 'orange',
        }
    })
    NotebookPage2:RegisterElement('line', {
        slot = "header",
        style = {
        ['color'] = 'orange',
        }
    })
    local inputTitel = ''
    NotebookPage2:RegisterElement('input', {
    label = _U('CreateEntryLabel'),
    placeholder = '...',
    persist = false,
    style = {
        ['background-color'] = '#FF8C00',
        ['color'] = 'orange',
        ['border-radius'] = '6px'
    }
    }, function(data)
        inputTitel = data.value
    end)
    local inputText = ''
    NotebookPage2:RegisterElement('textarea', {
    label = _U('EntryText'),
    placeholder = '...',
    rows = "7",
    resize = true,
    persist = false,
    style = {
        ['background-color'] = '#FF8C00',
        ['color'] = 'orange',
        ['border-radius'] = '6px'
    }
    }, function(data) 
        inputText = data.value
    end)
    NotebookPage2:RegisterElement('button', {
        label = _U('SaveEntry'),
        style = {
            ['background-color'] = '#FF8C00',
            ['color'] = 'orange',
            ['border-radius'] = '6px'
        },
    }, function()
        if inputTitel ~= '' and inputText ~= '' then
            TriggerServerEvent('mms-notebook:server:saveeintrag', inputTitel,inputText)
            NotebookPage1:RouteTo()
        else
            VORPcore.NotifyTip('Du musst deine Eingaben mit Enter bestätigen', 5000)
        end
    end)
    NotebookPage2:RegisterElement('button', {
        label = _U('Back'),
        style = {
            ['background-color'] = '#FF8C00',
        ['color'] = 'orange',
        ['border-radius'] = '6px'
        },
    }, function()
        NotebookPage1:RouteTo()
    end)
    NotebookPage2:RegisterElement('button', {
        label = _U('CloseNotebook'),
        style = {
            ['background-color'] = '#FF8C00',
        ['color'] = 'orange',
        ['border-radius'] = '6px'
        },
    }, function()
        Notebook:Close({
        })
    end)
    NotebookPage2:RegisterElement('subheader', {
        value = _U('CreateEntrySubHeader'),
        slot = "footer",
        style = {
        ['color'] = 'orange',
        }
    })
    NotebookPage2:RegisterElement('line', {
        slot = "footer",
        style = {
        ['color'] = 'orange',
        }
    })

end)


RegisterNetEvent('mms-notebook:client:ReciveEntrys')
AddEventHandler('mms-notebook:client:ReciveEntrys', function(YourEntrys)
    if not ReciveEntryPageOpen then
        ReciveEntryPageOpen = true
    else
        NotebookPage3:UnRegister()
    end
    NotebookPage3 = Notebook:RegisterPage('Page3')
    NotebookPage3:RegisterElement('header', {
        value = _U('YourEntrysHeader'),
        slot = "header",
        style = {
        ['color'] = 'orange',
        }
    })
    NotebookPage3:RegisterElement('line', {
        slot = "header",
        style = {
        ['color'] = 'orange',
        }
    })
    for h,v in ipairs(YourEntrys) do
        local Buttonlabel = '[ ' .. h .. ' ] ' .. v.titel
        NotebookPage3:RegisterElement('button', {
            label = Buttonlabel,
            style = {
                ['background-color'] = '#FF8C00',
                ['color'] = 'orange',
                ['border-radius'] = '6px'
            },
        }, function()
            local CurrentEntry = v
            TriggerEvent('mms-notebook:client:OpenEntry',CurrentEntry)
        end)
    end
    NotebookPage3:RegisterElement('button', {
        label = _U('Back'),
        style = {
            ['background-color'] = '#FF8C00',
        ['color'] = 'orange',
        ['border-radius'] = '6px'
        },
    }, function()
        NotebookPage1:RouteTo()
    end)
    NotebookPage3:RegisterElement('button', {
        label = _U('CloseNotebook'),
        style = {
            ['background-color'] = '#FF8C00',
        ['color'] = 'orange',
        ['border-radius'] = '6px'
        },
    }, function()
        Notebook:Close({})
    end)
    NotebookPage3:RegisterElement('subheader', {
        value = _U('YourEntrysSubHeader'),
        slot = "footer",
        style = {
        ['color'] = 'orange',
        }
    })
    NotebookPage3:RegisterElement('line', {
        slot = "footer",
        style = {
        ['color'] = 'orange',
        }
    })
    NotebookPage3:RouteTo()
end)



RegisterNetEvent('mms-notebook:client:OpenEntry')
AddEventHandler('mms-notebook:client:OpenEntry', function(CurrentEntry)
    if not EntryOpened then
        EntryOpened = true
    else
        NotebookPage4:UnRegister()
    end
    NotebookPage4 = Notebook:RegisterPage('Page4')
    NotebookPage4:RegisterElement('header', {
        value = CurrentEntry.titel,
        slot = "header",
        style = {
        ['color'] = 'orange',
        }
    })
    NotebookPage4:RegisterElement('line', {
        slot = "header",
        style = {
        ['color'] = 'orange',
        }
    })
    TitelText = NotebookPage4:RegisterElement('textdisplay', {
        value = CurrentEntry.text,
        style = {
            ['font-size'] = '20px',
            ['font-weight'] = 'bold',
            ['color'] = 'orange',
        }
    })
    TitelText = NotebookPage4:RegisterElement('textdisplay', {
        value = _U('EntryFrom') .. CurrentEntry.creator,
        style = {
            ['font-size'] = '20px',
            ['font-weight'] = 'bold',
            ['color'] = 'orange',
        }
    })
    local inputText = ''
    NotebookPage4:RegisterElement('textarea', {
    label = _U('EditEntry'),
    placeholder = '...',
    rows = "4",
    resize = true,
    persist = false,
    style = {
        ['background-color'] = '#FF8C00',
        ['color'] = 'orange',
        ['border-radius'] = '6px'
    }
    }, function(data)
        inputText = data.value
    end)
    NotebookPage4:RegisterElement('button', {
        label = _U('EditEntryButton'),
        style = {
            ['background-color'] = '#FF8C00',
            ['color'] = 'orange',
            ['border-radius'] = '6px'
        },
    }, function()
        TriggerServerEvent('mms-notebook:server:EditEntry',CurrentEntry,inputText)
        NotebookPage1:RouteTo()
    end)
    NotebookPage4:RegisterElement('button', {
        label = _U('GiveEntry'),
        style = {
            ['background-color'] = '#FF8C00',
            ['color'] = 'orange',
            ['border-radius'] = '6px'
        },
    }, function()
        TriggerServerEvent('mms-notebook:server:GetClosestPlayer',CurrentEntry)
    end)
    NotebookPage4:RegisterElement('button', {
        label = _U('DeleteEntry'),
        style = {
            ['background-color'] = '#FF8C00',
            ['color'] = 'orange',
            ['border-radius'] = '6px'
        },
    }, function()
        TriggerServerEvent('mms-notebook:server:DeleteEntry',CurrentEntry)
        NotebookPage1:RouteTo()
    end)
    NotebookPage4:RegisterElement('button', {
        label = _U('Back'),
        style = {
            ['background-color'] = '#FF8C00',
            ['color'] = 'orange',
            ['border-radius'] = '6px'
        },
    }, function()
        NotebookPage1:RouteTo()
    end)
    NotebookPage4:RegisterElement('subheader', {
        value = _U('CurrentEntrysSubHeader'),
        slot = "footer",
        style = {
        ['color'] = 'orange',
        }
    })
    NotebookPage4:RegisterElement('line', {
        slot = "footer",
        style = {
        ['color'] = 'orange',
        }
    })
    NotebookPage4:RouteTo()
end)

RegisterNetEvent('mms-notebook:client:GiveEntry')
AddEventHandler('mms-notebook:client:GiveEntry', function(ClosestCharacters,CurrentEntry)
    if not GiveEntryOpened then
        GiveEntryOpened = true
    else
        NotebookPage5:UnRegister()
    end
    NotebookPage5 = Notebook:RegisterPage('Page5')
    NotebookPage5:RegisterElement('header', {
        value = _U('GiveEntryHeader'),
        slot = "header",
        style = {
        ['color'] = 'orange',
        }
    })
    NotebookPage5:RegisterElement('line', {
        slot = "header",
        style = {
        ['color'] = 'orange',
        }
    })
    for h,v in ipairs(ClosestCharacters) do
        Buttonlabel = _U('GiveTo') .. v.Name
        NotebookPage5:RegisterElement('button', {
            label = Buttonlabel,
            style = {
                ['background-color'] = '#FF8C00',
                ['color'] = 'orange',
                ['border-radius'] = '6px'
            },
        }, function()
            CloseChar = v
            TriggerServerEvent('mms-notebook:server:GiveEntryToPlayer',CurrentEntry,CloseChar)
            NotebookPage1:RouteTo()
        end)
    end
    NotebookPage5:RegisterElement('button', {
        label = _U('Abort'),
        style = {
            ['background-color'] = '#FF8C00',
            ['color'] = 'orange',
            ['border-radius'] = '6px'
        },
    }, function()
        NotebookPage1:RouteTo()
    end)
    NotebookPage5:RegisterElement('subheader', {
        value = _U('GiveEntrySubHeader'),
        slot = "footer",
        style = {
        ['color'] = 'orange',
        }
    })
    NotebookPage5:RegisterElement('line', {
        slot = "footer",
        style = {
        ['color'] = 'orange',
        }
    })
    NotebookPage5:RouteTo()
end)