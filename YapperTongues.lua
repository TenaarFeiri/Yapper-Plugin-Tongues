local name, Tongues = ...

-- It should be here anyway because Yapper is a required dep.
-- If we get here, then we're all good. Initialise the addon.
local loginListener = nil
local function DoInit(self, event, ...)
    if event == "PLAYER_LOGIN" then
        local init = Tongues.Core:Initialise()
        if not init then
            -- If init failed, complain and return.
            error("YapperTongues failed to initialise for some reason.")
            return -- Not strictly necessary but doing it anyway.
        end
        -- We initialised. Unregister and kill the frame.
        loginListener:UnregisterAllEvents()
        loginListener = nil

        -- then verify API
        if Tongues.Core:CheckAPI() then
            Tongues.Core.Config.Enabled = true
        end
        if not Tongues.Core.Config.Enabled then
            return
        end
    end
end

loginListener = CreateFrame("Frame", "YapTongue")
loginListener:RegisterEvent("PLAYER_LOGIN")
loginListener:SetScript("OnEvent", DoInit)
