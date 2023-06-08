local GambitAPI = Gambit_Addon.API;
local nav = TRP3_API.navigation;
local L = GambitAPI.loc;

local sheets;

local function GetCharacterSheet(sheetID)
    assert(sheets[sheetID], "Sheet not found: " .. sheetID);
    return sheets[sheetID];
end

local function DeleteCharacterSheet(sheetID)
    assert(sheets[sheetID], "Sheet not found: " .. sheetID);
end

local function InitDB()
    if not GambitAPI.DB then
        GambitAPI.DB = {};
    end
    if not GambitAPI.DB.Sheets then
        GambitAPI.DB.Sheets = {};
    end

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
end

TRP3_API.RegisterCallback(TRP3_Addon, "WORKFLOW_ON_LOAD", function()
    InitDB();
end)