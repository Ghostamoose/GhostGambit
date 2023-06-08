local GambitAPI = Gambit_Addon.API;

GambitAPI.Events = {
    CHARACTER_SHEET_UPDATED = "CHARACTER_SHEET_UPDATED",
    CHARACTER_SHEET_LOADED = "CHARACTER_SHEET_LOADED",
    CHARACTER_SHEET_DELETED = "CHARACTER_SHEET_DELETED",
    CHARACTER_SHEET_OPENED = "CHARACTER_SHEET_OPENED",

    DICE_ROLL_REQUESTED = "DICE_ROLL_REQUESTED",
    DICE_ROLL_RESULT = "DICE_ROLL_RESULT",
}

GambitAPI.callbacks = TRP3_API.InitCallbackRegistryWithEvents(GambitAPI, GambitAPI.Events);

function GambitAPI:TriggerEvent(event, ...)
    assert(self.Events[event], "attempted to trigger an invalid addon event");
	self.callbacks:Fire(event, ...);
end
