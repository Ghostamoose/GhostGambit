local GambitAPI = Gambit_Addon.API;
local L = GambitAPI.loc;
local Enums = GambitAPI.Enums;

---@class Profile : Object
local Profile = {};

function Profile:New(profileName)
    self.Attributes = GambitAPI.Attributes:New();
    self.ProfileName = profileName;
    self.Alignment = Enums.Alignments.CG;

    return Mixin({}, self);
end

function Profile:GetCurrentProfile()
    return self.ProfileName;
end

GambitAPI.Profile = Profile;