local overrides = {}
local editorOpen = false

local function applyVehicle(vehicle, settings)
    if not DoesEntityExist(vehicle) then return end
    for key, value in pairs(settings) do
        SetVehicleHandlingFloat(vehicle, 'CHandlingData', key, tonumber(value) or 0.0)
    end
end

local function applyAllVehicles()
    local vehicles = GetGamePool('CVehicle')
    for i = 1, #vehicles do
        local vehicle = vehicles[i]
        local model = GetDisplayNameFromVehicleModel(GetEntityModel(vehicle)):lower()
        if overrides[model] then applyVehicle(vehicle, overrides[model]) end
    end
end

RegisterNetEvent('handling_editor:sync', function(data)
    overrides = type(data) == 'table' and data or {}
    applyAllVehicles()
    if editorOpen then SendNUIMessage({ action = 'sync', overrides = overrides }) end
end)

RegisterNetEvent('handling_editor:saveResult', function(success, message)
    SendNUIMessage({ action = 'toast', success = success, message = message })
end)

RegisterNUICallback('close', function(_, cb)
    editorOpen = false
    SetNuiFocus(false, false)
    cb({ ok = true })
end)

RegisterNUICallback('save', function(data, cb)
    TriggerServerEvent('handling_editor:requestSave', data.model, data.settings)
    cb({ ok = true })
end)

RegisterNUICallback('reset', function(data, cb)
    TriggerServerEvent('handling_editor:requestReset', data.model)
    cb({ ok = true })
end)

RegisterNUICallback('getVehicles', function(_, cb)
    local vehicles = {}
    local count = GetNumVehicleModels()
    for index = 0, count - 1 do
        local hash = GetVehicleModelByIndex(index)
        local display = GetDisplayNameFromVehicleModel(hash)
        if display and display ~= 'CARNOTFOUND' then
            local label = GetLabelText(display)
            if not label or label == 'NULL' then label = display end
            vehicles[#vehicles + 1] = { model = display:lower(), label = label, hash = hash }
        end
    end
    table.sort(vehicles, function(a, b) return a.label:lower() < b.label:lower() end)
    cb({ vehicles = vehicles, overrides = overrides, fields = Config.Fields })
end)

RegisterNUICallback('preview', function(data, cb)
    local ped = PlayerPedId()
    local vehicle = GetVehiclePedIsIn(ped, false)
    if vehicle ~= 0 then applyVehicle(vehicle, data.settings or {}) end
    cb({ ok = true })
end)

RegisterCommand(Config.Command, function()
    if editorOpen then return end
    TriggerServerEvent('handling_editor:requestSync')
    editorOpen = true
    SetNuiFocus(true, true)
    SendNUIMessage({ action = 'open' })
end, false)

CreateThread(function()
    while true do
        Wait(1500)
        applyAllVehicles()
    end
end)

AddEventHandler('onClientResourceStart', function(resource)
    if resource == GetCurrentResourceName() then TriggerServerEvent('handling_editor:requestSync') end
end)
