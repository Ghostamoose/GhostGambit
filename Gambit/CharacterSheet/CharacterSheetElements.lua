local GambitAPI = Gambit_Addon.API;

local L = GambitAPI.loc;
local Enum = GambitAPI.Enum;
local Events = GambitAPI.Events;
local Registry = GambitAPI.EventRegistry;
local Attributes = Enum.Attributes;

---------------

GambitCharacterSheetEditableFontstringMixin = {};

function GambitCharacterSheetEditableFontstringMixin:OnLoad()
    Registry:RegisterCallback(Events.CHARACTER_SHEET_EDIT_STATE_CHANGED, self.OnEditStateChanged, self);
end

function GambitCharacterSheetEditableFontstringMixin:OnEnterPressed()
    self:SetText(self.EditBox:GetText());
    if self.Callback and type(self.Callback) == "function" then
        self:Callback();
    end
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
    self:SetAttribute(10);

    self.AttributeValue:SetTextScale(1.3);
    self.ModifierValue:SetTextScale(3.7);
    self.Label:SetTextScale(1.1);

    self.NineSlice.BottomEdge:Hide();
end

function GambitCharacterSheetAttributeDisplayMixin:SetLabelText(text)
    self.Label:SetText(text);
end

function GambitCharacterSheetAttributeDisplayMixin:SetAttribute(number)
    self.Attribute = number;
    self:Update();
    Registry:TriggerEvent(Events.CHARACTER_SHEET_ATTRIBUTE_UPDATED, self.Attribute);
end

function GambitCharacterSheetAttributeDisplayMixin:GetAttribute()
    return self.Attribute;
end

function GambitCharacterSheetAttributeDisplayMixin:GetModifier()
    return self.Modifier;
end

function GambitCharacterSheetAttributeDisplayMixin:UpdateModifier()
    local modifier = floor((self.Attribute - 10) / 2);
    self.Modifier = Clamp(modifier, -5, 5);
end

function GambitCharacterSheetAttributeDisplayMixin:Update()
    self:UpdateModifier(); -- update the modifier for the attribute value
    self.AttributeValue:SetText(self.Attribute);
    self.ModifierValue:SetText(format("%+d", self.Modifier));
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

    self.Lookup = {
        [Enum.Attributes.STR] = self.Strength,
        [Enum.Attributes.DEX] = self.Dexterity,
        [Enum.Attributes.CON] = self.Constitution,
        [Enum.Attributes.INT] = self.Intelligence,
        [Enum.Attributes.WIS] = self.Wisdom,
        [Enum.Attributes.CHR] = self.Charisma,
    };
end

function GambitCharacterSheetAttributesMixin:SetAttribute(attribute, number)
    local attr = self.Lookup[attribute];
    attr:SetAttribute(number);
end

function GambitCharacterSheetAttributesMixin:GetAttribute(attribute)
    local attr = self.Lookup[attribute];
    return attr:GetAttribute();
end

function GambitCharacterSheetAttributesMixin:GetModifier(attribute)
    local attr = self.Lookup[attribute];
    return attr:GetModifier();
end

---------------

GambitCharacterSheetHeaderMixin = {};

function GambitCharacterSheetHeaderMixin:OnLoad()
    self.CharacterName.StaticText:SetJustifyH("CENTER");
    self.CharacterName.StaticText:SetTextScale(1.2);
    self.CharacterName:SetText(L.CHARACTER_SHEET_PH_NAME);
    self.CharacterName.Callback = function()
        CallMethodOnNearestAncestor(self, "Edit", "CharacterName", self.CharacterName.EditBox:GetText());
    end;

    self.ClassLevel.EditableText:SetText(L.CHARACTER_SHEET_PH_CLASSLEVEL);
    self.ClassLevel.Label:SetText(L.CHARACTER_SHEET_LABEL_CLASSLEVEL);

    self.Alignment.EditableText:SetText(L.CHARACTER_SHEET_PH_ALIGNMENT);
    self.Alignment.Label:SetText(L.CHARACTER_SHEET_LABEL_ALIGNMENT);

    self.Race.EditableText:SetText(L.CHARACTER_SHEET_PH_RACE);
    self.Race.Label:SetText(L.CHARACTER_SHEET_LABEL_RACE);

    self.LinkedCharacter.EditableText:SetText(L.CHARACTER_SHEET_PH_LINKED_CHAR);
    self.LinkedCharacter.Label:SetText(L.CHARACTER_SHEET_LABEL_LINKED_CHAR);
end

function GambitCharacterSheetHeaderMixin:SetClassLevel(text)
    self.ClassLevel.EditableText:SetText(text);
end

function GambitCharacterSheetHeaderMixin:SetAlignment(alignment)
    alignment = Enum.AlignmentsReverse[alignment];
    local text = L["ALIGNMENT_"..alignment]

    self.Alignment.EditableText:SetText(text);
end

function GambitCharacterSheetHeaderMixin:SetRace(text)
    self.Race.EditableText:SetText(text);
end

function GambitCharacterSheetHeaderMixin:SetLinkedChar(text)
    self.LinkedCharacter.EditableText:SetText(text);
end

function GambitCharacterSheetHeaderMixin:SetCharacterName(text)
    self.CharacterName:SetText(text);
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

    for skill, i in pairs(GambitAPI.Enum.Skills) do
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

---@class FeaturesEntryData
---@field FeatureName string

GambitCharacterSheetFeaturesEntryMixin = {};

function GambitCharacterSheetFeaturesEntryMixin:Init(data)
    self.FeatureName:SetText(data.FeatureName);
end

---------------

GambitCharacterSheetFeaturesMixin = {};

function GambitCharacterSheetFeaturesMixin:OnLoad()
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
    self.ScrollView:SetElementInitializer("GambitCharacterSheetFeaturesEntryTemplate", Initializer);

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

    for i=1, 20 do
        local data = {
            FeatureName = L.FEATURE_PH,
        };
        self.DataProvider:Insert(data);
    end
end

---------------

local DEFAULT_MAX_HEALTH = 100;

GambitCharacterSheetHealthMixin = {};

function GambitCharacterSheetHealthMixin:OnLoad()
    local stylizedFillInfo = C_Texture.GetAtlasInfo("SpecDial_Fill_Flipbook_Enchanting");
    self.HealthBar:SetSwipeTexture(stylizedFillInfo.file or stylizedFillInfo.fileName);
    self.HealthBar:SetMaxHealth(DEFAULT_MAX_HEALTH);

    local lowTexCoords =
	{
		x = stylizedFillInfo.leftTexCoord,
		y = stylizedFillInfo.topTexCoord,
	};
	local highTexCoords =
	{
		x = stylizedFillInfo.rightTexCoord,
		y = stylizedFillInfo.bottomTexCoord,
	};
	self.HealthBar:SetTexCoordRange(lowTexCoords, highTexCoords);

    self.HealthBar:UpdateBar(DEFAULT_MAX_HEALTH);

    local duration = 1.5;
    local frameSize = 330;
	self.FlipBookNumRows = stylizedFillInfo.height / frameSize;
	self.FlipBookNumCols = stylizedFillInfo.width / frameSize;
	self.TimePerFrame = duration / (self.FlipBookNumRows * self.FlipBookNumCols);
	self.FlipBookULx = stylizedFillInfo.leftTexCoord;
	self.FlipBookULy = stylizedFillInfo.topTexCoord;
	self.FlipBookBRx = stylizedFillInfo.rightTexCoord;
	self.FlipBookBRy = stylizedFillInfo.bottomTexCoord;

	self.FrameRow = 1;
	self.FrameCol = 1;
end

function GambitCharacterSheetHealthMixin:OnUpdate(dt)
	if not self.TimePerFrame then
		return;
	end

	if self.TimeOnFrame then
		self.TimeOnFrame = self.TimeOnFrame + dt;
	end

	local isLastFrame = self.FrameCol == self.FlipBookNumCols and self.FrameRow == self.FlipBookNumRows;
	local frameTime = self.TimePerFrame;
	if isLastFrame then
		frameTime = frameTime + (self.EndDelay or 0);
	end
	if not self.TimeOnFrame or self.TimeOnFrame > frameTime then
		self.TimeOnFrame = 0;
		self.FrameCol = self.FrameCol + 1;
		if self.FrameCol > self.FlipBookNumCols then
			self.FrameCol = 1;
			self.FrameRow = self.FrameRow + 1;
			if self.FrameRow > self.FlipBookNumRows then
				self.FrameRow = 1;
			end
		end

		local lowTexCoords =
		{
			x = Lerp(self.FlipBookULx, self.FlipBookBRx, (self.FrameCol - 1) / self.FlipBookNumCols),
			y = Lerp(self.FlipBookULy, self.FlipBookBRy, (self.FrameRow - 1) / self.FlipBookNumRows),
		};
		local highTexCoords =
		{
			x = Lerp(self.FlipBookULx, self.FlipBookBRx, self.FrameCol / self.FlipBookNumCols),
			y = Lerp(self.FlipBookULy, self.FlipBookBRy, self.FrameRow / self.FlipBookNumRows),
		};
		self.HealthBar:SetTexCoordRange(lowTexCoords, highTexCoords);
	end
end

---------------

GambitCharacterSheetHealthBarMixin = {};

function GambitCharacterSheetHealthBarMixin:SetMaxHealth(maxHealth)
    self.MaxHealth = maxHealth;
end

function GambitCharacterSheetHealthBarMixin:GetMaxHealth()
    return self.MaxHealth or DEFAULT_MAX_HEALTH;
end

function GambitCharacterSheetHealthBarMixin:UpdateBar(currentValue)
	if not currentValue then
		return;
	end

	CooldownFrame_SetDisplayAsPercentage(self, currentValue / self:GetMaxHealth());
end