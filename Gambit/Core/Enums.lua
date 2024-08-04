local GambitAPI = Gambit_Addon.API;
local L = GambitAPI.loc;

GambitAPI.Enum = {};

---@enum Alignments
GambitAPI.Enum.Alignments = {
    LG = 1,
    NG = 2,
    CG = 3,
    LN = 4,
    TN = 5,
    CN = 6,
    LE = 7,
    NE = 8,
    CE = 9,
};

---@enum AlignmentsReverse
GambitAPI.Enum.AlignmentsReverse = tInvert(GambitAPI.Enum.Alignments);

---@enum AlignmentColors
GambitAPI.Enum.AlignmentColors = {
    [GambitAPI.Enum.Alignments.LG] = CreateColor(1, 1, 1, 1),
    [GambitAPI.Enum.Alignments.NG] = CreateColor(1, 1, 1, 1),
    [GambitAPI.Enum.Alignments.CG] = CreateColor(1, 1, 1, 1),

    [GambitAPI.Enum.Alignments.LN] = CreateColor(1, 1, 1, 1),
    [GambitAPI.Enum.Alignments.TN] = CreateColor(1, 1, 1, 1),
    [GambitAPI.Enum.Alignments.CN] = CreateColor(1, 1, 1, 1),

    [GambitAPI.Enum.Alignments.LE] = CreateColor(1, 1, 1, 1),
    [GambitAPI.Enum.Alignments.NE] = CreateColor(1, 1, 1, 1),
    [GambitAPI.Enum.Alignments.CE] = CreateColor(1, 1, 1, 1),
};

---@enum Attributes
GambitAPI.Enum.Attributes = {
    STR = 1,
    DEX = 2,
    CON = 3,
    INT = 4,
    WIS = 5,
    CHR = 6,
};

---@enum Skills
GambitAPI.Enum.Skills = {
    ACROBATICS = 1,
    ANIMAL_HANDLING = 2,
    ARCANA = 3,
    ATHLETICS = 4,
    DECEPTION = 5,
    HISTORY = 6,
    INSIGHT = 7,
    INTIMIDATION = 8,
    INVESTIGATION = 9,
    MEDICINE = 10,
    NATURE = 11,
    PERCEPTION = 12,
    PERFORMANCE = 13,
    PERSUASION = 14,
    RELIGION = 15,
    SLEIGHT_OF_HAND = 16,
    STEALTH = 17,
    SURVIVAL = 18,
};