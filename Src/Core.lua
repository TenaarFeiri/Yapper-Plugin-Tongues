local name, Tongues = ...
YapperTonguesGlobal = YapperTonguesGlobal or {}

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
    CharacterSettings = nil, -- Backfilled by TonguesResolveDefaults
    Utils = {}, -- Hold utils functions
    EventHandler = {}, -- Hold EventHandler's functions
}

function Core:ResolveDefaults()
   -- First do a loop to see if something should be removed.
   if self.Settings == Defaults then
      return -- Nothing needs updating.
   end

   local outputTable = {}

   -- Build outputTable from Defaults to ensure only current defaults exist
   for k, v in pairs(Defaults) do
    -- Check if value is a table
    local isTable = type(v) == "table"
    if isTable then
        -- Recursively build table from Defaults
        outputTable[k] = {}
        for k2, v2 in pairs(v) do
            outputTable[k][k2] = v2
        end
    else
        -- If it's not a table, just copy the value
        outputTable[k] = v
    end
   end

   -- Overwrite Settings with outputTable to remove old settings
   YapperTonguesGlobal.Settings = outputTable
   self.Settings = outputTable
end

function Core:Initialise()
    -- Resolve defaults to clean up old settings
    self:ResolveDefaults()
    -- Ensure Config is properly set
    Core.Config = self.Settings.Config or Defaults.Config
    return true
end

function Core:CheckAPI()
    local api = _G.YapperAPI
    if not api then
        return false
    end
    return true
end

Tongues.Core = Core
local API = nil

-- Load UI module and register settings category
local UI = Tongues.UI
if UI and UI.Create then
    UI:Create()
end

local Settings = YapperTonguesGlobal.Settings or {}

-- Ensure Config always exists by merging missing defaults
if not Settings.Config then
    Settings.Config = {}
end

-- Merge missing config defaults
for k, v in pairs(Defaults.Config) do
    if Settings.Config[k] == nil then
        Settings.Config[k] = v
    end
end

Core.Settings = Settings
Core.Config = Settings.Config
