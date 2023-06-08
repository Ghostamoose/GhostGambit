Gambit_Addon = LibStub("AceAddon-3.0"):NewAddon("Gambit", "AceConsole-3.0");
Gambit_Addon.API = {};

--- Build version, based on Git revision number (ex: 1723)
--[===[@non-debug@
Gambit_API.BUILD_NUMBER = @project-revision@;
--@end-non-debug@]===]

--@debug@
Gambit_Addon.API.BUILD_NUMBER = -1;
--@end-debug@

--- Display version, based on the build tag (ex: 1.5.2)
--[===[@non-debug@
Gambit_API.VERSION_DISPLAY = "@project-version@";
--@end-non-debug@]===]
--@debug@
Gambit_Addon.API.VERSION_DISPLAY = "-dev";
--@end-debug@

Gambit_Addon.API.globals = {
	--@debug@

	-- Debug mode is enable when the add-on has not been packaged by Curse
	DEBUG_MODE = true,
	--@end-debug@

	--[===[@non-debug@

	-- Debug mode is disabled when the add-on has been packaged by Curse
	DEBUG_MODE = false,

	--@end-non-debug@]===]
};

Gambit_Addon.API.utils = {
	log = {},
	table = {},
	str = {},
	color = {},
	math = {},
	serial = {},
	event = {},
	music = {},
	texture = {},
	message = {},
	resources = {},
	factory = {}
};

Gambit_Addon.API.loc = LibStub("AceLocale-3.0"):GetLocale("Gambit", true);

