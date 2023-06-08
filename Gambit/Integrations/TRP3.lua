local GambitAPI = Gambit_Addon.API;
local L = GambitAPI.loc;

GambitAPI.TRP3_Module = {};

function GambitAPI.TRP3_Module:Print(...)
    GambitAPI.Print("TRP3_Module", ...);
end

function GambitAPI.TRP3_Module:OnModuleInitialize()
    self:Print("OnModuleInitialize");
    GambitAPI.CharacterSheet:Initialize();
	TRP3_API.RegisterCallback(GambitAPI, "CHARACTER_SHEET_LOADED", function()
		self:Print("CHARACTER_SHEET_LOADED"); end)
end

function GambitAPI.TRP3_Module:OnModuleEnable()
    self:Print("OnModuleEnable");
end

function GambitAPI.TRP3_Module:OnModuleDisable()
    self:Print("OnModuleDisable");
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
