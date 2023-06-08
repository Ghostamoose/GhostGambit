local GambitAPI = Gambit_Addon.API;
local L = GambitAPI.loc;

---@class Profile : Object
local Profile = {};

function Profile:New(profileName)
    self.Attributes = GambitAPI.Attributes:New();
    self.ProfileName = profileName;

    return Mixin({}, self);
end

GambitAPI.Profile = Profile;