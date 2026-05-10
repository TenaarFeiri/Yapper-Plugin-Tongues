local name, Tongues = ...

local Defaults = {
    Config = { -- This is saved globally.
        Enabled = false
    },

    --[[
        This would be where I'd put defaults for the Imported Settings.
        Obviously this will be empty, and is initialised in TonguesResolveDefaults.

        Format:
            CharacterName (GUID?)
                ↳ Setting (idk the settings yet)
                    ↳ Value (can be anything)
                ↳ Another setting
                    ↳ Another value
                ↳ etc
    --]]

    Local = {
        -- For the YapperTonguesLocal file.
        -- Contains default settings for character-specific language things.
    }
}

local Core = {
    API = nil,
    CharacterSettings = nil -- Backfilled by TonguesResolveDefaults
}
Tongues.Core = Core
local API = nil

--- Initialises config db if not present,
--- and backfills defaults if necessary.
local function TonguesResolveDefaults()
    local tbl = {}
    tbl.Config = {} -- Empty table first.
    
    -- Do we have a global table?
    if not YapperTonguesGlobal or type(YapperTonguesGlobal) ~= "table" then
        -- If not, initialise.
        YapperTonguesGlobal = {}
    end
    
    -- Does it have a config? If not, init.
    if not YapperTonguesGlobal.Config or type(YapperTonguesGlobal.Config) ~= "table" then
        YapperTonguesGlobal.Config = {}
    end

    for key, value in pairs(Defaults.Config) do
        if YapperTonguesGlobal.Config[key] ~= nil then
            -- If the setting exists in saved config, use that.
            tbl.Config[key] = YapperTonguesGlobal.Config[key]
        else
            -- Otherwise, we use the default.
            tbl.Config[key] = Defaults.Config[key]
        end
    end

    -- Then let's wipe the global savefile.
    YapperTonguesGlobal.Config = tbl.Config
    
    -- And, finally...
    Core.Config = YapperTonguesGlobal.Config

    -- Next we're gonna resolve the local variables.
    if not YapperTonguesLocal or type(YapperTonguesLocal) ~= "table" then
        -- If this does not exist, initialise it. We will backfill it the same way we did globals.
        YapperTonguesLocal = {}
    end

    -- Then set YTL in core.
    -- We'll backfill new settings there later
    Core.CharacterSettings = YapperTonguesLocal
end

function Core:CheckAPI()
    if not _G.YapperAPI then
        return false
    end
    Tongues.Core.API = _G.YapperAPI
    -- Just for pedantry to verify that it got added
    if Tongues.Core.API ~= _G.YapperAPI then
        return false
    end
    return true
end

--- Set up the Tongues plugin, including all of its UIs, defaults,
--- backfill new settings, and so on.
function Core:Initialise()
    -- Before all else, Utils must exist or we die.
    if not Tongues.Utils or type(Tongues.Utils) ~= "table" then
        return false
    end
    -- Check if settings exist then resolve them, potentially with defaults.
    TonguesResolveDefaults()

    if not self:CheckAPI() then
        error("Could not load Yapper's API. Does it not exist?")
        return false
    end
    API = Tongues.Core.API -- localise for speed

    -- remaining setup code below here
    Tongues.Events:Setup() -- Register our events and filters.

    return true
end