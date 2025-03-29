--//
--// Loader Script Made By xS_Killus
--//

--//
--// Game Loading
--//

repeat
    task.wait()
until game.GameId ~= 0 and game:IsLoaded()

--//
--// Notification Library
--//

getgenv()["IrisAd"] = true

local Notification = loadstring(game:HttpGet("https://api.irisapp.ca/Scripts/IrisBetterNotifications.lua"))()

--//
--// While Script Already Loaded
--//

if getgenv()["Break-Skill_Hub_V1_Loaded"] then
    Notification.Notify(
        "Break-Skill Hub - V1 | Loader",
        "<b><font color=\"rgb(255, 30, 30)\">Script already loaded!</font></b>",
        "rbxassetid://7771536804",
        {
            Duration = 5,
            TitleSettings = {
                TextXAlignment = Enum.TextXAlignment.Left,
                Font = Enum.Font.SourceSansBold
            },
            GradientSettings = {
                GradientEnabled = false,
                SolidColorEnabled = true,
                Retract = true,
                SolidColor = Color3.fromRGB(255, 30, 30)
            }
        }
    )

    error("Break-Skill Hub - V1 | Loader | Script already loaded!")

    return
end

--//
--// Instances And Functions
--//

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local CoreGui = game:GetService("CoreGui")
local VirtualUser = game:GetService("VirtualUser")
local Workspace = game:GetService("Workspace")

local Client = Players.LocalPlayer

Client.Idled:Connect(function()
    VirtualUser:Button2Down(Vector2.new(0, 0), Workspace.CurrentCamera.CFrame)

    task.wait(1)

    VirtualUser:Button2Up(Vector2.new(0, 0), Workspace.CurrentCamera.CFrame)
end)

for _, v in next, getconnections(Client.Idled) do
    if (v.Function) then
        continue
    end

    v:Disable()
end

RunService.RenderStepped:Connect(function()
    for i, v in pairs(CoreGui:GetChildren()) do
        if v:FindFirstChild("PropertiesFrame") then
            if v:FindFirstChild("ExplorerPanel") then
                if v:FindFirstChild("SideMenu") then
                    Client:Kick("\n[Break-Skill Hub - V1]:\n[Script Error]:\nDark Dex Detected!\nIf you keep trying to use Dark Dex while Break-Skill Hub is running your IP may be blocked!\ndiscord.gg/ev8bxrAa9p")

                    return
                end
            end
        end
    end
end)

--//
--// Game Script Loading
--//

if game.PlaceId == 920587237 then
    loadstring(game:HttpGet("https://raw.githubusercontent.com/Sklllus/B-S-Hub-V1/refs/heads/main/Games/Adopt%20Me.lua"))()
else
    Notification.Notify(
        "Break-Skill Hub - V1 | Loader",
        "<b><font color=\"rgb(255, 30, 30)\">Game not supported!</font></b>",
        "rbxassetid://7771536804",
        {
            Duration = 5,
            TitleSettings = {
                TextXAlignment = Enum.TextXAlignment.Left,
                Font = Enum.Font.SourceSansBold
            },
            GradientSettings = {
                GradientEnabled = false,
                SolidColorEnabled = true,
                Retract = true,
                SolidColor = Color3.fromRGB(255, 30, 30)
            }
        }
    )

    return
end
