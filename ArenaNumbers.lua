local addon, ArenaNumbers = ...
local floor, select, tonumber = math.floor, select, tonumber
local UnitName, STANDARD_TEXT_FONT = UnitName, STANDARD_TEXT_FONT
local IsInInstance, GetNumArenaOpponents = IsInInstance, GetNumArenaOpponents
local interval = 0.1
local time = 0
local ArenaNumbers = true
local AN_TEXT = "|cff69CCF0ArenaNumbers|r: "

local function ANDefaults()
	ANOptions["fontSize"] = 15.665118083221
    ANOptions["fontXpos"] = 0
    ANOptions["fontYpos"] = -15
    print(AN_TEXT .. " Settings reset to default.")
end


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
                    name:SetPoint("BOTTOM", plate, "TOP", ANOptions["fontXpos"], ANOptions["fontYpos"])
                    name:SetJustifyH("CENTER")
					
                    local font, fontHeight, flags = name:GetFont()  
                    name:SetFont(font, ANOptions["fontSize"], flags)
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

SLASH_ANCMDS1 = "/an"
SLASH_ANCMDS2 = "/anc"
SlashCmdList["ANCMDS"] = function(msg)
    local cmd, value = msg:match("^(%S*)%s*(.-)$")  
    value = tonumber(value)
    
    if (cmd == "scale" or cmd == "size") and value then
        ANOptions["fontSize"] = value
		print(AN_TEXT .. " Font size set to: " .. value)
    elseif (cmd == "xpos" or cmd == "x") and value then
        ANOptions["fontXpos"] = value
		print(AN_TEXT .. " X Position set to: " .. value)
    elseif (cmd == "ypos" or cmd == "y") and value then
        ANOptions["fontYpos"] = value
        print(AN_TEXT .. " Y Position set to: " .. value)
    elseif cmd == "reset" then
        ANDefaults() 
		print(AN_TEXT .. " Settings reset to default.")
    else
        print("Usage: /an scale / size <number> - set font size")
        print("Usage: /an x / xpos <number> - set x position")
        print("Usage: /an y / ypos <number> - set y position")
        print("Usage: /an reset - reset settings to default")
    end
end

local function OnAddonLoaded(...)
	if ... == addon then
	print(AN_TEXT .. " addon loaded.")
		if ANOptions == nil or ANOptions["fontSize"] == nil or ANOptions["fontXpos"] == nil or ANOptions["fontYpos"] == nil then
		    ANOptions = {} 
            ANDefaults()
			print(AN_TEXT .. " Settings reset to default.")
		end
	end
end

local frame = CreateFrame("Frame")
frame:RegisterEvent("PLAYER_LOGIN")
frame:RegisterEvent("ADDON_LOADED")
frame:SetScript("OnEvent", function(self, event, ...)
    if event == "ADDON_LOADED" then
        OnAddonLoaded(...)
	end

    if not (GetCVarBool("nameplateShowEnemies") or GetCVarBool("nameplateShowFriends")) then
        return
    end

    frame:SetScript("OnUpdate", onUpdate)
end)
