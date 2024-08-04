local GambitAPI = Gambit_Addon.API;
local L = GambitAPI.loc;
local Enum = GambitAPI.Enum;
local Utils = GambitAPI.Utils;
local Events = GambitAPI.Events;
local Registry = GambitAPI.EventRegistry;

local DEFAULT_SHEET_NAME = L.CHARACTER_SHEET_PH_PROFILE_NAME;
local DEFAULT_CHARACTER_NAME = L.CHARACTER_SHEET_PH_NAME;
local DEFAULT_ALIGNMENT = Enum.Alignments.TN;
local DEFAULT_ATTRIBUTES = {};
for attr, _ in pairs(Enum.Attributes) do
    DEFAULT_ATTRIBUTES[attr] = 10;
end
local DEFAULT_RACE = L.CHARACTER_SHEET_PH_RACE;
local DEFAULT_CLASS = L.CHARACTER_SHEET_PH_CLASS;
local DEFAULT_LEVEL = 1;
local DEFAULT_SKILLS = {}; -- TODO: populate
local DEFAULT_FEATURES = {}; -- TODO: populate
local DEFAULT_LINKS = {};

---@class GambitCharacterSheetID : string
---@class GambitCharacterSheet
local DEFAULT_SHEET = {
    SheetName = DEFAULT_SHEET_NAME,
    CharacterName = DEFAULT_CHARACTER_NAME,
    Alignment = DEFAULT_ALIGNMENT,
    Attributes = DEFAULT_ATTRIBUTES,
    Race = DEFAULT_RACE,
    Class = DEFAULT_CLASS,
    Level = DEFAULT_LEVEL,
    Skills = DEFAULT_SKILLS,
    Features = DEFAULT_FEATURES,
    Links = DEFAULT_LINKS,
    Local = false,
    ID = nil,
};

local db_defaults = {
    global = {
        Links = {};
        Sheets = {
            ["**"] = DEFAULT_SHEET,
        },
    },
};

local STORAGE_TYPE_SHEETS = 1;
local STORAGE_TYPE_LINKS = 2;

GambitAPI.Database = {};

function GambitAPI.Database:Initialize()
    local db = LibStub("AceDB-3.0"):New("GambitDB", db_defaults);
    self._data = db.global;
end

function GambitAPI.Database:GetDefaultCharacterSheet()
    return CopyTable(DEFAULT_SHEET);
end

function GambitAPI.Database:GetStorage(storageType)
    if storageType == STORAGE_TYPE_SHEETS then
        return self._data.Sheets;
    elseif storageType == STORAGE_TYPE_LINKS then
        return self._data.Links;
    end
end

-- UTILS --

function GambitAPI.Database:IsSheetValid(sheet)
    print(sheet and (sheet.ID ~= nil) or false);
    return sheet and (sheet.ID ~= nil) or false;
end

function GambitAPI.Database:DoesSheetNameExist(sheetName)
    local sheet, _ = self:GetCharacterSheetByName(sheetName);
    print(sheetName, sheet);
    return self:IsSheetValid(sheet);
end

function GambitAPI.Database:DoesSheetIDExist(sheetID)
    local sheet, _ = self:GetCharacterSheet(sheetID);
    return self:IsSheetValid(sheet);
end

function GambitAPI.Database:LinkCharacterIDToSheetID(characterID, sheetID)
    local links = self:GetStorage(STORAGE_TYPE_LINKS);
    links[characterID] = sheetID;
end

-- SAVING --

function GambitAPI.Database:SaveCharacterSheet(sheet)
    local sheetID = sheet.ID;
    if not sheetID then
        sheetID = Utils.GenerateUniqueID();
        sheet.ID = sheetID;
    end

    local storage = self:GetStorage(STORAGE_TYPE_SHEETS);
    storage[sheetID] = sheet;

    Registry:TriggerEvent(Events.CHARACTER_SHEET_UPDATED, sheetID);

    return sheetID;
end

-- GETTERS --

---@param sheetID GambitCharacterSheetID
---@return GambitCharacterSheet?
function GambitAPI.Database:GetCharacterSheet(sheetID)
    local storage = self:GetStorage(STORAGE_TYPE_SHEETS);
    local sheet = storage[sheetID];
    if self:IsSheetValid(sheet) then
        return sheet;
    end
end

-- this lookup is always assumed to be local
---@param sheetName string
---@return GambitCharacterSheet?, GambitCharacterSheetID?
function GambitAPI.Database:GetCharacterSheetByName(sheetName)
    local storage = self:GetStorage(STORAGE_TYPE_SHEETS);
    for sheetID, sheet in pairs(storage) do
        if sheet.SheetName == sheetName then
            return sheet, sheetID;
        end
    end
end

---@param characterID string
---@return GambitCharacterSheetID?
function GambitAPI.Database:GetLinkedCharacterSheetID(characterID)
    local storage = self:GetStorage(STORAGE_TYPE_LINKS);
    return storage[characterID];
end

---@param characterID string
---@return GambitCharacterSheet?, GambitCharacterSheetID?
function GambitAPI.Database:GetLinkedCharacterSheet(characterID)
    local sheetID = self:GetLinkedCharacterSheetID(characterID);
    local sheet = self:GetCharacterSheet(sheetID);
    return sheet, sheetID;
end

-- CREATION --

function GambitAPI.Database:InitializeNewCharacterSheet(sheet)
    local characterID = Utils.GetCharacterID();
    local characterName = Utils.SplitCharacterID(characterID);

    -- set sheet ID
    sheet.ID = Utils.GenerateUniqueID();

    -- set character link to the new sheet
    self:LinkCharacterIDToSheetID(characterID, sheet.ID);

    -- set class and level
    sheet.Class = "Adventurer";
    sheet.Level = 14;

    -- set race
    sheet.Race = "Sin'dorei";

    sheet.Local = true;
    sheet.CharacterName = characterName;
end

function GambitAPI.Database:CreateCharacterSheet(sheetName)
    if self:DoesSheetNameExist(sheetName) then
        return false; -- TODO: Handle duplicates somehow
    end

    local newSheet = self:GetDefaultCharacterSheet();
    newSheet.SheetName = sheetName;

    self:InitializeNewCharacterSheet(newSheet);
    self:SaveCharacterSheet(newSheet);
    return newSheet;
end

--------------

function Gambit_Addon:OnInitialize()
    self.DB = GambitAPI.Database;
    self.DB:Initialize();
end