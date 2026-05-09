local name, Tongues = ...

local Core = {
    Config = {
        Enabled = false
    }
}
Tongues.Core = Core

function Core:CheckAPI()
    if not _G.YapperAPI then
        return false
    end
    return true
end