local GambitAPI = Gambit_Addon.API;
local L = GambitAPI.loc;

---------------

GambitCharacterSheetEditableFontstringMixin = {};

function GambitCharacterSheetEditableFontstringMixin:OnEnterPressed()
    if self.Callback and type(self.Callback) == "function" then
        self:Callback();
    end

    self:SetText(self.EditBox:GetText());
end

function GambitCharacterSheetEditableFontstringMixin:OnEditStateChanged(isEditing)
    if isEditing then
        self.StaticText:Hide();
        self.EditBox:Show();
    else
        self.StaticText:Show();
        self.EditBox:Hide();
    end
end

function GambitCharacterSheetEditableFontstringMixin:SetText(text)
    self.EditBox:SetText(text);
    self:UpdateStaticText();
end

function GambitCharacterSheetEditableFontstringMixin:UpdateStaticText()
    local text = self.EditBox:GetText();
    self.StaticText:SetText(text);
end

---------------

GambitCharacterSheetAttributeDisplayMixin = {};

function GambitCharacterSheetAttributeDisplayMixin:OnLoad()
    self.AttributeValue:SetTextScale(4);
    self.ModifierValue:SetTextScale(1.3);
    self.Label:SetTextScale(1.1);

    self.NineSlice.BottomEdge:Hide();
end

function GambitCharacterSheetAttributeDisplayMixin:SetLabelText(text)
    self.Label:SetText(text);
end

function GambitCharacterSheetAttributeDisplayMixin:SetAttributeText(text)
    self.AttributeValue:SetText(text);
end

function GambitCharacterSheetAttributeDisplayMixin:SetModifierText(text)
    self.ModifierValue:SetText(text);
end

---------------

GambitCharacterSheetAttributesMixin = {};

function GambitCharacterSheetAttributesMixin:OnLoad()
    self.Strength:SetLabelText(L.ATTRIBUTE_STR);
    self.Dexterity:SetLabelText(L.ATTRIBUTE_DEX);
    self.Constitution:SetLabelText(L.ATTRIBUTE_CON);
    self.Intelligence:SetLabelText(L.ATTRIBUTE_INT);
    self.Wisdom:SetLabelText(L.ATTRIBUTE_WIS);
    self.Charisma:SetLabelText(L.ATTRIBUTE_CHR);
end

---------------

GambitCharacterSheetHeaderMixin = {};

function GambitCharacterSheetHeaderMixin:OnLoad()
    self.ProfileName.StaticText:SetJustifyH("CENTER");
    self.ProfileName.StaticText:SetTextScale(1.2);
    self.ProfileName:SetText(L.CHARACTER_SHEET_PH_PROFILE_NAME);

    self.ClassLevel.EditableText:SetText(L.CHARACTER_SHEET_PH_CLASSLEVEL);
    self.ClassLevel.Label:SetText(L.CHARACTER_SHEET_LABEL_CLASSLEVEL);

    self.Alignment.EditableText:SetText(L.CHARACTER_SHEET_PH_ALIGNMENT);
    self.Alignment.Label:SetText(L.CHARACTER_SHEET_LABEL_ALIGNMENT);

    self.Race.EditableText:SetText(L.CHARACTER_SHEET_PH_RACE);
    self.Race.Label:SetText(L.CHARACTER_SHEET_LABEL_RACE);

    self.LinkedCharacter.EditableText:SetText(L.CHARACTER_SHEET_PH_LINKED_CHAR);
    self.LinkedCharacter.Label:SetText(L.CHARACTER_SHEET_LABEL_LINKED_CHAR);
end

function GambitCharacterSheetHeaderMixin:SetClassLevelText(text)
    self.ClassLevel.EditableText:SetText(text);
end

function GambitCharacterSheetHeaderMixin:SetAlignmentText(text)
    self.Alignment.EditableText:SetText(text);
end

function GambitCharacterSheetHeaderMixin:SetRaceText(text)
    self.Race.EditableText:SetText(text);
end

function GambitCharacterSheetHeaderMixin:SetLinkedCharText(text)
    self.LinkedCharacter.EditableText:SetText(text);
end

function GambitCharacterSheetHeaderMixin:SetProfileNameText(text)
    self.ProfileName:SetText(text);
end

---------------

---@class SkillsEntryData
---@field SkillName string
---@field ModifierValue number
---@field Proficiency boolean

GambitCharacterSheetSkillsEntryMixin = {};

function GambitCharacterSheetSkillsEntryMixin:Init(data)
    self.ProficiencyBubble:SetChecked(data.Proficiency);
    self.SkillName:SetText(data.SkillName);
    self.ModifierValue:SetText(data.ModifierValue);
end

---------------

local function SortBySkillIndex(a, b)
    return a.SkillIndex < b.SkillIndex;
end

GambitCharacterSheetSkillsMixin = {};

function GambitCharacterSheetSkillsMixin:OnLoad()
    self.DataProvider = CreateDataProvider();

    local padding = 0;
    local spacing = 4;
    self.ScrollView = CreateScrollBoxListLinearView(padding, padding, padding, padding, spacing);
    self.ScrollView:SetDataProvider(self.DataProvider);

    local function Initializer(frame, data)
        frame:Init(data);
    end

    self.ScrollView:SetPanExtent(20);
    self.ScrollView:SetElementExtent(30);
    self.ScrollView:SetElementInitializer("GambitCharacterSheetSkillsEntryTemplate", Initializer);

    self.DataProvider:SetSortComparator(SortBySkillIndex);

    self.ScrollBox:SetInterpolateScroll(true);
    self.ScrollBar:SetInterpolateScroll(true);

    ScrollUtil.InitScrollBoxListWithScrollBar(self.ScrollBox, self.ScrollBar, self.ScrollView);

    local anchorsWithScrollBar = {
        CreateAnchor("TOPLEFT", 4, -4);
        CreateAnchor("BOTTOMRIGHT", self.ScrollBar, -13, 0),
    };

    local anchorsWithoutScrollBar = {
        anchorsWithScrollBar[1],
        CreateAnchor("BOTTOMRIGHT", -4, 0);
    };

    ScrollUtil.AddManagedScrollBarVisibilityBehavior(self.ScrollBox, self.ScrollBar, anchorsWithScrollBar, anchorsWithoutScrollBar);

    for skill, i in pairs(GambitAPI.Enums.Skills) do
        local data = {
            SkillIndex = i,
            SkillName = L["SKILL_"..skill],
            ModifierValue = fastrandom(1, 5),
            Proficiency = fastrandom(1, 2) == 1,
        };
        self.DataProvider:Insert(data);
    end
    self.DataProvider:Sort();
end

---------------