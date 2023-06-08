local GambitAPI = Gambit_Addon.API;

function GambitAPI:IsValidAlignment(alignment)
    return tContains(GambitAPI.Enums.Alignments, alignment)
end