local GambitAPI = Gambit_Addon.API;
local L = GambitAPI.loc;

---@class GambitCharacterSheetFrameMixin : Frame
---@field CharacterSheet CharacterSheetMixin
---@field SheetID string
GambitCharacterSheetFrameMixin = CreateFromMixins(CallbackRegistryMixin);

function GambitCharacterSheetFrameMixin:Init()
    assert(not self.Initialized, "CharacterSheetFrame is already initialized");

    if not self.SheetID then
        self.SheetID = GambitAPI.DB:GetCurrentCharacterSheetID();
    end

    self.MAX_ATTRIBUTES_PER_LINE = 3;

    self:SetupBackground();
    self:SetupNameplate();
    self:SetupEditButton();
    self:SetupAttributesDisplay();

    GambitAPI.EventHandler:RegisterCallback(GambitAPI.Events.CHARACTER_SHEET_CHANGED, function(sheetID) self:OnCharacterSheetChanged(sheetID) end);
    GambitAPI.EventHandler:RegisterCallback(GambitAPI.Events.CHARACTER_SHEET_UPDATED, function(sheetID) self:OnCharacterSheetUpdated(sheetID) end);

    self:UpdateCharacterSheetView(self.SheetID);

    self.Initialized = true;
end

function GambitCharacterSheetFrameMixin:SetMaxAttributesPerLine(number)
    self.MAX_ATTRIBUTES_PER_LINE = number;
    self:UpdateAttributesPosition();
    self:Update();
end

function GambitCharacterSheetFrameMixin:SetupBackground()
    local bg = self:CreateTexture(nil, "BACKGROUND");
    bg:SetTexture("Interface\\SPELLBOOK\\Spellbook-Page-1");
    bg:SetTexCoord(0.15, 1, 0, 0.975);
    bg:SetPoint("TOPRIGHT", -5, -2);
    bg:SetPoint("BOTTOMLEFT", -5, -2);
    bg:SetPoint("LEFT", 5, 0);

    self.bg = bg;
end

function GambitCharacterSheetFrameMixin:SetupNameplate()
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

function GambitCharacterSheetFrameMixin:GetGenericTextContainer(parent)
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

function GambitCharacterSheetFrameMixin:SetupEditButton()
    local b = CreateFrame("Button", nil, self, "TRP3_CommonButton");
    b:SetText(L.CHARACTER_SHEET_EDIT_BUTTON_TEXT);
    b:SetSize(70, 20);
    b:SetPoint("LEFT", self.Nameplate, "RIGHT", 5, 0);

    self.EditButton = b;
end

function GambitCharacterSheetFrameMixin:SetupAttributesDisplay()
    local f = CreateFrame("Frame", nil, self);
    f.bg = f:CreateTexture(nil, "BACKGROUND");
    f.bg:SetAtlas("GarrMissionLocation-Maw-bg-02");
    f.bg:ClearAllPoints();
    f.bg:SetAllPoints(f);

    f:SetPoint("TOPLEFT", self.Nameplate, "BOTTOMLEFT", 0, 0);
    f:SetPoint("BOTTOMRIGHT", self, "BOTTOMRIGHT", -10, 10);

    self.AttributeFrameContainer = f;

    self:UpdateAttributesPosition();
end

function GambitCharacterSheetFrameMixin:UpdateAttributesPosition()
    if not self.CharacterSheet then
        return;
    end

    self.CharacterAttributes = self.CharacterAttributes or {};

    local i = 1;
    local goToNextLine = false;
    for attribute, _ in pairs(self.CharacterSheet.Attributes) do
        local display = self.CharacterAttributes[i] or self:GetGenericStatDisplay(self.AttributeFrameContainer);
        display.Attribute = attribute; -- attribute abbreviation

        display:ClearAllPoints();

        if goToNextLine then
            -- previous entry was the last in it's row, so go to the next line
            local lineFirstIndex = i - self.MAX_ATTRIBUTES_PER_LINE;
            display:SetPoint("TOPLEFT", self.CharacterAttributes[lineFirstIndex], "BOTTOMLEFT", 0, -10);
            goToNextLine = false;
        elseif i == 1 then
            display:SetPoint("TOPLEFT", self.AttributeFrameContainer, "TOPLEFT", 10, -10);
        else
            display:SetPoint("LEFT", self.CharacterAttributes[i - 1], "RIGHT", 25, 0);
        end

        -- set this when the row has reached MAX_ATTRIBUTES_PER_LINE
        goToNextLine = (i % self.MAX_ATTRIBUTES_PER_LINE)  == 0;

        local attributeText = L["ATTRIBUTE_"..attribute];
        display.Label:SetText(attributeText);

        display.SetValue = function(self, value) self.StatValueRing.Value:SetText(value) end;

        tinsert(self.CharacterAttributes, i, display);
        i = i + 1;
    end
end

function GambitCharacterSheetFrameMixin:GetGenericStatDisplay(parent)
    local f = CreateFrame("Frame", nil, parent, "BackdropTemplate");
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
    f.ModifierValue:SetText("+1");
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

function GambitCharacterSheetFrameMixin:UpdateCharacterSheetView(sheetID)
    sheetID = sheetID or GambitAPI.DB:GetCurrentCharacterSheetID();

    local oldSheet = self.CharacterSheet;
    local newSheet = GambitAPI.DB:GetCharacterSheet(self.SheetID);

    if oldSheet and (oldSheet.Revision < newSheet.Revision) then
        self.CharacterSheet = newSheet;
        self.SheetID = sheetID;
    end
end

function GambitCharacterSheetFrameMixin:UpdateCharacterAttributes()
    for _, displayFrame in pairs(self.CharacterAttributes) do
        local value = self.DisplayedCharacterSheet.Attributes[displayFrame.Attribute];
        displayFrame:SetValue(value);
        displayFrame.ModifierValue:SetText("+1");
    end
end

function GambitCharacterSheetFrameMixin:SetCharacterName(name)
    self.Nameplate.TextContainer.Text:SetText(name);
end

function GambitCharacterSheetFrameMixin:SetCharacterRace(race)
    self.Nameplate.RaceTextContainer.Text:SetText(race);
end

function GambitCharacterSheetFrameMixin:SetCharacterClass(class)
    self.Nameplate.ClassTextContainer.Text:SetText(class);
end

function GambitCharacterSheetFrameMixin:UpdateCharacterAlignment()
    local alignment = self.CharacterSheet.Alignment
    local alignmentText = L["ALIGNMENT_"..alignment];
    local alignmentColor = GambitAPI.Utils.GetAlignmentColor(alignment);
    alignmentText = alignmentColor:WrapTextInColorCode(alignmentText);

    self.Nameplate.AlignmentTextContainer.Text:SetText(alignmentText);
end

function GambitCharacterSheetFrameMixin:Update()
    if not self.CharacterSheet then
        self:UpdateCharacterSheetView()
    end

    local TRP3_Player = AddOn_TotalRP3.Player.GetCurrentUser();

    local displayName = TRP3_Player:GetCustomColoredRoleplayingNamePrefixedWithIcon(20)
    local characteristics = TRP3_Player:GetCharacteristics();
    local displayColor = TRP3_Player:GetCustomColorForDisplay();

    local class = characteristics.CL;
    local race = characteristics.RA;

    if displayColor then
        class = displayColor:WrapTextInColorCode(class);
        race = displayColor:WrapTextInColorCode(race);
    end

    self:SetCharacterName(displayName);
    self:SetCharacterClass(class);
    self:SetCharacterRace(race);

    assert(self.CharacterSheet, "Missing Character Sheet");

    self:UpdateCharacterAlignment();
    self:UpdateCharacterAttributes();

    if self.ResizeTextContainers then
        for _, v in ipairs(self.ResizeTextContainers) do
            v:MarkDirty();
        end
    end
end

function GambitCharacterSheetFrameMixin:OnShow()
    GambitAPI.EventHandler:TriggerEvent(GambitAPI.Events.CHARACTER_SHEET_OPENED);

    if not self.Initialized then
        self:Init();
    end

    if not self.CharacterSheet then
        self:UpdateCharacterSheetView(GambitAPI.DB:GetCurrentCharacterSheetID());
    end

    self:Update();
end

function GambitCharacterSheetFrameMixin:ShowCharacterSheet(sheetID)
end

function GambitCharacterSheetFrameMixin:OnCharacterSheetChanged(sheetID)
    print("OnCharacterSheetChanged: " .. sheetID);
    self:UpdateCharacterSheetView(sheetID);
    self:Update();
end

function GambitCharacterSheetFrameMixin:OnCharacterSheetUpdated(sheetID)
    print("OnCharacterSheetUpdated: " .. sheetID);
    if sheetID == self.SheetID then
        self:UpdateCharacterSheetView(sheetID);
        self:Update();
    end
end

GambitAPI.Mixins.GambitCharacterSheetFrameMixin = GambitCharacterSheetFrameMixin;

-- FACTORY FUNCTION

function GambitAPI.Utils.Factory.CreateCharacterSheetFrame()
    assert(not GambitAPI.CharacterSheetFrame, "Attempt to create a duplicate CharacterSheetFrame");

    local f = CreateFrame("Frame", "Gambit_CharacterSheetFrame", nil, "BackdropTemplate");
    Mixin(f, GambitAPI.Mixins.GambitCharacterSheetFrameMixin);

    GambitAPI.EventHandler:TriggerEvent(GambitAPI.Events.CHARACTER_SHEET_FRAME_CREATED);

    return f;
end