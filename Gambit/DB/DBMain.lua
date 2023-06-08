local GambitAPI = Gambit_Addon.API;
local nav = TRP3_API.navigation;
local L = GambitAPI.loc;

local profiles, currentProfile;

local function InitDB()
    if not GambitDB then
        GambitDB = {};
    end

    profiles = GambitDB;

    nav.menu.registerMenu({
		id = "main_character_sheet_directory",
		text = L.CHARACTER_SHEET_DIRECTORY_TOOLTIP,
		onSelected = function() nav.menu.selectMenu("main_self_character_sheets") end,
	});

    nav.menu.registerMenu({
		id = "main_self_character_sheets",
        text = L.CHARACTER_SHEET_SELF_SHEETS_TOOLTIP,
		onSelected = function()
            nav.page.setPage("player_character_sheet"); end,
        isChildOf = "main_character_sheet_directory"
	});

    nav.menu.registerMenu({
		id = "main_stored_character_sheet_directory",
        text = L.CHARACTER_SHEET_STORED_SHEETS_TOOLTIP,
		onSelected = function()
            nav.page.setPage("player_character_sheet"); end,
        isChildOf = "main_character_sheet_directory"
	});

    GambitAPI.DB:SelectProfile(profiles.LastSelectedProfile)
end

TRP3_API.RegisterCallback(TRP3_Addon, "WORKFLOW_ON_LOAD", InitDB)

GambitAPI.DB = {};

local function isValidProfileName(profileName)
    for name, profile in pairs(profiles) do
        if name == profileName or name == "LastSelectedProfile" then
            return false;
        end
    end
    return true;
end

function GambitAPI.DB:GetProfiles()
    return profiles;
end

function GambitAPI.DB:CreateProfile(profileName)
    assert(isValidProfileName(profileName), "Profile name already exists: " .. profileName);
    profiles[profileName] = GambitAPI.Profile:New(profileName);
    self:SelectProfile(profileName);
end

function GambitAPI.DB:SelectProfile(profileName)
    assert(profiles[profileName], "Profile does not exist: " .. profileName);
    currentProfile = profiles[profileName];
    profiles.LastSelectedProfile = profileName;
    return currentProfile;
end

function GambitAPI.DB:GetCurrentProfile()
    return currentProfile;
end