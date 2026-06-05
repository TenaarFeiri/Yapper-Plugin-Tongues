local name, Tongues = ...
local UI = {}

local api = _G.YapperAPI or nil

if not api then
    print("YapperAPI not found. UI will not be created.")
    return
end

function UI:Create()
    -- Register Tongues settings category in Yapper
    api:RegisterSettingsCategory("tongues", "Tongues", {
        render = function(contentFrame, cursor)
            -- Simple render for now - placeholder UI
            local fs = contentFrame:CreateFontString(nil, "OVERLAY", "GameFontNormal")
            fs:SetPoint("TOPLEFT", contentFrame, "TOPLEFT", 16, -16)
            fs:SetText("Tongues Plugin Settings")
            fs:SetTextColor(1, 1, 1, 1)

            local desc = contentFrame:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
            desc:SetPoint("TOPLEFT", contentFrame, "TOPLEFT", 16, -40)
            desc:SetText("Configure language translation settings for Yapper.")
            desc:SetTextColor(0.9, 0.9, 0.9, 1)
        end
    })

    -- Register slash command to open Tongues settings
    SLASH_YAPPERTONGUES1 = "/tongues"
    SlashCmdList["YAPPERTONGUES"] = function()
        api:OpenSettingsCategory("tongues")
    end
end

Tongues.UI = UI
return UI