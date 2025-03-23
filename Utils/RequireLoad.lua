--//
--// Script Made By xS_Killus
--//

getgenv().IsSynapseV3 = not not gethui

getgenv().DisableEnvProtection = function() end
getgenv().EnableEnvProtection = function() end
getgenv().SX_VM_CNONE = function() end

local __Scripts = {}

getgenv().__Scripts = __Scripts

local DebugInfo = debug.info

local Info = DebugInfo(1, "s")

__Scripts[Info] = "RequireLoad"

local CachedRequires = {}

_G.CachedRequires = CachedRequires

getgenv().GetServerConstant = function(...)
    return ...
end
