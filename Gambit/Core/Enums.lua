local GambitAPI = Gambit_Addon.API;
local L = GambitAPI.loc;

GambitAPI.Enums = {};

GambitAPI.Enums.Alignments = {
    LG = L.ALIGNMENT_LAWFUL_GOOD,
    NG = L.ALIGNMENT_NEUTRAL_GOOD,
    CG = L.ALIGNMENT_CHAOTIC_GOOD,

    LN = L.ALIGNMENT_LAWFUL_NEUTRAL,
    TN = L.ALIGNMENT_TRUE_NEUTRAL,
    CN = L.ALIGNMENT_CHAOTIC_NEUTRAL,

    LE = L.ALIGNMENT_LAWFUL_EVIL,
    NE = L.ALIGNMENT_NEUTRAL_EVIL,
    CE = L.ALIGNMENT_CHAOTIC_EVIL,
};

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

GambitAPI.Enums.Attributes = {
    STR = L.ATTRIBUTE_STRENGTH,
    DEX = L.ATTRIBUTE_DEXTERITY,
    CON = L.ATTRIBUTE_CONSTITUTION,
    INT = L.ATTRIBUTE_INTELLIGENCE,
    WIS = L.ATTRIBUTE_WISDOM,
    CHA = L.ATTRIBUTE_CHARISMA,
};
