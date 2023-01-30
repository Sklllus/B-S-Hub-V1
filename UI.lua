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

local HttpService = game:GetService("HttpService")
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")

local Client = Players.LocalPlayer

local Mouse = Client:GetMouse()

local library = {
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
			Tertiary = Color3.fromRGB(220, 185, 20),
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
            Main = Color3.fromRGB(30, 30, 30),
            Secondary = Color3.fromRGB(65, 65, 65),
            Tertiary = Color3.fromRGB(235, 60, 60),
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
    WelcomeText = nil,
	DisplayName = nil,
    UrlLabel = nil,
	Url = nil,
    DragSpeed = 0.06,
    ToggleKey = Enum.KeyCode.Home,
}

library.__index = library

local selectedTab

library._promptExists = false
library._colorPickerExists = false

local GlobalTweenInfo = TweenInfo.new(0.2, Enum.EasingStyle.Linear, Enum.EasingDirection.InOut)

local updateSettings = function() end

--[
--UI Library Functions
--]

--[
--SetDefaults
--]

function library:SetDefaults(defaults, options)
	defaults = defaults or {}
	options = options or {}

	for option, value in next, options do
		defaults[option] = value
	end

	return defaults
end

--[
--ChangeTheme
--]

function library:ChangeTheme(toTheme)
	library.CurrentTheme = toTheme

	local c = self:Lighten(toTheme.Tertiary, 20)

	library.DisplayName.Text = "Welcome, <font color='rgb(" ..  math.floor(c.R * 255) .. "," .. math.floor(c.G * 255) .. "," .. math.floor(c.B * 255) .. ")'> <b>" .. Client.DisplayName .. "</b></font>"

	for color, objects in next, library.ThemeObjects do
		local themeColor = library.CurrentTheme[color]

		for _, obj in next, objects do
			local element, property, theme, colorAlter = obj[1], obj[2], obj[3], obj[4] or 0

			local themeColor = library.CurrentTheme[theme]

			local modifiedColor = themeColor

			if colorAlter < 0 then
				modifiedColor = library:Darken(themeColor, -1 * colorAlter)
			elseif colorAlter > 0 then
				modifiedColor = library:Lighten(themeColor, colorAlter)
			end

			element:Tween{[property] = modifiedColor}
		end
	end
end

--[
--Object
--]

function library:Object(class, properties)
	local localObject = Instance.new(class)

	local forcedProps = {
		BorderSizePixel = 0,
		AutoButtonColor = false,
		Font = Enum.Font.SourceSans,
		Text = ""
	}

	for property, value in next, forcedProps do
		pcall(function()
			localObject[property] = value
		end)
	end

	local methods = {}

	methods.AbsoluteObject = localObject

    --[
    --Tween
    --]

	function methods:Tween(options, callback)
		options = library:SetDefaults({
			Length = 0.2,
			Style = Enum.EasingStyle.Linear,
			Direction = Enum.EasingDirection.InOut
		}, options)

		callback = callback or function() return end


		local ti = TweenInfo.new(options.Length, options.Style, options.Direction)

		options.Length = nil
		options.Style = nil
		options.Direction = nil

		local tween = TweenService:Create(localObject, ti, options); tween:Play()

		tween.Completed:Connect(function()
			callback()
		end)

		return tween
	end

    --[
    --Round
    --]

	function methods:Round(radius)
		radius = radius or 6

		library:Object("UICorner", {
			Parent = localObject,
			CornerRadius = UDim.new(0, radius)
		})

		return methods
	end

    --[
    --Object
    --]

	function methods:Object(class, properties)
		properties = properties or {}

		properties.Parent = localObject

		return library:Object(class, properties)
	end

    --[
    --CrossFade
    --]

	function methods:CrossFade(p2, length)
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

	function methods:Fade(state, colorOverride, length, instant)
		length = length or 0.2

		if not rawget(self, "fadeFrame") then
			local frame = self:Object("Frame", {
				BackgroundColor3 = colorOverride or self.BackgroundColor3,
				BackgroundTransparency = (state and 1) or 0,
				Size = UDim2.fromScale(1, 1),
				Centered = true,
				ZIndex = 999
			}):Round(self.AbsoluteObject:FindFirstChildOfClass("UICorner") and self.AbsoluteObject:FindFirstChildOfClass("UICorner").CornerRadius.Offset or 0)

			rawset(self, "fadeFrame", frame)
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

				self.fadeFrame:tween({
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

	function methods:Stroke(color, thickness, strokeMode)
		thickness = thickness or 1
		strokeMode = strokeMode or Enum.ApplyStrokeMode.Border

		local stroke = self:Object("UIStroke", {
			ApplyStrokeMode = strokeMode,
			Thickness = thickness
		})

		if type(color) == "table" then
			local theme, colorAlter = color[1], color[2] or 0

			local themeColor = library.CurrentTheme[theme]

			local modifiedColor = themeColor

			if colorAlter < 0 then
				modifiedColor = library:Darken(themeColor, -1 * colorAlter)
			elseif colorAlter > 0 then
				modifiedColor = library:Lighten(themeColor, colorAlter)
			end

			stroke.Color = modifiedColor

			table.insert(library.ThemeObjects[theme], {
                stroke,
                "Color",
                theme,
                colorAlter
            })
		elseif type(color) == "string" then
			local themeColor = library.CurrentTheme[color]

			stroke.Color = themeColor

			table.insert(library.ThemeObjects[color], {
                stroke,
                "Color",
                color,
                0
            })
		else
			stroke.Color = color
		end

		return methods
	end

    --[
    --ToolTip
    --]

	function methods:ToolTip(text)
		local tooltipContainer = methods:Object("TextLabel", {
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
			Text = text,
			Position = UDim2.new(0.5, 0, 0, -8),
			TextXAlignment = Enum.TextXAlignment.Center,
			TextYAlignment = Enum.TextYAlignment.Center,
			AnchorPoint = Vector2.new(0.5, 1),
			BackgroundTransparency = 1,
			TextTransparency = 1
		}):Round(5)

		tooltipContainer.Size = UDim2.fromOffset(tooltipContainer.TextBounds.X + 16, tooltipContainer.TextBounds.Y + 8)

		local tooltipArrow = tooltipContainer:Object("ImageLabel", {
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

		local hovered = false

		methods.MouseEnter:Connect(function()
			hovered = true

			task.wait(0.2)

			if hovered then
				tooltipContainer:Tween({
                    BackgroundTransparency = 0.2,
                    TextTransparency = 0.2
                })

				tooltipArrow:Tween({
                    ImageTransparency = 0.2
                })
			end
		end)

		methods.MouseLeave:Connect(function()
			hovered = false

			tooltipContainer:Tween({
                BackgroundTransparency = 1,
                TextTransparency = 1
            })

			tooltipArrow:Tween({
                ImageTransparency = 1
            })
		end)

		return methods
	end

	local customHandlers = {
		Centered = function(value)
			if value then
				localObject.AnchorPoint = Vector2.new(0.5, 0.5)
				localObject.Position = UDim2.fromScale(0.5, 0.5)
			end
		end,
		Theme = function(value)
			for property, obj in next, value do
				if type(obj) == "table" then
					local theme, colorAlter = obj[1], obj[2] or 0

					local themeColor = library.CurrentTheme[theme]

					local modifiedColor = themeColor

					if colorAlter < 0 then
						modifiedColor = library:Darken(themeColor, -1 * colorAlter)
					elseif colorAlter > 0 then
						modifiedColor = library:Lighten(themeColor, colorAlter)
					end

					localObject[property] = modifiedColor

					table.insert(self.ThemeObjects[theme], {methods, property, theme, colorAlter})
				else
					local themeColor = library.CurrentTheme[obj]

					localObject[property] = themeColor

					table.insert(self.ThemeObjects[obj], {methods, property, obj, 0})
				end
			end
		end,
	}

	for property, value in next, properties do
		if customHandlers[property] then
			customHandlers[property](value)
		else
			localObject[property] = value
		end
	end

	return setmetatable(methods, {
		__index = function(_, property)
			return localObject[property]
		end,
		__newindex = function(_, property, value)
			localObject[property] = value
		end
	})
end

--[
--Show
--]

function library:Show(state)
	self.Toggled = state

	self.mainFrame.ClipsDescendants = true

	if state then
		self.mainFrame:Tween({
            Size = self.mainFrame.oldSize,
            Length = 0.25
        }, function()
			rawset(self.mainFrame, "oldSize", (state and self.mainFrame.oldSize) or self.mainFrame.Size)

			self.mainFrame.ClipsDescendants = false
		end)

		task.wait(0.15)

		self.mainFrame:Fade(not state, self.mainFrame.BackgroundColor3, 0.15)
	else
		self.mainFrame:Fade(not state, self.mainFrame.BackgroundColor3, 0.15)

		task.wait(0.1)

		self.mainFrame:Tween({
            Size = UDim2.new(),
            Length = 0.25
        })
	end
end

--[
--Darken
--]

function library:Darken(color, f)
	local h, s, v = Color3.toHSV(color)

	f = 1 - ((f or 15) / 80)

	return Color3.fromHSV(h, math.clamp(s / f, 0, 1), math.clamp(v * f, 0, 1))
end

--[
--Lighten
--]

function library:Lighten(color, f)
	local h, s, v = Color3.toHSV(color)

	f = 1 - ((f or 15) / 80)

	return Color3.fromHSV(h, math.clamp(s * f, 0, 1), math.clamp(v / f, 0, 1))
end

--[
--SetStatus
--]

function library:SetStatus(txt)
	self.statusText.Text = txt
end

--[
--CreateWindow
--]

function library:CreateWindow(options)
	local settings = {
		Theme = "BreakSkill"
	}

	if readfile and writefile and isfile and makefolder and isfolder then
        if not isfolder("./Break-Skill Hub - V1") then
            makefolder("./Break-Skill Hub - V1")
        end

        if not isfolder("./Break-Skill Hub - V1/UI") then
            makefolder("./Break-Skill Hub - V1/UI")
        end

		if not isfile("./Break-Skill Hub - V1/UI/Settings.json") then
			writefile("./Break-Skill Hub - V1/UI/Settings.json", HttpService:JSONEncode(settings))
		end

		settings = HttpService:JSONDecode(readfile("./Break-Skill Hub - V1/UI/Settings.json"))

		library.CurrentTheme = library.Themes[settings.Theme]

		updateSettings = function(property, value)
			settings[property] = value

			writefile("./Break-Skill Hub - V1/UI/Settings.json", HttpService:JSONEncode(settings))
		end
	end

	options = self:SetDefaults({
		Name = "Break-Skill Hub - V1",
		Size = UDim2.fromOffset(600, 500),
		Theme = self.Themes[settings.Theme],
		Link = "https://github.com/Sklllus/Break-Skill-Hub-V1/"
	}, options)

	if getgenv and getgenv().BreakSkillUI then
		getgenv():BreakSkillUI()
		getgenv().BreakSkillUI = nil
	end

	if options.Link:sub(-1, -1) == "/" then
		options.Link = options.Link:sub(1, -2)
	end

	if options.Theme.Light then
		self.Darken, self.Lighten = self.Lighten, self.Darken
	end

	self.CurrentTheme = options.Theme

	local gui = self:Object("ScreenGui", {
		Parent = (RunService:IsStudio() and Client.PlayerGui) or game:GetService("CoreGui"),
		ZIndexBehavior = Enum.ZIndexBehavior.Global
	})

	local notificationHolder = gui:Object("Frame", {
		AnchorPoint = Vector2.new(1, 1),
		BackgroundTransparency = 1,
		Position = UDim2.new(1, -30,1, -30),
		Size = UDim2.new(0, 300, 1, -60)
	})

	local _notiHolderList = notificationHolder:Object("UIListLayout", {
		Padding = UDim.new(0, 20),
		VerticalAlignment = Enum.VerticalAlignment.Bottom
	})

	local core = gui:Object("Frame", {
		Size = UDim2.new(),
		Theme = {
            BackgroundColor3 = "Main"
        },
		Centered = true,
		ClipsDescendants = true
	}):Round(10)

	core:Fade(true, nil, 0.2, true)
	core:Fade(false, nil, 0.4)

	core:Tween({
        Size = options.Size,
        Length = 0.3
    }, function()
		core.ClipsDescendants = false
	end)

	do
		local S, Event = pcall(function()
			return core.MouseEnter
		end)

		if S then
			core.Active = true

			Event:Connect(function()
				local Input = core.InputBegan:Connect(function(Key)
					if Key.UserInputType == Enum.UserInputType.MouseButton1 then
						local ObjectPosition = Vector2.new(Mouse.X - core.AbsolutePosition.X, Mouse.Y - core.AbsolutePosition.Y)

						while RunService.RenderStepped:Wait() and UserInputService:IsMouseButtonPressed(Enum.UserInputType.MouseButton1) do
							if library.LockDragging then
								local FrameX, FrameY = math.clamp(Mouse.X - ObjectPosition.X, 0, gui.AbsoluteSize.X - core.AbsoluteSize.X), math.clamp(Mouse.Y - ObjectPosition.Y, 0, gui.AbsoluteSize.Y - core.AbsoluteSize.Y)

								core:tween{
									Position = UDim2.fromOffset(FrameX + (core.Size.X.Offset * core.AnchorPoint.X), FrameY + (core.Size.Y.Offset * core.AnchorPoint.Y)),
									Length = library.DragSpeed
								}
							else
								core:tween{
									Position = UDim2.fromOffset(Mouse.X - ObjectPosition.X + (core.Size.X.Offset * core.AnchorPoint.X), Mouse.Y - ObjectPosition.Y + (core.Size.Y.Offset * core.AnchorPoint.Y)),
									Length = library.DragSpeed
								}
							end
						end
					end
				end)

				local Leave

				Leave = core.MouseLeave:Connect(function()
					Input:disconnect()
					Leave:disconnect()
				end)
			end)
		end
	end

	rawset(core, "oldSize", options.Size)

	self.mainFrame = core

	local tabButtons = core:Object("ScrollingFrame", {
		Size = UDim2.new(1, -40, 0, 25),
		Position = UDim2.fromOffset(5, 5),
		BackgroundTransparency = 1,
		ClipsDescendants = true,
		ScrollBarThickness = 0,
		ScrollingDirection = Enum.ScrollingDirection.X,
		AutomaticCanvasSize = Enum.AutomaticSize.X
	})

	tabButtons:Object("UIListLayout", {
		FillDirection = Enum.FillDirection.Horizontal,
		HorizontalAlignment = Enum.HorizontalAlignment.Left,
		SortOrder = Enum.SortOrder.LayoutOrder,
		Padding = UDim.new(0, 4)
	})

	local closeButton = core:Object("ImageButton", {
		BackgroundTransparency = 1,
		Size = UDim2.fromOffset(14, 14),
		Position = UDim2.new(1, -11, 0, 11),
		Theme = {
            ImageColor3 = "StrongText"
        },
		Image = "http://www.roblox.com/asset/?id=8497487650",
		AnchorPoint = Vector2.new(1)
	})

	closeButton.MouseEnter:Connect(function()
		closeButton:Tween({
            ImageColor3 = Color3.fromRGB(255, 125, 145)
        })
	end)

	closeButton.MouseLeave:Connect(function()
		closeButton:Tween({
            ImageColor3 = library.CurrentTheme.StrongText
        })
	end)

	local function closeUI()
		core.ClipsDescendants = true

		core:Fade(true)

		task.wait(0.1)

		core:tween({
            Size = UDim2.new()
        }, function()
			gui.AbsoluteObject:Destroy()
		end)
	end

	if getgenv then
		getgenv().BreakSkillUI = closeUI
	end

	closeButton.MouseButton1Click:Connect(function()
		closeUI()
	end)

	local urlBar = core:Object("Frame", {
		Size = UDim2.new(1, -10, 0, 25),
		Position = UDim2.new(0, 5,0, 35),
		Theme = {
            BackgroundColor3 = "Secondary"
        }
	}):Round(5)

	local searchIcon = urlBar:Object("ImageLabel", {
		AnchorPoint = Vector2.new(0, .5),
		Position = UDim2.new(0, 5,0.5, 0);
		Theme = {
            ImageColor3 = "Tertiary"
        },
		Size = UDim2.fromOffset(16, 16),
		Image = "http://www.roblox.com/asset/?id=8497489946",
		BackgroundTransparency = 1
	})

	local link = urlBar:Object("TextLabel", {
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

	library.UrlLabel = link
	library.Url = options.Link

	local shadowHolder = core:Object("Frame", {
		BackgroundTransparency = 1,
		Size = UDim2.fromScale(1, 1),
		ZIndex = 0
	})

	local shadow = shadowHolder:Object("ImageLabel", {
		Centered = true,
		BackgroundTransparency = 1,
		Size = UDim2.new(1, 47,1, 47),
		ZIndex = 0,
		Image = "rbxassetid://6015897843",
		ImageColor3 = Color3.new(0, 0, 0),
		ImageTransparency = .6,
		SliceCenter = Rect.new(47, 47, 450, 450),
		ScaleType = Enum.ScaleType.Slice,
		SliceScale = 1
	})

	local content = core:Object("Frame", {
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

	local status = core:Object("TextLabel", {
		AnchorPoint = Vector2.new(0, 1),
		BackgroundTransparency = 1,
		Position = UDim2.new(0, 5, 1, -6),
		Size = UDim2.new(0.2, 0, 0, 10),
		Font = Enum.Font.SourceSans,
		Text = "Status | Idle",
		Theme = {
            TextColor3 = "Tertiary"
        },
		TextSize = 14,
		TextXAlignment = Enum.TextXAlignment.Left
	})

	local homeButton = tabButtons:Object("TextButton", {
		Name = "hehehe siuuuuuuuuu",
		BackgroundTransparency = 0,
		Theme = {
            BackgroundColor3 = "Secondary"
        },
		Size = UDim2.new(0, 125, 0, 25)
	}):Round(5)

	local homeButtonText = homeButton:Object("TextLabel", {
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
		Font = Enum.Font.SourceSans,
		TextTruncate = Enum.TextTruncate.AtEnd
	})

	local homeButtonIcon = homeButton:Object("ImageLabel", {
		AnchorPoint = Vector2.new(0, 0.5),
		BackgroundTransparency = 1,
		Position = UDim2.new(0, 5, 0.5, 0),
		Size = UDim2.new(0, 15, 0, 15),
		Image = "http://www.roblox.com/asset/?id=8569322835",
		Theme = {
            ImageColor3 = "StrongText"
        }
	})

	local homePage = content:Object("Frame", {
		Size = UDim2.fromScale(1, 1),
		Centered = true,
		BackgroundTransparency = 1
	})

	local tabs = {}

	selectedTab = homeButton

	tabs[#tabs + 1] = {
        homePage,
        homeButton
    }

	do
		local down = false
		local hovered = false

		homeButton.MouseEnter:Connect(function()
			hovered = true

			homeButton:Tween({
                BackgroundTransparency = ((selectedTab == homeButton) and 0.15) or 0.3
            })
		end)

		homeButton.MouseLeave:Connect(function()
			hovered = false

			homeButton:Tween({
                BackgroundTransparency = ((selectedTab == homeButton) and 0.15) or 1
            })
		end)

		homeButton.MouseButton1Down:Connect(function()
			down = true

			homeButton:Tween({
                BackgroundTransparency = 0
            })
		end)

		UserInputService.InputEnded:Connect(function(key)
			if key.UserInputType == Enum.UserInputType.MouseButton1 then
				down = false

				homeButton:Tween({
                    BackgroundTransparency = ((selectedTab == homeButton) and 0.15) or (hovered and 0.3) or 1
                })
			end
		end)

		homeButton.MouseButton1Click:Connect(function()
			for _, tabInfo in next, tabs do
				local page = tabInfo[1]
				local button = tabInfo[2]

				page.Visible = false
			end

			selectedTab:Tween({
                BackgroundTransparency = ((selectedTab == homeButton) and 0.15) or 1
            })

			selectedTab = homeButton

			homePage.Visible = true

			homeButton.BackgroundTransparency = 0

			library.UrlLabel.Text = library.Url .. "/home"
		end)
	end

	self.SelectedTabButton = homeButton

	local homePageLayout = homePage:Object("UIListLayout", {
		Padding = UDim.new(0, 10),
		FillDirection = Enum.FillDirection.Vertical,
		HorizontalAlignment = Enum.HorizontalAlignment.Center
	})

	local homePagePadding = homePage:Object("UIPadding", {
		PaddingTop = UDim.new(0, 10)
	})

	local profile = homePage:Object("Frame", {
		AnchorPoint = Vector2.new(0, .5),
		Theme = {
            BackgroundColor3 = "Secondary"
        },
		Size = UDim2.new(1, -20, 0, 100)
	}):Round(7)

	local profilePictureContainer = profile:Object("ImageLabel", {
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

	local displayName

    do
		local h, s, v = Color3.toHSV(options.Theme.Tertiary)

		local c = self:Lighten(options.Theme.Tertiary, 20)

		displayName = profile:Object("TextLabel", {
			RichText = true,
			Text = "Welcome, <font color='rgb(" ..  math.floor(c.R*255) .. "," .. math.floor(c.G*255) .. "," .. math.floor(c.B*255) .. ")'> <b>" .. Client.DisplayName .. "</b></font>",
			TextScaled = true,
			Position = UDim2.new(0, 105,0, 10),
			Theme = {
                TextColor3 = {
                    "Tertiary", 10
                }
            },
			Size = UDim2.new(0, 400,0, 40),
			BackgroundTransparency = 1,
			TextXAlignment = Enum.TextXAlignment.Left
		})

		library.DisplayName = displayName
	end

	local profileName = profile:Object("TextLabel", {
		Text = "@" .. Client.Name,
		TextScaled = true,
		Position = UDim2.new(0, 105,0, 47),
		Theme = {
            TextColor3 = "Tertiary"
        },
		Size = UDim2.new(0, 400,0, 20),
		BackgroundTransparency = 1,
		TextXAlignment = Enum.TextXAlignment.Left
	})

	local timeDisplay = profile:Object("TextLabel", {
		BackgroundTransparency = 1,
		Position = UDim2.new(0, 105, 1, -10),
		Size = UDim2.new(0, 400,0, 20),
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
		local desiredInterval = 1
		local counter = 0

		RunService.Heartbeat:Connect(function(step)
			counter += step

			if counter >= desiredInterval then
				counter -= desiredInterval

				local date = tostring(os.date("%X"))

				timeDisplay.Text = date:sub(1, date:len() - 3)
			end
		end)
	end

	local settingsTabIcon = profile:Object("ImageButton", {
		BackgroundTransparency = 1,
		Theme = {
            ImageColor3 = "WeakText"
        },
		Size = UDim2.fromOffset(24, 24),
		Position = UDim2.new(1, -10, 1, -10),
		AnchorPoint = Vector2.new(1, 1),
		Image = "http://www.roblox.com/asset/?id=8559790237"
	}):ToolTip("Settings")

	local creditsTabIcon = profile:Object("ImageButton", {
		BackgroundTransparency = 1,
		Theme = {
            ImageColor3 = "WeakText"
        },
		Size = UDim2.fromOffset(24, 24),
		Position = UDim2.new(1, -44, 1, -10),
		AnchorPoint = Vector2.new(1, 1),
		Image = "http://www.roblox.com/asset/?id=8577523456"
	}):ToolTip("Credits")

	local quickAccess = homePage:Object("Frame", {
		BackgroundTransparency = 1,
		Size = UDim2.new(1, -20, 0, 180)
	})

	quickAccess:Object("UIGridLayout", {
		CellPadding = UDim2.fromOffset(10, 10),
		CellSize = UDim2.fromOffset(55, 55),
		HorizontalAlignment = Enum.HorizontalAlignment.Center,
		VerticalAlignment = Enum.VerticalAlignment.Center
	})

	quickAccess:Object("UIPadding", {
		PaddingBottom = UDim.new(0, 10),
		PaddingLeft = UDim.new(0, 70),
		PaddingRight = UDim.new(0, 70),
		PaddingTop = UDim.new(0, 5)
	})

	local mt = setmetatable({
		core = core,
		notifs = notificationHolder,
		statusText = status,
		container = content,
		navigation = tabButtons,
		Theme = options.Theme,
		Tabs = tabs,
		quickAccess = quickAccess,
		homeButton = homeButton,
		homePage = homePage,
		nilFolder = core:Object("Folder")
	}, library)

	local settingsTab = library.CreateTab(mt, {
		Name = "Settings",
		Internal = settingsTabIcon,
		Icon = "rbxassetid://8559790237"
	})

	settingsTab:_ThemeSelector()

	settingsTab:AddKeybind({
		Name = "Toggle Key",
		Description = "Key to show/hide the UI.",
		Keybind = Enum.KeyCode.Delete,
		Callback = function()
			self.Toggled = not self.Toggled

			library:Show(self.Toggled)
		end
	})

	settingsTab:AddToggle({
		Name = "Lock Dragging",
		Description = "Makes sure you can't drag UI outside of window.",
		StartingState = true,
		Callback = function(state)
			library.LockDragging = state
		end
	})

	settingsTab:AddSlider({
		Name = "UI Drag Speed",
		Description = "How smooth dragging looks.",
		Max = 20,
		Default = 14,
		Callback = function(value)
			library.DragSpeed = (20 - value) / 100
		end
	})

	local creditsTab = library.CreateTab(mt, {
		Name = "Credits",
		Internal = creditsTabIcon,
		Icon = "http://www.roblox.com/asset/?id=8577523456"
	})

	rawset(mt, "creditsContainer", creditsTab.container)

	creditsTab:AddCredit({
        Name = "Abstract",
        Description = "UI Library Developer",
        Discord = "Abstract#8007",
        V3rmillion = "AbstractPoo"
    })

	creditsTab:AddCredit({
        Name = "Deity",
        Description = "UI Library Developer",
        Discord = "Deity#0228",
        V3rmillion = "0xDEITY"
    })

    creditsTab:AddCredit({
        Name = "Skillus (xX_XSI)",
        Description = "Script Developer",
        Discord = "discord.gg/ev8bxrAa9p"
    })

	return mt
end

function library:CreateTab(options)
	options = self:SetDefaults({
		Name = "New Tab",
		Icon = "rbxassetid://8569322835"
	}, options)

	local tab = self.container:Object("ScrollingFrame", {
		AnchorPoint = Vector2.new(0, 1),
		Visible = false,
		BackgroundTransparency = 1,
		Position = UDim2.fromScale(0, 1),
		Size = UDim2.fromScale(1, 1),
		ScrollBarThickness = 0,
		ScrollingDirection = Enum.ScrollingDirection.Y
	})

	local quickAccessButton
	local quickAccessIcon

	if not options.Internal then
		quickAccessButton = self.quickAccess:Object("TextButton", {
			Theme = {
                BackgroundColor3 = "Secondary"
            }
		}):Round(5):ToolTip(options.Name)

		quickAccessIcon = quickAccessButton:Object("ImageLabel", {
			BackgroundTransparency = 1,
			Theme = {
                ImageColor3 = "StrongText"
            },
			Image = options.Icon,
			Size = UDim2.fromScale(0.5, 0.5),
			Centered = true
		})
	else
		quickAccessButton = options.Internal
	end

	local layout = tab:Object("UIListLayout", {
		Padding = UDim.new(0, 10),
		HorizontalAlignment = Enum.HorizontalAlignment.Center
	})

	tab:Object("UIPadding", {
		PaddingTop = UDim.new(0, 10)
	})

	local tabButton = library:Object("TextButton", {
		BackgroundTransparency = 1,
		Parent = self.nilFolder.AbsoluteObject,
		Theme = {
            BackgroundColor3 = "Secondary"
        },
		Size = UDim2.new(0, 125, 0, 25),
		Visible = false
	}):Round(5)

	self.Tabs[#self.Tabs + 1] = {
        tab, tabButton,
        options.Name
    }

	do
		local down = false
		local hovered = false

		tabButton.MouseEnter:Connect(function()
			hovered = true

			tabButton:Tween({
                BackgroundTransparency = ((selectedTab == tabButton) and 0.15) or 0.3
            })
		end)

		tabButton.MouseLeave:Connect(function()
			hovered = false

			tabButton:Tween({
                BackgroundTransparency = ((selectedTab == tabButton) and 0.15) or 1
            })
		end)

		tabButton.MouseButton1Down:Connect(function()
			down = true

			tabButton:Tween({
                BackgroundTransparency = 0
            })
		end)

		UserInputService.InputEnded:Connect(function(key)
			if key.UserInputType == Enum.UserInputType.MouseButton1 then
				down = false

				tabButton:Tween({
                    BackgroundTransparency = ((selectedTab == tabButton) and 0.15) or (hovered and 0.3) or 1
                })
			end
		end)

		tabButton.MouseButton1Click:Connect(function()
			for _, tabInfo in next, self.Tabs do
				local page = tabInfo[1]
				local button = tabInfo[2]

				page.Visible = false
			end

			selectedTab:Tween({
                BackgroundTransparency = ((selectedTab == tabButton) and 0.15) or 1
            })

			selectedTab = tabButton
			tab.Visible = true

			tabButton.BackgroundTransparency = 0

			library.UrlLabel.Text = library.Url .. "/" .. options.Name:lower()
		end)

		quickAccessButton.MouseEnter:Connect(function()
			quickAccessButton:Tween({
                BackgroundColor3 = library.CurrentTheme.Tertiary
            })
		end)

		quickAccessButton.MouseLeave:Connect(function()
			quickAccessButton:Tween({
                BackgroundColor3 = library.CurrentTheme.Secondary
            })
		end)

		quickAccessButton.MouseButton1Click:Connect(function()
			if not tabButton.Visible then
				tabButton.Parent = self.navigation.AbsoluteObject
				tabButton.Size = UDim2.new(0, 50, tabButton.Size.Y.Scale, tabButton.Size.Y.Offset)
				tabButton.Visible = true

				tabButton:Fade(false, library.CurrentTheme.Main, 0.1)

				tabButton:Tween({
                    Size = UDim2.new(0, 125, tabButton.Size.Y.Scale, tabButton.Size.Y.Offset),
                    Length = 0.1
                })

				for _, tabInfo in next, self.Tabs do
					local page = tabInfo[1]
					local button = tabInfo[2]

					page.Visible = false
				end

				selectedTab:Tween({
                    BackgroundTransparency = ((selectedTab == tabButton) and 0.15) or 1
                })
				selectedTab = tabButton

				tab.Visible = true

				tabButton.BackgroundTransparency = 0

				library.UrlLabel.Text = library.Url .. "/" .. options.Name:lower()
			end
		end)
	end

	local tabButtonText = tabButton:Object("TextLabel", {
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
		Font = Enum.Font.SourceSans,
		TextTruncate = Enum.TextTruncate.AtEnd
	})

	local tabButtonIcon = tabButton:Object("ImageLabel", {
		AnchorPoint = Vector2.new(0, 0.5),
		BackgroundTransparency = 1,
		Position = UDim2.new(0, 5, 0.5, 0),
		Size = UDim2.new(0, 15, 0, 15),
		Image = options.Icon,
		Theme = {
            ImageColor3 = "StrongText"
        }
	})

	local tabButtonClose = tabButton:Object("ImageButton", {
		AnchorPoint = Vector2.new(1, 0.5),
		BackgroundTransparency = 1,
		Position = UDim2.new(1, -5, 0.5, 0),
		Size = UDim2.fromOffset(14, 14),
		Image = "rbxassetid://8497487650",
		Theme = {
            ImageColor3 = "StrongText"
        }
	})

	tabButtonClose.MouseButton1Click:Connect(function()
		tabButton:Fade(true, library.CurrentTheme.Main, 0.1)

		tabButton:Tween({
            Size = UDim2.new(0, 50, tabButton.Size.Y.Scale, tabButton.Size.Y.Offset),
            Length = 0.1
        }, function()
			tabButton.Visible = false

			tab.Visible = false

			tabButton.Parent = self.nilFolder.AbsoluteObject

			task.wait()
		end)

		local visible = {}

		for _, tab in next, self.Tabs do
			if not tab[2] == selectedTab then
                tab[1].Visible = false
            end

			if tab[2].Visible then
				visible[#visible + 1] = tab
			end
		end

		local lastTab = visible[#visible]

		if selectedTab == self.homeButton then
			tab.Visible = false
		elseif #visible == 2 then
			selectedTab.Visible = false

			tab.Visible = false

			self.homePage.Visible = true

			self.homeButton:Tween({
                BackgroundTransparency = 0.15
            })

			selectedTab = self.homeButton

			library.UrlLabel.Text = library.Url .. "/home"
		elseif tabButton == lastTab[2] then
			lastTab = visible[#visible - 1]

			tab.Visible = false

			lastTab[2]:Tween({
                BackgroundTransparency = 0.15
            })

			lastTab[1].Visible = true

			selectedTab = lastTab[2]

			library.UrlLabel.Text = library.Url .. "/" .. lastTab[3]:lower()
		else
			tab.Visible = false

			lastTab[2]:Tween({
                BackgroundTransparency = 0.15
            })

			lastTab[1].Visible = true

			selectedTab = lastTab[2]

			library.UrlLabel.Text = library.Url .. "/" .. lastTab[3]:lower()
		end
	end)

	return setmetatable({
		statusText = self.statusText,
		container = tab,
		Theme = self.Theme,
		core = self.core,
		layout = layout
	}, library)
end

--[
--ResizeTab
--]

function library:_ResizeTab()
	if self.container.ClassName == "ScrollingFrame" then
		self.container.CanvasSize = UDim2.fromOffset(0, self.layout.AbsoluteContentSize.Y + 20)
	else
		self.sectionContainer.Size = UDim2.new(1, -24, 0, self.layout.AbsoluteContentSize.Y + 20)

		self.parentContainer.CanvasSize = UDim2.fromOffset(0, self.parentLayout.AbsoluteContentSize.Y + 20)
	end
end

--[
--_ThemeSelector
--]

function library:_ThemeSelector()
	local themesCount = 0

	for _ in next, library.Themes do
		themesCount += 1
	end

	local themeContainer = self.container:Object("Frame", {
		Theme = {
            BackgroundColor3 = "Secondary"
        },
		Size = UDim2.new(1, -20, 0, 127)
	}):Round(7)

	local text = themeContainer:Object("TextLabel", {
		BackgroundTransparency = 1,
		Position = UDim2.fromOffset(10, 5),
		Size = UDim2.new(0.5, -10, 0, 22),
		Text = "Theme",
		TextSize = 22,
		Theme = {
            TextColor3 = "StrongText"
        },
		TextXAlignment = Enum.TextXAlignment.Left
	})

	local colorThemesContainer = themeContainer:Object("Frame", {
		Size = UDim2.new(1, 0, 1, -32),
		BackgroundTransparency = 1,
		Position = UDim2.new(0.5, 0, 1, -5),
		AnchorPoint = Vector2.new(0.5, 1)
	})

	local grid = colorThemesContainer:Object("UIGridLayout", {
		CellPadding = UDim2.fromOffset(10, 10),
		CellSize = UDim2.fromOffset(102, 83),
		VerticalAlignment = Enum.VerticalAlignment.Center
	})

	colorThemesContainer:Object("UIPadding", {
		PaddingLeft = UDim.new(0, 10),
		PaddingTop = UDim.new(0, 5)
	})

	for themeName, themeColors in next, library.Themes do
		local count = 0

		for _, color in next, themeColors do
			if not (type(color) == "boolean") then
				count += 1
			end
		end

		if count >= 5 then
			local theme = colorThemesContainer:Object("TextButton", {
				BackgroundTransparency = 1
			})

			local themeColorsContainer = theme:Object("Frame", {
				Size = UDim2.new(1, 0, 1, -20),
				BackgroundTransparency = 1
			}):Round(5):Stroke("WeakText", 1)

			local themeNameLabel = theme:Object("TextLabel", {
				BackgroundTransparency = 1,
				Text = themeName,
				TextSize = 16,
				Theme = {
                    TextColor3 = "StrongText"
                },
				Size = UDim2.new(1, 0, 0, 20),
				Position = UDim2.fromScale(0, 1),
				AnchorPoint = Vector2.new(0, 1)
			})

			local colorMain = themeColorsContainer:Object("Frame", {
				Centered = true,
				Size = UDim2.fromScale(1, 1),
				BackgroundColor3 = themeColors.Main
			}):Round(4)

			local colorSecondary = colorMain:Object("Frame", {
				Centered = true,
				Size = UDim2.new(1, -16, 1, -16),
				BackgroundColor3 = themeColors.Secondary
			}):Round(4)

			colorSecondary:Object("UIListLayout", {
				Padding = UDim.new(0, 5)
			})

			colorSecondary:Object("UIPadding", {
				PaddingTop = UDim.new(0, 5),
				PaddingLeft = UDim.new(0, 5)
			})

			local colorTertiary = colorSecondary:Object("Frame", {
				Size = UDim2.new(1, -20, 0, 9),
				BackgroundColor3 = themeColors.Tertiary
			}):Round(100)

			local colorStrong = colorSecondary:Object("Frame", {
				Size = UDim2.new(1, -30, 0, 9),
				BackgroundColor3 = themeColors.StrongText
			}):Round(100)

			local colorTertiary = colorSecondary:Object("Frame", {
				Size = UDim2.new(1, -40, 0, 9),
				BackgroundColor3 = themeColors.WeakText
			}):Round(100)

			theme.MouseButton1Click:Connect(function()
				library:ChangeTheme(library.Themes[themeName])

				updateSettings("Theme", themeName)
			end)
		end
	end

	self:_ResizeTab()
end

--[
--AddCredit
--]

function library:AddCredit(options)
	options = self:SetDefaults({
		Name = "Credit",
		Description = nil
	}, options)

	options.V3rmillion = options.V3rmillion or options.V3rm

	local creditContainer = (self.creditsContainer or self.container):Object("Frame", {
		Theme = {
            BackgroundColor3 = "Secondary"
        },
		Size = UDim2.new(1, -20, 0, 52)
	}):Round(7)

	local name = creditContainer:Object("TextLabel", {
		BackgroundTransparency = 1,
		Position = UDim2.fromOffset(10, (options.Description and 5) or 0),
		Size = (options.Description and UDim2.new(0.5, -10, 0, 22)) or UDim2.new(0.5, -10, 1, 0),
		Text = options.Name,
		TextSize = 22,
		Theme = {
            TextColor3 = "StrongText"
        },
		TextXAlignment = Enum.TextXAlignment.Left
	})

	if options.Description then
		local description = creditContainer:Object("TextLabel", {
			BackgroundTransparency = 1,
			Position = UDim2.fromOffset(10, 27),
			Size = UDim2.new(0.5, -10, 0, 20),
			Text = options.Description,
			TextSize = 18,
			Theme = {
                TextColor3 = "WeakText"
            },
			TextXAlignment = Enum.TextXAlignment.Left
		})
	end

	if setclipboard then
		if options.Github then
			local githubContainer = creditContainer:Object("TextButton", {
				AnchorPoint = Vector2.new(1, 1),
				Size = UDim2.fromOffset(24, 24),
				Position = UDim2.new(1, -8, 1, -8),
				Theme = {
                    BackgroundColor3 = {
                        "Main",
                        10
                    }
                }
			}):Round(5):ToolTip("Copy Github")

			local github = githubContainer:Object("ImageLabel", {
				Image = "http://www.roblox.com/asset/?id=11965755499",
				Size = UDim2.new(1, -4, 1, -4),
				Centered = true,
				BackgroundTransparency = 1
			}):Round(100)

			githubContainer.MouseButton1Click:Connect(function()
				setclipboard(options.Github)
			end)
		end

		if options.Discord then
			local discordContainer = creditContainer:Object("TextButton", {
				AnchorPoint = Vector2.new(1, 1),
				Size = UDim2.fromOffset(24, 24),
				Position = UDim2.new(1, -8, 1, -8),
				BackgroundColor3 = Color3.fromRGB(88, 101, 242)
			}):Round(5):ToolTip("Copy Discord")

			local discord = discordContainer:Object("Frame", {
				Size = UDim2.new(1, -6, 1, -6),
				Centered = true,
				BackgroundTransparency = 1
			})

			local tr = discord:Object("ImageLabel", {
				BackgroundTransparency = 1,
				AnchorPoint = Vector2.new(1, 0),
				Size = UDim2.new(0.5, 0, 0.5, 0),
				Position = UDim2.new(1, 0, 0, -0),
				ImageColor3 = Color3.fromRGB(255, 255, 255),
				Image = "http://www.roblox.com/asset/?id=8594150191",
				ScaleType = Enum.ScaleType.Crop
			})

			local tl = discord:Object("ImageLabel", {
				BackgroundTransparency = 1,
				AnchorPoint = Vector2.new(0, 0),
				Size = UDim2.new(0.5, 0, 0.5, 0),
				Position = UDim2.new(0, 0, 0, -0),
				ImageColor3 = Color3.fromRGB(255, 255, 255),
				Image = "http://www.roblox.com/asset/?id=8594187532",
				ScaleType = Enum.ScaleType.Crop
			})

			local bl = discord:Object("ImageLabel", {
				BackgroundTransparency = 1,
				AnchorPoint = Vector2.new(0, 1),
				Size = UDim2.new(0.5, 0, 0.5, 0),
				Position = UDim2.new(0, 0, 1, 0),
				ImageColor3 = Color3.fromRGB(255, 255, 255),
				Image = "http://www.roblox.com/asset/?id=8594194954",
				ScaleType = Enum.ScaleType.Crop
			})

			local br = discord:Object("ImageLabel", {
				BackgroundTransparency = 1,
				AnchorPoint = Vector2.new(1, 1),
				Size = UDim2.new(0.5, 0, 0.5, 0),
				Position = UDim2.new(1, 0, 1, 0),
				ImageColor3 = Color3.fromRGB(255, 255, 255),
				Image = "http://www.roblox.com/asset/?id=8594206483",
				ScaleType = Enum.ScaleType.Crop
			})

			discordContainer.MouseButton1Click:Connect(function()
				setclipboard(options.Discord)
			end)
		end

		if options.V3rmillion then
			local v3rmillionContainer = creditContainer:Object("TextButton", {
				AnchorPoint = Vector2.new(1, 1),
				Size = UDim2.fromOffset(24, 24),
				Position = UDim2.new(1, -40, 1, -8),
				Theme = {
                    BackgroundColor3 = {
                        "Main",
                        10
                    }
                }
			}):Round(5):ToolTip("Copy V3rm")

			local v3rmillion = v3rmillionContainer:Object("ImageLabel", {
				Image = "http://www.roblox.com/asset/?id=8594086769",
				Size = UDim2.new(1, -4, 1, -4),
				Centered = true,
				BackgroundTransparency = 1
			})

			v3rmillionContainer.MouseButton1Click:Connect(function()
				setclipboard(options.V3rmillion)
			end)
		end
	end

	self._ResizeTab({
		container = self.creditsContainer or self.container,
		layout = (self.creditsContainer and self.creditsContainer.AbsoluteObject.UIListLayout) or self.layout
	})
end

--XD

return setmetatable(library, {
    __index = function(_, i)
        return rawget(library, i:lower())
    end
})
