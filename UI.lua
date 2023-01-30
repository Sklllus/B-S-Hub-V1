--[[
         _   _ ___   _       _
        | | | |_ _| | |   (_) |__  _ __ __ _ _ __ _   _
        | | | || |  | |   | | '_ \| '__/ _` | '__| | | |
        | |_| || |  | |___| | |_) | | | (_| | |  | |_| |
         \___/|___| |_____|_|_.__/|_|  \__,_|_|   \__, |
                                                  |___/

            UI Library Made by xS_Killus
    © Copyright 2023 Break-Skill Hub Inc. All rights reserved.

--]]

--Instances And Functions

local CoreGui = game:GetService("CoreGui")
local HttpService = game:GetService("HttpService")
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")

local Client = Players.LocalPlayer

local Mouse = Client:GetMouse()

local library = {
    WorkspaceName = "Break-Skill Hub - V1",
    Flags = {},
    Connections = {},
    Configuration = {
        HideKeybind = Enum.KeyCode.RightShift,
        EasingStyle = Enum.EasingStyle.Quart,
        EasingDirection = Enum.EasingDirection.Out,
        SmoothDragging = true
    },
    Themes = {
        Legacy = {
            Main = Color3.fromHSV(260 / 360, 60 / 255, 35 / 255),
            Secondary = Color3.fromHSV(240 / 360, 40 / 255, 65 / 255),
            Tertiary = Color3.fromHSV(260 / 360, 60 / 255, 150 / 255),
            StrongText = Color3.fromHSV(0, 0, 1),
            WeakText = Color3.fromHSV(0, 0, 170 / 255)
        },
        Serika = {
            Main = Color3.fromRGB(50, 50, 55),
            Secondary = Color3.fromRGB(80, 80, 85),
            Tertiary = Color3.fromRGB(225, 185, 20),
            StrongText = Color3.fromHSV(0, 0, 1),
            WeakText = Color3.fromHSV(0, 0, 170 / 255)
        },
        Dark = {
            Main = Color3.fromRGB(30, 30, 35),
            Secondary = Color3.fromRGB(50, 50, 55),
            Tertiary = Color3.fromRGB(70, 130, 180),
            StrongText = Color3.fromHSV(0, 0, 1),
            WeakText = Color3.fromHSV(0, 0, 170 / 255)
        },
        Rust = {
            Main = Color3.fromRGB(35, 35, 35),
            Secondary = Color3.fromRGB(65, 65, 65),
            Tertiary = Color3.fromRGB(235, 95, 40),
            StrongText = Color3.fromHSV(0, 0, 1),
            WeakText = Color3.fromHSV(0, 0, 170 / 255)
        },
        Aqua = {
            Main = Color3.fromRGB(20, 20, 20),
            Secondary = Color3.fromRGB(65, 65, 65),
            Tertiary = Color3.fromRGB(50, 155, 135),
            StrongText = Color3.fromHSV(0, 0, 1),
            WeakText = Color3.fromHSV(0, 0, 170 / 255)
        },
        BreakSkill = {
            Main = Color3.fromRGB(35, 35, 35),
            Secondary = Color3.fromRGB(70, 70, 70),
            Tertiary = Color3.fromRGB(225, 55, 55),
            StrongText = Color3.fromHSV(0, 0, 1),
            WeakText = Color3.fromHSV(0, 0, 170 / 255)
        }
    },
    ColorPickerStyles = {
        Legacy = 0,
        Modern = 1
    },
    ThemeObjects = {
        Main = {},
        Secondary = {},
        Tertiary = {},
        StrongText = {},
        WeakText = {}
    },
    Toggled = true,
    LockDragging = false,
    DisplayName = nil,
    URLLabel = nil,
    URL = nil,
    DragSpeed = 0.05,
    ToggleKey = Enum.KeyCode.RightShift
}

library.__index = library

local SelectedTab

library._promptExists = false
library._colorPickerExists = false

local GlobalTweenInfo = TweenInfo.new(0.2, library.Configuration.EasingStyle, library.Configuration.EasingDirection)

local UpdateSettings = function() end

--[
--UI Library Functions
--]

--[
--SetDefaults
--]

function library:SetDefaults(defaults, options)
    defaults = defaults or {}
    options = options or {}

    for o, v in next, options do
        defaults[o] = v
    end

    return defaults
end

--[
--ChangeTheme
--]

function library:ChangeTheme(toTheme)
    library.CurrentTheme = toTheme

    local Lighten = self:Lighten(toTheme.Tertiary, 20)

    library.DisplayName.Text = "Welcome, <font color='rgb(" .. math.floor(Lighten.R * 255) .. "," .. math.floor(Lighten.G * 255) .. "," .. math.floor(Lighten.B * 255) .. ")'> <font>" .. Client.DisplayName .. "</b></font>"

    for c, objs in next, library.ThemeObjects do
        local ThemeColor = library.CurrentTheme[c]

        for _, o in next, objs do
            local Element, Property, Theme, ColorAlter = o[1], o[2], o[3], o[4] or 0

            ThemeColor = library.CurrentTheme[Theme]

            local ModifiedColor = ThemeColor

            if ColorAlter < 0 then
                ModifiedColor = library:Darken(ThemeColor, -1 * ColorAlter)
            elseif ColorAlter > 0 then
                ModifiedColor = library:Lighten(ThemeColor, ColorAlter)
            end

            Element:Tween({
                [Property] = ModifiedColor
            })
        end
    end
end

--[
--Object
--]

function library:Object(class, props)
    local LocalObject = Instance.new(class)

    local ForcedPops = {
        BorderSizePixel = 0,
        AutoButtonColor = false,
        Font = Enum.Font.Code,
        Text = ""
    }

    for p, v in next, ForcedPops do
        pcall(function()
            LocalObject[p] = v
        end)
    end

    local Methods = {}

    Methods.AbsoluteObject = LocalObject

    --[
    --Tween
    --]

    function Methods:Tween(options, callback)
        options = library:SetDefaults({
            Length = 0.2,
            Style = library.Configuration.EasingStyle,
            Direction = library.Configuration.EasingDirection
        }, options)

        callback = callback or function ()
            return
        end

        local TI = TweenInfo.new(options.Length, options.Style, options.Direction)

        options.Length = nil
        options.Style = nil
        options.Direction = nil

        local Tween = TweenService:Create(LocalObject, TI, options)

        Tween:Play()

        Tween.Completed:Connect(function()
            callback()
        end)

        return Tween
    end

    --[
    --Round
    --]

    function Methods:Round(radius)
        radius = radius or 6

        library:Object("UICorner", {
            Parent = LocalObject,
            CornerRadius = UDim.new(0, radius)
        })

        return Methods
    end

    --[
    --Object
    --]

    function Methods:Object(class2, props2)
        props2 = props2 or {}

        props2.Parent = LocalObject

        return library:Object(class2, props2)
    end

    --[
    --CrossFade
    --]

    function Methods:CrossFade(p2, length)
        length = length or .2

        self:Tween({
            ImageTransparency = 1
        })

        p2:Tween({
            ImageTransparency = 0
        })
    end

    --[
    --Fade
    --]

    function Methods:Fade(state, colorOverride, length, instant)
        length = length or 0.2

        if not rawget(self, "fadeFrame") then
            local Frame = self:Object("Frame", {
                BackgroundColor3 = colorOverride or self.BackgroundColor3,
                BackgroundTransparency = (state and 1) or 0,
                Size = UDim2.fromScale(1, 1),
                Centered = true,
                ZIndex = 999
            }):Round(self.AbsoluteObject:FindFirstChildOfClass("UICorner") and self.AbsoluteObject:FindFirstChildOfClass("UICorner").CornerRadius.Offset or 0)

            rawset(self, "fadeFrame", Frame)
        else
            self.fadeFrame.BackgroundColor3 = colorOverride or self.BackgroundColor3
        end

        if instant then
            if state then
                self.fadeFrame.BackgroundTransparency = 0
                self.fadeFrame.Visible = true
            else
                self.fadeFrame.BackgroundTransparency = 1
                self.fadeFrame.Visible = false
            end
        else
            if state then
                self.fadeFrame.BackgroundTransparency = 1
                self.fadeFrame.Visible = true

                self.fadeFrame:Tween({
                    BackgroundTransparency = 0,
                    Length = length
                })
            else
                self.fadeFrame.BackgroundTransparency = 0

                self.fadeFrame:Tween({
                    BackgroundTransparency = 1,
                    Length = length
                }, function()
                    self.fadeFrame.Visible = false
                end)
            end
        end
    end

    --[
    --Stroke
    --]

    function Methods:Stroke(color, thickness, strokeMode)
        thickness = thickness or 1
        strokeMode = strokeMode or Enum.ApplyStrokeMode.Border

        local Stroke = self:Object("UIStroke", {
            ApplyStrokeMode = strokeMode,
            Thickness = thickness
        })

        if type(color) == "table" then
            local Theme, ColorAlter = color[1], color[2] or 0

            local ThemeColor = library.CurrentTheme[Theme]

            local ModifiedColor = ThemeColor

            if ColorAlter < 0 then
                ModifiedColor = library:Darken(ThemeColor, -1 * ColorAlter)
            elseif ColorAlter > 0 then
                ModifiedColor = library:Lighten(ThemeColor, ColorAlter)
            end

            Stroke.Color = ModifiedColor

            table.insert(library.ThemeObjects[Theme], {
                Stroke,
                "Color",
                Theme,
                ColorAlter
            })
        elseif type(color) == "string" then
            local ThemeColor = library.CurrentTheme[color]

            Stroke.Color = ThemeColor

            table.insert(library.ThemeObjects[color], {
                Stroke,
                "Color",
                color,
                0
            })
        else
            Stroke.Color = color
        end

        return Methods
    end

    --[
    --ToolTip
    --]

    function Methods:ToolTip(options)
        local Name = (options.Name or options.Title or options.Text) or "New ToolTip"

        local ToolTipContainer = Methods:Object("TextLabel", {
            Theme = {
                BackgroundColor3 = {
                    "Main",
                    10
                },
                TextColor3 = {
                    "WeakText"
                }
            },
            TextSize = 16,
            Text = Name,
            Position = UDim2.new(0.5, 0, 0, -8),
            TextXAlignment = Enum.TextXAlignment.Center,
            TextYAlignment = Enum.TextYAlignment.Center,
            AnchorPoint = Vector2.new(0.5, 1),
            BackgroundTransparency = 1,
            TextTransparency = 1
        }):Round(5)

        ToolTipContainer.Size = UDim2.fromOffset(ToolTipContainer.TextBounds.X + 16, ToolTipContainer.TextBounds.Y + 8)

        local ToolTipArrow = ToolTipContainer:Object("ImageLabel", {
            Image = "http://www.roblox.com/asset/?id=4292970642",
            Theme = {
                ImageColor3 = {
                    "Main",
                    10
                }
            },
            AnchorPoint = Vector2.new(0.5, 0),
            Rotation = 180,
            Position = UDim2.fromScale(0.5, 1),
            Size = UDim2.fromOffset(10, 6),
            BackgroundTransparency = 1,
            ImageTransparency = 1
        })

        local Hovered = false

        Methods.MouseEnter:Connect(function()
            Hovered = true

            task.wait(0.2)

            if Hovered then
                ToolTipContainer:Tween({
                    BackgroundTransparency = 0.2,
                    TextTransparency = 0.2
                })

                ToolTipArrow:Tween({
                    ImageTransparency = 0.2
                })
            end
        end)

        Methods.MouseLeave:Connect(function()
            Hovered = false

            ToolTipContainer:Tween({
                BackgroundTransparency = 1,
                TextTransparency = 1
            })

            ToolTipArrow:Tween({
                ImageTransparency = 1
            })
        end)

        return Methods
    end

    local CustomHandlers = {
        Centered = function(val)
            if val then
                LocalObject.AnchorPoint = Vector2.new(0.5, 0.5)
                LocalObject.Position = UDim2.fromScale(0.5, 0.5)
            end
        end,
        Theme = function(val)
            for p, o in next, val do
                if type(o) == "table" then
                    local Theme, ColorAlter = o[1], o[2] or 0

                    local ThemeColor = library.CurrentTheme[Theme]

                    local ModifiedColor = ThemeColor

                    if ColorAlter < 0 then
                        ModifiedColor = library:Darken(ThemeColor, -1 * ColorAlter)
                    elseif ColorAlter > 0 then
                        ModifiedColor = library:Lighten(ThemeColor, ColorAlter)
                    end

                    LocalObject[p] = ModifiedColor

                    table.insert(self.ThemeObjects[Theme], {
                        Methods,
                        p,
                        Theme,
                        ColorAlter
                    })
                else
                    local ThemeColor = library.CurrentTheme[o]

                    LocalObject[p] = ThemeColor

                    table.insert(self.ThemeObjects[o], {
                        Methods,
                        p,
                        o,
                        0
                    })
                end
            end
        end
    }

    for p, v in next, props do
        if CustomHandlers[p] then
            CustomHandlers[p](v)
        else
            LocalObject[p] = v
        end
    end

    return setmetatable(Methods, {
        __index = function(_, property)
            return LocalObject[property]
        end,
        __newindex = function(_, property, val)
            LocalObject[property] = val
        end
    })
end

--[
--Show
--]

function library:Show(state)
    self.Toggled = state

    self.MainFrame.ClipsDescendants = true

    if state then
        self.MainFrame:Tween({
            Size = self.MainFrame.OldSize,
            Length = 0.25
        }, function()
            rawset(self.MainFrame, "OldSize", (state and self.MainFrame.OldSize) or self.MainFrame.Size)

            self.MainFrame.ClipsDescendants = false
        end)

        task.wait(0.15)

        self.MainFrame:Fade(not state, self.MainFrame.BackgroundColor3, 0.15)
    else
        self.MainFrame:Fade(not state, self.MainFrame.BackgroundColor3, 0.15)

        task.wait(0.1)

        self.MainFrame:Tween({
            Size = UDim2.new(),
            Length = 0.25
        })
    end
end

--[
--Darken
--]

function library:Darken(color, f)
    local H, S, V = Color3.toHSV(color)

    f = 1 - ((f or 15) / 80)

    return Color3.fromHSV(H, math.clamp(S / f, 0, 1), math.clamp(V * f, 0, 1))
end

--[
--Lighten
--]

function library:Lighten(color, f)
    local H, S, V = Color3.toHSV(color)

    f = 1 - ((f or 15) / 80)

    return Color3.fromHSV(H, math.clamp(S * f, 0, 1), math.clamp(V / f, 0, 1))
end

--[
--SetStatus
--]

function library:SetStatus(options)
    local Name = (options.Name or options.Title or options.Text) or "Status | Idle"

    self.StatusText.Text = Name
end

--[
--CreateWindow
--]

function library:CreateWindow(options)
    local Name = (options.Name or options.Title or options.Text) or "New Window"

    local Settings = {
        Theme = "BreakSkill"
    }

    if readfile and writefile and isfile and isfolder and makefolder then
        if not isfolder("./Break-Skill Hub - V1") then
            makefolder("./Break-Skill Hub - V1")
        end

        if not isfolder("./Break-Skill Hub - V1/UI") then
            makefolder("./Break-Skill Hub - V1/UI")
        end

        if not isfile("./Break-Skill Hub - V1/UI/Settings.json") then
            writefile("Settings.json", HttpService:JSONEncode(Settings))
        end

        Settings = HttpService:JSONDecode(readfile("Settings.json"))

        library.CurrentTheme = library.Themes[Settings.Theme]

        UpdateSettings = function(property, value)
            Settings[property] = value

            writefile("Settings.json", HttpService:JSONEncode(Settings))
        end
    end

    options = self:SetDefaults({
        Name = "Break-Skill Hub - V1",
        Size = UDim2.fromOffset(600, 500),
        Theme = self.Themes[Settings.Theme],
        Link = "https://github.com/Sklllus/B-S-Hub-V1"
    }, options)

    if getgenv and getgenv()["BreakSkillUI"] then
        getgenv():BreakSkillUI()

        getgenv()["BreakSkillUI"] = nil
    end

    if options.Link:sub(-1, -1) == "/" then
        options.Link = options.Link:sub(1, -2)
    end

    if options.Theme.Light then
        self.Darken, self.Lighten = self.Lighten, self.Darken
    end

    self.CurrentTheme = options.Theme

    local Window = self:Object("ScreenGui", {
        Parent = (RunService:IsStudio() and Client.PlayerGui) or CoreGui,
        ZIndexBehavior = Enum.ZIndexBehavior.Global
    })

    local NotificationHolder = Window:Object("Frame", {
        AnchorPoint = Vector2.new(1, 1),
        BackgroundTransparency = 1,
        Position = UDim2.new(1, -30, 1, -30),
        Size = UDim2.new(0, 300, 1, -60)
    })

    local _NotificationHolderList = NotificationHolder:Object("UIListLayout", {
        Padding = UDim.new(0, 20),
        VerticalAlignment = Enum.VerticalAlignment.Bottom
    })

    local Core = Window:Object("Frame", {
        Size = UDim2.new(),
        Theme = {
            BackgroundColor3 = "Main"
        },
        Centered = true,
        ClipsDescendants = true
    }):Round(10)

    Core:Fade(false, nil, 0.4)

    Core:Tween({
        Size = options.Size, Length = 0.3
    }, function()
        Core.ClipsDescendants = false
    end)

    do
        local S, Event = pcall(function()
            return Core.MouseEnter
        end)

        if S then
            Core.Active = true

            Event:Connect(function()
                local Input = Core.InputBegan:Connect(function(key)
                    if key.UserInputType == Enum.UserInputType.MouseButton1 then
                        local ObjectPosition = Vector2.new(Mouse.X - Core.AbsolutePosition.X, Mouse.Y - Core.AbsolutePosition.Y)

                        while RunService.RenderStepped:Wait() and UserInputService:IsMouseButtonPressed(Enum.UserInputType.MouseButton1) do
                            if library.LockDragging then
                                local FrameX, FrameY = math.clamp(Mouse.X - ObjectPosition.X, 0, Window.AbsoluteSize.X - Core.AbsoluteSize.X), math.clamp(Mouse.Y - ObjectPosition.Y, 0, Window.AbsoluteSize.Y - Core.AbsoluteSize.Y)

                                Core:Tween({
                                    Position = UDim2.fromOffset(FrameX + (Core.Size.X.Offset * Core.AnchorPoint.X), FrameY + (Core.Size.Y.Offset * Core.AnchorPoint.Y)),
                                    Length = library.DragSpeed
                                })
                            else
                                Core:Tween({
                                    Position = UDim2.fromOffset(Mouse.X - ObjectPosition.X + (Core.Size.X.Offset * Core.AnchorPoint.X), Mouse.Y - ObjectPosition.Y + (Core.Size.Y.Offset * Core.AnchorPoint.Y)),
                                    Length = library.DragSpeed
                                })
                            end
                        end
                    end
                end)

                local Leave

                Leave = Core.MouseLeave:Connect(function()
                    Input:Disconnect()
                    Leave:Disconnect()
                end)
            end)
        end
    end

    rawset(Core, "OldSize", options.Size)

    self.MainFrame = Core

    local TabButtons = Core:Object("ScrollingFrame", {
        Size = UDim2.new(1, -40, 0, 25),
        Position = UDim2.fromOffset(5, 5),
        BackgroundTransparency = 1,
        ClipsDescendants = true,
        ScrollBarThickness = 0,
        ScrollingDirection = Enum.ScrollingDirection.X,
        AutomaticCanvasSize = Enum.AutomaticSize.X
    })

    TabButtons:Object("UIListLayout", {
        FillDirection = Enum.FillDirection.Horizontal,
        HorizontalAlignment = Enum.HorizontalAlignment.Left,
        SortOrder = Enum.SortOrder.LayoutOrder,
        Padding = UDim.new(0, 4)
    })

    local CloseButton = Core:Object("ImageButton", {
        BackgroundTransparency = 1,
        Size = UDim2.fromOffset(14, 14),
        Position = UDim2.new(1, -11, 0, 11),
        Theme = {
            ImageColor3 = "StrongText"
        },
        Image = "http://www.roblox.com/asset/?id=8497487650",
        AnchorPoint = Vector2.new(1)
    })

    CloseButton.MouseEnter:Connect(function()
        CloseButton:Tween({
            ImageColor3 = Color3.fromRGB(255, 125, 145)
        })
    end)

    CloseButton.MouseLeave:Connect(function()
        CloseButton:Tween({
            ImageColor3 = library.CurrentTheme.StrongText
        })
    end)

    local function CloseUI()
        Core.ClipsDescendants = true

        Core:Fade(true)

        task.wait(0.1)

        Core:Tween({
            Size = UDim2.new()
        }, function()
            Window.AbsoluteObject:Destroy()
        end)
    end

    if getgenv then
        getgenv()["BreakSkillUI"] = CloseUI
    end

    CloseButton.MouseButton1Click:Connect(function()
        CloseUI()
    end)

    local URLBar = Core:Object("Frame", {
        Size = UDim2.new(1, -10, 0, 25),
        Position = UDim2.new(0, 5, 0, 35),
        Theme = {
            BackgroundColor3 = "Secondary"
        }
    }):Round(5)

    local SearchIcon = URLBar:Object("ImageLabel", {
        AnchorPoint = Vector2.new(0, .5),
        Position = UDim2.new(0, 5, 0.5, 0),
        Theme = {
            ImageColor3 = "Tertiary"
        },
        Size = UDim2.fromOffset(16, 16),
        Image = "http://www.roblox.com/asset/?id=8497489946",
        BackgroundTransparency = 1
    })

    local Link = URLBar:Object("TextLabel", {
        AnchorPoint = Vector2.new(0, 0.5),
        Position = UDim2.new(0, 26, 0.5, 0),
        BackgroundTransparency = 1,
        Size = UDim2.new(1, -30, .6, 0),
        Text = options.Link .. "/home",
        Theme = {
            TextColor3 = "WeakText"
        },
        TextSize = 14,
        TextScaled = false,
        TextXAlignment = Enum.TextXAlignment.Left
    })

    library.URLLabel = Link
    library.URL = options.Link

    local ShadowHolder = Core:Object("Frame", {
        BackgroundTransparency = 1,
        Size = UDim2.fromScale(1, 1),
        ZIndex = 0
    })

    local Shadow = ShadowHolder:Object("ImageLabel", {
        Centered = true,
        BackgroundTransparency = 1,
        Size = UDim2.new(1, 47, 1, 47),
        ZIndex = 0,
        Image = "rbxassetid://6015897843",
        ImageColor3 = Color3.fromRGB(0, 0, 0),
        ImageTransparency = .6,
        SliceCenter = Rect.new(47, 47, 450, 450),
        SliceType = Enum.ScaleType.Slice,
        SliceScale = 1
    })

    local Content = Core:Object("Frame", {
        Theme = {
            BackgroundColor3 = {
                "Secondary",
                -10
            }
        },
        AnchorPoint = Vector2.new(0.5, 1),
        Position = UDim2.new(0.5, 0, 1, -20),
        Size = UDim2.new(1, -10, 1, -86)
    }):Round(7)

    local Status = Core:Object("TextLabel", {
        AnchorPoint = Vector2.new(0, 1),
        BackgroundTransparency = 1,
        Position = UDim2.new(0, 5, 1, -6),
        Size = UDim2.new(0.2, 0, 0, 10),
        Font = Enum.Font.Code,
        Text = "Status | Idle",
        Theme = {
            TextColor3 = "Tertiary"
        },
        TextSize = 14,
        TextXAlignment = Enum.TextXAlignment.Left
    })

    local HomeButton = TabButtons:Object("TextButton", {
        Name = "Home",
        BackgroundTransparency = 0,
        Theme = {
            BackgroundColor3 = "Secondary"
        },
        Size = UDim2.new(0, 125, 0, 25)
    }):Round(5)

    local HomeButtonText = HomeButton:Object("TextLabel", {
        Theme = {
            TextColor3 = "StrongText"
        },
        AnchorPoint = Vector2.new(0, .5),
        BackgroundTransparency = 1,
        TextSize = 14,
        Text = Name,
        Position = UDim2.new(0, 25, 0.5, 0),
        TextXAlignment = Enum.TextXAlignment.Left,
        Size = UDim2.new(1, -45, 0.5, 0),
        Font = Enum.Font.Code,
        TextTruncate = Enum.TextTruncate.AtEnd
    })

    local HomeButtonIcon = HomeButton:Object("ImageLabel", {
        AnchorPoint = Vector2.new(0, 0.5),
        BackgroundTransparency = 1,
        Position = UDim2.new(0, 5, 0.5, 0),
        Size = UDim2.new(0, 15, 0, 15),
        Image = "http://www.roblox.com/asset/?id=8569322835",
        Theme = {
            ImageColor3 = "StrongText"
        }
    })

    local HomePage = Content:Object("Frame", {
        Size = UDim2.fromScale(1, 1),
        Centered = true,
        BackgroundTransparency = 1
    })

    local Tabs = {}

    SelectedTab = HomeButton

    Tabs[#Tabs + 1] = {
        HomePage,
        HomeButton
    }

    do
        local Down = false
        local Hovered = false

        HomeButton.MouseEnter:Connect(function()
            Hovered = true

            HomeButton:Tween({
                BackgroundTransparency = ((SelectedTab == HomeButton) and 0.15) or 0.3
            })
        end)

        HomeButton.MouseLeave:Connect(function()
            Hovered = false

            HomeButton:Tween({
                BackgroundTransparency = ((SelectedTab == HomeButton) and 0.15) or 1
            })
        end)

        HomeButton.MouseButton1Down:Connect(function()
            Down = true

            HomeButton:Tween({
                BackgroundTransparency = 0
            })
        end)

        UserInputService.InputEnded:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 then
                Down = false

                HomeButton:Tween({
                    BackgroundTransparency = ((SelectedTab == HomeButton) and 0.15) or (Hovered and 0.3) or 1
                })
            end
        end)

        HomeButton.MouseButton1Click:Connect(function()
            for _, ti in next, Tabs do
                local Page = ti[1]
                local Button = ti[2]

                Page.Visible = false
            end

            SelectedTab:Tween({
                BackgroundTransparency = ((SelectedTab == HomeButton) and 0.15) or 1
            })

            SelectedTab = HomeButton

            HomePage.Visible = true

            HomeButton.BackgroundTransparency = 0

            library.URLLabel.Text = library.URL .. "/home"
        end)
    end

    self.SelectedTabButton = HomeButton

    local HomePageLayout = HomePage:Object("UIListLayout", {
        Padding = UDim.new(0, 10),
        FillDirection = Enum.FillDirection.Vertical,
        HorizontalAlignment = Enum.HorizontalAlignment.Center
    })

    local HomePagePadding = HomePage:Object("UIPadding", {
        PaddingTop = UDim.new(0, 10)
    })

    local Profile = HomePage:Object("Frame", {
        AnchorPoint = Vector2.new(0, .5),
        Theme = {
            BackgroundColor3 = "Secondary"
        },
        Size = UDim2.new(1, -20, 0, 100)
    }):Round(7)

    local ProfilePictureContainer = Profile:Object("ImageLabel", {
        Image = Players:GetUserThumbnailAsync(Client.UserId, Enum.ThumbnailType.HeadShot, Enum.ThumbnailSize.Size100x100),
        Theme = {
            BackgroundColor3 = {
                "Secondary",
                10
            }
        },
        AnchorPoint = Vector2.new(0, 0.5),
        Position = UDim2.new(0, 10, 0.5),
        Size = UDim2.fromOffset(80, 80)
    }):Round(100)

    local DisplayName

    do
        local H, S, V = Color3.toHSV(options.Theme.Tertiary)

        local Lighten = self:Lighten(options.Theme.Tertiary, 20)

        DisplayName = Profile:Object("TextLabel", {
            RichText = true,
            Text = "Welcome, <font color='rgb(" .. math.floor(Lighten.R * 255) .. "," .. math.floor(Lighten.G * 255) .. "," .. math.floor(Lighten.B * 255) .. ")'><b>" .. Client.DisplayName .. "</></font>",
            TextScaled = true,
            Position = UDim2.new(0, 105, 0, 10),
            Theme = {
                TextColor3 = {
                    "Tertiary",
                    10
                }
            },
            Size = UDim2.new(0, 400, 0, 40),
            BackgroundTransparency = 1,
            TextXAlignment = Enum.TextXAlignment.Left
        })

        library.DisplayName = DisplayName
    end

    local ProfileName = Profile:Object("TextLabel", {
        Text = "@" .. Client.Name,
        TextScaled = true,
        Position = UDim2.new(0, 105, 0, 47),
        Theme = {
            TextColor3 = "Tertiary"
        },
        Size = UDim2.new(0, 400, 0, 20),
        BackgroundTransparency = 1,
        TextXAlignment = Enum.TextXAlignment.Left
    })

    local TimeDisplay = Profile:Object("TextLabel", {
        BackgroundTransparency = 1,
        Position = UDim2.new(0, 105, 1, -10),
        Size = UDim2.new(0, 400, 0, 20),
        AnchorPoint = Vector2.new(0, 1),
        Theme = {
            TextColor3 = {
                "WeakText",
                -20
            }
        },
        TextScaled = true,
        TextXAlignment = Enum.TextXAlignment.Left,
        Text = tostring(os.date("%X")):sub(1, os.date("%X"):len() - 3)
    })

    do
        local DesiredInterval = 1
        local Counter = 0

        RunService.RenderStepped:Connect(function(deltaTime)
            Counter += deltaTime

            if Counter >= DesiredInterval then
                Counter -= DesiredInterval

                local Date = tostring(os.date("%X"))

                TimeDisplay.Text = Date:sub(1, Date:len() - 3)
            end
        end)
    end

    local SettingsTabIcon = Profile:Object("ImageButton", {
        BackgroundTransparency = 1,
        Theme = {
            ImageColor3 = "WeakText"
        },
        Size = UDim2.fromOffset(24, 24),
        Position = UDim2.new(1, -10, 1, -10),
        AnchorPoint = Vector2.new(1, 1),
        Image = "http://www.roblox.com/asset/?id=8559790237"
    }):ToolTip("Settings")

    local CreditsTabIcon = Profile:Object("ImageButton", {
        BackgroundTransparency = 1,
        Theme = {
            ImageColor3 = "WeakText"
        },
        Size = UDim2.fromOffset(24, 24),
        Position = UDim2.new(1, -44, 1, -10),
        AnchorPoint = Vector2.new(1, 1),
        Image = "http://www.roblox.com/asset/?id=8577523456"
    }):ToolTip("Credits")

    local QuickAccess = HomePage:Object("Frame", {
        BackgroundTransparency = 1,
        Size = UDim2.new(1, -20, 0, 180)
    })

    QuickAccess:Object("UIGridLayout", {
        CellPadding = UDim2.fromOffset(10, 10),
        CellSize = UDim2.fromOffset(55, 55),
        HorizontalAlignment = Enum.HorizontalAlignment.Center,
        VerticalAlignment = Enum.VerticalAlignment.Center
    })

    QuickAccess:Object("UIPadding", {
        PaddingBottom = UDim.new(0, 10),
        PaddingLeft = UDim.new(0, 70),
        PaddingRight = UDim.new(0, 70),
        PaddingTop = UDim.new(0, 5)
    })

    local mt = setmetatable({
        Core = Core,
        Notifs = NotificationHolder,
        StatusText = Status,
        Container = Content,
        Navigation = TabButtons,
        Theme = options.Theme,
        Tabs = Tabs,
        QuickAccess = QuickAccess,
        HomeButton = HomeButton,
        HomePage = HomePage,
        NilFolder = Core:Object("Folder")
    }, library)

    local SettingsTab = library:CreateTab(mt, {
        Name = "Settings",
        Internal = SettingsTabIcon,
        Icon = "rbxassetid://8559790237"
    })

    SettingsTab:_ThemeSelector()

    SettingsTab:AddKeybind({
        Name = "Toggle Key",
        Description = "Key to show/hide UI.",
        Keybind = Enum.KeyCode.RightShift,
        Callback = function()
            self.Toggled = not self.Toggled

            library:Show(self.Toggled)
        end
    })

    SettingsTab:AddToggle({
        Name = "Lock Dragging",
        Description = "Makes sure you can't drag UI outside of window.",
        StartingState = true,
        Callback = function(val)
            library.LockDragging = val
        end
    })

    SettingsTab:AddSlider({
        Name = "UI Drag speed",
        Description = "How smooth dragging looks.",
        Default = 14,
        Max = 20,
        Callback = function(val)
            library.DragSpeed = (20 - val) / 100
        end
    })

    local CreditsTab = library:CreateTab(mt, {
        Name = "Credits",
        Internal = CreditsTabIcon,
        Icon = "http://www.roblox.com/asset/?id=8577523456"
    })

    rawset(mt, "CreditsContainer", CreditsTab.Container)

    CreditsTab:AddCredit({
        Name = "Abstract",
        Description = "UI Library Developer",
        Discord = "Abstract#8007",
        V3rmillion = "AbstractPoo"
    })

    CreditsTab:AddCredit({
        Name = "Deity",
        Description = "UI Library Developer",
        Discord = "Deity#0228",
        V3rmillion = "0xDEITY"
    })

    CreditsTab:AddCredit({
        Name = "Skillus (xX_XSI)",
        Description = "UI Library (Rework) and Script Developer"
    })

    return mt
end

--[
--CreateNotification
--]

function library:CreateNotification(options)
    options = self:SetDefaults({
        Title = "Notification",
        Text = "Test Notification",
        Duration = 5,
        Callback = function() end
    }, options)

    local FadeOut

    local Noti = self.Notifs:Object("Frame", {
        BackgroundTransparency = 1,
        Theme = {
            BackgroundColor3 = "Main"
        },
        Size = UDim2.new(0, 300, 0, 0)
    }):Round(10)

    local _NotiPadding = Noti:Object("UIPadding", {
        PaddingBottom = UDim.new(0, 11),
        PaddingTop = UDim.new(0, 11),
        PaddingLeft = UDim.new(0, 11),
        PaddingRight = UDim.new(0, 11)
    })

    local DropShadow = Noti:Object("Frame", {
        ZIndex = 0,
        BackgroundTransparency = 1,
        Size = UDim2.fromScale(1, 1)
    })

    local _Shadow = DropShadow:Object("ImageLabel", {
        Centered = true,
        Position = UDim2.fromScale(.5, .5),
        BackgroundTransparency = 1,
        Size = UDim2.new(1, 70, 1, 70),
        ZIndex = 0,
        Image = "rbxassetid://6014261993",
        ImageColor3 = Color3.fromRGB(0, 0, 0),
        ImageTransparency = 1,
        ScaleType = Enum.ScaleType.Slice,
        SliceCenter = Rect.new(49, 49, 450, 450)
    })

    local DurationHolder = Noti:Object("Frame", {
        BackgroundTransparency = 1,
        Theme = {
            BackgroundColor3 = "Secondary"
        },
        AnchorPoint = Vector2.new(0, 1),
        Position = UDim2.fromScale(0, 1),
        Size = UDim2.new(1, 0, 0, 4)
    }):Round(100)

    local Length = DurationHolder:Object("Frame", {
        BackgroundTransparency = 1,
        Theme = {
            BackgroundColor3 = "Tertiary"
        },
        Size = UDim2.fromScale(1, 1)
    }):Round(100)

    local Icon = Noti:Object("ImageLabel", {
        BackgroundTransparency = 1,
        ImageTransparency = 1,
        Position = UDim2.fromOffset(1, 1),
        Size = UDim2.fromOffset(18, 18),
        Image = "rbxassetid://8628681683",
        Theme = {
            ImageColor3 = "Tertiary"
        }
    })

    local Exit = Noti:Object("ImageButton", {
        Image = "http://www.roblox.com/asset/?id=8497487650",
        AnchorPoint = Vector2.new(1, 0),
        ImageColor3 = Color3.fromRGB(255, 255, 255),
        Position = UDim2.new(1, -3, 0, 3),
        Size = UDim2.fromOffset(14, 14),
        BackgroundTransparency = 1,
        ImageTransparency = 1
    })

    Exit.MouseButton1Click:Connect(function()
        FadeOut()
    end)

    local Text = Noti:Object("TextLabel", {
        BackgroundTransparency = 1,
        Text = options.Text,
        Position = UDim2.new(0, 0, 0, 23),
        Size = UDim2.new(1, 0, 100, 0),
        TextSize = 16,
        TextTransparency = 1,
        TextWrapped = true,
        TextColor3 = Color3.fromRGB(255, 255, 255),
        TextXAlignment = Enum.TextXAlignment.Left,
        TextYAlignment = Enum.TextYAlignment.Top
    })

    Text:Tween({
        Size = UDim2.new(1, 0, 0, Text.TextBounds.Y)
    })

    local Title = Noti:Object("TextLabel", {
        BackgroundTransparency = 1,
        Position = UDim2.fromOffset(23, 0),
        Size = UDim2.new(1, -60, 0, 20),
        Font = Enum.Font.Code,
        Text = options.Title,
        Theme = {
            TextColor3 = "Tertiary"
        },
        TextSize = 17,
        TextXAlignment = Enum.TextXAlignment.Left,
        TextWrapped = true,
        TextTruncate = Enum.TextTruncate.AtEnd,
        TextTransparency = 1
    })

    FadeOut = function()
        task.delay(0.3, function()
            Noti.AbsoluteObject:Destroy()

            options.Callback()
        end)

        Icon:Tween({
            ImageTransparency = 1,
            Length = 0.2
        })

        Exit:Tween({
            ImageTransparency = 1,
            Length = 0.2
        })

        DurationHolder:Tween({
            BackgroundTransparency = 1,
            Length = 0.2
        })

        Length:Tween({
            BackgroundTransparency = 1,
            Length = 0.2
        })

        Text:Tween({
            TextTransparency = 1,
            Length = 0.2
        })

        Title:Tween({
            TextTransparency = 1,
            Length = 0.2
        }, function()
            _Shadow:Tween({
                ImageTransparency = 1,
                Length = 0.2
            })

            Noti:Tween({
                BackgroundTransparency = 1,
                Length = 0.2,
                Size = UDim2.fromOffset(300, 0)
            })
        end)
    end

    _Shadow:Tween({
        ImageTransparency = .6,
        Length = 0.2
    })

    Noti:Tween({
        BackgroundTransparency = 0,
        Length = 0.2,
        Size = UDim2.fromOffset(300, Text.TextBounds.Y + 63)
    }, function()
        Icon:Tween({
            ImageTransparency = 0,
            Length = 0.2
        })

        Exit:Tween({
            ImageTransparency = 0,
            Length = 0.2
        })

        DurationHolder:Tween({
            BackgroundTransparency = 0,
            Length = 0.2
        })

        Length:Tween({
            BackgroundTransparency = 0,
            Length = 0.2
        })

        Text:Tween({
            TextTransparency = 0,
            Length = 0.2
        })

        Title:Tween({
            TextTransparency = 0,
            Length = 0.2
        })
    end)

    Length:Tween({
        Size = UDim2.fromScale(0, 1),
        Length = options.Duration
    }, function()
        FadeOut()
    end)
end

--[
--CreateTab
--]

function library:CreateTab(options)
    options = self:SetDefaults({
        Name = "New Tab",
        Icon = "rbxassetid://8569322835"
    }, options)

    local Tab = self.Container:Object("ScrollingFrame", {
        AnchorPoint = Vector2.new(0, 1),
        Visible = false,
        BackgroundTransparency = 1,
        Position = UDim2.fromScale(0, 1),
        Size = UDim2.fromScale(1, 1),
        ScrollBarThickness = 0,
        ScrollingDirection = Enum.ScrollingDirection.Y
    })

    local QuickAccessButton
    local QuickAccessIcon

    if not options.Internal then
        QuickAccessButton = self.QuickAccess:Object("TextButton", {
            Theme = {
                BackgroundColor3 = "Secondary"
            }
        }):Round(5):ToolTip(options.Name)

        QuickAccessIcon = QuickAccessButton:Object("ImageLabel", {
            BackgroundTransparency = 1,
            Theme = {
                ImageColor3 = "StrongText"
            },
            Image = options.Icon,
            Size = UDim2.fromScale(0.5, 0.5),
            Centered = true
        })
    else
        QuickAccessButton = options.Internal
    end

    local Layout = Tab:Object("UIListLayout", {
        Padding = UDim.new(0, 10),
        HorizontalAlignment = Enum.HorizontalAlignment.Center
    })

    Tab:Object("UIPadding", {
        PaddingTop = UDim.new(0, 10)
    })

    local TabButton = library:Object("TextButton", {
        BackgroundTransparency = 1,
        Parent = self.NilFolder.AbsoluteObject,
        Theme = {
            BackgroundColor3 = "Secondary"
        },
        Size = UDim2.new(0, 125, 0, 25),
        Visible = false
    }):Round(5)

    self.Tabs[#self.Tabs + 1] = {
        Tab,
        TabButton,
        options.Name
    }

    do
        local Down = false
        local Hovered = false

        TabButton.MouseEnter:Connect(function()
            Hovered = true

            TabButton:Tween({
                BackgroundTransparency = ((SelectedTab == TabButton) and 0.15) or 0.3
            })
        end)

        TabButton.MouseLeave:Connect(function()
            Hovered = true

            TabButton:Tween({
                BackgroundTransparency = ((SelectedTab == TabButton) and 0.15) or 1
            })
        end)

        TabButton.MouseButton1Down:Connect(function()
            Hovered = false

            TabButton:Tween({
                BackgroundTransparency = ((SelectedTab == TabButton) and 0.15) or 1
            })
        end)

        UserInputService.InputEnded:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 then
                Down = false

                TabButton:Tween({
                    BackgroundTransparency = ((SelectedTab == TabButton) and 0.15) or (Hovered and 0.3) or 1
                })
            end
        end)

        TabButton.MouseButton1Click:Connect(function()
            for _, ti in next, self.Tabs do
                local Page = ti[1]
                local Button = ti[2]

                Page.Visible = false
            end

            SelectedTab:Tween({
                BackgroundTransparency = ((SelectedTab == TabButton) and 0.15) or 1
            })

            SelectedTab = TabButton

            Tab.Visible = true

            TabButton.BackgroundTransparency = 0

            library.URLLabel.Text = library.URL .. "/" .. options.Name:lower()
        end)

        QuickAccessButton.MouseEnter:Connect(function()
            QuickAccessButton:Tween({
                BackgroundColor3 = library.CurrentTheme.Tertiary
            })
        end)

        QuickAccessButton.MouseLeave:Connect(function()
            QuickAccessButton:Tween({
                BackgroundColor3 = library.CurrentTheme.Secondary
            })
        end)

        QuickAccessButton.MouseButton1Click:Connect(function()
            if not TabButton.Visible then
                TabButton.Parent = self.Navigation.AbsoluteObject
                TabButton.Size = UDim2.new(0, 50, TabButton.Size.Y.Scale, TabButton.Size.Y.Offset)
                TabButton.Visible = true

                TabButton:Fade(false, library.CurrentTheme.Main, 0.1)

                TabButton:Tween({
                    Size = UDim2.new(0, 125, TabButton.Size.Y.Scale, TabButton.Size.Y.Offset),
                    Length = 0.1
                })

                for _, ti in next, self.Tabs do
                    local Page = ti[1]
                    local Button = ti[2]

                    Page.Visible = false
                end

                SelectedTab:Tween({
                    BackgroundTransparency = ((SelectedTab == TabButton) and 0.15) or 1
                })

                SelectedTab = TabButton

                Tab.Visible = true

                TabButton.BackgroundTransparency = 0

                library.URLLabel.Text = library.URL .. "/" .. options.Name:lower()
            end
        end)
    end

    local TabButtonText = TabButton:Object("TextLabel", {
        Theme = {
            TextColor3 = "StrongText"
        },
        AnchorPoint = Vector2.new(0, .5),
        BackgroundTransparency = 1,
        TextSize = 14,
        Text = options.Name,
        Position = UDim2.new(0, 25, 0.5, 0),
        TextXAlignment = Enum.TextXAlignment.Left,
        Size = UDim2.new(1, -45, 0.5, 0),
        Font = Enum.Font.Code,
        TextTruncate = Enum.TextTruncate.AtEnd
    })

    local TabButtonIcon = TabButton:Object("ImageLabel", {
        AnchorPoint = Vector2.new(0, 0.5),
        BackgroundTransparency = 1,
        Position = UDim2.new(0, 5, 0.5, 0),
        Size = UDim2.new(0, 15, 0, 15),
        Image = options.Icon,
        Theme = {
            ImageColor3 = "StrongText"
        }
    })

    local TabButtonClose = TabButton:Object("ImageButton", {
        AnchorPoint = Vector2.new(1, 0.5),
        BackgroundTransparency = 1,
        Position = UDim2.new(1, -5, 0.5, 0),
        Size = UDim2.fromOffset(14, 14),
        Image = "rbxassetid://8497487650",
        Theme = {
            ImageColor3 = "StrongText"
        }
    })

    TabButtonClose.MouseButton1Click:Connect(function()
        TabButton:Fade(true, library.CurrentTheme.Main, 0.1)
        TabButton:Tween({
            Size = UDim2.new(0, 50, TabButton.Size.Y.Scale, TabButton.Size.Y.Offset),
            Length = 0.1
        }, function()
            TabButton.Visible = false

            Tab.Visible = false

            TabButton.Parent = self.NilFolder.AbsoluteObject

            task.wait()
        end)

        local Visible = {}

        for _, t in next, self.Tabs do
            if not t[2] == SelectedTab then
                t[1].Visible = false
            end

            if t[2].Visible then
                Visible[#Visible + 1] = t
            end
        end

        local LastTab = Visible[#Visible]

        if SelectedTab == self.HomeButton then
            Tab.Visible = false
        elseif #Visible == 2 then
            SelectedTab.Visible = false

            Tab.Visible = false

            self.HomePage.Visible = true

            self.HomeButton:Tween({
                BackgroundTransparency = 0.15
            })

            SelectedTab = self.HomeButton

            library.URLLabel.Text = library.URL .. "/home"
        elseif TabButton == LastTab[2] then
            LastTab = Visible[#Visible - 1]

            Tab.Visible = false

            LastTab[2]:Tween({
                BackgroundTransparency = 0.15
            })

            LastTab[1].Visible = true

            SelectedTab = LastTab[2]

            library.URLLabel.Text = library.URL .. "/" .. LastTab[3]:lower()
        else
            Tab.Visible = false

            LastTab[2]:Tween({
                BackgroundTransparency = 0.15
            })

            LastTab[1].Visible = true

            SelectedTab = LastTab[2]

            library.URLLabel.Text = library.URL .. "/" .. LastTab[3]:lower()
        end
    end)

    return setmetatable({
        StatusText = self.StatusText,
        Container = Tab,
        Theme = self.Theme,
        Core = self.Core,
        Layout = Layout
    }, library)
end

--[
--_ResizeTab
--]

function library:_ResizeTab()
    if self.Container.ClassName == "ScrollingFrame" then
        self.Container.CanvasSize = UDim2.fromOffset(0, self.Layout.AbsoluteContentSize.Y + 20)
    else
        self.SectionContainer.Size = UDim2.new(1, -24, 0, self.Layout.AbsoluteContentSize.Y + 20)
        self.ParentContainer.CanvasSize = UDim2.fromOffset(0, self.ParentLayout.AbsoluteContentSize.Y + 20)
    end
end

return library
