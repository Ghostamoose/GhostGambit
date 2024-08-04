local GambitAPI = Gambit_Addon.API;
local L = GambitAPI.loc;
local DB = GambitAPI.Database;
local Enum = GambitAPI.Enum;
local Utils = GambitAPI.Utils;
local Events = GambitAPI.Events;
local Registry = GambitAPI.EventRegistry;

GambitCharacterFrameMixin = {};

function GambitCharacterFrameMixin:OnLoad()
    ButtonFrameTemplate_HidePortrait(self);
    self:SetTitle(L.CHARACTER_SHEET_FRAME_TITLE);

    RunNextFrame(function() DevTool:AddData(self, "GambitFrame") end);

    Registry:RegisterCallback(Events.CHARACTER_SHEET_EDIT_STATE_CHANGED, self.OnCharacterSheetEditStateChanged, self);
    Registry:RegisterCallback(Events.CHARACTER_SHEET_UPDATED, self.OnCharacterSheetUpdated, self);

    self.CurrentSheet = nil;
    self.Editing = false;
end

function GambitCharacterFrameMixin:OnCharacterSheetEditStateChanged(isEditing)
    self.Editing = isEditing;
end

-- reload the sheet if it's updated while we're viewing it
function GambitCharacterFrameMixin:OnCharacterSheetUpdated(sheetID)
    if self.CurrentSheet and self.CurrentSheet.ID == sheetID then
        self:LoadCharacterSheetByID(sheetID);
    end
end

function GambitCharacterFrameMixin:HasAuthorityForCurrentSheet()
    return self.CurrentSheet and self.CurrentSheet.Local == true;
end

---Loads a character sheet
---@param sheet GambitCharacterSheet
---@return boolean success
function GambitCharacterFrameMixin:LoadCharacterSheet(sheet)
    if not sheet or not GambitFrame then
        return false;
    end

    -- Load attributes
    for attribute, value in pairs(sheet.Attributes) do
        attribute = Enum.Attributes[attribute];
        GambitFrame.Attributes:SetAttribute(attribute, value);
    end

    -- Set profile name
    GambitFrame.Header:SetCharacterName(sheet.CharacterName);

    -- Set alignment text
    GambitFrame.Header:SetAlignment(sheet.Alignment);

    -- Set class and level text
    GambitFrame.Header:SetClassLevel(format("%s (%d)", sheet.Class, sheet.Level));

    -- Set Race text
    GambitFrame.Header:SetRace(sheet.Race);

    self.CurrentSheet = sheet;
    return true;
end

function GambitCharacterFrameMixin:LoadCharacterSheetByID(sheetID)
    ---@type GambitCharacterSheet
    local sheet = DB:GetCharacterSheet(sheetID);
    return self:LoadCharacterSheet(sheet);
end

function GambitCharacterFrameMixin:LoadLinkedCharacterSheet(characterID)
    if not characterID then
        characterID = Utils.GetCharacterID();
    end

    local sheet = DB:GetLinkedCharacterSheet(characterID);
    return self:LoadCharacterSheet(sheet);
end

function GambitCharacterFrameMixin:Edit(key, value)
    if not self:HasAuthorityForCurrentSheet() then
        return;
    end

    self.CurrentSheet[key] = value;
    DB:SaveCharacterSheet(self.CurrentSheet);
end

function TEST()
    Registry:TriggerEvent(Events.CHARACTER_SHEET_EDIT_STATE_CHANGED, not GambitFrame.Editing);
end

EventUtil.RegisterOnceFrameEventAndCallback("PLAYER_ENTERING_WORLD", function() GambitFrame:LoadLinkedCharacterSheet("Ghost-Broxigar"); end)