--//
--// Entity Made By xS_Killus
--//

local EntityLib = {
    IsAlive = false,
    Character = {},
    List = {},
    Connections = {},
    PlayerConnections = {},
    EntityThreads = {},
    Running = false,
    Events = setmetatable({}, {
        __index = function(self, ind)
            self[ind] = {
                Connections = {},
                Connect = function(rself, func)
                    table.insert(rself.Connections, func)

                    return {
                        Disconnect = function()
                            local Rind = table.find(rself.Connections, func)

                            if Rind then
                                table.remove(rself.Connections, Rind)
                            end
                        end
                    }
                end,
                Fire = function(rself, ...)
                    for _, v in rself.Connections do
                        task.spawn(v, ...)
                    end
                end,
                Destroy = function(rself)
                    table.clear(rself.Connections)
                    table.clear(rself)
                end
            }

            return self[ind]
        end
    })
}

local cloneref = cloneref or function (obj)
    return obj
end

local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local Workspace = game:GetService("Workspace")

local Client = Players.LocalPlayer
local Camera = Workspace.CurrentCamera

local function GetMousePosition()
    if UserInputService.TouchEnabled then
        return Camera.ViewportSize / 2
    end

    return UserInputService.GetMouseLocation(UserInputService)
end

local function LoopClean(tbl)
    for i, v in tbl do
        if type(v) == "table" then
            LoopClean(v)
        end

        tbl[i] = nil
    end
end

local function WaitForChildOfType(obj, name, timeout, prop)
    local CheckTick = tick() + timeout

    local Returned

    repeat
        Returned = prop and obj[name] or obj:FindFirstChildOfClass(name)

        if Returned or CheckTick < tick() then
            break
        end

        task.wait()
    until false

    return Returned
end

EntityLib.TargetCheck = function(ent)
    if ent.TeamCheck then
        return ent:TeamCheck()
    end

    if ent.NPC then
        return true
    end

    if not Client.Team then
        return true
    end

    if not ent.Player.Team then
        return true
    end

    if ent.Player.Team ~= Client.Team then
        return true
    end

    return #ent.Player.Team:GetPlayers() == #Players:GetPlayers()
end

EntityLib.GetUpdateConnections = function(ent)
    local Hum = ent.Humanoid

    return {
        Hum:GetPropertyChangedSignal("Health"),
        Hum:GetPropertyChangedSignal("MaxHealth")
    }
end

EntityLib.IsVulnerable = function(ent)
    return ent.Health > 0 and not ent.Character.FindFirstChildWhichIsA(ent.Character, "ForceField")
end

EntityLib.GetEntityColor = function(ent)
    ent = ent.Player

    return ent and tostring(ent.TeamColor) ~= "White" and ent.TeamColor.Color or nil
end

EntityLib.IgnoreObject = RaycastParams.new()

EntityLib.IgnoreObject.RespectCanCollide = true

EntityLib.Wallcheck = function(origin, position, ignoreObject)
    if typeof(ignoreObject) ~= "Instance" then
        local IgnoreList = {
            Camera,
            Client.Character
        }

        for _, v in EntityLib.List do
            if v.Targetable then
                table.insert(IgnoreList, v.Character)
            end
        end

        if typeof(ignoreObject) == "table" then
            for _, v in ignoreObject do
                table.insert(IgnoreList, v)
            end
        end

        ignoreObject = EntityLib.IgnoreObject

        ignoreObject.FilterDescendantsInstances = IgnoreList
    end

    return Workspace.Raycast(Workspace, origin, (position - origin), ignoreObject)
end

EntityLib.EntityMouse = function(entitySettings)
    if EntityLib.IsAlive then
        local MouseLocation, SortingTable = entitySettings.MouseOrigin or GetMousePosition(), {}

        for _, v in EntityLib.List do
            if not entitySettings.Players and v.Player then
                continue
            end

            if not entitySettings.NPCs and v.NPC then
                continue
            end

            if not v.Targetable then
                continue
            end

            local Position, VIS = Camera.WorldToViewportPoint(Camera, v[entitySettings.Part].Position)

            if not VIS then
                continue
            end

            local Mag = (MouseLocation - Vector2.new(Position.X, Position.Y)).Magnitude

            if Mag > entitySettings.Range then
                continue
            end

            if EntityLib.IsVulnerable(v) then
                table.insert(SortingTable, {
                    Entity = v,
                    Magnitude = v.Target and -1 or Mag
                })
            end
        end

        table.sort(SortingTable, entitySettings.Sort or function (a, b)
            return a.Magnitude < b.Magnitude
        end)

        for _, v in SortingTable do
            if entitySettings.Wallcheck then
                if EntityLib.Wallcheck(entitySettings.Origin, v.Entity[entitySettings.Part].Position, entitySettings.Wallcheck) then
                    continue
                end
            end

            table.clear(entitySettings)
            table.clear(SortingTable)

            return v.Entity
        end

        table.clear(SortingTable)
    end

    table.clear(entitySettings)
end

EntityLib.EntityPosition = function(entitySettings)
    if EntityLib.IsAlive then
        local LocalPosition, SortingTable = entitySettings.Origin or EntityLib.Character.HumanoidRootPart.Position, {}

        for _, v in EntityLib.List do
            if not entitySettings.Players and v.Player then
                continue
            end

            if not entitySettings.NPCs and v.NPC then
                continue
            end

            if not v.Targetable then
                continue
            end

            local Mag = (v[entitySettings.Part].Position - LocalPosition).Magnitude

            if Mag > entitySettings.Range then
                continue
            end

            if EntityLib.IsVulnerable(v) then
                table.insert(SortingTable, {
                    Entity = v,
                    Magnitude = v.Target and -1 or Mag
                })
            end
        end

        table.sort(SortingTable, entitySettings.Sort or function (a, b)
            return a.Magnitude < b.Magnitude
        end)

        for _, v in SortingTable do
            if entitySettings.Wallcheck then
                if EntityLib.Wallcheck(LocalPosition, v.Entity[entitySettings.Part].Position, entitySettings.Wallcheck) then
                    continue
                end
            end

            table.clear(entitySettings)
            table.clear(SortingTable)

            return v.Entity
        end

        table.clear(SortingTable)
    end

    table.clear(entitySettings)
end

EntityLib.AllPosition = function(entitySettings)
    local Returned = {}

    if EntityLib.IsAlive then
        local LocalPosition, SortingTable = entitySettings.Origin or EntityLib.Character.HumanoidRootPart.Position, {}

        for _, v in EntityLib.List do
            if not entitySettings.Players and v.Player then
                continue
            end

            if not entitySettings.NPCs and v.NPC then
                continue
            end

            if not v.Targetable then
                continue
            end

            local Mag = (v[entitySettings.Part].Position - LocalPosition).Magnitude

            if Mag > entitySettings.Range then
                continue
            end

            if EntityLib.IsVulnerable(v) then
                table.insert(SortingTable, {
                    Entity = v,
                    Magnitude = v.Target and -1 or Mag
                })
            end
        end

        table.sort(SortingTable, entitySettings.Sort or function (a, b)
            return a.Magnitude < b.Magnitude
        end)

        for _, v in SortingTable do
            if entitySettings.Wallcheck then
                if EntityLib.Wallcheck(LocalPosition, v.Entity[entitySettings.Part].Position, entitySettings.Wallcheck) then
                    continue
                end
            end

            table.insert(Returned, v.Entity)

            if #Returned >= (entitySettings.Limit or math.huge) then
                break
            end
        end

        table.clear(SortingTable)
    end

    table.clear(entitySettings)

    return Returned
end

EntityLib.GetEntity = function(char)
    for i, v in EntityLib.List do
        if v.Player == char or v.Character == char then
            return v, i
        end
    end
end

EntityLib.AddEntity = function(char, plr, teamFunc)
    if not char then
        return
    end

    EntityLib.EntityThreads[char] = task.spawn(function()
        local Hum = WaitForChildOfType(char, "Humanoid", 10)

        local HumRootPart = Hum and WaitForChildOfType(Hum, "RootPart", Workspace.StreamingEnabled and 9e9 or 10, true)

        local Head = char:WaitForChild("Head", 10) or HumRootPart

        if Hum and HumRootPart then
            local Entity = {
                Connections = {},
                Character = char,
                Health = Hum.Health,
                Head = Head,
                Humanoid = Hum,
                HumanoidRootPart = HumRootPart,
                HipHeight = Hum.HipHeight + (HumRootPart.Size.Y / 2) + (Hum.RigType == Enum.HumanoidRigType.R6 and 2 or 0),
                MaxHealth = Hum.MaxHealth,
                NPC = plr == nil,
                Player = plr,
                RootPart = HumRootPart,
                TeamCheck = teamFunc
            }

            if plr == Client then
                EntityLib.Character = Entity
                EntityLib.IsAlive = true

                EntityLib.Events.LocalAdded:Fire(Entity)
            else
                Entity.Targetable = EntityLib.TargetCheck(Entity)

                for _, v in EntityLib.GetUpdateConnections(Entity) do
                    table.insert(Entity.Connections, v:Connect(function()
                        Entity.Health = Hum.Health
                        Entity.MaxHealth = Hum.MaxHealth

                        EntityLib.Events.EntityUpdated:Fire(Entity)
                    end))
                end

                table.insert(EntityLib.List, Entity)

                EntityLib.Events.EntityAdded:Fire(Entity)
            end
        end

        EntityLib.EntityThreads[char] = nil
    end)
end

EntityLib.RemoveEntity = function(char, localCheck)
    if localCheck then
        if EntityLib.IsAlive then
            EntityLib.IsAlive = false

            for _, v in EntityLib.Character.Connections do
                v:Disconnect()
            end

            table.clear(EntityLib.Character.Connections)

            EntityLib.Events.LocalRemoved:Fire(EntityLib.Character)
        end

        return
    end

    if char then
        if EntityLib.EntityThreads[char] then
            task.cancel(EntityLib.EntityThreads[char])

            EntityLib.EntityThreads[char] = nil
        end

        local Entity, ind = EntityLib.GetEntity(char)

        if ind then
            for _, v in Entity.Connections do
                v:Disconnect()
            end

            table.clear(Entity.Connections)

            table.remove(EntityLib.List, ind)

            EntityLib.Events.EntityRemoved:Fire(Entity)
        end
    end
end

EntityLib.RefreshEntity = function(char, plr)
    EntityLib.RemoveEntity(char)

    EntityLib.AddEntity(char, plr)
end

EntityLib.AddPlayer = function(plr)
    if plr.Character then
        EntityLib.RefreshEntity(plr.Character, plr)
    end

    EntityLib.PlayerConnections[plr] = {
        plr.CharacterAdded:Connect(function(char)
            EntityLib.RefreshEntity(char, plr)
        end),
        plr.CharacterRemoving:Connect(function(char)
            EntityLib.RemoveEntity(char, plr == Client)
        end),
        plr:GetPropertyChangedSignal("Team"):Connect(function()
            for _, v in EntityLib.List do
                if v.Targetable ~= EntityLib.TargetCheck(v) then
                    EntityLib.RefreshEntity(v.Character, v.Player)
                end
            end

            if plr == Client then
                EntityLib.Start()
            else
                EntityLib.RefreshEntity(plr.Character, plr)
            end
        end)
    }
end

EntityLib.RemovePlayer = function(plr)
    if EntityLib.PlayerConnections[plr] then
        for _, v in EntityLib.PlayerConnections[plr] do
            v:Disconnect()
        end

        table.clear(EntityLib.PlayerConnections[plr])

        EntityLib.PlayerConnections[plr] = nil
    end

    EntityLib.RemoveEntity(plr)
end

EntityLib.Start = function()
    if EntityLib.Running then
        EntityLib.Stop()
    end

    table.insert(EntityLib.Connections, Players.PlayerAdded:Connect(function(v)
        EntityLib.AddPlayer(v)
    end))

    table.insert(EntityLib.Connections, Players.PlayerRemoving:Connect(function(v)
        EntityLib.RemovePlayer(v)
    end))

    for _, v in Players:GetPlayers() do
        EntityLib.AddPlayer(v)
    end

    table.insert(EntityLib.Connections, Workspace:GetPropertyChangedSignal("CurrentCamera"):Connect(function()
        Camera = Workspace.CurrentCamera or Workspace:FindFirstChildWhichIsA("Camera")
    end))

    EntityLib.Running = true
end

EntityLib.Stop = function()
    for _, v in EntityLib.Connections do
        v:Disconnect()
    end

    for _, v in EntityLib.PlayerConnections do
        for _, v2 in v do
            v2:Disconnect()
        end

        table.clear(v)
    end

    EntityLib.RemoveEntity(nil, true)

    local Cloned = table.clone(EntityLib.List)

    for _, v in Cloned do
        EntityLib.RemoveEntity(v.Character)
    end

    for _, v in EntityLib.EntityThreads do
        task.cancel(v)
    end

    table.clear(EntityLib.PlayerConnections)
    table.clear(EntityLib.EntityThreads)
    table.clear(EntityLib.Connections)
    table.clear(Cloned)

    EntityLib.Running = false
end

EntityLib.Kill = function()
    if EntityLib.Running then
        EntityLib.Stop()
    end

    for _, v in EntityLib.Events do
        v:Destroy()
    end

    EntityLib.IgnoreObject:Destroy()

    LoopClean(EntityLib)
end

EntityLib.Refresh = function()
    local Cloned = table.clone(EntityLib.List)

    for _, v in Cloned do
        EntityLib.RefreshEntity(v.Character, v.Player)
    end

    table.clear(Cloned)
end

EntityLib.Start()

return EntityLib
