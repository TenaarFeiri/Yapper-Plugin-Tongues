--[[
    This is the plugin's event manager. It registers events and filters with Yapper,
    and will delegate thos events to the proper channel.
    It pulls double duty as creator and delegator, utilising Yapper's API.
]]

local name, Tongues = ...

local Events = {}
Tongues.Events = Events
local Utils = Tongues.Utils
local Ready = false
local API = nil      -- Set during Setup()

local Filters = {}   -- Filter handles
local Callbacks = {} -- Callback handles

------ Local functions ------
local function OnPreSend(payload)
    -- Process text before it's sent.
    -- TODO: Implement
    local text = payload.text
    --print("Yapper tongues received: " .. text)
    return payload
end

local function OnEditboxShow(chatType, target)
    -- Do things when the editbox is shown.
    -- Args don't matter here, we use these callbacks to show/hide
end

local function OnEditboxHide()
    -- Do things when the editbox is hidden.
end


-------------- These have to be last in this section. --------------
local function RegisterAllFilters()
    -- Register all the filters we need and store the handles in their appropriate table entries.
    Filters.PRE_SEND = API:RegisterFilter("PRE_SEND", OnPreSend)
    -- Validate that no filter returned nil.
    local tbl = {}
    for k, v in pairs(Filters) do
        if v == nil then
            tbl[k] = true
        end
    end
    if not next(tbl) then
        return true
    end
    return tbl
end

local function RegisterAllCallbacks()
    Callbacks.EDITBOX_SHOW = API:RegisterCallback("EDITBOX_SHOW", OnEditboxShow)
    Callbacks.EDITBOX_HIDE = API:RegisterCallback("EDITBOX_HIDE", OnEditboxHide)

    -- Validate that no callback returned nil.
    local tbl = {}
    for k, v in pairs(Callbacks) do
        if v == nil then
            tbl[k] = true
        end
    end
    if not next(tbl) then
        return true
    end
    return tbl
end
------------ Functions accessible by other files ------------

function Events:Setup()
    if not Utils:IsActive() then
        -- We're not active. Do nothing.
        return false
    end

    -- By the time we reach this function, we've already confirmed the API exists.
    API = _G.YapperAPI

    -- Now register all the filters so we are ready to accept events from Yapper.
    local assignFilters = RegisterAllFilters()     -- True or a table.
    local assignCallbacks = RegisterAllCallbacks() -- True or a table.

    -- If our filters or callbacks returned tables, some (or all) of the registrations failed.
    local errTbl = {}
    if type(assignFilters) == "table" then
        errTbl.filters = assignFilters
    end
    if type(assignCallbacks) == "table" then
        errTbl.callbacks = assignCallbacks
    end
    if next(errTbl) then
        -- If we have table entries here, dump them in an error, but allow the plugin to continue.
        print("|cffff0000[YapperTongues Error]:|r Some hooks failed to register:")
        for category, hooks in pairs(errTbl) do
            for hookName, _ in pairs(hooks) do
                print(string.format("  - %s: %s", category:upper(), hookName))
            end
        end
    end
    errTbl = nil -- Kill errTbl.
    return true
end

---Unregister callbacks, single, several or all.
---@param callbacks table|string|nil
function Events:UnregisterCallbacks(callbacks)
    if callbacks == nil then
        -- Assume all callbacks to wipe if nil.
        for k, v in pairs(Callbacks) do
            API:UnregisterCallback(v)
        end
        Callbacks = {}
    elseif type(callbacks) == "table" then
        -- Otherwise, clear the callbacks in the table.
        for _, key in pairs(callbacks) do
            if Callbacks[key] then
                API:UnregisterCallback(Callbacks[key])
                Callbacks[key] = nil
            end
        end
    elseif type(callbacks) == "string" then
        if Callbacks[callbacks] then
            API:UnregisterCallback(Callbacks[callbacks])
            Callbacks[callbacks] = nil
        end
    end
end

---Unregister filters, single, several or all.
---@param filters table|string|nil
function Events:UnregisterFilters(filters)
    if filters == nil then
        -- Nil assumes all filters.
        for k, v in pairs(Filters) do
            API:UnregisterFilter(v)
        end
        Filters = {} -- And wipe the filters.
    elseif type(filters) == "table" then
        -- Clear the filters provided.
        for _, key in pairs(filters) do
            if Filters[key] then
                API:UnregisterFilter(Filters[key])
                Filters[key] = nil
            end
        end
    elseif type(filters) == "string" then
        if Filters[filters] then
            API:UnregisterFilter(Filters[filters])
            Filters[filters] = nil
        end
    end
end

function Events:IsReady()
    if Utils:IsActive() then
        Ready = true
    else
        Ready = false
    end
    return Ready
end
