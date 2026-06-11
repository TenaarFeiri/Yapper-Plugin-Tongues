local name, Tongues = ...
local Utils = Tongues.Core.Utils or nil

if not Utils then
    -- This probably loaded before Core.lua, in which case if this happens fix your fucking shit
    print("Tongues Utils could not load. This should never happen; make sure Core is the first file to load.")
    return
end
