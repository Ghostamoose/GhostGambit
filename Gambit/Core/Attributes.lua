local GambitAPI = Gambit_Addon.API;
local L = GambitAPI.loc;
local Enums = GambitAPI.Enums;

local defaultAttributeLevel = 3;

---@class Attributes : Object
local Attributes = {};

---@return Attributes
function Attributes:New()
    self.STR = defaultAttributeLevel;
    self.DEX = defaultAttributeLevel;
    self.CON = defaultAttributeLevel;
    self.INT = defaultAttributeLevel;
    self.WIS = defaultAttributeLevel;
    self.CHA = defaultAttributeLevel;

    return Mixin({}, self);
end

---@param attribute string
---@param value number
---@return number
function Attributes:SetAttribute(attribute, value)
    assert(Enums.Attributes[attribute], "Invalid attribute: " .. attribute);
    self[attribute] = value;
    return self[attribute];
end

---@param attribute string
---@return number
function Attributes:GetAttribute(attribute)
    assert(Enums.Attributes[attribute], "Invalid attribute: " .. attribute);
    return self[attribute];
end

---@param attribute string
function Attributes:GetModifier(attribute)
end

---@param attribute string
---@param modifier number
---@param duration number
function Attributes:AddExternalModifier(attribute, modifier, duration)
end

GambitAPI.Attributes = Attributes;