local name, Tongues = ...

-- First we check Yapper's API. If it's not available then this whole addon is moot.
if Tongues.Core:CheckAPI() then
    Tongues.Core.Config.Enabled = true
end

if not Tongues.Core.Config.Enabled then
    return
end

-- It should be here anyway because Yapper is a required dep.
-- If we get here, then we're all good. Initialise the addon.

local init = Tongues.Core:Initialise()
if not init then
    -- If init failed, complain and return.
    error("YapperTongues failed to initialise for some reason.")
    return -- Not strictly necessary but doing it anyway.
end