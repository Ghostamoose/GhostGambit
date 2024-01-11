local GambitAPI = Gambit_Addon.API;
local L = GambitAPI.loc;

local localCharacterSheets, remoteCharacterSheets, currentCharacterSheetID, defaultCharacterSheet, characterLinks;

local function JoinedUnitName(unitToken)
    local name, realm = UnitFullName(unitToken);
    return name .. "-" .. realm;
end

local function InitDB()
    if not GambitDB then
        GambitDB = {};
    end

    if not GambitDB.Local then
        GambitDB.Local = {};
    end

    if not GambitDB.Remote then
        GambitDB.Remote = {};
    end

    if not GambitDB.Characters then
        GambitDB.Characters = {};
    end

    localCharacterSheets = GambitDB.Local;
    remoteCharacterSheets = GambitDB.Remote;

    defaultCharacterSheet = CreateAndInitFromMixin(GambitAPI.Mixins.CharacterSheetMixin, L.DEFAULT_SHEET_ID);
    characterLinks = GambitDB.Characters;

    local playerName = JoinedUnitName("player");
    local links = GambitAPI.DB:GetLinksForPlayer(playerName);
    currentCharacterSheetID = links and links.sheetID or L.DEFAULT_SHEET_ID;

    GambitAPI.EventHandler:TriggerEvent(GambitAPI.Events.DB_INITIALIZED);
end

GambitAPI.EventHandler:RegisterCallback(GambitAPI.Events.TRP3_MODULE_ENABLED, InitDB);

GambitAPI.DB = {};

function GambitAPI.DB:DoesLocalCharacterSheetExist(sheetID)
    return localCharacterSheets[sheetID] ~= nil
end

function GambitAPI.DB:DoesRemoteCharacterSheetExist(sheetID)
    return remoteCharacterSheets[sheetID] ~= nil
end

function GambitAPI.DB:CreateCharacterSheet(sheetName)
    local uniqueID = GambitAPI.CharacterSheetUtils.GenerateID();
    assert(not self:DoesLocalCharacterSheetExist(uniqueID), "UniqueID conflict");

    local newCharacterSheet = CreateAndInitFromMixin(GambitAPI.Mixins.CharacterSheetMixin, sheetName);
    localCharacterSheets[uniqueID] = newCharacterSheet;

    self:SelectLocalCharacterSheet(uniqueID);
    return uniqueID;
end

function GambitAPI.DB:GetCharacterSheet(sheetID)
    if sheetID == L.DEFAULT_SHEET_ID then
        return defaultCharacterSheet;
    end

    return localCharacterSheets[sheetID] or remoteCharacterSheets[sheetID];
end

function GambitAPI.DB:GetLinksForPlayer(playerName)
    return characterLinks[playerName] or {};
end

function GambitAPI.DB:GetDefaultCharacterSheet()
    return defaultCharacterSheet;
end

function GambitAPI.DB:GetCurrentCharacterSheet()
    return self:GetCharacterSheet(currentCharacterSheetID);
end

function GambitAPI.DB:GetCurrentCharacterSheetID()
    return currentCharacterSheetID or L.DEFAULT_SHEET_ID;
end

function GambitAPI.DB:OverwriteCharacterSheet(sheetID, newSheet)
    local oldSheet = self:GetCharacterSheet(sheetID);

    if oldSheet then
        newSheet.Revision = oldSheet.Revision + 1;
    end

    -- should probably do some recycling to prevent accidental deletions

    localCharacterSheets[sheetID] = newSheet;
    GambitAPI.EventHandler:TriggerEvent(GambitAPI.Events.CHARACTER_SHEET_UPDATED, sheetID);
end

function GambitAPI.DB:SelectLocalCharacterSheet(sheetID)
    if sheetID then
        assert(self:DoesLocalCharacterSheetExist(sheetID), "Local character sheet with ID " .. sheetID .. " does not exist");
        currentCharacterSheetID = sheetID;
    else
        currentCharacterSheetID = L.DEFAULT_SHEET_ID;
    end

    self:UpdateLinkForUnit("player", currentCharacterSheetID);

    GambitAPI.EventHandler:TriggerEvent(GambitAPI.Events.CHARACTER_SHEET_CHANGED, currentCharacterSheetID);

    return currentCharacterSheetID;
end

function GambitAPI.DB:UpdateLinkForUnit(unitToken, sheetID)
    local playerName = JoinedUnitName(unitToken);

    if not characterLinks[playerName] then
        characterLinks[playerName] = {};
    end

    characterLinks[playerName].sheetID = sheetID;
end

function GambitAPI.DB:DeleteLocalCharacterSheet(sheetID)
    assert(self:DoesLocalCharacterSheetExist(sheetID), "Character sheet does not exist: " .. sheetID);
    assert(sheetID ~= currentCharacterSheetID, "Attempt to delete currently selected character sheet");
    localCharacterSheets[sheetID] = nil;
    return true;
end