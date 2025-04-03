--//
--// Bypass V1 Made By xS_Killus
--//

local AdService = game:GetService("AdService")

local BypassSubVersion = "Full"
local Naughty = "RemoveLoadingScreen"

local ACFlags = 0

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
    BypassSubVersion = "Partial"

    for _, c in next, AdService:GetChildren() do
        if c:IsA("RemoteEvent") then
            local Name = c.Name

            local Swap = Instance.new("UnreliableRemoteEvent")

            Swap.Name = Name
            Swap.Parent = AdService

            c:Destroy()
        end
    end
end
