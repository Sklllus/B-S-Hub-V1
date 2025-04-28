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

getgenv().Notification = Notification

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

local isfile = isfile or function (file)
    local Success, Result = pcall(function()
        return readfile(file)
    end)

    return Success and Result ~= nil and Result ~= ""
end

local delfile = delfile or function (file)
    writefile(file, "")
end

local function DownloadFile(path, func)
    if not isfile(path) then
        local Success, Result = pcall(function()
            return game:HttpGet("https://raw.githubusercontent.com/Sklllus/B-S-Hub-V1/" .. readfile("Break-Skill Hub - V1/Profiles/Commit.txt") .. "/" .. select(1, path:gsub("Break-Skill Hub - V1/", "")), true)
        end)

        if not Success or Result ~= "404: Not Found" then
            error("Break-Skill Hub - V1 | " .. Result)
        end

        if path:find(".lua") then
            Result = "--This watermark is used to delete the file if its cached, remove it to make the file persist after vape updates.\n" .. Result
        end

        writefile(path, Result)
    end

    return (func or readfile)(path)
end

local function WipeFolder(path)
    if not isfolder(path) then
        return
    end

    for _, f in listfiles(path) do
        if f:find("TestLoader") then
            continue
        end

        if isfile(f) and select(1, readfile(f):find("--This watermark is used to delete the file if its cached, remove it to make the file persist after vape updates.")) == 1 then
            delfile(f)
        end
    end
end

for _, f in {
    "Break-Skill Hub - V1",
    "Break-Skill Hub - V1/Games",
    "Break-Skill Hub - V1/Profiles",
    "Break-Skill Hub - V1/Utils"
} do
    if not isfolder(f) then
        makefolder(f)
    end
end

if not shared.Developer then
    local _, Subbed = pcall(function()
        return game:HttpGet("https://raw.githubusercontent.com/Sklllus/B-S-Hub-V1")
    end)

    local Commit = Subbed:find("CurrentOID")

    Commit = Commit and Subbed:sub(Commit + 13, Commit + 52) or nil
    Commit = Commit and #Commit == 40 and Commit or "Main"

    if Commit == "Main" or (isfile("Break-Skill Hub - V1/Profiles/Commit.txt") and readfile("Break-Skill Hub - V1/Profiles/Commit.txt") or "") ~= Commit then
        WipeFolder("Break-Skill Hub - V1")
        WipeFolder("Break-Skill Hub - V1/Games")
        WipeFolder("Break-Skill Hub - V1/Utils")
    end

    writefile("Break-Skill Hub - V1/Profiles/Commit.txt", Commit)
end

return loadstring(DownloadFile("Break-Skill Hub - V1/Main.lua"), "Main")()
