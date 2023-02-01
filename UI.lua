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

--Object

function library:Object(class, props)
	local LocalObject = Instance.new(class)

	local ForcedProps = {
		BorderSizePixel = 0,
		AutoButtonColor = false,
		Font = Enum.Font.SourceSans,
		Text = ""
	}

	for property, value in next, ForcedProps do
		pcall(function()
			LocalObject[property] = value
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

		callback = callback or function() return end

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
			local theme, colorAlter = color[1], color[2] or 0
			local themeColor = library.CurrentTheme[theme]
			local modifiedColor = themeColor

			if colorAlter < 0 then
				modifiedColor = library:Darken(themeColor, -1 * colorAlter)
			elseif colorAlter > 0 then
				modifiedColor = library:Lighten(themeColor, colorAlter)
			end

			Stroke.Color = modifiedColor

			table.insert(library.ThemeObjects[theme], {
				Stroke,
				"Color",
				theme,
				colorAlter
			})
		elseif type(color) == "string" then
			local themeColor = library.CurrentTheme[color]

			Stroke.Color = themeColor

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
		local tooltipContainer = Methods:Object("TextLabel", {
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

		Methods.MouseEnter:Connect(function()
			hovered = true

			wait(0.2)

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

		Methods.MouseLeave:Connect(function()
			hovered = false

			tooltipContainer:Tween({
				BackgroundTransparency = 1,
				TextTransparency = 1
			})

			tooltipArrow:Tween({
				ImageTransparency = 1
			})
		end)

		return Methods
	end

	local customHandlers = {
		Centered = function(value)
			if value then
				LocalObject.AnchorPoint = Vector2.new(0.5, 0.5)
				LocalObject.Position = UDim2.fromScale(0.5, 0.5)
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

					LocalObject[property] = modifiedColor

					table.insert(self.ThemeObjects[theme], {
						Methods,
						property,
						theme,
						colorAlter
					})
				else
					local themeColor = library.CurrentTheme[obj]

					LocalObject[property] = themeColor

					table.insert(self.ThemeObjects[obj], {
						Methods,
						property,
						obj,
						0
					})
				end
			end
		end,
	}

	for property, value in next, props do
		if customHandlers[property] then
			customHandlers[property](value)
		else
			LocalObject[property] = value
		end
	end

	return setmetatable(Methods, {
		__index = function(_, property)
			return LocalObject[property]
		end,
		__newindex = function(_, property, value)
			LocalObject[property] = value
		end,
	})
end

--Darken

function library:Darken(color, f)
	local H, S, V = Color3.toHSV(color)

	f = 1 - ((f or 15) / 80)

	return Color3.fromHSV(H, math.clamp(S / f, 0, 1), math.clamp(V * f, 0, 1))
end

--Lighten

function library:Lighten(color, f)
	local H, S, V = Color3.toHSV(color)

	f = 1 - ((f or 15) / 80)

	return Color3.fromHSV(H, math.clamp(S * f, 0, 1), math.clamp(V / f, 0, 1))
end

--SetDefaults

function library:SetDefaults(defaults, options)
	defaults = defaults or {}
	options = options or {}

	for o, v in next, options do
		defaults[options] = v
	end

	return defaults
end

--CreateWindow

function library:CreateWindow(options)
	local Settings = {
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
			writefile("./Break-Skill Hub - V1/UI/Settings.json", HttpService:JSONEncode(Settings))
		end

		Settings = HttpService:JSONDecode(readfile("./Break-Skill Hub - V1/UI/Settings.json"))

		library.CurrentTheme = library.Themes[Settings.Theme]

		UpdateSettings = function(property, val)
			Settings[property] = val

			writefile("./Break-Skill Hub - V1/UI/Settings.json", HttpService:JSONEncode(Settings))
		end
	end

	options = library:SetDefaults({
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
		AnchorPoint = Vector2.new(0, 0.5),
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
		Size = UDim2.new(1, -30, 0.6, 0),
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
		ImageTransparency = 0.6,
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
		AnchorPoint = Vector2.new(0, 0.5),
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

	local WindowFunctions = {}

	SelectedTab = HomeButton

	WindowFunctions[#WindowFunctions + 1] = {
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
			for _, ti in next, WindowFunctions do
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

			library.URLLabel.Text = library.Link .. "/home"
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
		AnchorPoint = Vector2.new(0, 0.5),
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
			Text = "Welcome, <font color='rgb(" .. math.floor(Light.R * 255) .. "," .. math.floor(Light.G * 255) .. "," .. math.floor(Light.B * 255) .. ")'> <b>" .. Client.DisplayName .. "</b></font>",
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
		CellPadding = UDim.new(10, 10),
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
		Tabs = WindowFunctions,
		QuickAccess = QuickAccess,
		HomeButton = HomeButton,
		HomePage = HomePage,
		NilFolder = Core:Object("Folder")
	}, library)

	return mt
end

--XD

return setmetatable(library, {
	__index = function(_, i)
		return rawget(library, i:lower())
	end
})
