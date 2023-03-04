--[
--Script Made By xS_Killus
--]

local Exploit

local SeralizeTable = loadstring(game:HttpGet("https://raw.githubusercontent.com/Sklllus/B-S-Hub-V1/main/Utilities/SeralizeTable.lua", true))()

if syn and syn_crypt_derive then
    Exploit = "Synapse"
elseif gethui and identifyexecutor() == "ScriptWare" then
    Exploit = "Script-Ware"
end

local CachedFunctions = {
    rconsoleprint = getgenv()["rconsoleprint"],
    rconsolewarn = getgenv()["rconsolewarn"],
    rconsoleerr = getgenv()["rconsoleerr"] or getgenv()["rconsoleerror"],
    rconsoleinfo = getgenv()["rconsoleinfo"],
    rconsoleinput = getgenv()["rconsoleinput"]
}

local SWColors = {
    ["Black"] = true,
    ["red"] = true,
    ["ured"] = true,
    ["bred"] = true,
    ["green"] = true,
    ["ugreen"] = true,
    ["bgreen"] = true,
    ["yellow"] = true,
    ["uyellow"] = true,
    ["byellow"] = true,
    ["blue"] = true,
    ["ublue"] = true,
    ["bblue"] = true,
    ["magenta"] = true,
    ["umagenta"] = true,
    ["bmagenta"] = true,
    ["cyan"] = true,
    ["ucyan"] = true,
    ["bcyan"] = true,
    ["white"] = true,
    ["uwhite"] = true,
    ["bwhite"] = true
}

local SynColors = {
    ["@@BLACK@@"] = true,
    ["@@BLUE@@"] = true,
    ["@@GREEN@@"] = true,
    ["@@CYAN@@"] = true,
    ["@@RED@@"] = true,
    ["@@MAGENTA@@"] = true,
    ["@@BROWN@@"] = true,
    ["@@LIGHT_GRAY@@"] = true,
    ["@@DARK_GRAY@@"] = true,
    ["@@LIGHT_BLUE@@"] = true,
    ["@@LIGHT_GREEN@@"] = true,
    ["@@LIGHT_CYAN@@"] = true,
    ["@@LIGHT_RED@@"] = true,
    ["@@LIGHT_MAGENTA@@"] = true,
    ["@@YELLOW@@"] = true,
    ["@@WHITE@@"] = true
}

local Defaults = {
    rconsoleprint = nil,
    rconsolewarn = nil,
    rconsoleerr = nil,
    rconsoleerror = nil,
    rconsoleinfo = nil,
    rconsoleclear = nil,
    rconsolewritetable = nil
}

local function FormatData(...)
    local Args = {
        ...
    }

    for _, a in next, Args do
        if a == "" then
            CachedFunctions.rconsoleprint("")
        else
            Args[_] = tostring(a)
        end
    end

    local Coloring = select(#Args, ...)

    if not (isconsoleopen and isconsoleopen()) then
        rconsolecreate()

        local SWName, SWVer = identifyexecutor()

        rconsolesettitle(SWName .. " " .. SWVer)
    end

    if SWColors[Coloring] then
        Coloring = SWColors[Coloring]

        table.remove(Args, #Args)
    else
        Coloring = "white"
    end

    return {
        table.concat(Args, " "),
        Coloring
    }
end

local function FormatSynData(...)
    local Args = {
        ...
    }

    for _, a in next, Args do
        if a == "" then
            CachedFunctions.rconsoleprint("")
        else
            Args[_] = tostring(a)
        end
    end

    if #Args == 1 and Args[1]:find("@@") then
        if SynColors[Args[1]] then
            return Args[1]
        end

        return "@@WHITE@@"
    end

    return table.concat(Args, " ")
end

local function DoDash(color)
    CachedFunctions.rconsoleprint("[", "white")
    CachedFunctions.rconsoleprint("*", color)
    CachedFunctions.rconsoleprint("] ", "white")
end

if Exploit == "Synapse" then
    Defaults.rconsoleprint = function(...)
        local Formatted = FormatSynData(...)

        CachedFunctions.rconsoleprint(Formatted)
    end

    Defaults.rconsolewarn = function(...)
        local Formatted = FormatSynData(...)

        CachedFunctions.rconsolewarn(Formatted)
    end

    Defaults.rconsoleerr = function(...)
        local Formatted = FormatSynData(...)

        CachedFunctions.rconsoleerr(Formatted)
    end

    Defaults.rconsoleinfo = function(...)
        local Formatted = FormatSynData(...)

        CachedFunctions.rconsoleinfo(Formatted)
    end

    Defaults.rconsoleerror = Defaults.rconsoleerr
elseif Exploit == "Script-Ware" then
    Defaults.rconsoleprint = function(...)
        local Formatted = FormatData(...)

        CachedFunctions.rconsoleprint(Formatted[1], Formatted[2])
    end

    Defaults.rconsolewarn = function(...)
        local Formatted = FormatData(...)

        DoDash("yellow")

        CachedFunctions.rconsoleprint(Formatted[1], Formatted[2])
        CachedFunctions.rconsoleprint("")
    end

    Defaults.rconsoleerr = function(...)
        local Formatted = FormatData(...)

        DoDash("red")

        CachedFunctions.rconsoleprint(Formatted[1], Formatted[2])
        CachedFunctions.rconsoleprint("")
    end

    Defaults.rconsoleinfo = function(...)
        local Formatted = FormatData(...)

        DoDash("blue")

        CachedFunctions.rconsoleprint(Formatted[1], Formatted[2])
        CachedFunctions.rconsoleprint("")
    end

    Defaults.rconsoleerror = Defaults.rconsoleerr
end

for c, l in next, CachedFunctions do
    c = l
end

for fn, f in next, Defaults do
    getgenv()[tostring(fn)] = f
end

getgenv()["rconsolewritetable"] = function(table)
    if typeof(table) ~= "table" then
        return warn("Break-Skill Hub - V1 | Error | You must provide a table as the first argument!")
    end

    rconsolewarn(("Table ID: %s "):format(tostring(table)))
    rconsoleprint(SeralizeTable(table) or "Failure to seralize")
    rconsoleprint("")
end
