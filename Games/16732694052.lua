--//
--// Script Made By xS_Killus
--//

--//
--// UI Library and Teleport Place Library and Notification Library
--//

getgenv()["IrisAd"] = true

local Notification = loadstring(game:HttpGet("https://api.irisapp.ca/Scripts/IrisBetterNotifications.lua"))()

local library = loadstring(game:GetObjects("rbxassetid://7657867786")[1].Source)()

--//
--// Instances And Functions
--//

local CollectionService = game:GetService("CollectionService")
local GuiService = game:GetService("GuiService")
local Lighting = game:GetService("Lighting")
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local StarterGui = game:GetService("StarterGui")
local TeleportService = game:GetService("TeleportService")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local Workspace = game:GetService("Workspace")
local VirtualInputManager = game:GetService("VirtualInputManager")

local VeryImportantPart = Instance.new("Part")
local FakeTank = Instance.new("Glue")

FakeTank.Name = "DivingTank"

FakeTank:SetAttribute("Tier", 9e9)

local Camera = Workspace.CurrentCamera
local Client = Players.LocalPlayer

local CurrentTool
local AlwaysPerfectCast

local NoHooking = false
local Debugging = true

local ZoneFishOrigin = nil

local State = {
    GettingMeteor = false,
    ToolResetCooldown = 5,
    LastToolReset = os.clock(),
    OwnedBoats = {}
}

local GlobalStorage = {
    PeakZones = {
        ["Overgrowth Caves"] = true,
        ["Frigid Cavern"] = true,
        ["Cryogenic Canal"] = true,
        ["Glacial Grotto"] = true
    }
}

do
    VeryImportantPart.Name = "SpawnBox"

    local Prio = Instance.new("IntValue", VeryImportantPart)

    Prio.Name = "Priority"
    Prio.Value = 10

    local Name = Instance.new("StringValue", VeryImportantPart)

    Name.Name = "zonename"
    Name.Value = "???"
end

if not hookfunction and hookmetamethod then
    hookfunction = function(...) end
    hookmetamethod = function(...) end

    NoHooking = true
end

if not getconnections then
    getconnections = function(...) end
end

if not setthreadidentity then
    setthreadidentity = function(...) end
end

local function Uniplemented()
    return warn("Break-Skill Hub - V1 | Script | This feature is not implemented yet.")
end

local function DBGPrint(...)
    if Debugging then
        print("Break-Skill Hub - V1 | Debugging | ", ...)
    end
end

local function DBGWarn(...)
    if Debugging then
        warn("Break-Skill Hub - V1 | Debugging | ", ...)
    end
end

local function WaitForTable(root, instancePath, timeout)
    local Inst = root

    for i, v in pairs(instancePath) do
        Inst = Inst:WaitForChild(v, timeout)
    end

    return Inst
end

local function GetFirstAncestorOfClass(object, class)
    local Ancestor = object.Parent

    local Depth = 0

    while Ancestor do
        Depth += 1

        if Depth > 255 then
            warn("Break-Skill Hub - V1 | Script | Aborted GetFirstAncestorOfClass: Too deep")

            return nil
        end

        if Ancestor:IsA(class) then
            return Ancestor
        end

        Ancestor = Ancestor.Parent
    end

    return nil
end

local function LockPersistent(object)
    assert(object:IsA("Model"), "Object must be a model")

    if object.ModelStreamingMode ~= Enum.ModelStreamingMode.Persistent then
        CollectionService:AddTag(object, "ForcePersistent")

        object:SetAttribute("OldStreamingMode", object.ModelStreamingMode.Name)

        object.ModelStreamingMode = Enum.ModelStreamingMode.Persistent
    end
end

local function EnsureStream(root, instancePath, pos, timeout)
    Client:RequestStreamAroundAsync(pos, timeout)

    local Target = WaitForTable(root, instancePath, timeout)

    local Model = GetFirstAncestorOfClass(Target, "Model")

    if Model then
        LockPersistent(Model)
    end

    return Target
end

local function EnsureInstance(inst)
    return (inst and inst:IsDescendantOf(game))
end

local function _Round(num, numDecimalPlaces)
    local Mult = 10 ^ (numDecimalPlaces or 0)

    return math.floor(num * Mult + 0.5) / Mult
end

local Remotes = {
    ReelFinished = ReplicatedStorage.events:WaitForChild("reelfinished "),
    SellAll = ReplicatedStorage.events:WaitForChild("SellAll"),
    Power = EnsureStream(Workspace, {"world", "npcs", "Merlin", "Merlin", "power"}, Vector3.new(-930, 226, -993), 5),
    Luck = EnsureStream(Workspace, {"world", "npcs", "Merlin", "Merlin", "luck"}, Vector3.new(-930, 226, -993), 5)
}

local Interface = {
    FishRadar = ReplicatedStorage.resources.items.items["Fish Radar"]["Fish Radar"],
    TeleportSpots = WaitForTable(Workspace, {"world", "spawns", "TpSpots"}),
    Inventory = WaitForTable(Client.PlayerGui, {"hud", "safezone", "backpack"}),
    MeteorItems = Workspace:WaitForChild("MeteorItems"),
    PlayerData = ReplicatedStorage:WaitForChild("playerstats"):WaitForChild(Client.Name),
    NPCs = Workspace:WaitForChild("world"):WaitForChild("npcs"),
    BoatModels = WaitForTable(ReplicatedStorage, {"resources", "replicated", "instances", "vessels"}),
    Active = Workspace:WaitForChild("active"),
    ActiveBoats = Workspace:WaitForChild("active"):WaitForChild("boats")
}

local Collection = {}

local function Collect(item)
    table.insert(Collection, item)
end

local Utils = {}

do
    function Utils.CountInstances(parent, name)
        local Count = 0

        for _, i in next, parent:GetChildren() do
            if i.Name == name then
                Count += 1
            end
        end

        return Count
    end

    function Utils:BreakVelocity()
        if Client.Character then
            task.spawn(function()
                for i = 20, 1, -1 do
                    RunService.Heartbeat:Wait()

                    for _, p in next, Client.Character:GetDescendants() do
                        if p:IsA("BasePart") then
                            p.Velocity = Vector3.new(0, 0, 0)
                            p.AssemblyAngularVelocity = Vector3.new(0, 0, 0)
                        end
                    end
                end
            end)
        end
    end

    function Utils.ToggleLocationCC(val)
        local LocationCC = Lighting:FindFirstChild("location")

        if LocationCC then
            LocationCC.Enabled = val
        end
    end

    function Utils.GameNotify(mess)
        ReplicatedStorage.events.anno_localthoughtbig:Fire(mess, nil, nil, nil, "Exotic")
    end

    function Utils.GetCharacters()
        local Chars = {}

        for _, p in next, Players:GetPlayers() do
            if p.Character then
                table.insert(Chars, p.Character)
            end
        end

        return Chars
    end

    function Utils.Net(typ, index)
        return ReplicatedStorage.packages.Net:FindFirstChild(typ .. "/" .. index)
    end

    function Utils.Character()
        return Client.Character
    end

    function Utils.Humanoid()
        local Char = Utils.Character()

        if Char then
            return Char:FindFirstAncestorOfClass("Humanoid")
        end

        return nil
    end

    function Utils.CastTo(a, b, params)
        local Direction = (b - a)

        return Workspace:Raycast(a, Direction. params)
    end

    function Utils.SafePosition(pos, range)
        local Chars = Utils.GetCharacters()

        local RayParams = RaycastParams.new()

        RayParams.FilterType = Enum.RaycastFilterType.Exclude
        RayParams.RespectCanCollide = true
        RayParams.FilterDescendantsInstances = Chars

        for _, c in next, Chars do
            local Head = c:FindFirstChild("Head")

            local Pivot = c:GetPivot()

            if Head then
                local Raycast = Utils.CastTo(pos, Head.Position, RayParams)

                if Raycast then
                    return false
                end
            end

            if Pivot then
                local Distance = (pos - Pivot.Position).Magnitude * 0.5

                if Distance <= range then
                    return false
                end
            end
        end

        return true
    end

    function Utils.TP(target, checkSafe)
        local Pivot

        if typeof(target) == "CFrame" then
            Pivot = target
        elseif typeof(target) == "Vector3" then
            Pivot = CFrame.new(target)
        elseif typeof(target) == "PVInstance" then
            Pivot = target:GetPivot()
        elseif typeof(target) == "BasePart" then
            Pivot = target:GetPivot()
        elseif typeof(target) == "Model" then
            Pivot = target:GetPivot()
        end

        if checkSafe then
            if not Utils.SafePosition(Pivot.Position, 50) then
                return false
            end
        end

        local Char = Utils.Character()

        if Char then
            Char:PivotTo(Pivot)

            return true
        end

        return false
    end

    function Utils.EliminateVelocity(model)
        for _, p in next, model:GetDescendants() do
            if p:IsA("BasePart") then
                p.Velocity = Vector3.new(0, 0, 0)
                p.AssemblyAngularVelocity = Vector3.new(0, 0, 0)
            end
        end

        return nil
    end

    function Utils.GetUsernameMatch(partialName)
        local BestMatch = nil

        local BestMatchLength = 0

        for _, p in next, Players:GetPlayers() do
            if string.find(p.Name:lower(), partialName:lower()) then
                if #p.Name > BestMatchLength then
                    BestMatch = p

                    BestMatchLength = #p.Name
                end
            end
        end

        return BestMatch
    end

    function Utils.CharacterChildRemoved(child)
        if child:IsA("Tool") then
            CurrentTool = nil
        end
    end

    function Utils.Capitalize(str)
        return string.upper(string.sub(str, 1, 1)) .. string.sub(str, 2)
    end

    function Utils.GetNPC(typ, single)
        local function GetNPCType(npc)
            local NPCType = "Unknown"

            if npc:FindFirstChild("shipwright") then
                NPCType = "Shipwright"
            elseif npc:FindFirstChild("merchant") then
                NPCType = "Merchant"
            elseif npc:FindFirstChild("angler") then
                NPCType = "Angler"
            end

            return NPCType
        end

        local NPCs = Interface.NPCs:GetChildren()

        local Results = {}

        for _, c in next, NPCs do
            local NPCType = GetNPCType(c)

            if NPCType == typ then
                if single then
                    return c
                else
                    table.insert(Results, c)
                end
            end
        end

        return nil
    end
end

local TeleportLocations = {}
local TeleportLocationsValues = {}

for _, l in next, Interface.TeleportSpots:GetChildren() do
    TeleportLocations[Utils.Capitalize(l.Name)] = l.Position + Vector3.new(0, 6, 0)
end

for n, p in next, TeleportLocations do
    table.insert(TeleportLocationsValues, n)
end

table.sort(TeleportLocationsValues)

local FishingZones = {}

for _, z in next, Workspace:WaitForChild("zones"):WaitForChild("fishing"):GetChildren() do
    if not FishingZones[z.Name] then
        FishingZones[z.Name] = z
    end
end

local FishingZonesValues = {}

for n, z in next, FishingZones do
    table.insert(FishingZonesValues, n)
end

local function ResetTool()
    if CurrentTool then
        local ToolCache = Client.Character:FindFirstAncestorOfClass("Tool")

        if CurrentTool then
            if State.LastToolReset + State.ToolResetCooldown < os.clock() then
                State.LastToolReset = os.clock()

                Client.Character.Humanoid:UnequipTools()

                task.wait()

                ToolCache.Parent = Client.Character
            end
        end
    end
end

--//
--// Window
--//

local Window = library:CreateWindow({
    Name = "Break-Skill Hub - V1 | ",
    Themeable = {
        Image = "rbxassetid://7771536804",
        Credit = false,
        Info = {
            "Script Made By: xS_Killus",
            "UI Library Made By: Pepsi",
        }
    },
    DefaultTheme = '{"__Designer.Colors.section":"B0AFB0","__Designer.Colors.topGradient":"232323","__Designer.Settings.ShowHideKey":"Enum.KeyCode.RightShift","__Designer.Colors.otherElementText":"817F81","__Designer.Colors.hoveredOptionBottom":"2D2D2D","__Designer.Background.ImageAssetID":"rbxassetid://7771536804","__Designer.Colors.selectedOption":"373737","__Designer.Colors.unselectedOption":"282828","__Designer.Background.UseBackgroundImage":true,"__Designer.Files.WorkspaceFile":"Break-Skill Hub V1","__Designer.Colors.innerBorder":"493F49","__Designer.Colors.unhoveredOptionTop":"323232","__Designer.Colors.main":"750000","__Designer.Colors.outerBorder":"0F0F0F","__Designer.Background.ImageColor":"FFFFFF","__Designer.Colors.elementBorder":"141414","__Designer.Colors.sectionBackground":"232222","__Designer.Colors.background":"282828","__Designer.Colors.bottomGradient":"1D1D1D","__Designer.Background.ImageTransparency":35,"__Designer.Colors.hoveredOptionTop":"414141","__Designer.Colors.elementText":"939193","__Designer.Colors.unhoveredOptionBottom":"232323"}'
})

--//
--// Fishing Tab
--//

local MainTab = Window:CreateTab({
    Name = "Main"
})

--// Casting Section

local CastingSection = MainTab:CreateSection({
    Name = "Casting",
    Side = "Left"
})

local AutoCast = CastingSection:AddToggle({
    Name = "Auto Cast",
    Flag = "AutoCast",
    Value = false,
    Locked = false
})

if not NoHooking then
    AlwaysPerfectCast = CastingSection:AddToggle({
        Name = "Always Perfect Cast",
        Flag = "AlwaysPerfectCast",
        Value = false,
        Locked = false
    })
end

local InstantBob = CastingSection:AddToggle({
    Name = "Instant Bob",
    Flag = "InstantBob",
    Value = false,
    Locked = false
})

--// Reeling Section

local ReelingSection = MainTab:CreateSection({
    Name = "Reeling",
    Side = "Left"
})

local AutoReel = ReelingSection:AddToggle({
    Name = "Auto Reel",
    Flag = "AutoReel",
    Value = false,
    Locked = false
})

local InstantReel = ReelingSection:AddToggle({
    Name = "Instant Reel",
    Flag = "InstantReel",
    Value = false,
    Locked = false
})

local AlwaysPerfectReel = ReelingSection:AddToggle({
    Name = "Always Perfect Reel",
    Flag = "AlwaysPerfectReel",
    Value = false,
    Locked = false
})

--// Shake Section

local ShakeSection = MainTab:CreateSection({
    Name = "Shake",
    Side = "Left"
})

local AutoShake = ShakeSection:AddToggle({
    Name = "Auto Shake",
    Flag = "AutoShake",
    Value = false,
    Locked = false
})

local CenterShake = ShakeSection:AddToggle({
    Name = "Center Shake",
    Flag = "CenterShake",
    Value = false,
    Locked = false
})

--// Fishing Section

local FishingSection = MainTab:CreateSection({
    Name = "Fishing",
    Side = "Left"
})

local ZoneFish = FishingSection:AddToggle({
    Name = "Zone Fish",
    Flag = "ZoneFish",
    Value = false,
    Locked = false,
    Callback = function(val)
        if val then
            ZoneFishOrigin = Client.Character:GetPivot()
        else
            for _, s in next, Enum.HumanoidStateType:GetEnumItems() do
                Client.Character.Humanoid:SetStateEnabled(s, true)
            end

            if ZoneFishOrigin then
                Client.Character.Humanoid:UnequipTools()

                for _ = 1, 10 do
                    task.wait()

                    Utils.TP(ZoneFishOrigin.Position)
                end

                ZoneFishOrigin = nil
            end
        end
    end
})

local ZoneFishSearchBox = FishingSection:AddSearchBox({
    Name = "Zone Fish",
    Flag = "ZoneFishSearchBox",
    BlankValue = "Select zone...",
    MultiSelect = false,
    Sort = false,
    List = FishingZonesValues
})

--// Teleports Section

local TeleportsSection = MainTab:CreateSection({
    Name = "Teleports",
    Side = "Right"
})

local TeleportsSearchBox = TeleportsSection:AddSearchBox({
    Name = "Teleports",
    Flag = "TeleportsSearchBox",
    BlankValue = "Select location to teleport...",
    MultiSelect = false,
    Sort = false,
    List = TeleportLocationsValues
})

local TeleportButton = TeleportsSection:AddButton({
    Name = "Teleport",
    Locked = false,
    Callback = function()
        local Selected = library.Flags.TeleportsSearchBox

        local Position = TeleportLocations[Selected]

        if Position then
            Utils.TP(Position)
        end
    end
})

--// Remote Shop Section

local RemoteShopSection = MainTab:CreateSection({
    Name = "Remote Shop",
    Side = "Right"
})

local RemoteShopSearchBox = RemoteShopSection:AddSearchBox({
    Name = "Remote Shop",
    Flag = "RemoteShopSearchBox",
    BlankValue = "Select item to buy...",
    MultiSelect = false,
    Sort = false,
    List = {}
})

local RemoteShopButton = RemoteShopSection:AddButton({
    Name = "Buy Item",
    Locked = false,
    Callback = function()
        local Selected = library.Flags.RemoteShopSearchBox

        local Item = Workspace:WaitForChild("world"):WaitForChild("interactables"):FindFirstChild(Selected)

        if Item then
            local Origin = Client.Character:GetPivot()

            local LockPositionConnection = RunService.Heartbeat:Connect(function()
                Utils.TP(Item:GetPivot())
            end)

            task.wait(0.3)

            for _, d in next, Item:GetDescendants() do
                if d:IsA("ProximityPrompt") then
                    fireproximityprompt(d)

                    break
                end
            end

            task.wait(0.3)

            LockPositionConnection:Disconnect()

            Utils.TP(Origin.Position)

            Utils:BreakVelocity()
        end
    end
})

local ItemAmount = RemoteShopSection:AddSlider({
    Name = "Item Amount",
    Flag = "ItemAmount",
    Format = "Amount: %s",
    Min = 1,
    Value = 1,
    Max = 1000,
    IllegalInput = false,
    CustomInput = {
        IllegalInput = false
    }
})

local BuyPower = RemoteShopSection:AddButton({
    Name = "Buy Power",
    Locked = false,
    Callback = function()
        local Amount = library.Flags.ItemAmount

        for i = 1, Amount do
            task.spawn(function()
                Remotes.Power:InvokeServer()
            end)
        end
    end
})

local BuyLuck = RemoteShopSection:AddButton({
    Name = "Buy Luck",
    Locked = false,
    Callback = function()
        local Amount = library.Flags.ItemAmount

        for i = 1, Amount do
            task.spawn(function()
                Remotes.Luck:InvokeServer()
            end)
        end
    end
})

--// Misc Section

local MiscSection = MainTab:CreateSection({
    Name = "Misc",
    Side = "Right"
})

local AutoSell = MiscSection:AddToggle({
    Name = "Auto Sell",
    Flag = "AutoSell",
    Value = false,
    Locked = false
})

local AutoMeteor = MiscSection:AddToggle({
    Name = "Auto Meteor",
    Flag = "AutoMeteor",
    Value = false,
    Locked = false
})

local ServerStresser = MiscSection:AddToggle({
    Name = "Server Stresser",
    Flag = "ServerStresser",
    Value = false,
    Locked = false,
    Callback = function(val)
        if not val then
            TeleportService:Teleport(game.PlaceId, Client)
        else
            Utils.TP(Client.Character:GetPivot().Position + Vector3.new(0, 9e9, 0))
        end
    end
})

local InfiniteOxygen = MiscSection:AddToggle({
    Name = "Infinite Oxygen",
    Flag = "InfiniteOxygen",
    Value = false,
    Locked = false,
    Callback = function(val)
        if val then
            FakeTank.Parent = Client.Character
        else
            FakeTank.Parent = nil
        end
    end
})

local DisableInventory = MiscSection:AddToggle({
    Name = "Disable Inventory",
    Flag = "DisableInventory",
    Value = false,
    Locked = false,
    Callback = function(val)
        local Inventory = WaitForTable(Client.PlayerGui, {"hud", "safezone", "backpack"})

        if Inventory then
            Inventory.Visible = not val

            StarterGui:SetCoreGuiEnabled(Enum.CoreGuiType.Backpack, val)
        end
    end
})

local BoatSpawnSearchBox = MiscSection:AddSearchBox({
    Name = "Boat Spawn",
    Flag = "BoatSpawnSearchBox",
    BlankValue = "Select boat to spawn...",
    MultiSelect = false,
    Sort = false,
    List = State.OwnedBoats
})

local BoatSpawnButton = MiscSection:AddButton({
    Name = "Spawn",
    Locked = false,
    Callback = function()
        local BoatSpawnLocation = Client.Character:GetPivot().Position

        local BoatPreview = nil

        local BoatName = library.Flags.BoatSpawnSearchBox

        local ShipWightNPC = Utils.GetNPC("Shipwright", true)

        if not ShipWightNPC then
            DBGWarn("Shipwright not found.")

            return
        end

        if not BoatName then
            DBGWarn("Please select a boat.")

            return
        end

        if Interface.BoatModels:FindFirstChild(BoatName) then
            BoatPreview = Interface.BoatModels:FindFirstChild(BoatName):Clone()

            BoatPreview.Parent = Camera
        else
            BoatPreview = Instance.new("Model")
        end

        for _, p in next, BoatPreview:GetDescendants() do
            if p:IsA("BasePart") then
                p.Anchored = true
                p.CanCollide = false
                p.CanTouch = false
            end
        end

        local Origin = Client.Character:GetPivot()

        Camera.CameraType = Enum.CameraType.Scriptable

        TweenService:Create(Camera, TweenInfo.new(0.5), {
            CFrame = CFrame.new(Origin.Position + Vector3.new(0, 80, 0), Origin.Position)
        }):Play()

        task.wait(0.5)

        UserInputService.MouseBehavior = Enum.MouseBehavior.LockCurrentPosition

        local CameraMotionConnection

        CameraMotionConnection = RunService.RenderStepped:Connect(function()
            local Delta = UserInputService:GetMouseDelta()

            local X, Y = Delta.X, Delta.Y

            Camera.CFrame *= CFrame.Angles(0, math.rad(-X * 0.5), 0) * CFrame.Angles(math.rad(-Y * 0.5), 0, 0)

            local Params = RaycastParams.new()

            Params.FilterType = Enum.RaycastFilterType.Exclude

            Params.FilterDescendantsInstances = {
                Client.Character,
                BoatPreview
            }

            local CameraHit = Workspace:Raycast(Camera.CFrame.Position, Camera.CFrame.LookVector * 500, Params)

            if CameraHit then
                BoatSpawnLocation = CameraHit.Position + Vector3.new(0, 10, 0)

                BoatPreview:PivotTo(CFrame.new(BoatSpawnLocation))
            end
        end)

        local InputConnection

        InputConnection = UserInputService.InputBegan:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 then
                InputConnection:Disconnect()

                CameraMotionConnection:Disconnect()

                Camera.CameraType = Enum.CameraType.Custom

                UserInputService.MouseBehavior = Enum.MouseBehavior.Default

                Client.Character:PivotTo(ShipWightNPC:GetPivot())

                task.wait(0.3)

                fireproximityprompt(ShipWightNPC.dialogprompt)

                local Result = ShipWightNPC.shipwright.giveUI:InvokeServer()

                BoatPreview:Destroy()

                if Result then
                    Utils.Net("RF", "Boats/Spawn"):InvokeServer(BoatName)
                    Utils.Net("RE", "Boats/Close"):FireServer()

                    repeat
                        task.wait(0.5)
                    until Interface.ActiveBoats:FindFirstChild(Client.Name)

                    local Ship = Interface.ActiveBoats:FindFirstChild(Client.Name):FindFirstAncestorOfClass("Model")

                    local Seat = Ship:FindFirstAncestorOfClass("VehicleSeat")

                    local SitPrompt = Seat:WaitForChild("sitprompt")

                    task.wait(0.5)

                    fireproximityprompt(SitPrompt)

                    task.wait(0.5)

                    for i = 1, 60 do
                        task.wait()

                        Ship:PivotTo(CFrame.new(BoatSpawnLocation))
                    end

                    Ship.PlanePart.Rotation = Vector3.new(0, 0, 0)

                    local WaterRayParams = RaycastParams.new()

                    WaterRayParams.FilterType = Enum.RaycastFilterType.Include
                    WaterRayParams.IgnoreWater = false

                    WaterRayParams.FilterDescendantsInstances = {
                        Workspace.Terrain
                    }

                    local WaterHeight = Workspace:Raycast(Ship.PlanePart.Position + Vector3.new(0, 100, 0), Vector3.new(0, -255, 0))

                    if WaterHeight then
                        Ship.PlanePart.Position = Ship.PlanePart.Position * Vector3.new(1, 0, 1) + Vector3.new(0, 127, 0)
                    end
                end
            end
        end)
    end
})

--XD

if not NoHooking then
    local OldIndex

    OldIndex = hookmetamethod(game, "__index", function(...)
        if not checkcaller() then
            local Args = {
                ...
            }

            local self, key = Args[1], Args[2]

            if self == Interface.Inventory and key == "Visible" then
                local CallingScript = getcallingscript()

                if CallingScript and (not game.IsDescendantOf(CallingScript, Interface.Inventory)) then
                    return true
                end
            end
        end

        return OldIndex(...)
    end)

    local OldNameCall

    OldNameCall = hookmetamethod(game, "__namecall", function(...)
        if not checkcaller() then
            local Method = getnamecallmethod()

            local Args = {
                ...
            }

            local self = table.remove(Args, 1)

            if Method == "FireServer" then
                if tostring(self) == "cast" then
                    if library.Flags.AlwaysPerfectCast then
                        Args[1] = 100
                    end
                elseif self == Remotes.ReelFinished then
                    if library.Flags.AlwaysPerfectReel then
                        Args[1] = 100
                        Args[2] = true
                    end
                end

                return OldNameCall(self, unpack(Args))
            end
        end

        return OldNameCall(...)
    end)
end

local AutoCastCoroutine = coroutine.create(function()
    local LastCastAttempt = 0

    while task.wait(0.3) do
        if library.Flags.AutoCast then
            pcall(function()
                if not CurrentTool then
                    return
                end

                local Values = CurrentTool:FindFirstChild("values")

                if CurrentTool and Values then
                    local Events = CurrentTool:FindFirstChild("events")

                    if Values:FindFirstChild("bite") and Values.bite.Value == true and Values.casted.Value == true then
                        if (not Client.PlayerGui:FindFirstChild("reel")) and tick() - LastCastAttempt > 5 then
                            ResetTool()
                        end
                    end

                    if Utils.CountInstances(Client.PlayerGui, "reel") > 1 then
                        ResetTool()

                        for _, c in next, Client.PlayerGui:GetChildren() do
                            if c.Name == "reel" then
                                c:Destroy()
                            end
                        end
                    end

                    if Values.casted.Value == false then
                        LastCastAttempt = tick()

                        local AnimationFolder = ReplicatedStorage:WaitForChild("resources"):WaitForChild("animations")

                        local CastAnimation = Client.Character:FindFirstChild("Humanoid"):LoadAnimation(AnimationFolder.fishing.throw)

                        CastAnimation.Priority = Enum.AnimationPriority.Action3

                        CastAnimation:Play()

                        Events.cast:FireServer(100, 1)

                        CastAnimation.Stopped:Once(function()
                            CastAnimation:Destroy()

                            local WaitingAnimation = Client.Character:FindFirstChild("Humanoid"):LoadAnimation(AnimationFolder.fishing.waiting)

                            WaitingAnimation.Priority = Enum.AnimationPriority.Action3

                            WaitingAnimation:Play()

                            local UnEquippedLoop, CastConnection

                            CastConnection = Values.casted.Changed:Once(function()
                                WaitingAnimation:Stop()
                                WaitingAnimation:Destroy()

                                coroutine.close(UnEquippedLoop)
                            end)

                            UnEquippedLoop = coroutine.create(function()
                                repeat
                                    task.wait()
                                until not CurrentTool

                                WaitingAnimation:Stop()
                                WaitingAnimation:Destroy()

                                CastConnection:Disconnect()
                            end)

                            coroutine.resume(UnEquippedLoop)
                        end)
                    end
                end
            end)
        end
    end
end)

local AutoReelCoroutine = coroutine.create(function()
    while true do
        RunService.RenderStepped:Wait()

        local ReelUI = Client.PlayerGui:FindFirstChild("reel")

        if not ReelUI then
            continue
        end

        if library.Flags.AutoReel then
            local Bar = ReelUI:FindFirstChild("bar")

            if not Bar then
                continue
            end

            local PlayerBar = Bar:FindFirstChild("playerbar")
            local TargetBar = Bar:FindFirstChild("fish")

            while Bar and ReelUI:IsDescendantOf(Client.PlayerGui) do
                RunService.RenderStepped:Wait()

                local UnFilteredTargetPosition = PlayerBar.Position:Lerp(TargetBar.Position, 0.7)

                local TargetPosition = UDim2.fromScale(math.clamp(UnFilteredTargetPosition.X.Scale, 0.15, 0.85), UnFilteredTargetPosition.Y.Scale)

                PlayerBar.Position = TargetPosition
            end
        elseif library.Flags.InstantReel then
            local Bar = ReelUI:FindFirstChild("bar")

            if Bar then
                local ReelScript = Bar:FindFirstChild("reel")

                if ReelScript and ReelScript.Enabled == true then
                    Remotes.ReelFinished:FireServer(100, library.Flags.PerfectReel)
                end
            end
        end
    end
end)

local AutoClickCoroutine = coroutine.create(function()
    function Utils.MountShakeUI(shakeUI)
        local SafeZone = shakeUI:WaitForChild("safezone", 5)

        local function HandleButton(button)
            button.Selectable = true

            if EnsureInstance(button) then
                GuiService.SelectedObject = button
            end
        end

        if not SafeZone then
            DBGWarn("Unable to mount shake ui.")

            return
        end

        if library.Flags.CenterShake then
            local Connect = SafeZone:WaitForChild("connect", 1)

            if Connect then
                Connect.Enabled = false
            end

            SafeZone.Size = UDim2.fromOffset(0, 0)
            SafeZone.Position = UDim2.fromScale(0.5, 0.5)
            SafeZone.AnchorPoint = Vector2.new(0.5, 0.5)
        end

        if library.Flags.AutoShake then
            local Connection = SafeZone.ChildAdded:Connect(function(child)
                if child:IsA("ImageButton") then
                    local Done = false

                    task.spawn(function()
                        repeat
                            RunService.Heartbeat:Wait()

                            HandleButton(child)
                        until Done
                    end)

                    task.spawn(function()
                        repeat
                            RunService.Heartbeat:Wait()
                        until (not child) or (not child:IsDescendantOf(SafeZone))

                        Done = true
                    end)
                end
            end)

            repeat
                RunService.Heartbeat:Wait()

                if GuiService.SelectedObject and GuiService.SelectedObject:IsDescendantOf(SafeZone) then
                    VirtualInputManager:SendKeyEvent(true, Enum.KeyCode.Return, false, game)
                    VirtualInputManager:SendKeyEvent(false, Enum.KeyCode.Return, false, game)
                end

                RunService.Heartbeat:Wait()
            until not SafeZone:IsDescendantOf(Client.PlayerGui)

            Connection:Disconnect()

            GuiService.SelectedObject = nil
        end
    end

    Collect(Client.PlayerGui.ChildAdded:Connect(function(child)
        if child.Name == "shakeui" and child:IsA("ScreenGui") then
            Utils.MountShakeUI(child)
        end
    end))
end)

local ServerStresserCoroutine = coroutine.create(function()
    local Backpack = Client.Backpack

    local function IsFish(tool)
        return tool:FindFirstChild("fishscript") or (tool:GetAttribute("IsFish") == true)
    end

    while task.wait(5) do
        if not library.Flags.ServerStresser then
            continue
        end

        for i, t in next, Backpack:GetChildren() do
            task.spawn(function()
                if IsFish(t) then
                    t:SetAttribute("IsFish", true)

                    local FishModel = t:FindFirstChild("Fish")

                    if FishModel then
                        FishModel:Destroy()
                    end

                    t.Parent = Client.Character
                end
            end)
        end

        Client.Character.Humanoid:UnequipTools()
    end
end)

coroutine.resume(AutoCastCoroutine)
coroutine.resume(AutoReelCoroutine)
coroutine.resume(AutoClickCoroutine)
coroutine.resume(ServerStresserCoroutine)

Collect(AutoCastCoroutine)
Collect(AutoReelCoroutine)
Collect(AutoClickCoroutine)
Collect(ServerStresserCoroutine)

do
    function Utils.CharacterChildAdded(child)
        if child:IsA("Tool") then
            CurrentTool = child

            if library.Flags.ServerStresser then
                local FishModel = child:WaitForChild("Fish", 1)

                if FishModel then
                    FishModel:Destroy()
                end

                task.delay(0.5, function()
                    for i, v in next, child:GetDescendants() do
                        if v:IsA("BasePart") then
                            v.Anchored = true
                        end
                    end
                end)
            end
        elseif child:IsA("Humanoid") then
            Collect(child.StateChanged:Connect(function()
                if library.Flags.ZoneFish then
                    for _, s in next, Enum.HumanoidStateType:GetEnumItems() do
                        if s ~= Enum.HumanoidStateType.Running then
                            child:SetStateChanged(s, false)
                        end
                    end

                    child:ChangeState(Enum.HumanoidStateType.Running)
                end
            end))

            Collect(child.Died:Once(function()
                ZoneFish:Set(false)
            end))
        end
    end

    function Utils.CharacterAdded(char)
        for _, c in next, char:GetChildren() do
            Utils.CharacterChildAdded(c)
        end

        Collect(char.ChildAdded:Connect(Utils.CharacterChildAdded))
        Collect(char.ChildRemoved:Connect(Utils.CharacterChildRemoved))
    end

    function Utils.UpdateShopDropdown()
        local Items = Workspace:WaitForChild("world"):WaitForChild("interactables"):GetChildren()

        local Values = {}

        for _, i in next, Items do
            table.insert(Values, i.Name)
        end

        RemoteShopSearchBox:UpdateList(Values)
    end

    function Utils.BoatsChanged()
        local Boats = Interface.PlayerData.Boats:GetChildren()

        State.OwnedBoats = {}

        for _, b in next, Boats do
            table.insert(State.OwnedBoats, b.Name)
        end

        BoatSpawnSearchBox:UpdateList(State.OwnedBoats)
    end
end

local ShopUpdateCoroutine = coroutine.create(function()
    while task.wait(1) do
        if library.Flags.AutoSell then
            Remotes.SellAll:InvokeServer()
        end

        Utils.UpdateShopDropdown()
    end
end)

coroutine.resume(ShopUpdateCoroutine)

Collect(ShopUpdateCoroutine)

Collect(Client.CharacterAdded:Connect(Utils.CharacterAdded))

if Client.Character then
    Utils.CharacterAdded(Client.Character)
end

Collect(RunService.RenderStepped:Connect(function()
    local Inventory = WaitForTable(Client.PlayerGui, {"hud", "safezone", "backpack"})

    if Inventory and Inventory.Visible then
        Inventory.Visible = not library.Flags.DisableInventory

        StarterGui:SetCoreGuiEnabled(Enum.CoreGuiType.Backpack, library.Flags.DisableInventory)
    end
end))

Collect(Interface.MeteorItems.ChildAdded:Connect(function(item)
    if library.Flags.AutoMeteor then
        State.GettingMeteor = true

        local Origin = Client.Character:GetPivot()

        local Prompt = WaitForTable(item, {"Center", "prompt"}, 5)

        local Center = Prompt.Parent

        local TPConnection = RunService.PostSimulation:Connect(function()
            Utils.TP(Center:GetPivot() - (Vector3.yAxis * 5))
        end)

        task.delay(2, function()
            fireproximityprompt(Prompt)
        end)

        task.delay(4, function()
            TPConnection:Disconnect()

            Utils.TP(Origin)

            State.GettingMeteor = false
        end)
    end
end))

Collect(RunService.PostSimulation:Connect(function()
    if library.Flags.InstantBob then
        if CurrentTool then
            local Bobber = CurrentTool:FindFirstChild("bobber")

            if Bobber then
                local Params = RaycastParams.new()

                Params.FilterType = Enum.RaycastFilterType.Include

                Params.FilterDescendantsInstances = {
                    Workspace.Terrain
                }

                local RaycastResult = Workspace:Raycast(Bobber.Position, -Vector3.yAxis * 100, Params)

                if RaycastResult then
                    if RaycastResult.Instance:IsA("Terrain") then
                        Bobber:PivotTo(CFrame.new(RaycastResult.Position))
                    end
                end
            end
        end
    elseif library.Flags.ZoneFish then
        InfiniteOxygen:Set(true)

        if State.GettingMeteor then
            return
        end

        for _, p in next, Client.Character:GetDescendants() do
            if p:IsA("BasePart") then
                p.CanTouch = false
                p.AssemblyAngularVelocity = Vector3.zero
                p.AssemblyLinearVelocity = Vector3.zero
            end
        end

        local Zone = FishingZones[library.Flags.ZoneFishSearchBox]

        if Zone then
            local Origin = Zone:GetPivot()

            Utils.TP(Origin - Vector3.new(0, 20, 0))

            if CurrentTool then
                local Bobber = CurrentTool:FindFirstChild("bobber")

                if Bobber then
                    local Rope = Bobber:FindFirstChildOfClass("RopeConstraint")

                    if Rope then
                        Rope.Length = 9e9
                    end

                    Bobber:PivotTo(Origin)
                end
            end
        end
    end
end))
