local GambitAPI = Gambit_Addon.API;

GambitAPI.CharacterSheet = GambitAPI.utils.factory:CreateCharacterSheetFrame();

function GambitAPI.CharacterSheet:Print(...)
    GambitAPI.Print("CharacterSheet", ...);
end

function GambitAPI.CharacterSheet:Initialize()
    -- init character sheet page
    TRP3_API.navigation.page.registerPage({
		id = "player_character_sheet",
		frame = GambitAPI.CharacterSheet,
		onPagePostShow = function() self:OnCharacterSheetShow(true) end,
	});
end

function GambitAPI.CharacterSheet:OnCharacterSheetShow(isSelf)
    if isSelf then
        self:Print("OnSelfCharacterSheetShow");
        self.isSelf = true;
    else
        self:Print("OnOtherCharacterSheetShow");
        self.isSelf = false;
    end

    GambitAPI.CharacterSheet:Update(); -- adjust text box sizes
    GambitAPI:TriggerEvent("CHARACTER_SHEET_OPENED");
end

