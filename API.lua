--[
--Script Made By xS_Killus
--]

--[
--Game Loading
--]

local Start = tick()

repeat
    task.wait()
until game.GameId ~= 0 and game:IsLoaded() and game:GetService("Players").LocalPlayer.Character:WaitForChild("HumanoidRootPart") and game:GetService("Players").LocalPlayer.Character:WaitForChild("Humanoid") and game:GetService("Players").LocalPlayer.Character:WaitForChild("Humanoid").Health > 0

--While Loading Script

if BreakSkill_Hub_V1_Loaded and BreakSkill_Hub_V1_Loaded.Game then
    print("ALREADY LOADED NOTIFICATION")

    error("Break-Skill Hub - V1 | Already executed!")

    return
end

--Instances And Functions

local CoreGui = game:GetService("CoreGui")
local MarketplaceService = game:GetService("MarketplaceService")
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local VirtualUser = game:GetService("VirtualUser")
local Workspace = game:GetService("Workspace")

local Client = Players.LocalPlayer

local QueueOnTeleport = queue_on_teleport or (syn and syn.queue_on_teleport)

local LoadArgs = {
    ...
}

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
                    Client:Kick("\n[Break-Skill Hub - V1]:\n[Script Error]:\nDark Dex Detected!\nIf you keep trying to use Dark Dex while the script is running your whitelist may be blocked!\ndiscord.gg/ev8bxrAa9p")

                    return
                end
            end
        end
    end
end)

if syn and not is_sirhurtclosure and not pebc_execute then

elseif getexecutorname then

elseif KRNL_LOADED then

else
    Client:Kick("\n[Break-Skill Hub - V1]:\n[Executor Error]:\nYour executor is not supported!\nYou can find supported executors on our discord!\ndiscord.gg/ev8bxrAa9p")

    return
end

local function GetSupportedGame()
    local Game

    for id, info in pairs(BreakSkill_Hub_V1_Loaded.Games) do
        if tostring(game.GameId) == id then
            Game = info

            break
        end
    end

    if not Game then
        return BreakSkill_Hub_V1_Loaded.Games.Universal
    end

    return Game
end

local function Concat(array, sep)
    local Output = ""

    for i, v in ipairs(array) do
        Output = i == #array and Output .. tostring(v) or Output .. tostring(v) .. sep
    end

    return Output
end

local function GetScript(script)
    return BreakSkill_Hub_V1_Loaded.Debug and readfile("Break-Skill Hub - V1/" .. script .. ".lua") or game:HttpGetAsync(("%s%s.lua"):format(BreakSkill_Hub_V1_Loaded.Domain, script))
end

local function LoadScript(script)
    return loadstring(BreakSkill_Hub_V1_Loaded.Debug and readfile("Break-Skill Hub - V1/" .. script .. ".lua") or game:HttpGetAsync(("%s%s.lua"):format(BreakSkill_Hub_V1_Loaded.Domain, script)))()
end

--[
--Game Script Loading
--]

getgenv()["BreakSkill_Hub_V1_Loaded"] = {
    Debug = LoadArgs[1],
    Utilities = {},
    Domain = "https://raw.githubusercontent.com/Sklllus/B-S-Hub-V1/main/",
    Games = {
        ["Universal"] = {
            Name = "Universal",
            Script = "Universal"
        },
        ["2916899287"] = {
            Name = "Blackhawk Rescue Mission 5",
            Script = "Games/BRM5"
        },
        ["2788229376"] = {
            Name = "Da Hood",
            Script = "Games/DH"
        },
        ["443406476"] = {
            Name = "Project Lazarus",
            Script = "Games/PL"
        }
    }
}

BreakSkill_Hub_V1_Loaded.Utilities.UI = LoadScript("Utilities/UI")
BreakSkill_Hub_V1_Loaded.Utilities.Misc = LoadScript("Utilities/Misc")
BreakSkill_Hub_V1_Loaded.Utilities.Drawing = LoadScript("Utilities/Drawing")

local SupportedGame = GetSupportedGame()

Client.OnTeleport:Connect(function(teleportState)
    if teleportState == Enum.TeleportState.InProgress then
        QueueOnTeleport(([[
            local LoadArgs = {
                %s
            }

            loadstring(LoadArgs[1] and readfile("Break-Skill Hub - V1/Loader.lua") or game:HttpGetAsync("%sLoader.lua"))(unpack(LoadArgs))
        ]]):format(Concat(LoadArgs, ","), BreakSkill_Hub_V1_Loaded.Domain))
    end
end)

if SupportedGame then
    BreakSkill_Hub_V1_Loaded.Game = SupportedGame.Name

    LoadScript(SupportedGame.Script)

    print("TIME NOTIFICATION")

    print("GAME SCRIPT LOADED NOTIFICATION")
end
