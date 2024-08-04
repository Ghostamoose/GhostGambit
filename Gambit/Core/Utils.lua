local GambitAPI = Gambit_Addon.API;
local Enum = GambitAPI.Enum;
local Utils = GambitAPI.Utils;

-- stolen from TRP3
local ID_CHARS = {};
for i=48, 57 do
	tinsert(ID_CHARS, string.char(i));
end
for i=65, 90 do
	tinsert(ID_CHARS, string.char(i));
end
for i=97, 122 do
	tinsert(ID_CHARS, string.char(i));
end
local sID_CHARS = #ID_CHARS;

function Utils.GenerateUniqueID()
    local id = date("%m%d%H%M%S");
	for _=1, 5 do
		id = id .. ID_CHARS[math.random(1, sID_CHARS)];
	end
	return id;
end

function Utils.GetAlignmentColor(alignment)
	return Enum.AlignmentColors[alignment];
end

---@param unitToken? UnitId
---@return string characterID
function Utils.GetCharacterID(unitToken)
	unitToken = unitToken or "player";

	local name, realm = UnitFullName(unitToken);
	if not realm then
		realm = GetNormalizedRealmName();
	end

	return format("%s-%s", name, realm);
end

---@param unitToken? UnitId
---@return string? name, string? realm
function Utils.GetCharacterName(unitToken)
	local characterID = Utils.GetCharacterID(unitToken);
	local name, realm = strsplit("-", characterID, 2);
	return name, realm;
end

---@param characterID string
---@return string name, string realm
function Utils.SplitCharacterID(characterID)
	return strsplit("-", characterID, 2);
end

function Utils.UsingTRP3()
end