--// Script Loader By xS_Killus
--// Break-Skill Hub - V1 Softwares

--// Game Loading

repeat
    task.wait()
until game.GameId ~= 0 and game:IsLoaded()

local StartTimer = tick()

--// Notif Library

getgenv()["IrisAd"] = true

local Notification = loadstring(game:HttpGet("https://api.irisapp.ca/Scripts/IrisBetterNotifications.lua"))()

--// Script Already Loaded

if getgenv()["Break-Skill_Hub_V1_Loaded"] then
    Notification.Notify("Break-Skill Hub - V1", "<b><font color=\"rgb(255, 30, 30)\">Script Already Loaded!</font></b>", "rbxassetid://7771536804", {
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

    error("Break-Skill Hub - V1 | Script Already Executed!")

    return
end

--// Instances And Functions

local MarketplaceService = game:GetService("MarketplaceService")
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local VirtualUser = game:GetService("VirtualUser")
local Workspace = game:GetService("Workspace")
local CoreGui = game:GetService("CoreGui")

local Client = Players.LocalPlayer

local QueueOnTeleport = queue_on_teleport or (syn and syn.queue_on_teleport)

Client.Idled:Connect(function()
    VirtualUser:Button2Down(Vector2.new(0, 0), Workspace.CurrentCamera.CFrame)

    task.wait(1)

    VirtualUser:Button2Up(Vector2.new(0, 0), Workspace.CurrentCamera.CFrame)
end)

RunService.RenderStepped:Connect(function()
    for i, v in pairs(CoreGui:GetChildren()) do
        if v:FindFirstChild("PropertiesFrame") then
            if v:FindFirstChild("ExplorerPanel") then
                if v:FindFirstChild("SideMenu") then
                    Client:Kick("\n[Break-Skill Hub - V1]\n[Script Error]\nDark Dex Detected!\nIf you keep trying to use Dark Dex while the script running your whitelist may be blocked!\n")

                    return
                end
            end
        end
    end
end)

if syn and not is_sirhurtclosure and not pebc_execute and not gethui then
    getgenv()["Executor"] = "Synapse X V2"
elseif syn and not is_sirhurtclosure and not pebc_execute and gethui then
    getgenv()["Executor"] = "Synapse X V3"
elseif getexecutorname then
    getgenv()["Executor"] = "Script-Ware"
elseif KRNL_LOADED then
    getgenv()["Executor"] = "KRNL"
else
    Client:Kick("\n[Break-Skill Hub - V1]\n[Executor Error]\nYour executor is not supported!\nYou can find supported executors on our discord!")

    return
end

--//
--// Game Script Loading
--//

local Success, Returned = pcall(function()
    return game:HttpGet("https://raw.githubusercontent.com/Sklllus/B-S-Hub-V1/main/Games/" .. game.PlaceId .. ".lua")
end)

if not (Success and Returned and #Returned ~= 0) then
    Notification.Notify("Break-Skill Hub - V1", "<b><font color=\"rgb(255, 30, 30)\">Game Not Supported!</font></b>", "rbxassetid://7771536804", {
        Duration = 5,
        TitleSettings = {
            TextXAlignment = Enum.TextXAlignment.Left,
            Font = Enum.Font.SourceSansBold
        },
        GradientEnabled = {
            GradientEnabled = false,
            SolidColorEnabled = true,
            SolidColor = Color3.fromRGB(255, 30, 30),
            Retract = true
        }
    })

    error("Break-Skill Hub - V1 | Game Not Supported!")

    return
end

getgenv()["library"]:AddConnection(Client.OnTeleport, function(state)
    if state == Enum.TeleportState.InProgress then
        QueueOnTeleport(([[
            loadstring(game:HttpGet("https://raw.githubusercontent.com/Sklllus/B-S-Hub-V1/main/Loader.lua"))()
        ]]))
    end
end)

Notification.Notify("Break-Skill Hub - V1", "Loading Script For <b><font color=\"rgb(255, 30, 30)\">" .. MarketplaceService:GetProductInfo(game.PlaceId).Name .. "</font></b>!", "rbxassetid://7771536804", {
    Duration = 10,
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

loadstring(tostring(Returned))()

local FinishLoadingTimer

if getgenv()["library"].Loaded then
    FinishLoadingTimer = tick()
end

Notification.Notify("Break-Skill Hub - V1", "Script Loaded In <b><font color=\"rgb(255, 30, 30)\">" .. FinishLoadingTimer .. "</font></b>.", "rbxassetid://7771536804", {
    Duration = 10,
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
