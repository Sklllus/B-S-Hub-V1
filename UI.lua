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
	Themes = {
		BreakSkill = {
			Main = Color3.fromRGB(35, 35, 35),
			Secondary = Color3.fromRGB(65, 65, 65),
			Tertiary = Color3.fromRGB(225, 55, 55),
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
		}
	},
	ThemeObjects = {
		Main = {},
		Secondary = {},
		Tertiary = {},
		StrongText = {},
		WeakText = {}
	},
	ColorPickerStyles = {
		Legacy = 0,
		Modern = 1
	},
	Toggled = true,
	LockDragging = false,
	WelcomeText = nil,
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

local GlobalTweenInfo = TweenInfo.new(0.2, Enum.EasingStyle.Linear, Enum.EasingDirection.InOut)

local UpdateSettings = function() end

--[
--UI Library Functions
--]

--[
--Object
--]

function library:Object(class, props)
	local LocalObject = Instance.new(class)

	local ForcedProps = {
		BorderSizePixel = 0,
		AutoButtonColor = false,
		Font = Enum.Font.Code,
		Text = ""
	}

	for p, v in next, ForcedProps do
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
			Style = Enum.EasingStyle.Linear,
			Direction = Enum.EasingDirection.InOut
		}, options)

		callback = callback or function () return end

		local ti = TweenInfo.new(options.Length, options.Style, options.Direction)

		options.Length = nil
		options.Style = nil
		options.Direction = nil

		local Tween = TweenService:Create(LocalObject, ti, options)

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

		if not rawget(self, "FadeFrame") then
			local Frame = self:Object("Frame", {
				BackgroundColor3 = colorOverride or self.BackgroundColor3,
				BackgroundTransparency = (state and 1) or 0,
				Size = UDim2.fromScale(1, 1),
				Centered = true,
				ZIndex = 999
			}):Round(self.AbsoluteObject:FindFirstChildOfClass("UICorner") and self.AbsoluteObject:FindFirstChildOfClass("UICorner").CornerRadius.Offset or 0)

			rawset(self, "FadeFrame", Frame)
		else
			self.FadeFrame.BackgroundColor3 = colorOverride or self.BackgroundColor3
		end

		if instant then
			if state then
				self.FadeFrame.BackgroundTransparency = 0
				self.FadeFrame.Visible = true
			else
				self.FadeFrame.BackgroundTransparency = 1
				self.FadeFrame.Visible = false
			end
		else
			if state then
				self.FadeFrame.BackgroundTransparency = 1
				self.FadeFrame.Visible = true

				self.FadeFrame:Tween({
					BackgroundTransparency = 0,
					Length = length
				})
			else
				self.FadeFrame.BackgroundTransparency = 0

				self.FadeFrame:Tween({
					BackgroundTransparency = 1,
					Length = length
				}, function()
					self.FadeFrame.Visible = false
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

	function Methods:ToolTip(text)
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
			Text = text,
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

function library:SetStatus(text)
	self.StatusText.Text = text
end

--[
--ChangeTheme
--]

function library:ChangeTheme(toTheme)
	library.CurrentTheme = toTheme

	local Light = self:Lighten(toTheme.Tertiary, 20)

	library.DisplayName.Text = "Welcome, <font color='rgb(" .. math.floor(Light.R * 255) .. "," .. math.floor(Light.G * 255) .. "," .. math.floor(Light.B * 255) .. ")'><b>" .. Client.DisplayName .. "</b></font>"

	for c, o in next, library.ThemeObjects do
		local ThemeColor = library.CurrentTheme[c]

		for _, o2 in next, o do
			local Element, Property, Theme, ColorAlter = o2[1], o2[2], o2[3], o2[4] or 0

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
--CreateWindow
--]

function library:CreateWindow(options)
	local Settings = {
		Theme = "BreakSkill"
	}

	if readfile and isfile and makefolder and writefile and isfolder then
		if not isfolder("./Break-Skill Hub - V1") then
			makefolder("./Break-Skill Hub - V1")
		end

		if not isfolder("./Break-Skill Hub - V1/UI") then
			makefolder("./Break-Skill Hub - V1/UI")
		end

		if not isfile("./Break-Skill Hub - V1/UI/Settings.json") then
			writefile("./Break-Skill Hub - V1/UI/Settings.json", HttpService:JSONEncode(Settings))
		end

		Settings = HttpService:JSONDecode(readfile("./Break-Skill Hub - V1/UI/Settings.json"))

		library.CurrentTheme = library.Themes[Settings.Theme]

		UpdateSettings = function(property, val)
			Settings[property] = val

			writefile("./Break-Skill Hub - V1/UI/Settings.json", HttpService:JSONEncode(Settings))
		end
	end

	options = self:SetDefaults({
		Name = "Break-Skill Hub - V1",
		Size = UDim2.fromOffset(600, 500),
		Theme = self.Themes[Settings.Theme],
		Link = "https://github.com/Skillus/Break-Skill-Hub-V1"
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

	Core:Fade(true, nil, 0.2, true)
	Core:Fade(false, nil, 0.4)

	Core:Tween({
		Size = options.Size,
		Length = 0.3
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
			ImageColor3 = Color3.fromRGB(255, 125, 140)
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
		ScaleType = Enum.ScaleType.Slice,
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
		Text = options.Name,
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
		Image = "http://www.roblox.com/asset/?id=8569322735",
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

		local Light = self:Lighten(options.Theme.Tertiary, 20)

		DisplayName = Profile:Object("TextLabel", {
			RichText = true,
			Text = "Welcome, <font color='rgb(" .. math.floor(Light.R * 255) .. "," .. math.floor(Light.G * 255) .. "," .. math.floor(Light.B * 255) .. ")'><b>" .. Client.DisplayName .. "</b></font>",
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

		RunService.Heartbeat:Connect(function(deltaTime)
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
		Notifications = NotificationHolder,
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

	local CreditsTab = library:CreateTab(mt, {
		Name = "Credits",
		Internal = CreditsTabIcon,
		Icon = "http://www.roblox.com/asset/?id=8577523456"
	})

	rawset(mt, "CreditsContainer", CreditsTab.Container)

	return mt
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
			Hovered = false

			TabButton:Tween({
				BackgroundTransparency = ((SelectedTab == TabButton) and 0.15) or 1
			})
		end)

		TabButton.MouseButton1Down:Connect(function()
			Down = true

			TabButton:Tween({
				BackgroundTransparency = 0
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

		for _, tab in next, self.Tabs do
			if not tab[2] == SelectedTab then
				tab[1].Visible = false
			end

			if tab[2].Visible then
				Visible[#Visible + 1] = tab
			end
		end

		local LastTab = Visible[#Visible]

		if SelectedTab == self.HomeButton then
			Tab.Visible = false
		elseif #Visible == 2 then
			SelectedTab.Visible = false

			Tab.Visible = false

			self.HomePage.Visible = true

			self.HomePage:Tween({
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

--Meta

return setmetatable(library, {
	__index = function(_, i)
		return rawget(library, i:lower())
	end
})
