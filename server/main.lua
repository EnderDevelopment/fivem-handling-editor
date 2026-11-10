local overrides = {}
local resourceName = GetCurrentResourceName()

local function isAllowed(source)
    return not Config.RequirePermission or IsPlayerAceAllowed(source, Config.PermissionAce)
end

local function validModel(model)
    return type(model) == 'string' and #model > 0 and #model <= 64 and model:match('^[%w_%-]+$') ~= nil
end

local function loadOverrides()
    local raw = LoadResourceFile(resourceName, Config.SaveFile)
    if not raw or raw == '' then return end
    local ok, decoded = pcall(json.decode, raw)
    if ok and type(decoded) == 'table' then overrides = decoded end
end

local function saveOverrides()
    SaveResourceFile(resourceName, Config.SaveFile, json.encode(overrides), -1)
end

local function sanitizeSettings(input)
    if type(input) ~= 'table' then return nil end
    local allowed, cleaned = {}, {}
    for _, field in ipairs(Config.Fields) do allowed[field.key] = field end
    for key, value in pairs(input) do
        local field = allowed[key]
        local number = tonumber(value)
        if field and number and number == number and number ~= math.huge and number ~= -math.huge then
            cleaned[key] = math.max(field.min, math.min(field.max, number))
        end
    end
    if next(cleaned) == nil then return nil end
    return cleaned
end

RegisterNetEvent('handling_editor:requestSync', function()
    TriggerClientEvent('handling_editor:sync', source, overrides)
end)

RegisterNetEvent('handling_editor:requestSave', function(model, settings)
    local player = source
    if not isAllowed(player) then
        TriggerClientEvent('handling_editor:saveResult', player, false, 'You do not have permission to save handling.')
        return
    end
    if not validModel(model) then
        TriggerClientEvent('handling_editor:saveResult', player, false, 'Invalid vehicle model.')
        return
    end
    local cleaned = sanitizeSettings(settings)
    if not cleaned then
        TriggerClientEvent('handling_editor:saveResult', player, false, 'No valid handling values received.')
        return
    end
    local key = model:lower()
    overrides[key] = overrides[key] or {}
    for setting, value in pairs(cleaned) do overrides[key][setting] = value end
    saveOverrides()
    TriggerClientEvent('handling_editor:sync', -1, overrides)
    TriggerClientEvent('handling_editor:saveResult', player, true, 'Saved and synced for all players.')
end)

RegisterNetEvent('handling_editor:requestReset', function(model)
    local player = source
    if not isAllowed(player) then
        TriggerClientEvent('handling_editor:saveResult', player, false, 'You do not have permission to reset handling.')
        return
    end
    if not validModel(model) then return end
    overrides[model:lower()] = nil
    saveOverrides()
    TriggerClientEvent('handling_editor:sync', -1, overrides)
    TriggerClientEvent('handling_editor:saveResult', player, true, 'Override removed and synced for all players.')
end)

AddEventHandler('playerJoining', function()
    local player = source
    SetTimeout(1500, function()
        if GetPlayerName(player) then TriggerClientEvent('handling_editor:sync', player, overrides) end
    end)
end)

AddEventHandler('onResourceStart', function(name)
    if name == resourceName then loadOverrides() end
end)

loadOverrides()
