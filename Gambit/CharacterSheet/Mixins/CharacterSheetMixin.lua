local GambitAPI = Gambit_Addon.API;
local L = GambitAPI.loc;

local CharacterSheetMixin = {};

function CharacterSheetMixin:Init()
    self.backdropInfo = TRP3_BACKDROP_TOOLTIP_0_24_5555;

    self.isSelf = true;

    self:SetupBackground();
    self:SetupNameplate();
    self:SetupEditButton();
    self:SetupStatPage();
end

function CharacterSheetMixin:SetupBackground()
    local bg = self:CreateTexture(nil, "BACKGROUND");
    bg:SetTexture("Interface\\SPELLBOOK\\Spellbook-Page-1");
    bg:SetTexCoord(0.15, 1, 0, 0.975);
    bg:SetPoint("TOPRIGHT", -5, -2);
    bg:SetPoint("BOTTOMLEFT", -5, -2);
    bg:SetPoint("LEFT", 5, 0);

    self.bg = bg;
end

function CharacterSheetMixin:SetupNameplate()
    local f = CreateFrame("Frame", nil, self, "TRP3_AltHoveredFrame");
    f:SetSize(0, 100);
    f:SetPoint("TOPLEFT", self, "TOPLEFT", 15, -20);
    f:SetPoint("RIGHT", -90, 0);

    f.TextContainer = CreateFrame("Frame", nil, f, "TRP3_TruncatedTextTemplate");
    f.TextContainer:SetSize(0, 30);
    f.TextContainer:SetPoint("TOPLEFT", f, "TOPLEFT", 20, -15);
    f.TextContainer:SetPoint("RIGHT", f, "TOPRIGHT", -20, 0);

    f.TextContainer.Banner = f.TextContainer:CreateTexture(nil, "OVERLAY");
    f.TextContainer.Banner:SetTexture("Interface\\QuestionFrame\\TitleBanner");
    f.TextContainer.Banner:SetAlpha(0.85);
    f.TextContainer.Banner:SetSize(256, 64);
    f.TextContainer.Banner:SetPoint("CENTER", 1, -20);

    f.TextContainer.Text = f.TextContainer:CreateFontString(nil, "OVERLAY", "SystemFont_Med1");
    f.TextContainer.Text:SetJustifyH("CENTER");
    f.TextContainer.Text:SetText(L.CHARACTER_SHEET_PH_NAME);
    f.TextContainer.Text:SetSize(150, 0);
    f.TextContainer.Text:SetPoint("CENTER", f.TextContainer.Banner, 0, 18);
    f.TextContainer.Text:SetTextColor(0.2824, 0.0157, 0.0157, 1);
    f.TextContainer.Text:SetShadowColor(0, 0, 0, 0.85);
    f.TextContainer.Text:SetShadowOffset(1, -1);

    -- Class text field
    f.ClassTextContainer = self:GetGenericTextContainer();
    f.ClassTextContainer:SetPoint("TOPLEFT", f, "LEFT", 25, -5);
    f.ClassTextContainer.Text:SetText(L.CHARACTER_SHEET_PH_CLASS);
    f.ClassTextContainer.Label:SetText(L.CHARACTER_SHEET_LABEL_CLASS);

    -- Race text field
    f.RaceTextContainer = self:GetGenericTextContainer();
    f.RaceTextContainer:SetPoint("TOP", f, "CENTER", 0, -5);
    f.RaceTextContainer.Text:SetText(L.CHARACTER_SHEET_PH_RACE);
    f.RaceTextContainer.Label:SetText(L.CHARACTER_SHEET_LABEL_RACE);

    -- Alignment text field
    f.AlignmentTextContainer = self:GetGenericTextContainer();
    f.AlignmentTextContainer:SetPoint("TOPRIGHT", f, "RIGHT", -25, -5);
    f.AlignmentTextContainer.Text:SetText(L.CHARACTER_SHEET_PH_ALIGNMENT);
    f.AlignmentTextContainer.Label:SetText(L.CHARACTER_SHEET_LABEL_ALIGNMENT);

    self.Nameplate = f;
end

function CharacterSheetMixin:GetGenericTextContainer(parent)
    parent = parent or self;

    if not self.ResizeTextContainers then
        self.ResizeTextContainers = {};
    end

    local f = CreateFrame("Frame", nil, parent, "ResizeLayoutFrame");
    f:SetSize(120, 35);

    f.Text = f:CreateFontString(nil, "OVERLAY", "GameFontNormal");
    f.Text:SetJustifyH("CENTER");
    f.Text:SetJustifyV("TOP");
    f.Text:SetText(L.CHARACTER_SHEET_GENERIC_PH_TEXT);
    f.Text:SetTextColor(0.1, 1.0, 0.75, 1);
    f.Text:SetPoint("TOPLEFT", f, "TOPLEFT", 0, -5);

    f.Label = f:CreateFontString(nil, "OVERLAY", "GameFontNormal");
    f.Label:SetJustifyH("CENTER");
    f.Label:SetJustifyV("BOTTOM");
    f.Label:SetText(L.CHARACTER_SHEET_GENERIC_PH_TEXT);
    f.Label:SetTextColor(0.1, 1.0, 0.75, 1);
    f.Label:SetPoint("TOP", f.Text, "BOTTOM", 0, 0);

    tinsert(self.ResizeTextContainers, f);

    return f;
end

function CharacterSheetMixin:SetupEditButton()
    local b = CreateFrame("Button", nil, self, "TRP3_CommonButton");
    b:SetText(L.CHARACTER_SHEET_EDIT_BUTTON_TEXT);
    b:SetSize(70, 20);
    b:SetPoint("LEFT", self.Nameplate, "RIGHT", 5, 0);

    self.EditButton = b;
end

function CharacterSheetMixin:SetupStatPage()
    local f = CreateFrame("Frame", nil, self);
    f.bg = f:CreateTexture(nil, "BACKGROUND");
    f.bg:SetAtlas("GarrMissionLocation-Maw-bg-02");
    f.bg:ClearAllPoints();
    f.bg:SetAllPoints(f);

    f:SetPoint("TOPLEFT", self.Nameplate, "BOTTOMLEFT", 0, 0);
    f:SetPoint("BOTTOMRIGHT", self, "BOTTOMRIGHT", -10, 10);

    self.StatPage = f;

    f.stat1 = self:GetGenericStatDisplay();
    f.stat1:SetPoint("TOPLEFT", f, "TOPLEFT", 10, -10);
    f.stat1.Label:SetText(L.ATTRIBUTE_CHARISMA);

    f.stat2 = self:GetGenericStatDisplay();
    f.stat2:SetPoint("BOTTOMLEFT", f, "BOTTOMLEFT", 10, 25);
    f.stat2.Label:SetText(L.ATTRIBUTE_DEXTERITY);

    f.stat3 = self:GetGenericStatDisplay();
    f.stat3:SetPoint("LEFT", f.stat1, "RIGHT", 25, 0);
    f.stat3.Label:SetText(L.ATTRIBUTE_STRENGTH);

    f.stat4 = self:GetGenericStatDisplay();
    f.stat4:SetPoint("LEFT", f.stat2, "RIGHT", 25, 0);
    f.stat4.Label:SetText(L.ATTRIBUTE_WISDOM);
end

function CharacterSheetMixin:GetGenericStatDisplay()
    local f = CreateFrame("Frame", nil, self.StatPage, "BackdropTemplate");
    f:SetSize(100, 125);

    f.Border = f:CreateTexture(nil, "BORDER", nil, -1);
    f.Border:SetAtlas("AdventureMap-InsetMapBorder");
    f.Border:ClearAllPoints();
    f.Border:SetAllPoints(f);

    f.bg = f:CreateTexture(nil, "BACKGROUND");
    f.bg:SetAtlas("UI-Frame-Kyrian-CardParchment");
    f.bg:ClearAllPoints();
    f.bg:SetAllPoints(f);

    f.Label = f:CreateFontString(nil, "OVERLAY", "GameFontNormal");
    f.Label:SetJustifyH("CENTER");
    f.Label:SetPoint("TOP", f, "TOP", 0, -10);
    f.Label:SetText(L.CHARACTER_SHEET_GENERIC_PH_TEXT);
    f.Label:SetTextColor(1, 1, 1, 1);
    f.Label:SetTextHeight(14);

    f.ModifierValue = f:CreateFontString(nil, "OVERLAY", "GameFontNormal");
    f.ModifierValue:SetJustifyH("CENTER");
    f.ModifierValue:SetPoint("CENTER", f, "CENTER", -2, 5);
    f.ModifierValue:SetText("+3");
    f.ModifierValue:SetTextColor(1, 1, 1, 1);
    f.ModifierValue:SetTextHeight(30);

    f.StatValueRing = f:CreateTexture(nil, "BORDER", nil, 2);
    f.StatValueRing:SetAtlas("auctionhouse-itemicon-border-white");
    f.StatValueRing:SetPoint("CENTER", f, "BOTTOM", 0, 10);
    f.StatValueRing:SetSize(75, 75);

    f.StatValueRing.Value = f:CreateFontString(nil, "OVERLAY", "GameFontNormal");
    f.StatValueRing.Value:SetJustifyH("CENTER");
    f.StatValueRing.Value:SetPoint("CENTER", f.StatValueRing, "CENTER", -1, 0);
    f.StatValueRing.Value:SetText("15");
    f.StatValueRing.Value:SetTextColor(1, 1, 1, 1);
    f.StatValueRing.Value:SetTextHeight(20);

    f.StatValueRing.bg = f:CreateTexture(nil, "BORDER", nil, 1);
    f.StatValueRing.bg:SetAtlas("jailerstower-wayfinder-rewardglow");
    f.StatValueRing.bg:SetAllPoints(f.StatValueRing);

    f.StatValueRing.mask = f:CreateMaskTexture();
    f.StatValueRing.mask:SetAllPoints(f.StatValueRing);
    f.StatValueRing.mask:SetTexture("Interface/CHARACTERFRAME/TempPortraitAlphaMask", "CLAMPTOBLACKADDITIVE", "CLAMPTOBLACKADDITIVE");

    f.StatValueRing.bg:AddMaskTexture(f.StatValueRing.mask);

    return f;
end


-- Utility functions

function CharacterSheetMixin:SetCharacterName(name)
    if not name then
        return;
    end

    self.Nameplate.TextContainer.Text:SetText(name);
end

function CharacterSheetMixin:SetCharacterRace(race)
    if not race then
        return;
    end

    self.Nameplate.RaceTextContainer.Text:SetText(race);
end

function CharacterSheetMixin:SetCharacterClass(class)
    if not class then
        return;
    end

    self.Nameplate.ClassTextContainer.Text:SetText(class);
end

function CharacterSheetMixin:SetCharacterAlignment(alignment)
    if not alignment then
        return;
    end

    local alignmentString = GambitAPI.Enums.Alignments[alignment];
    assert(alignmentString, "Invalid alignment: " .. alignment);

    local alignmentColor = GambitAPI.Enums.AlignmentColors[alignment];
    alignmentString = alignmentColor:WrapTextInColorCode(alignmentString);

    self.Nameplate.AlignmentTextContainer.Text:SetText(alignmentString);
end

function CharacterSheetMixin:Update()
    if self.isSelf then
        self:UpdateSelf();
    else
        self:UpdateOther();
    end

    if self.ResizeTextContainers then
        for _, v in ipairs(self.ResizeTextContainers) do
            v:MarkDirty();
        end
    end
end

function CharacterSheetMixin:UpdateSelf()
    local TRP3_Player = AddOn_TotalRP3.Player.GetCurrentUser();

    local displayName = TRP3_Player:GetCustomColoredRoleplayingNamePrefixedWithIcon(20)
    local characteristics = TRP3_Player:GetCharacteristics();
    local displayColor = TRP3_Player:GetCustomColorForDisplay();

    local class = displayColor:WrapTextInColorCode(characteristics.CL);
    local race = displayColor:WrapTextInColorCode(characteristics.RA);

    self:SetCharacterName(displayName);
    self:SetCharacterClass(class);
    self:SetCharacterRace(race);
    self:SetCharacterAlignment("CE")
end

function CharacterSheetMixin:UpdateOther()
    print("bongus")
end

function GambitAPI.utils.factory:CreateCharacterSheetFrame()
    local f = CreateFrame("Frame", "Gambit_CharacterSheetFrame", nil, "BackdropTemplate");
    Mixin(f, CharacterSheetMixin);
    f:Init();
    return f;
end