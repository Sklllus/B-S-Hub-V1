--[
--Script Made By xS_Killus
--]

repeat
    task.wait()
until game.GameId ~= 0 and game:IsLoaded() and game:GetService("Players").LocalPlayer.Character:WaitForChild("HumanoidRootPart") and game:GetService("Players").LocalPlayer.Character:WaitForChild("Humanoid") and game:GetService("Players").LocalPlayer.Character:WaitForChild("Humanoid").Health > 0

--Instances And Functions

local CoreGui = game:GetService("CoreGui")
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Teams = game:GetService("Teams")
local UserInputService = game:GetService("UserInputService")
local Workspace = game:GetService("Workspace")

local Client = Players.LocalPlayer

local Camera = Workspace.CurrentCamera

local WhiteColor = Color3.fromRGB(255, 255, 255)
local BlackColor = Color3.fromRGB(0, 0, 0)
local GreenColor = Color3.fromRGB(30, 255, 30)
local RedColor = Color3.fromRGB(255, 30, 30)

local DrawingLibrary = {
    ESP = {},
    ObjectESP = {}
}

Workspace:GetPropertyChangedSignal("CurrentCamera"):Connect(function()
    Camera = Workspace.CurrentCamera
end)

if not HighlightContainer then
    getgenv()["HighlightContainer"] = Instance.new("Folder", CoreGui)

    HighlightContainer.Name = "HighlightContainer"
end

local function GetFontFromName(fontName)
    return (fontName == "UI" and 0) or (fontName == "System" and 1) or (fontName == "Plex" and 2) or (fontName == "Monospace" and 3) or 0
end

local function GetDistanceFromCamera(position)
    return (position - Camera.CFrame.Position).Magnitude
end

local function CheckDistance(enabled, distance, maxDistance)
    if not enabled then
        return true
    end

    return distance <= maxDistance
end

local function ClampDistance(enabled, clamp, distance)
    if not enabled then
        return clamp
    end

    return math.clamp(1 / distance * 1000, 0, clamp)
end

local function DynamicFOV(enabled, fov)
    if not enabled then
        return fov
    end

    return ((120 - Camera.FieldOfView) * 4) + fov
end

local function GetFlag(f, f1, f2)
    return f[f1 .. f2]
end

local function GetCharacter(target, mode)
    if mode == "Player" then
        local Character = target.Character

        if not Character then
            return
        end

        return Character, Character:FindFirstChild("HumanoidRootPart")
    else
        return target, target:FindFirstChild("HumanoidRootPart")
    end
end

local function GetHealth(target, character, mode)
    local Humanoid = character:FindFirstChildOfClass("Humanoid")

    if not Humanoid then
        return
    end

    return Humanoid.Health, Humanoid.MaxHealth, Humanoid.Health > 0
end

local function GetTeam(target, character, mode)
    if mode == "Player" then
        if target.Neutral then
            return true, target.TeamColor.Color
        else
            return Client.Team ~= target.Team, target.TeamColor.Color
        end
    else
        return true, WhiteColor
    end
end

local function AddHighlight()
    local Highlight = Instance.new("Highlight", HighlightContainer)

    return Highlight
end

local function AddDrawing(type, props)
    local Drawing = Drawing.new(type)

    if not props then
        return Drawing
    end

    for p, v in pairs(props) do
        Drawing[p] = v
    end

    return Drawing
end

local function RemoveDrawing(tbl)
    for i, d in pairs(tbl) do
        if d.Remove then
            d:Remove()
        else
            RemoveDrawing(d)
        end
    end
end

local function AntiAliasingXY(x, y)
    return Vector2.new(math.round(x), math.round(y))
end

local function AntiAliasingP(position)
    return Vector2.new(math.round(position.X), math.round(position.Y))
end

local function CalculateBox(model, position)
    local Size = model:GetExtentsSize()

    local ScaleFactor = 1 / (position.Z * math.tan(math.rad(Camera.FieldOfView / 2)) * 2) * 1000

    Size = AntiAliasingXY(ScaleFactor * Size.X, ScaleFactor * Size.Y)

    position = Vector2.new(position.X, position.Y)

    return AntiAliasingP(position - Size / 2), Size
end

local function GetRelative(position)
    local Relative = Camera.CFrame:PointToObjectSpace(position)

    return Vector2.new(-Relative.X, -Relative.Z)
end

local function RotateDirection(direction, radius)
    radius = math.rad(radius)

    local X = direction.X * math.cos(radius) - direction.Y * math.sin(radius)
    local Y = direction.X * math.sin(radius) + direction.Y * math.cos(radius)

    return Vector2.new(X, Y)
end

local function RelativeToCenter(size)
    return AntiAliasingP(Camera.ViewportSize / 2 - size)
end

--[
--DrawingLibrary Functions
--]

--[
--AddObject
--]

function DrawingLibrary:AddObject(object, objectName, objectPosition, globalFlag, flag, flags)
    if DrawingLibrary.ObjectESP[object] then
        return
    end

    DrawingLibrary.ObjectESP[object] = {
        IsBasePart = typeof(objectPosition) ~= "Vector3",
        Object = {
            Name = objectName,
            Position = objectPosition
        },
        Flag = flag,
        GlobalFlag = globalFlag,
        Flags = flags,
        Drawing = {
            Text = AddDrawing("Text", {
                Transparency = 0,
                Visible = false,
                Outline = true,
                Center = true,
                ZIndex = 1
            })
        }
    }
end

--[
--AddESP
--]

function DrawingLibrary:AddESP(target, mode, flag, flags)
    if DrawingLibrary.ESP[target] then
        return
    end

    DrawingLibrary.ESP[target] = {
        Target = {},
        Mode = mode,
        Flag = flag,
        Flags = flags,
        Highlight = AddHighlight(),
        Drawing = {
            Box = {
                Main = AddDrawing("Square", {
                    Transparency = 0,
                    Visible = false,
                    ZIndex = 1
                }),
                Outline = AddDrawing("Square", {
                    Transparency = 0,
                    Visible = false
                }),
                Text = AddDrawing("Text", {
                    Color = WhiteColor,
                    Transparency = 0,
                    Visible = false,
                    Center = true,
                    ZIndex = 1
                })
            },
            HealthBar = {
                Main = AddDrawing("Square", {
                    Transparency = 0,
                    Visible = false,
                    Filled = true,
                    ZIndex = 1
                }),
                Outline = AddDrawing("Square", {
                    Transparency = 0,
                    Visible = false,
                    Filled = true
                })
            },
            Arrow = {
                Main = AddDrawing("Triangle", {
                    Transparency = 0,
                    Visible = false,
                    ZIndex = 1
                }),
                Outline = AddDrawing("Triangle", {
                    Transparency = 0,
                    Visible = false
                })
            },
            Head = {
                Main = AddDrawing("Circle", {
                    Transparency = 0,
                    Visible = false,
                    ZIndex = 1
                }),
                Outline = AddDrawing("Circle", {
                    Transparency = 0,
                    Visible = false
                })
            },
            Tracer = AddDrawing("Line", {
                Transparency = 0,
                Visible = false,
                ZIndex = 1
            })
        }
    }
end

--[
--RemoveESP
--]

function DrawingLibrary:RemoveESP(target)
    local ESP = DrawingLibrary.ESP[target]

    if not ESP then
        return
    end

    if ESP.Highlight then
        ESP.Highlight:Destroy()
    end

    RemoveDrawing(ESP.Drawing)

    DrawingLibrary.ESP[target] = nil
end

--[
--RemoveObject
--]

function DrawingLibrary:RemoveObject(target)
    local Object = DrawingLibrary.ObjectESP[target]

    if not Object then
        return
    end

    RemoveDrawing(Object.Drawing)

    DrawingLibrary.ObjectESP[target] = nil
end

--[
--SetupCursor
--]

function DrawingLibrary:SetupCursor(config)
    local Cursor = AddDrawing("Triangle", {
        Color = WhiteColor,
        Filled = true,
        Thickness = 1,
        Transparency = 1,
        Visible = true,
        ZIndex = 2
    })

    local CursorOutline = AddDrawing("Triangle", {
        Color = BlackColor,
        Filled = true,
        Thickness = 1,
        Transparency = 1,
        Visible = true,
        ZIndex = 1
    })

    local CrosshairL = AddDrawing("Line", {
        Thickness = 1.5,
        Transparency = 1,
        Visible = true,
        ZIndex = 3
    })

    local CrosshairR = AddDrawing("Line", {
        Thickness = 1.5,
        Transparency = 1,
        Visible = true,
        ZIndex = 3
    })

    local CrosshairT = AddDrawing("Line", {
        Thickness = 1.5,
        Transparency = 1,
        Visible = true,
        ZIndex = 3
    })

    local CrosshairB = AddDrawing("Line", {
        Thickness = 1.5,
        Transparency = 1,
        Visible = true,
        ZIndex = 3
    })

    BreakSkill_Hub_V1_Loaded.Utilities.Misc:NewThreadLoop(0, function()
        local CursorEnabled = config["Mouse/Enabled"] and UserInputService.MouseBehavior == Enum.MouseBehavior.Default and not UserInputService.MouseIconEnabled
        local CrosshairEnabled = config["Mouse/Crosshair/Enabled"] and UserInputService.MouseBehavior ~= Enum.MouseBehavior.Default and not UserInputService.MouseIconEnabled

        local Mouse = UserInputService:GetMouseLocation()

        Cursor.Visible = CursorEnabled
        CursorOutline.Visible = CursorEnabled

        CrosshairL.Visible = CrosshairEnabled
        CrosshairR.Visible = CrosshairEnabled
        CrosshairT.Visible = CrosshairEnabled
        CrosshairB.Visible = CrosshairEnabled

        if CursorEnabled then
            Cursor.PointA = Mouse + Vector2.new(0, 15)
            Cursor.PointB = Mouse
            Cursor.PointC = Mouse + Vector2.new(10, 10)

            CursorOutline.PointA = Cursor.PointA + Vector2.new(0, 1)
            CursorOutline.PointB = Cursor.PointB
            CursorOutline.PointC = Cursor.PointC + Vector2.new(1, 0)
        end

        if CrosshairEnabled then
            local Color = config["Mouse/Crosshair/Color"][6]

            CrosshairL.Color = Color
            CrosshairL.From = Mouse - Vector2.new(config["Mouse/Crosshair/Gap"], 0)
            CrosshairL.To = Mouse - Vector2.new(config["Mouse/Crosshair/Size"] + config["Mouse/Crosshair/Gap"], 0)

            CrosshairR.Color = Color
            CrosshairR.From = Mouse + Vector2.new(config["Mouse/Crosshair/Gap"] + 1, 0)
            CrosshairR.To = Mouse + Vector2.new(config["Mouse/Crosshair/Size"] + (config["Mouse/Crosshair/Gap"] + 1), 0)

            CrosshairT.Color = Color
            CrosshairT.From = Mouse - Vector2.new(0, config["Mouse/Crosshair/Gap"])
            CrosshairT.To = Mouse - Vector2.new(0, config["Mouse/Crosshair/Size"] + config["Mouse/Crosshair/Gap"])

            CrosshairB.Color = Color
            CrosshairB.From = Mouse + Vector2.new(0, config["Mouse/Crosshair/Gap"] + 1)
            CrosshairB.To = Mouse + Vector2.new(0, config["Mouse/Crosshair/Size"] + (config["Mouse/Crosshair/Gap"] + 1))
        end
    end)
end

--[
--FOVCircle
--]

function DrawingLibrary:FOVCircle(name, config)
    local FOVCircle = AddDrawing("Circle", {
        ZIndex = 4
    })

    local Outline = AddDrawing("Circle", {
        ZIndex = 3
    })

    BreakSkill_Hub_V1_Loaded.Utilities.Misc:NewThreadLoop(0, function()
        FOVCircle.Visible = config[name .. "/Enabled"] and config[name .. "/Circle/Enabled"]

        Outline.Visible = config[name .. "/Enabled"] and config[name .. "/Circle/Enabled"]

        if FOVCircle.Visible then
            local FOV = DynamicFOV(config[name .. "/DynamicFOV"], config[name .. "/FieldOfView"])

            local Position = UserInputService:GetMouseLocation()

            FOVCircle.Transparency = 1 - config[name .. "/Circle/Color"][4]
            FOVCircle.Color = config[name .. "/Circle/Color"][6]
            FOVCircle.Thickness = config[name .. "/Circle/Thickness"]
            FOVCircle.NumSides = config[name .. "/Circle/NumSides"]
            FOVCircle.Filled = config[name .. "/Circle/Filled"]

            Outline.Transparency = 1 - config[name .. "/Circle/Color"][4]
            Outline.Thickness = config[name .. "/Circle/Thickness"] + 2
            Outline.NumSides = config[name .. "/Circle/NumSides"]

            FOVCircle.Radius = FOV
            FOVCircle.Position = Position

            Outline.Radius = FOV
            Outline.Position = Position
        end
    end)
end

BreakSkill_Hub_V1_Loaded.Utilities.Misc:NewThreadLoop(0.025, function()
    for o, esp in pairs(DrawingLibrary.ObjectESP) do
        if not GetFlag(esp.Flags, esp.GlobalFlag, "/Enabled") or not GetFlag(esp.Flags, esp.Flag, "/Enabled") then
            esp.Drawing.Text.Visible = false

            continue
        end

        local Position = esp.IsBasePart and esp.Object.Position.Position or esp.Object.Position

        local ScreenPosition, OnScreen = Camera:WorldToViewportPoint(Position)

        local Distance = GetDistanceFromCamera(Position) * 0.28

        local InTheRange = CheckDistance(GetFlag(esp.Flags, esp.GlobalFlag, "/DistanceCheck"), Distance, GetFlag(esp.Flags, esp.GlobalFlag, "/Distance"))

        esp.Drawing.Text.Visible = (OnScreen and InTheRange) and (GetFlag(esp.Flags, esp.Flag, "/Enabled") and GetFlag(esp.Flags, esp.GlobalFlag, "/Enabled")) or false

        if esp.Drawing.Text.Visible then
            local Color = GetFlag(esp.Flags, esp.Flag, "/Color")

            esp.Drawing.Text.Transparency = 1 - Color[4]
            esp.Drawing.Text.Color = Color[6]
            esp.Drawing.Text.Text = string.format("%s\n%i studs", esp.Object.Name, Distance)
            esp.Drawing.Text.Position = Vector2.new(ScreenPosition.X, ScreenPosition.Y)
        end
    end
end)

BreakSkill_Hub_V1_Loaded.Utilities.Misc:NewThreadLoop(0.025, function()
    for t, esp in pairs(DrawingLibrary.ESP) do
        esp.Target.Character, esp.Target.RootPart = GetCharacter(t, esp.Mode)

        if esp.Target.Character and esp.Target.RootPart then
            esp.Target.ScreenPosition, esp.Target.OnScreen = Camera:WorldToViewportPoint(esp.Target.RootPart.Position)

            local Distance = GetDistanceFromCamera(esp.Target.RootPart.Position)

            esp.Target.InTheRange = CheckDistance(GetFlag(esp.Flags, esp.Flag, "/DistanceCheck"), Distance, GetFlag(esp.Flags, esp.Flag, "/Distance"))
            esp.Target.IsEnemyTeam, esp.Target.TeamColor = GetTeam(t, esp.Target.Character, esp.Mode)
            esp.Target.Health, esp.Target.MaxHealth, esp.Target.IsAlive = GetHealth(t, esp.Target.Character, esp.Mode)
            esp.Target.Color = GetFlag(esp.Flags, esp.Flag, "/TeamColor") and esp.Target.TeamColor or (esp.Target.IsEnemyTeam and GetFlag(esp.Flags, esp.Flag, "/Enemy")[6] or GetFlag(esp.Flags, esp.Flag, "/Ally")[6])

            if esp.Target.OnScreen and esp.Target.InTheRange then
                if esp.Highlight.Enabled then
                    esp.Highlight.Adornee = esp.Target.Character
                    esp.Highlight.FillColor = esp.Target.Color
                    esp.Highlight.FillTransparency = GetFlag(esp.Flags, esp.Flag, "/Highlight/Transparency")
                    esp.Highlight.OutlineColor = GetFlag(esp.Flags, esp.Flag, "/Highlight/OutlineColor")[6]
                    esp.Highlight.OutlineTransparency = GetFlag(esp.Flags, esp.Flag, "/Highlight/OutlineColor")[4]
                end

                if esp.Drawing.Head.Main.Visible and esp.Drawing.Tracer.Visible then
                    local Head = esp.Target.Character:FindFirstChild("Head", true)

                    if Head then
                        local HeadPosition = Camera:WorldToViewportPoint(Head.Position)

                        if esp.Drawing.Head.Main.Visible then
                            esp.Drawing.Head.Main.Color = esp.Target.Color
                            esp.Drawing.Head.Main.Radius = ClampDistance(GetFlag(esp.Flags, esp.Flag, "/Head/AutoScale"), GetFlag(esp.Flags, esp.Flag, "/Head/Radius"), Distance)
                            esp.Drawing.Head.Main.Filled = GetFlag(esp.Flags, esp.Flag, "/Head/Filled")
                            esp.Drawing.Head.Main.NumSides = GetFlag(esp.Flags, esp.Flag, "/Head/NumSides")
                            esp.Drawing.Head.Main.Thickness = GetFlag(esp.Flags, esp.Flag, "/Head/Thickness")
                            esp.Drawing.Head.Main.Transparency = 1 - GetFlag(esp.Flags, esp.Flag, "/Head/Transparency")

                            esp.Drawing.Head.Outline.Radius = esp.Drawing.Head.Main.Radius
                            esp.Drawing.Head.Outline.NumSides = esp.Drawing.Head.Main.NumSides
                            esp.Drawing.Head.Outline.Thickness = esp.Drawing.Head.Main.Thickness + 2
                            esp.Drawing.Head.Outline.Transparency = esp.Drawing.Head.Main.Transparency

                            esp.Drawing.Head.Main.Position = Vector2.new(HeadPosition.X, HeadPosition.Y)

                            esp.Drawing.Head.Outline.Position = esp.Drawing.Head.Main.Position
                        end

                        if esp.Drawing.Tracer.Visible then
                            local TracerMode = GetFlag(esp.Flags, esp.Flag, "/Tracer/Mode")

                            esp.Drawing.Tracer.Color = esp.Target.Color
                            esp.Drawing.Tracer.Thickness = GetFlag(esp.Flags, esp.Flag, "/Tracer/Thickness")
                            esp.Drawing.Tracer.Transparency = 1 - GetFlag(esp.Flags, esp.Flag, "/Tracer/Transparency")
                            esp.Drawing.Tracer.From = TracerMode[1] == "From Mouse" and UserInputService:GetMouseLocation() or TracerMode[1] == "From Bottom" and Vector2.new(Camera.ViewportSize / 2, Camera.ViewportSize.Y)
                            esp.Drawing.Tracer.To = Vector2.new(HeadPosition.X, HeadPosition.Y)
                        end
                    end
                end

                if esp.Drawing.Box.Main.Visible or esp.Drawing.Box.Text.Visible then
                    local BoxPosition, BoxSize = CalculateBox(esp.Target.Character, esp.Target.ScreenPosition)

                    esp.Target.HealthPercent, esp.Target.BoxTooSmall = esp.Target.Health / esp.Target.MaxHealth, BoxSize.Y <= 12

                    if esp.Drawing.Box.Main.Visible then
                        esp.Drawing.Box.Main.Color = esp.Target.Color
                        esp.Drawing.Box.Main.Filled = GetFlag(esp.Flags, esp.Flag, "/Box/Filled")
                        esp.Drawing.Box.Main.Thickness = GetFlag(esp.Flags, esp.Flag, "/Box/Thickness")
                        esp.Drawing.Box.Main.Transparency = 1 - GetFlag(esp.Flags, esp.Flag, "/Box/Transparency")

                        esp.Drawing.Box.Outline.Thickness = esp.Drawing.Box.Main.Thickness + 2
                        esp.Drawing.Box.Outline.Transparency = esp.Drawing.Box.Main.Transparency

                        esp.Drawing.Box.Main.Size = BoxSize
                        esp.Drawing.Box.Main.Position = BoxPosition

                        esp.Drawing.Box.Outline.Size = esp.Drawing.Box.Main.Size
                        esp.Drawing.Box.Outline.Position = esp.Drawing.Box.Main.Position
                    end

                    if esp.Drawing.HealthBar.Main.Visible and not esp.Target.BoxTooSmall then
                        esp.Drawing.HealthBar.Main.Color = RedColor:Lerp(GreenColor, esp.Target.HealthPercent)

                        esp.Drawing.HealthBar.Outline.Size = Vector2.new(3, BoxSize.Y + 2)
                        esp.Drawing.HealthBar.Outline.Position = Vector2.new(BoxPosition.X - esp.Drawing.HealthBar.Outline.Size.X - 2, BoxPosition.Y - 1)

                        esp.Drawing.HealthBar.Main.Size = Vector2.new(esp.Drawing.HealthBar.Outline.Size.X - 2, -esp.Target.HealthPercent * (esp.Drawing.HealthBar.Outline.Size.Y - 2))
                        esp.Drawing.HealthBar.Main.Position = esp.Drawing.HealthBar.Outline.Position + Vector2.new(1, esp.Drawing.HealthBar.Outline.Size.Y - 1)
                    end

                    if esp.Drawing.Box.Text.Visible then
                        esp.Drawing.Box.Text.Size = ClampDistance(GetFlag(esp.Flags, esp.Flag, "/Text/AutoScale"), GetFlag(esp.Flags, esp.Flag, "/Text/Size"), Distance)
                        esp.Drawing.Box.Text.Outline = GetFlag(esp.Flags, esp.Flag, "/Text/Outline")
                        esp.Drawing.Box.Text.Font = GetFontFromName(GetFlag(esp.Flags, esp.Flag, "/Text/Font")[1])
                        esp.Drawing.Box.Text.Transparency = 1 - GetFlag(esp.Flags, esp.Flag, "/Text/Transparency")
                        esp.Drawing.Box.Text.Text = string.format("%s\n%i studs", esp.Mode == "Player" and t.Name or (esp.Target.IsEnemyTeam and "Enemy NPC" or "Ally NPC"), Distance)
                        esp.Drawing.Box.Text.Position = Vector2.new(BoxPosition.X + BoxSize.X / 2, BoxPosition.Y + BoxSize.Y)
                    end
                end
            else
                if esp.Drawing.Arrow.Main.Visible then
                    local Relative = GetRelative(esp.Target.RootPart.Position)
                    local SideLength = GetFlag(esp.Flags, esp.Flag, "/Arrow/Width") / 2

                    local Direction = Relative.Unit

                    local Base = Direction * GetFlag(esp.Flags, esp.Flag, "/Arrow/Distance")
                    local BaseL = Base * RotateDirection(Direction, 90) * SideLength
                    local BaseR = Base * RotateDirection(Direction, -90) * SideLength

                    local Tip = Direction * (GetFlag(esp.Flags, esp.Flag, "/Arrow/Distance") + GetFlag(esp.Flags, esp.Flag, "/Arrow/Height"))

                    local RTCBL = RelativeToCenter(BaseL)
                    local RTCBR = RelativeToCenter(BaseR)
                    local RTCT = RelativeToCenter(Tip)

                    esp.Drawing.Arrow.Main.Color = esp.Target.Color
                    esp.Drawing.Arrow.Main.Filled = GetFlag(esp.Flags, esp.Flag, "/Arrow/Filled")
                    esp.Drawing.Arrow.Main.Thickness = GetFlag(esp.Flags, esp.Flag, "/Arrow/Thickness")
                    esp.Drawing.Arrow.Main.Transparency = 1 - GetFlag(esp.Flags, esp.Flag, "/Arrow/Transparency")

                    esp.Drawing.Arrow.Outline.Thickness = esp.Drawing.Arrow.Main.Thickness + 1
                    esp.Drawing.Arrow.Outline.Transparency = esp.Drawing.Arrow.Main.Transparency

                    esp.Drawing.Arrow.Main.PointA = RTCBL
                    esp.Drawing.Arrow.Main.PointB = RTCBR
                    esp.Drawing.Arrow.Main.PointC = RTCT

                    esp.Drawing.Arrow.Outline.PointA = RTCBL
                    esp.Drawing.Arrow.Outline.PointB = RTCBR
                    esp.Drawing.Arrow.Outline.PointC = RTCT
                end
            end
        end

        local TeamCheck = not GetFlag(esp.Flags, esp.Flag, "/TeamCheck") and not esp.Target.IsEnemyTeam or esp.Target.IsEnemyTeam
        local Visible = esp.Target.OnScreen and esp.Target.InTheRange and esp.Target.RootPart and esp.Target.IsAlive and TeamCheck
        local ArrowVisible = not esp.Target.OnScreen and esp.Target.InTheRange and esp.Target.RootPart and esp.Target.IsAlive and TeamCheck

        esp.Highlight.Enabled = Visible and GetFlag(esp.Flags, esp.Flag, "/Highlight/Enabled") or false

        esp.Drawing.Box.Main.Visible = Visible and GetFlag(esp.Flags, esp.Flag, "/Box/Enabled") or false
        esp.Drawing.Box.Outline.Visible = GetFlag(esp.Flags, esp.Flag, "/Box/Outline") and esp.Drawing.Box.Main.Visible or false
        esp.Drawing.Box.Text.Visible = Visible and GetFlag(esp.Flags, esp.Flag, "/Text/Enabled") or false

        esp.Drawing.HealthBar.Main.Visible = GetFlag(esp.Flags, esp.Flag, "/Box/HealthBar") and not esp.Target.BoxTooSmall and esp.Drawing.Box.Main.Visible or false
        esp.Drawing.HealthBar.Outline.Visible = GetFlag(esp.Flags, esp.Flag, "/Box/Outline") and esp.Drawing.HealthBar.Main.Visible or false

        esp.Drawing.Arrow.Main.Visible = ArrowVisible and GetFlag(esp.Flags, esp.Flag, "/Arrow/Enabled") or false
        esp.Drawing.Arrow.Outline.Visible = GetFlag(esp.Flags, esp.Flag, "/Arrow/Outline") and esp.Drawing.Arrow.Main.Visible or false

        esp.Drawing.Head.Main.Visible = Visible and GetFlag(esp.Flags, esp.Flag, "/Head/Enabled") or false
        esp.Drawing.Head.Outline.Visible = GetFlag(esp.Flags, esp.Flag, "/Head/Outline") and esp.Drawing.Head.Main.Visible or false

        esp.Drawing.Tracer.Visible = Visible and GetFlag(esp.Flags, esp.Flag, "/Tracer/Enabled") or false
    end
end)

return DrawingLibrary
