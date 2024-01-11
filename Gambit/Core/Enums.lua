local GambitAPI = Gambit_Addon.API;
local L = GambitAPI.loc;

GambitAPI.Enums = {};

---@enum Alignments
GambitAPI.Enums.Alignments = {
    LG = "LG",
    NG = "NG",
    CG = "CG",
    LN = "LN",
    TN = "TN",
    CN = "CN",
    LE = "LE",
    NE = "NE",
    CE = "CE",
};

---@enum AlignmentColors
GambitAPI.Enums.AlignmentColors = {
    LG = CreateColor(1, 1, 1, 1),
    NG = CreateColor(1, 1, 1, 1),
    CG = CreateColor(1, 1, 1, 1),

    LN = CreateColor(1, 1, 1, 1),
    TN = CreateColor(1, 1, 1, 1),
    CN = CreateColor(1, 1, 1, 1),

    LE = CreateColor(1, 1, 1, 1),
    NE = CreateColor(1, 1, 1, 1),
    CE = CreateColor(1, 1, 1, 1),
};

---@enum Attributes
GambitAPI.Enums.Attributes = {
    STR = "STR",
    DEX = "DEX",
    CON = "CON",
    INT = "INT",
    WIS = "WIS",
    CHR = "CHR",
};

---@enum Skills
GambitAPI.Enums.Skills = {
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