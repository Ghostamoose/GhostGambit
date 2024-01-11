local GambitAPI = Gambit_Addon.API;
local L = GambitAPI.loc;

GambitCharacterFrameMixin = {};

function GambitCharacterFrameMixin:OnLoad()
    ButtonFrameTemplate_HidePortrait(self);
    self:SetTitle(L.CHARACTER_SHEET_FRAME_TITLE);

    RunNextFrame(function() DevTool:AddData(self, "GambitFrame") end);
end