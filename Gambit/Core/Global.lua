local GambitAPI = Gambit_Addon.API;

local function GeneratePrintPrefix(moduleName, addNewLine)
    local prefix;

    if not moduleName then
        prefix = "|cfff542bfGambit|r: ";
    else
        prefix = "|cfff542bfGambit|r.|cfff542bf" .. moduleName .. "|r: ";
    end

    if addNewLine then
        return prefix .. "\n";
    else
        return prefix;
    end
end

local function GenerateDumpPrefix(moduleName, tableTitle)
    local prefix = GeneratePrintPrefix(moduleName);

    if tableTitle then
        return prefix .. tableTitle .. "\n";
    else
        return prefix .. "\n";
    end
end

function GambitAPI.Print(module, ...)
    if not ...  or not GambitPreferences then
        return;
    end

    local message;
    local newTable = {};
    for _, v in ipairs({...}) do
        if v then
            local str = tostring(v);
            table.insert(newTable, str);
        end
    end
    message = strjoin(", ", unpack(newTable));

    local prefix = GeneratePrintPrefix(module);
    print(prefix .. message);
end

function GambitAPI.Dump(module, tableTitle, message)
    if type(tableTitle) == "table" then
        message = tableTitle;
        tableTitle = nil;
    end

    local prefix = GenerateDumpPrefix(module, tableTitle);
    print(prefix);
	DevTools_Dump(message);
end

function GambitAPI.DumpTableWithDisplayKeys(module, tableTitle, displayKeys, message)
    local prefix = GenerateDumpPrefix(module, tableTitle);
    print(prefix);

    for i, v in ipairs(message) do
        print("|cff88ccff[" .. i .. "] " .. displayKeys[i] .. "|r=\"" .. tostring(v) .. "\"");
    end
end