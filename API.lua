--[
--Script Made By xS_Killus
--]

--[
--Game Loading
--]

local Start = tick()

repeat
    task.wait()
until game:IsLoaded() and game:GetService("Players").LocalPlayer.Character:WaitForChild("HumanoidRootPart") and game:GetService("Players").LocalPlayer.Character:WaitForChild("Humanoid") and game:GetService("Players").LocalPlayer.Character.Humanoid.Health

--Notification Library

getgenv()["IrisAd"] = true

local Notification = loadstring(game:HttpGet("https://api.irisapp.ca/Scripts/IrisBetterNotifications.lua"))()

--While Loading Script

if getgenv()["Break-Skill_V1_Loaded"] == true then
    Notification.Notify(
        "Break-Skill Hub - V1",
		"<b><font color=\"rgb(255, 30, 30)\">Break-Skill Hub - V1 already executed!</font></b>",
		"rbxassetid://7771536804",
		{
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
		}
	)

    error("Break-Skill Hub - V1 | Already executed!")

    return
end

--Instances And Functions

local MarketplaceService = game:GetService("MarketplaceService")
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local CoreGui = game:GetService("CoreGui")
local VirtualUser = game:GetService("VirtualUser")

local Client = Players.LocalPlayer

getgenv()["DH"] = true
getgenv()["PL"] = true

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
    Client:Kick("\n[Break-Skill Hub - V1]:\n[Executor Error]:\nYour executor is not supported!\nYou can find supported executors on our discord!\ndiscord.gg/ev8bxrAa9p (Copied)")

    setclipboard("discord.gg/ev8bxrAa9p")

    return
end

--Anti AFK

Client.Idled:Connect(function()
    VirtualUser:Button2Down(Vector2.new(0, 0), workspace.CurrentCamera.CFrame)

    task.wait(1)

    VirtualUser:Button2Up(Vector2.new(0, 0), workspace.CurrentCamera.CFrame)
end)

--[
--Game Script Loading
--]

if game.PlaceId == 142823291 and getgenv()["DH"] == true then
    loadstring(game:HttpGet("https://raw.githubusercontent.com/Sklllus/Break-Skill-Hub-V1/main/Murder%20Mystery%202.lua"))()

    if getgenv()["Break-Skill_Hub_DaHood_Loaded"] == true then
        local End = (tick() - Start)

        Notification.Notify("Break-Skill Hub - V1", "<b><font color=\"rgb(255, 30, 30)\">Loading script time: </font><font color=\"rgb(30, 255, 30)\">" .. End .. " </font><font color=\"rgb(255, 30, 30)\">ms.</font></b>", "rbxassetid://7771536804", {
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
    end

    if getgenv()["Break-Skill_Hub_Loaded"] == true then
        Notification.Notify("Break-Skill Hub - V1", "<b><font color=\"rgb(255, 30, 30)\">Successfully loaded script for</font> <font color=\"rgb(30, 255, 30)\">" .. MarketplaceService:GetProductInfo(game.PlaceId).Name .. "</font><font color=\"rgb(255, 30, 30)\">!</font></b>", "rbxassetid://7771536804", {
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
    end
elseif game.PlaceId == 443406476 and getgenv()["PL"] == true then
	loadstring(game:HttpGet("https://raw.githubusercontent.com/Sklllus/Break-Skill-Hub-V1/main/Project%20Lazarus.lua"))()

	if getgenv()["Break-Skill_Hub_ProjectLazarus_Loaded"] == true then
		local End = (tick() - Start)

		Notification.Notify("Break-Skill Hub - V1", "<b><font color=\"rgb(255, 30, 30)\">Loading script time: </font><font color=\"rgb(30, 255, 30)\">" .. End .. " </font><font color=\"rgb(255, 30, 30)\">ms.</font></b>", "rbxassetid://7771536804", {
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
	end

	if getgenv()["Break-Skill_Hub_Loaded"] == true then
		Notification.Notify("Break-Skill Hub - V1", "<b><font color=\"rgb(255, 30, 30)\">Successfully loaded script for</font> <font color=\"rgb(30, 255, 30)\">" .. MarketplaceService:GetProductInfo(game.PlaceId).Name .. "</font><font color=\"rgb(255, 30, 30)\">!</font></b>", "rbxassetid://7771536804", {
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
	end
elseif game.PlaceId == 142823291 and getgenv()["DH"] == false then
    Client:Kick("\n[Break-Skill Hub - V1]:\n[Game Error]:\nGame disabled!\nYou can find enabled games on our discord!\ndiscord.gg/ev8bxrAa9p (Copied)")

    setclipboard("discord.gg/ev8bxrAa9p")

    return
elseif game.PlaceId == 443406476 and getgenv()["PL"] == false then
	Client:Kick("\n[Break-Skill Hub - V1]:\n[Game Error]:\nGame disabled!\nYou can find enabled games on our discord!\ndiscord.gg/ev8bxrAa9p (Copied)")

	setclipboard("discord.gg/ev8bxrAa9p")

	return
else
    Client:Kick("\n[Break-Skill Hub - V1]:\n[Game Error]:\nGame not supported!\nYou can find supported games on our discord!\ndiscord.gg/ev8bxrAa9p (Copied)")

    setclipboard("discord.gg/ev8bxrAa9p")

    return
end
