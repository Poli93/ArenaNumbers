local _, ArenaNumbers = ...
local floor, select, tonumber = math.floor, select, tonumber
local UnitName, STANDARD_TEXT_FONT = UnitName, STANDARD_TEXT_FONT
local IsInInstance, GetNumArenaOpponents = IsInInstance, GetNumArenaOpponents
local interval = 0.1
local time = 0
local enabled = true
local ArenaNumbers = true


local function AddElements(plate, time)
    local _, border, _, _, _, _, name, levelText = plate:GetRegions()

    if time >= interval then
        time = 0

        local _, type = IsInInstance()
        if ArenaNumbers and type == "arena" then
            for i = 1, GetNumArenaOpponents() do
                local text = name:GetText()
                if UnitName("arena" .. i) == text then
                    name:SetText(i) 
                end
                local nr = tonumber(text)
                if nr then
                    name:SetText(nr)
                    name:ClearAllPoints()
                    name:SetPoint("BOTTOM", plate, "TOP", 0, -15)
                    name:SetJustifyH("CENTER")
                end
            end
        end
    end
end

local function onUpdate(self, elapsed)
    local plates = WorldFrame:GetNumChildren()

    time = time + elapsed

    for i = 1, plates do
        local plate = select(i, WorldFrame:GetChildren())
        local _, region = plate:GetRegions()
        if region and region:GetObjectType() == "Texture" and region:GetTexture() == "Interface\\Tooltips\\Nameplate-Border" then
            AddElements(plate, time)
        end
    end
end

local frame = CreateFrame("Frame")
frame:RegisterEvent("PLAYER_LOGIN")
frame:SetScript("OnEvent", function()
    if not (GetCVarBool("nameplateShowEnemies") or GetCVarBool("nameplateShowFriends")) then
        return
    end

    frame:SetScript("OnUpdate", onUpdate)
end)
