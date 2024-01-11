local GambitAPI = Gambit_Addon.API;

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

function Utils.GenerateID()
    local id = date("%m%d%H%M%S");
	for _=1, 5 do
		id = id .. ID_CHARS[math.random(1, sID_CHARS)];
	end
	return id;
end

function Utils.GetAlignmentColor(alignment)
	local color = GambitAPI.Enums.AlignmentColors[alignment];

	if not color then
		alignment = GambitAPI.Enums.AlignmentsReverse[alignment];
		color = GambitAPI.Enums.AlignmentColors[alignment];
	end

	return color;
end