--//
--// Bypass V3 Made By xS_Killus
--//

local ReplicatedStorage = game:GetService("ReplicatedStorage")

local BypassSubVersion = "FullEmulationV2"
local Naughty = "RemoveLoadingScreen"

local ACFlags = 0

local ExcludedServices = {
    "ScriptContext",
    "RobloxReplicatedStorage",
    "ReplicatedStorage",
    "StarterGui",
    "Players",
    "Workspace"
}

local HandShakeEmulated

HandShakeEmulated = hookfunction(function(...)
    return task.wait(9e9)
end)

if getreg and hookfunction and isexecutorclosure and getgc then
    local function AssertFunction(v)
        return type(v) == "function" and islclosure(v) and not isexecutorclosure(v)
    end

    for _, o in next, getgc() do
        if AssertFunction(o) then
            local Source = debug.info(o, "s")

            if Source:find(Naughty) then
                ACFlags += 1

                hookfunction(o, function() end)
            end
        end
    end

    for _, o in next, getreg() do
        if type(o) == "thread" then
            local Source = debug.info(o, 1, "s")

            if Source and Source:find(Naughty) then
                ACFlags += 1

                coroutine.close(o)
            end
        end
    end
else
    BypassSubVersion = "OnlyEmulationV2"

    if getnilinstances then
        BypassSubVersion = "AltKillEmulationV2"

        local NilInstances = getnilinstances()

        for _, ni in next, NilInstances do
            if ni:IsA("LuaSourceContainer") and ni.Name:find("Loading") then
                ACFlags += 1

                ni:Destroy()
            end
        end
    end

    for _, s in next, game:GetChildren() do
        if table.find(ExcludedServices, s.Name) then
            continue
        end

        for _, c in next, s:GetChildren() do
            if c:IsA("RemoteEvent") then
                local Name = c.Name

                local Swap = Instance.new("UnreliableRemoteEvent")

                Swap.Name = Name
                Swap.Parent = s

                c:Destroy()
            end
        end
    end
end

local HandShake = ReplicatedStorage:WaitForChild("events"):WaitForChild("getsettings")

HandShake.OnClientInvoke = HandShakeEmulated
