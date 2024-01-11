local GambitAPI = Gambit_Addon.API;
local L = GambitAPI.loc;

local nav = TRP3_API.navigation;

local Print = function(...) GambitAPI.Print("TRP3_Module", ...); end;

GambitAPI.TRP3_Module = {};

function GambitAPI.TRP3_Module:OnModuleInitialize()
    GambitAPI.EventHandler:TriggerEvent(GambitAPI.Events.TRP3_MODULE_INITIALIZED);
end

function GambitAPI.TRP3_Module:OnModuleEnable()
	GambitAPI.CharacterSheetFrame = GambitAPI.Utils.Factory.CreateCharacterSheetFrame();

	    -- register page with TRP3
	nav.page.registerPage({
		id = "player_character_sheet",
		frame = GambitAPI.CharacterSheetFrame,
		onPagePreShow = function(...) GambitAPI.CharacterSheetFrame:OnShow(...); end
	});

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

	GambitAPI.EventHandler:TriggerEvent(GambitAPI.Events.TRP3_MODULE_ENABLED);
end

function GambitAPI.TRP3_Module:OnModuleDisable()
    GambitAPI.EventHandler:TriggerEvent(GambitAPI.Events.TRP3_MODULE_DISABLED);
end

--
-- Module Registration
--

TRP3_API.module.registerModule({
	id = "ghost_gambit_trp3",
	name = L.TRP3_MODULE_NAME,
	description = L.TRP3_MODULE_DESCRIPTION,
	version = 1,
	minVersion = 0,
	hotReload = true,
	onInit = function() return GambitAPI.TRP3_Module:OnModuleInitialize(); end,
	onStart = function() return GambitAPI.TRP3_Module:OnModuleEnable(); end,
	onDisable = function() return GambitAPI.TRP3_Module:OnModuleDisable(); end,
});
