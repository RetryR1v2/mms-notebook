local vorpCore = exports.vorp_core:GetCore()

local notebookProp = nil
local penProp = nil

local notebookAnimDict = 'amb_work@world_human_write_notebook@female_a@idle_c'
local notebookAnimName = 'idle_g'

local function LoadModel(model)
    local modelHash = GetHashKey(model)
    RequestModel(modelHash)
    while not HasModelLoaded(modelHash) do
        Wait(10)
    end
    return modelHash
end


local function LoadAnimDict(dict)
    RequestAnimDict(dict)
    while not HasAnimDictLoaded(dict) do
        Wait(10)
    end
end


local function StartNotebookAnimation()
    local ped = PlayerPedId()
    local coords = GetEntityCoords(ped)
    if notebookProp and DoesEntityExist(notebookProp) then
        DeleteObject(notebookProp)
        notebookProp = nil
    end

    if penProp and DoesEntityExist(penProp) then
        DeleteObject(penProp)
        penProp = nil
    end

    local notebookModel = LoadModel('mp006_s_mp_book_emote01x')
    local penModel = LoadModel('P_PEN01X')

    notebookProp = CreateObject(notebookModel,coords.x,coords.y,coords.z,true,true,false,false,true)
    penProp = CreateObject(penModel,coords.x,coords.y,coords.z,true,true,false,false,true)

    SetEntityCollision(notebookProp, false, false)
    SetEntityCollision(penProp, false, false)

    local leftHand = GetEntityBoneIndexByName(ped, 'SKEL_L_HAND')
    local rightHand = GetEntityBoneIndexByName(ped, 'SKEL_R_HAND')

    AttachEntityToEntity(notebookProp,ped,leftHand,0.10,0.030,0.020,10.0,0.0,15.0,true,true,false,true,1,true)

    AttachEntityToEntity(penProp,ped,rightHand,0.065,0.018,-0.015,5.0,95.0,5.0,true,true,false,true,1,true)

    LoadAnimDict(notebookAnimDict)

    TaskPlayAnim(ped,notebookAnimDict,notebookAnimName,1.0,1.0,-1,1,0.0,false,false,false,'',false)

    SetModelAsNoLongerNeeded(notebookModel)
    SetModelAsNoLongerNeeded(penModel)
end

local function StopNotebookAnimation()
    local ped = PlayerPedId()
    StopAnimTask(ped,notebookAnimDict,notebookAnimName,1.0)

    if notebookProp and DoesEntityExist(notebookProp) then
        DeleteObject(notebookProp)
        notebookProp = nil
    end

    if penProp and DoesEntityExist(penProp) then
        DeleteObject(penProp)
        penProp = nil
    end

    RemoveAnimDict(notebookAnimDict)
end

RegisterNetEvent('openNotebook',function()
    StartNotebookAnimation()
    SetNuiFocus(true, true)

    SendNUIMessage({
        action = 'open',
    })
end)

-- Get Lang

RegisterNuiCallback('getLang',function(data,cb)
    local lang = Config.lang
    cb({success = true, lang = lang})
end)

RegisterNuiCallback('sendMessage',function(data,cb)
    local title = data.title
    local message = data.message
    TriggerServerEvent('saveMessageToDatabase', title, message)
    
    cb({success = true, message = 'Nachricht wurde gespeichert'})
end)

RegisterNuiCallback('close',function(data,cb)
    StopNotebookAnimation()
    SetNuiFocus(false, false)

    SendNUIMessage({
        action = 'close'
    })

    cb({success = true})
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

-- Save Edited Message

RegisterNuiCallback('saveEditedMessage',function(data,cb)
    local id = data.id
    local title = data.title
    local message = data.message
    local data = vorpCore.Callback.TriggerAwait('editMessage',id,title,message)
    cb(data)
end)
