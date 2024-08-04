local GambitAPI = Gambit_Addon.API;

GambitAPI.Events = {
    CHARACTER_SHEET_FRAME_CREATED = "Gambit.CharacterSheetFrameCreated",
    CHARACTER_SHEET_UPDATED = "Gambit.CharacterSheetUpdated",
    CHARACTER_SHEET_LOADED = "Gambit.CharacterSheetLoaded",
    CHARACTER_SHEET_DELETED = "Gambit.CharacterSheetDeleted",
    CHARACTER_SHEET_OPENED = "Gambit.CharacterSheetOpened",
    CHARACTER_SHEET_CHANGED = "Gambit.CharacterSheetChanged",
    CHARACTER_SHEET_EDIT_STATE_CHANGED = "Gambit.CharacterSheetEditStateChanged",
    CHARACTER_SHEET_ATTRIBUTE_UPDATED = "Gambit.CharacterSheetAttributeUpdated",

    DICE_ROLL_REQUESTED = "Gambit.DiceRollRequested",
    DICE_ROLL_RESULT = "Gambit.DiceRollResult",

    DB_INITIALIZED = "Gambit.DatabaseInitialized",

    TRP3_MODULE_INITIALIZED = "Gambit.TRP3ModuleInitialized",
    TRP3_MODULE_ENABLED = "Gambit.TRP3ModuleEnabled",
    TRP3_MODULE_DISABLED = "Gambit.TRP3ModuleDisabled",
};

GambitAPI.EventRegistry = EventRegistry;