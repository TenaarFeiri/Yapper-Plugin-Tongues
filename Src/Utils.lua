local name, Tongues = ...

local Utils = {}
Tongues.Utils = Utils
local config = Tongues.Core.Config

--- Is the plugin active?
function Utils:IsActive()
    if not Tongues.Core.Config.Enabled or type(Tongues.Core.Config.Enabled) ~= "boolean" then
        return false
    end
    return true
end
