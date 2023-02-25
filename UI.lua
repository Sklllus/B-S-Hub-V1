--[
--UI Library Made By xS_Killus (xX_XSI)
--]

--[
--Instances And Functions
--]

local HttpService = game:GetService("HttpService")
local MarketplaceService = game:GetService("MarketplaceService")
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local TextService = game:GetService("TextService")
local TweenService = game:GetService("TweenService")
local CoreGui = game:GetService("CoreGui")
local UserInputService = game:GetService("UserInputService")

if getgenv()["library"] then
    getgenv()["library"]:Unload()
end

local library = {
    Title = "Break-Skill Hub - V1",
    FolderName = "Break-Skill Hub - V1",
    ConfigFolderName = "Break-Skill Hub - V1/Configs",
    FileExt = ".json",
    Tabs = {},
    Flags = {},
    Instances = {},
    Connections = {},
    Options = {},
    Notifications = {},
    Theme = {},
    Draggable = true,
    Open = false,
    Popup = nil,
    TabSize = 0
}

getgenv()["library"] = library

local Dragging, DragInput, DragStart, StartPos, DragObject

local BlacklistedKeys = {
    Enum.KeyCode.Unknown,
    Enum.KeyCode.W,
    Enum.KeyCode.S,
    Enum.KeyCode.A,
    Enum.KeyCode.D,
    Enum.KeyCode.Slash,
    Enum.KeyCode.Tab,
    Enum.KeyCode.Escape,
    Enum.KeyCode.Tilde,
    Enum.KeyCode.Backspace,
    Enum.KeyCode.Space,
    Enum.KeyCode.NumLock,
    Enum.KeyCode.ScrollLock,
    Enum.KeyCode.CapsLock
}

local WhitelistedMouseInputs = {
    Enum.UserInputType.MouseButton1,
    Enum.UserInputType.MouseButton2,
    Enum.UserInputType.MouseButton3
}

--[
--UI Library Functions
--]

--Round

library.Round = function(num, bracket)
    if typeof(num) == "Vector2" then
        return Vector2.new(library.Round(num.X), library.Round(num.Y))
    elseif typeof(num) == "Vector3" then
        return Vector3.new(library.Round(num.X), library.Round(num.Y), library.Round(num.Z))
    elseif typeof(num) == "Color3" then
        return library.Round(num.R * 255), library.Round(num.G * 255), library.Round(num.B * 255)
    else
        return num - num % (bracket or 1)
    end
end

--CreateLabel

library.CreateLabel = function(option, parent)
    option.Main = library:Create("TextLabel", {
        LayoutOrder = option.Position,
        Position = UDim2.new(0, 6, 0, 0),
        Size = UDim2.new(1, -12, 0, 24),
        BackgroundTransparency = 1,
        TextSize = 15,
        Font = Enum.Font.Code,
        Text = tostring(option.Text),
        TextColor3 = option.Color,
        TextXAlignment = Enum.TextXAlignment.Left,
        TextYAlignment = Enum.TextYAlignment.Top,
        TextWrapped = true,
        Parent = parent
    })

    --[
    --SetText
    --]

    function option:SetText(newText)
        option.Main.Text = newText

        option.Text, option.text = newText, newText
    end

    --[
    --SetColor
    --]

    function option:SetColor(newColor)
        TweenService:Create(option.Main, TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
            TextColor3 = newColor
        }):Play()

        option.Color = newColor
    end

    setmetatable(option, {
        __newindex = function(t, i, v)
            if i == "Text" then
                option.Main.Text = tostring(v)
                option.Main.Size = UDim2.new(1, -12, 0, TextService:GetTextSize(option.Main.Text, 15, Enum.Font.Code, Vector2.new(option.Main.AbsoluteSize.X, 9e9)).Y + 6)
            end
        end
    })

    option.text = option.Text
end

--CreateDivider

library.CreateDivider = function(option, parent)
    option.Main = library:Create("Frame", {
        LayoutOrder = option.Position,
        Size = UDim2.new(1, 0, 0, 18),
        BackgroundTransparency = 1,
        Parent = parent
    })

    library:Create("Frame", {
        AnchorPoint = Vector2.new(0.5, 0.5),
        Position = UDim2.new(0.5, 0, 0.5, 0),
        Size = UDim2.new(1, -24, 0, 1),
        BackgroundColor3 = Color3.fromRGB(60, 60, 60),
        BorderColor3 = Color3.fromRGB(0, 0, 0),
        Parent = option.Main
    })

    option.Title = library:Create("TextLabel", {
        AnchorPoint = Vector2.new(0.5, 0.5),
        Position = UDim2.new(0.5, 0, 0.5, 0),
        BackgroundColor3 = Color3.fromRGB(30, 30, 30),
        BorderSizePixel = 0,
        TextColor3 = Color3.fromRGB(160, 160, 160),
        TextSize = 15,
        Text = tostring(option.Text),
        Font = Enum.Font.Code,
        TextXAlignment = Enum.TextXAlignment.Center,
        Parent = option.Main
    })

    setmetatable(option, {
        __newindex = function(t, i, v)
            if i == "Text" then
                if v then
                    option.Title.Text = tostring(v)
                    option.Title.Size = UDim2.new(0, TextService:GetTextSize(option.Title.Text, 15, Enum.Font.Code, Vector2.new(9e9, 9e9)).X + 12, 0, 20)

                    option.Main.Size = UDim2.new(1, 0, 0, 18)
                else
                    option.Title.Text = ""
                    option.Title.Size = UDim2.new()

                    option.Main.Size = UDim2.new(1, 0, 0, 6)
                end
            end
        end
    })

    option.text = option.Text
end

--CreateButton

library.CreateButton = function(option, parent)
    option.HasInit = true

    option.Main = library:Create("Frame", {
        LayoutOrder = option.Position,
        Size = UDim2.new(1, 0, 0, 28),
        BackgroundTransparency = 1,
        Parent = parent
    })

    option.Title = library:Create("TextLabel", {
        AnchorPoint = Vector2.new(0.5, 1),
        Position = UDim2.new(0.5, 0, 1, -5),
        Size = UDim2.new(1, -12, 0, 20),
        BackgroundColor3 = Color3.fromRGB(50, 50, 50),
        BorderColor3 = Color3.fromRGB(0, 0, 0),
        Text = tostring(option.Text),
        TextColor3 = Color3.fromRGB(255, 255, 255),
        TextSize = 15,
        Font = Enum.Font.Code,
        Parent = option.Main
    })

    library:Create("ImageLabel", {
        Size = UDim2.new(1, 0, 1, 0),
        BackgroundTransparency = 1,
        Image = "rbxassetid://2592362371",
        ImageColor3 = Color3.fromRGB(60, 60, 60),
        ScaleType = Enum.ScaleType.Slice,
        SliceCenter = Rect.new(2, 2, 62, 62),
        Parent = option.Title
    })

    library:Create("ImageLabel", {
        Size = UDim2.new(1, -2, 1, -2),
        Position = UDim2.new(0, 1, 0, 1),
        BackgroundTransparency = 1,
        Image = "rbxassetid://2592362371",
        ImageColor3 = Color3.fromRGB(0, 0, 0),
        ScaleType = Enum.ScaleType.Slice,
        SliceCenter = Rect.new(2, 2, 62, 62),
        Parent = option.Title
    })

    library:Create("UIGradient", {
        Color = ColorSequence.new({
            ColorSequenceKeypoint.new(0.000, Color3.fromRGB(180, 180, 180)),
            ColorSequenceKeypoint.new(1.000, Color3.fromRGB(255, 255, 255))
        }),
        Rotation = -90,
        Parent = option.Title
    })

    if option.Lock then
        option.Title.TextColor3 = Color3.fromRGB(160, 30, 30)
        option.Title.BorderColor3 = Color3.fromRGB(160, 30, 30)
    end

    option.Title.InputBegan:Connect(function(input)
        if input.UserInputType.Name == "MouseButton1" then
            if option.Lock then
                return
            end

            option.Callback()

            if library then
                library.Flags[option.Flag] = true
            end
        end

        if input.UserInputType.Name == "MouseMovement" then
            if not library.Warning and not library.Slider then
                if not option.Lock then
                    TweenService:Create(option.Title, TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
                        BorderColor3 = library.Flags["UI/Accent Color"]
                    }):Play()
                end

                if option.Tip then
                    library.ToolTip.Text = option.Tip
                    library.ToolTip.Size = UDim2.new(0, TextService:GetTextSize(option.Tip, 15, Enum.Font.Code, Vector2.new(9e9, 9e9)).X, 0, 20)
                end
            end
        end
    end)

    option.Title.InputChanged:Connect(function(input)
        if input.UserInputType.Name == "MouseMovement" then
            if option.Tip then
                library.ToolTip.Position = UDim2.new(0, input.Position.X + 26, 0, input.Position.Y + 36)
            end
        end
    end)

    option.Title.InputEnded:Connect(function(input)
        if input.UserInputType.Name == "MouseMovement" then
            if not option.Lock then
                TweenService:Create(option.Title, TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
                    BorderColor3 = Color3.fromRGB(0, 0, 0)
                }):Play()
            end

            if option.Tip then
                library.ToolTip.Text = ""
                library.ToolTip.Size = UDim2.new()
            end
        end
    end)

    --[
    --SetLock
    --]

    function option:SetLock(newLock)
        option.Lock = newLock

        TweenService:Create(option.Title, TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
            TextColor3 = newLock and Color3.fromRGB(160, 30, 30) or Color3.fromRGB(255, 255, 255),
            BorderColor3 = newLock and Color3.fromRGB(160, 30, 30) or Color3.fromRGB(0, 0, 0)
        })
    end

    --[
    --Trigger
    --]

    function option:Trigger()
        option.Callback()
    end
end

--CreateToggle

library.CreateToggle = function(option, parent)
    option.HasInit = true

    option.Main = library:Create("Frame", {
        LayoutOrder = option.Position,
        Size = UDim2.new(1, 0, 0, 20),
        BackgroundTransparency = 1,
        Parent = parent
    })

    local TickBox = library:Create("Frame", {
        Position = UDim2.new(0, 6, 0, 4),
        Size = UDim2.new(0, 12, 0, 12),
        BackgroundColor3 = library.Flags["UI/Accent Color"],
        BorderColor3 = Color3.fromRGB(0, 0, 0),
        Parent = option.Main
    })

    local TickBoxOverlay = library:Create("ImageLabel", {
        Size = UDim2.new(1, 0, 1, 0),
        BackgroundTransparency = option.State and 1 or 0,
        BackgroundColor3 = Color3.fromRGB(50, 50, 50),
        BorderColor3 = Color3.fromRGB(0, 0, 0),
        Image = "rbxassetid://4155801252",
        ImageTransparency = 0.6,
        ImageColor3 = Color3.fromRGB(0, 0, 0),
        Parent = TickBox
    })

    library:Create("ImageLabel", {
        Size = UDim2.new(1, 0, 1, 0),
        BackgroundTransparency = 1,
        Image = "rbxassetid://2592362371",
        ImageColor3 = Color3.fromRGB(60, 60, 60),
        ScaleType = Enum.ScaleType.Slice,
        SliceCenter = Rect.new(2, 2, 62, 62),
        Parent = TickBox
    })

    library:Create("ImageLabel", {
        Size = UDim2.new(1, -2, 1, -2),
        Position = UDim2.new(0, 1, 0, 1),
        BackgroundTransparency = 1,
        Image = "rbxassetid://2592362371",
        ImageColor3 = Color3.fromRGB(0, 0, 0),
        ScaleType = Enum.ScaleType.Slice,
        SliceCenter = Rect.new(2, 2, 62, 62),
        Parent = TickBox
    })

    table.insert(library.Theme, TickBox)

    option.Interest = library:Create("Frame", {
        Position = UDim2.new(0, 0, 0, 0),
        Size = UDim2.new(1, 0, 0, 20),
        BackgroundTransparency = 1,
        Parent = option.Main
    })

    option.Title = library:Create("TextLabel", {
        Position = UDim2.new(0, 24, 0, 0),
        Size = UDim2.new(1, 0, 1, 0),
        BackgroundTransparency = 1,
        Text = tostring(option.Text),
        TextColor3 = option.State and Color3.fromRGB(210, 210, 210) or Color3.fromRGB(180, 180, 180),
        TextSize = 15,
        Font = Enum.Font.Code,
        TextXAlignment = Enum.TextXAlignment.Left,
        Parent = option.Interest
    })

    if option.Lock then
        if option.State then
            option:SetState(not option.State)
        end

        option.Title.TextColor3 = Color3.fromRGB(160, 30, 30)
        TickBox.BorderColor3 = Color3.fromRGB(160, 30, 30)
        TickBoxOverlay.BorderColor3 = Color3.fromRGB(160, 30, 30)
    end

    option.Interest.InputBegan:Connect(function(input)
        if input.UserInputType.Name == "MouseButton1" then
            if option.Lock then
                return
            end

            option:SetState(not option.State)
        end

        if input.UserInputType.Name == "MouseMovement" then
            if not library.Warning and not library.Slider then
                if not option.Lock then
                    TweenService:Create(TickBox, TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
                        BorderColor3 = library.Flags["UI/Accent Color"]
                    }):Play()

                    TweenService:Create(TickBoxOverlay, TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
                        BorderColor3 = library.Flags["UI/Accent Color"]
                    }):Play()
                end
            end

            if option.Tip then
                library.ToolTip.Text = tostring(option.Tip)
                library.ToolTip.Size = UDim2.new(0, TextService:GetTextSize(option.Tip, 15, Enum.Font.Code, Vector2.new(9e9, 9e9)).X, 0, 20)
            end
        end
    end)

    option.Interest.InputChanged:Connect(function(input)
        if input.UserInputType.Name == "MouseMovement" then
            if option.Tip then
                library.ToolTip.Position = UDim2.new(0, input.Position.X + 26, 0, input.Position.Y + 36)
            end
        end
    end)

    option.Interest.InputEnded:Connect(function(input)
        if input.UserInputType.Name == "MouseMovement" then
            if not option.Lock then
                TweenService:Create(TickBox, TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
                    BorderColor3 = Color3.fromRGB(0, 0, 0)
                }):Play()

                TweenService:Create(TickBoxOverlay, TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
                    BorderColor3 = Color3.fromRGB(0, 0, 0)
                }):Play()
            end

            library.ToolTip.Position = UDim2.new(2)
        end
    end)

    --[
    --SetLock
    --]

    function option:SetLock(newLock)
        if option.State then
            option:SetState(not option.State)
        end

        option.Lock = newLock

        TweenService:Create(option.Title, TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
            TextColor3 = newLock and Color3.fromRGB(160, 30, 30) or (option.State and Color3.fromRGB(210, 210, 210) or Color3.fromRGB(180, 180, 180))
        }):Play()

        TweenService:Create(TickBox, TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
            BorderColor3 = newLock and Color3.fromRGB(160, 30, 30) or Color3.fromRGB(0, 0, 0)
        }):Play()

        TweenService:Create(TickBoxOverlay, TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
            BorderColor3 = newLock and Color3.fromRGB(160, 30, 30) or Color3.fromRGB(0, 0, 0)
        }):Play()
    end

    --[
    --SetState
    --]

    function option:SetState(state, noCallback)
        state = typeof(state) == "boolean" and state

        state = state or false

        library.Flags[self.Flag] = state

        self.State = state

        TweenService:Create(option.Title, TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
            TextColor3 = state and Color3.fromRGB(210, 210, 210) or Color3.fromRGB(160, 160, 160)
        }):Play()

        TickBoxOverlay.BackgroundTransparency = state and 1 or 0

        if not noCallback then
            self.Callback(state)
        end
    end

    if option.State ~= nil then
        delay(1, function()
            if library then
                option.Callback(option.State)
            end
        end)
    end

    setmetatable(option, {
        __newindex = function(t, i, v)
            if i == "Text" then
                option.Title.Text = tostring(v)
            end
        end
    })
end

--[
--Create
--]

function library:Create(class, props)
    if not class then
        return
    end

    props = props or {}

    local A = class == "Square" or class == "Line" or class == "Text" or class == "Quad" or class == "Circle" or class == "Triangle"

    local T = A and Drawing or Instance

    local Inst = T.new(class)

    if not A then
        if class == "ScreenGui" then
            if RunService:IsStudio() then
                Inst.Parent = script.Parent.Parent
            elseif gethui and syn then
                Inst.Parent = gethui()
            elseif gethui and not syn then
                Inst.Parent = gethui()
            elseif not gethui and syn and syn.protect_gui then
                pcall(function()
                    Inst.RobloxLocked = true
                end)

                syn.protect_gui(Inst)

                Inst.Parent = CoreGui
            else
                Inst.Parent = CoreGui
            end
        end
    end

    for p, v in next, props do
        Inst[p] = v
    end

    table.insert(self.Instances, {
        Object = Inst,
        Method = A
    })

    return Inst
end

--[
--AddConnection
--]

function library:AddConnection(connection, name, callback)
    callback = type(name) == "function" and name or callback

    connection = connection:Connect(callback)

    if name ~= callback then
        self.Connections[name] = connection
    else
        table.insert(self.Connections, connection)
    end

    return connection
end

--[
--Unload
--]

function library:Unload()
    for _, c in next, self.Connections do
        c:Disconnect()
    end

    for _, i in next, self.Instances do
        if i.Method then
            pcall(function()
                i.Object:Remove()
            end)
        else
            i.Object:Destroy()
        end
    end

    for _, o in next, self.Options do
        if o.Type == "Toggle" then
            coroutine.resume(coroutine.create(o.SetState, o))
        end
    end

    library = nil

    getgenv()["library"] = nil
    getgenv()["Watermark"] = nil
end

--[
--GetConfigs
--]

function library:GetConfigs()
    if not isfolder(self.FolderName) then
        makefolder(self.FolderName)
    end

    if not isfolder(self.ConfigFolderName) then
        makefolder(self.ConfigFolderName)

        return {}
    end

    local Files = {}

    local A = 0

    for i, v in next, listfiles(self.ConfigFolderName) do
        if v:sub(#v - #self.FileExt + 1, #v) == self.FileExt then
            A = A + 1

            v = v:gsub(self.ConfigFolderName .. "\\", "")
            v = v:gsub(self.FileExt, "")

            table.insert(Files, A, v)
        end
    end

    return Files
end

--[
--SaveConfig
--]

function library:SaveConfig(config)
    local Config = {}

    if table.find(self:GetConfigs(), config) then
        Config = HttpService:JSONDecode(readfile(self.ConfigFolderName .. "/" .. config .. self.FileExt))
    end

    for _, o in next, self.Options do
        if o.Type ~= "Button" and o.Flag and not o.SkipFlag then
            if o.Type == "Toggle" then
                Config[o.Flag] = o.State and 1 or 0
            elseif o.Type == "ColorPicker" then
                Config[o.Flag] = {
                    o.Color.R,
                    o.Color.G,
                    o.Color.B
                }

                if o.Transparency then
                    Config[o.Flag .. "_Transparency"] = o.Transparency
                end
            elseif o.Type == "Keybind" then
                if o.Key ~= "none" then
                    Config[o.Flag] = o.Key
                end
            elseif o.Type == "Dropdown" then
                Config[o.Flag] = o.Value
            else
                Config[o.Flag] = o.Value
            end
        end
    end

    writefile(self.ConfigFolderName .. "/" .. config .. self.FileExt, HttpService:JSONEncode(Config))
end

--[
--LoadConfig
--]

function library:LoadConfig(config)
    if table.find(self:GetConfigs(), config) then
        local Read, Config = pcall(function()
            return HttpService:JSONDecode(readfile(self.ConfigFolderName .. "/" .. config .. self.FileExt))
        end)

        Config = Read and Config or {}

        for _, o in next, self.Options do
            if o.HasInit then
                if o.Type ~= "Button" and o.Flag and not o.SkipFlag then
                    if o.Type == "Toggle" then
                        spawn(function()
                            o:SetState(Config[o.Flag] == 1)
                        end)
                    elseif o.Type == "ColorPicker" then
                        if Config[o.Flag] then
                            spawn(function()
                                o:SetColor(Config[o.Flag])
                            end)

                            if o.Transparency then
                                spawn(function()
                                    o:SetTransparency(Config[o.Flag .. "_Transparency"])
                                end)
                            end
                        end
                    elseif o.Type == "Keybind" then
                        spawn(function()
                            o:SetKey(Config[o.Flag])
                        end)
                    else
                        spawn(function()
                            o:SetValue(Config[o.Flag])
                        end)
                    end
                end
            end
        end
    end
end

--[
--CreateWatermark
--]

function library:CreateWatermark(name, pos)
    local Title = " " .. name:gsub("{game}", MarketplaceService:GetProductInfo(game.PlaceId).Name):gsub("{fps}", "0 FPS") .. " "

    local Watermark = library:Create("ScreenGui", {
        Name = "Watermark"
    })

    getgenv()["Watermark"] = Watermark

    local MainBar = library:Create("Frame", {
        Name = "MainBar",
        BorderColor3 = Color3.fromRGB(80, 80, 80),
        ZIndex = 5,
        Position = UDim2.new(0, pos and pos.X or 10, 0, pos and pos.Y or 10),
        Size = UDim2.new(0, 0, 0, 25),
        Parent = Watermark
    })

    local Gradient = library:Create("UIGradient", {
        Name = "Gradient",
        Rotation = 90,
        Color = ColorSequence.new({
            ColorSequenceKeypoint.new(0.000, Color3.fromRGB(40, 40, 40)),
            ColorSequenceKeypoint.new(1.000, Color3.fromRGB(10, 10, 10))
        }),
        Parent = MainBar
    })

    local Outline = library:Create("Frame", {
        Name = "Outline",
        ZIndex = 4,
        BorderSizePixel = 0,
        BackgroundColor3 = Color3.fromRGB(60, 60, 60),
        Position = UDim2.fromOffset(-1, -1),
        Parent = MainBar
    })

    local BlackOutline = library:Create("Frame", {
        Name = "BlackOutline",
        ZIndex = 3,
        BorderSizePixel = 0,
        BackgroundColor3 = Color3.fromRGB(0, 0, 0),
        Position = UDim2.fromOffset(-2, -2),
        Parent = MainBar
    })

    local Label = library:Create("TextLabel", {
        Name = "Label",
        Parent = MainBar,
        BackgroundTransparency = 1,
        Position = UDim2.new(0, 0, 0, 0),
        Size = UDim2.new(0, 238, 0, 25),
        Font = Enum.Font.Code,
        ZIndex = 6,
        Text = Title,
        TextColor3 = Color3.fromRGB(255, 255, 255),
        TextSize = 15,
        TextXAlignment = Enum.TextXAlignment.Left
    })

    Label.Size = UDim2.new(0, Label.TextBounds.X + 10, 0, 25)

    local TopBar = library:Create("Frame", {
        Name = "TopBar",
        Parent = MainBar,
        ZIndex = 6,
        BackgroundColor3 = library.Flags["UI/Accent Color"],
        BorderSizePixel = 0,
        Size = UDim2.new(0, 0, 0, 1)
    })

    table.insert(library.Theme, TopBar)

    MainBar.Size = UDim2.new(0, Label.TextBounds.X, 0, 25)
    TopBar.Size = UDim2.new(0, Label.TextBounds.X + 6, 0, 1)

    Outline.Size = MainBar.Size + UDim2.fromOffset(2, 2)
    BlackOutline.Size = MainBar.Size + UDim2.fromOffset(4, 4)

    MainBar.Size = UDim2.new(0, Label.TextBounds.X + 4, 0, 25)
    Label.Size = UDim2.new(0, Label.TextBounds.X + 4, 0, 25)
    TopBar.Size = UDim2.new(0, Label.TextBounds.X + 6, 0, 1)

    Outline.Size = MainBar.Size + UDim2.fromOffset(2, 2)
    BlackOutline.Size = MainBar.Size + UDim2.fromOffset(4, 4)

    local StartTime, Counter, OldFPS = os.clock(), 0, nil

    library:AddConnection(RunService.Heartbeat, function()
        if not name:find("{fps}") then
            Label.Text = " " .. name:gsub("{game}", MarketplaceService:GetProductInfo(game.PlaceId).Name):gsub("{fps}", "0 FPS") .. " "
        end

        if name:find("{fps}") then
            local CurrentTime = os.clock()

            Counter = Counter + 1

            if CurrentTime - StartTime >= 1 then
                local FPS = math.floor(Counter / (CurrentTime - StartTime))

                Counter = 0

                StartTime = CurrentTime

                if FPS ~= OldFPS then
                    Label.Text = " " .. name:gsub("{game}", MarketplaceService:GetProductInfo(game.PlaceId).Name):gsub("{fps}", FPS .. " FPS") .. " "
                    Label.Size = UDim2.new(0, Label.TextBounds.X + 10, 0, 25)
                    MainBar.Size = UDim2.new(0, Label.TextBounds.X, 0, 25)
                    TopBar.Size = UDim2.new(0, Label.TextBounds.X, 0, 1)

                    Outline.Size = MainBar.Size + UDim2.fromOffset(2, 2)
                    BlackOutline.Size = MainBar.Size + UDim2.fromOffset(4, 4)
                end

                OldFPS = FPS
            end
        end
    end)

    library:AddConnection(MainBar.MouseEnter, function()
        TweenService:Create(MainBar, TweenInfo.new(0.2, Enum.EasingStyle.Linear, Enum.EasingDirection.In), {
            BackgroundTransparency = 1,
            Active = false
        }):Play()

        TweenService:Create(TopBar, TweenInfo.new(0.2, Enum.EasingStyle.Linear, Enum.EasingDirection.In), {
            BackgroundTransparency = 1,
            Active = false
        }):Play()

        TweenService:Create(Label, TweenInfo.new(0.2, Enum.EasingStyle.Linear, Enum.EasingDirection.In), {
            TextTransparency = 1,
            Active = false
        }):Play()

        TweenService:Create(Outline, TweenInfo.new(0.2, Enum.EasingStyle.Linear, Enum.EasingDirection.In), {
            BackgroundTransparency = 1,
            Active = false
        }):Play()

        TweenService:Create(BlackOutline, TweenInfo.new(0.2, Enum.EasingStyle.Linear, Enum.EasingDirection.In), {
            BackgroundTransparency = 1,
            Active = false
        }):Play()
    end)

    library:AddConnection(MainBar.MouseLeave, function()
        TweenService:Create(MainBar, TweenInfo.new(0.2, Enum.EasingStyle.Linear, Enum.EasingDirection.In), {
            BackgroundTransparency = 0,
            Active = true
        }):Play()

        TweenService:Create(TopBar, TweenInfo.new(0.2, Enum.EasingStyle.Linear, Enum.EasingDirection.In), {
            BackgroundTransparency = 0,
            Active = true
        }):Play()

        TweenService:Create(Label, TweenInfo.new(0.2, Enum.EasingStyle.Linear, Enum.EasingDirection.In), {
            TextTransparency = 0,
            Active = true
        }):Play()

        TweenService:Create(Outline, TweenInfo.new(0.2, Enum.EasingStyle.Linear, Enum.EasingDirection.In), {
            BackgroundTransparency = 0,
            Active = true
        }):Play()

        TweenService:Create(BlackOutline, TweenInfo.new(0.2, Enum.EasingStyle.Linear, Enum.EasingDirection.In), {
            BackgroundTransparency = 0,
            Active = true
        }):Play()
    end)
end

--[
--CreateTab
--]

function library:CreateTab(title, pos)
    local Tab = {
        CanInit = true,
        Tabs = {},
        Columns = {},
        Title = tostring(title)
    }

    table.insert(self.Tabs, pos or #self.Tabs + 1, Tab)

    --[
    --CreateColumn
    --]

    function Tab:CreateColumn()
        local Column = {
            Sections = {},
            Position = #self.Columns,
            CanInit = true,
            Tab = self
        }

        table.insert(self.Columns, Column)

        --[
        --CreateSection
        --]

        function Column:CreateSection(title)
            local Section = {
                Title = tostring(title),
                Options = {},
                CanInit = true,
                Column = self
            }

            table.insert(self.Sections, Section)

            --[
            --AddLabel
            --]

            function Section:AddLabel(text, color)
                local Option = {
                    Text = text,
                    Color = color
                }

                Option.Section = self
                Option.Type = "Label"
                Option.Position = #self.Options
                Option.CanInit = true

                table.insert(self.Options, Option)

                if library.HasInit and self.HasInit then
                    library.CreateLabel(Option, self.Content)
                else
                    Option.Init = library.CreateLabel
                end

                return Option
            end

            --[
            --AddDivider
            --]

            function Section:AddDivider(text)
                local Option = {
                    Text = text
                }

                Option.Section = self
                Option.Type = "Divider"
                Option.Position = #self.Options
                Option.CanInit = true

                table.insert(self.Options, Option)

                if library.HasInit and self.HasInit then
                    library.CreateDivider(Option, self.Content)
                else
                    Option.Init = library.CreateDivider
                end

                return Option
            end

            --[
            --AddButton
            --]

            function Section:AddButton(option)
                option = typeof(option) == "table" and option or {}

                option.Section = self
                option.Text = tostring(option.Text)
                option.Callback = typeof(option.Callback) == "function" and option.Callback or function () end
                option.Lock = option.Lock or false
                option.Type = "Button"
                option.Position = #self.Options
                option.Flag = (library.FlagPrefix and library.FlagPrefix .. " " or "") .. (option.Flag or option.Text)
                option.SubCount = 0
                option.CanInit = (option.CanInit ~= nil and option.CanInit) or true
                option.Tip = option.Tip and tostring(option.Tip)

                table.insert(self.Options, option)

                library.Options[option.Flag] = option

                if library.HasInit and self.HasInit then
                    library.CreateButton(option, self.Content)
                else
                    option.Init = library.CreateButton
                end

                return option
            end

            --[
            --AddToggle
            --]

            function Section:AddToggle(option)
                option = typeof(option) == "table" and option or {}

                option.Section = self
                option.Text = tostring(option.Text)
                option.State = option.State == nil and nil or (typeof(option.State) == "boolean" and option.State or false)
                option.Callback = typeof(option.Callback) == "function" and option.Callback or function () end
                option.Lock = option.Lock or false
                option.Type = "Toggle"
                option.Position = #self.Options
                option.Flag = (library.FlagPrefix and library.FlagPrefix .. " " or "") .. (option.Flag or option.Text)
                option.SubCount = 0
                option.CanInit = (option.CanInit ~= nil and option.CanInit) or true
                option.Tip = option.Tip and tostring(option.Tip)

                library.Flags[option.Flag] = option.State

                table.insert(self.Options, option)

                library.Options[option.Flag] = option

                if library.HasInit and self.HasInit then
                    library.CreateToggle(option, self.Content)
                else
                    option.Init = library.CreateToggle
                end

                return option
            end

            --[
            --Init (Section)
            --]

            function Section:Init()
                if self.HasInit then
                    return
                end

                self.HasInit = true

                self.Main = library:Create("Frame", {
                    BackgroundColor3 = Color3.fromRGB(30, 30, 30),
                    BorderColor3 = Color3.fromRGB(0, 0, 0),
                    Parent = Column.Main
                })

                self.Content = library:Create("Frame", {
                    Size = UDim2.new(1, 0, 1, 0),
                    BackgroundColor3 = Color3.fromRGB(30, 30, 30),
                    BorderColor3 = Color3.fromRGB(60, 60, 60),
                    BorderMode = Enum.BorderMode.Inset,
                    Parent = self.Main
                })

                library:Create("ImageLabel", {
                    Size = UDim2.new(1, -2, 1, -2),
                    Position = UDim2.new(0, 1, 0, 1),
                    BackgroundTransparency = 1,
                    Image = "rbxassetid://2592362371",
                    ImageColor3 = Color3.fromRGB(0, 0, 0),
                    ScaleType = Enum.ScaleType.Slice,
                    SliceCenter = Rect.new(2, 2, 62, 62),
                    Parent = self.Main
                })

                table.insert(library.Theme, library:Create("Frame", {
                    Size = UDim2.new(1, 0, 0, 1),
                    BackgroundColor3 = library.Flags["UI/Accent Color"],
                    BorderSizePixel = 0,
                    Parent = self.Main
                }))

                local Layout = library:Create("UIListLayout", {
                    HorizontalAlignment = Enum.HorizontalAlignment.Center,
                    SortOrder = Enum.SortOrder.LayoutOrder,
                    Padding = UDim.new(0, 2),
                    Parent = self.Content
                })

                library:Create("UIPadding", {
                    PaddingTop = UDim.new(0, 12),
                    Parent = self.Content
                })

                self.TitleText = library:Create("TextLabel", {
                    AnchorPoint = Vector2.new(0, 0.5),
                    Position = UDim2.new(0, 12, 0, 0),
                    Size = UDim2.new(0, TextService:GetTextSize(self.Title, 15, Enum.Font.Code, Vector2.new(9e9, 9e9)).X + 10, 0, 3),
                    BackgroundColor3 = Color3.fromRGB(30, 30, 30),
                    BorderSizePixel = 0,
                    Text = self.Title,
                    TextSize = 15,
                    Font = Enum.Font.Code,
                    TextColor3 = Color3.fromRGB(255, 255, 255),
                    Parent = self.Main
                })

                Layout.Changed:Connect(function()
                    self.Main.Size = UDim2.new(1, 0, 0, Layout.AbsoluteContentSize.Y + 16)
                end)

                for _, o in next, self.Options do
                    if o.CanInit then
                        o.Init(o, self.Content)
                    end
                end
            end

            if library.HasInit and self.HasInit then
                Section:Init()
            end

            return Section
        end

        --[
        --Init (Column)
        --]

        function Column:Init()
            if self.HasInit then
                return
            end

            self.HasInit = true

            self.Main = library:Create("ScrollingFrame", {
                ZIndex = 2,
                Position = UDim2.new(0, 6 + (self.Position * 239), 0, 2),
                Size = UDim2.new(0, 233, 1, -4),
                BackgroundTransparency = 1,
                BorderSizePixel = 0,
                ScrollBarImageColor3 = Color3.fromRGB(0, 0, 0),
                ScrollBarThickness = 4,
                VerticalScrollBarInset = Enum.ScrollBarInset.ScrollBar,
                ScrollingDirection = Enum.ScrollingDirection.Y,
                Visible = false,
                Parent = library.ColumnHolder
            })

            local Layout = library:Create("UIListLayout", {
                HorizontalAlignment = Enum.HorizontalAlignment.Center,
                SortOrder = Enum.SortOrder.LayoutOrder,
                Padding = UDim.new(0, 12),
                Parent = self.Main
            })

            library:Create("UIPadding", {
                PaddingTop = UDim.new(0, 8),
                PaddingLeft = UDim.new(0, 2),
                PaddingRight = UDim.new(0, 2),
                Parent = self.Main
            })

            Layout.Changed:Connect(function()
                self.Main.CanvasSize = UDim2.new(0, 0, 0, Layout.AbsoluteContentSize.Y + 14)
            end)

            for _, s in next, self.Sections do
                if s.CanInit and #s.Options > 0 then
                    s:Init()
                end
            end
        end

        if library.HasInit and self.HasInit then
            Column:Init()
        end

        return Column
    end

    --[
    --Init (Tab)
    --]

    function Tab:Init()
        if self.HasInit then
            return
        end

        self.HasInit = true

        local Size = TextService:GetTextSize(self.Title, 18, Enum.Font.Code, Vector2.new(9e9, 9e9)).X + 10

        self.Button = library:Create("TextLabel", {
            Position = UDim2.new(0, library.TabSize, 0, 22),
            Size = UDim2.new(0, Size, 0, 30),
            BackgroundTransparency = 1,
            Text = self.Title,
            TextColor3 = Color3.fromRGB(255, 255, 255),
            TextSize = 15,
            Font = Enum.Font.Code,
            TextWrapped = true,
            ClipsDescendants = true,
            Parent = library.Main
        })

        library.TabSize = library.TabSize + Size

        self.Button.InputBegan:Connect(function(input)
            if input.UserInputType.Name == "MouseButton1" then
                library:SelectTab(self)
            end
        end)

        for _, c in next, self.Columns do
            if c.CanInit then
                c:Init()
            end
        end
    end

    if self.HasInit then
        Tab:Init()
    end

    return Tab
end

--[
--Init (Window)
--]

function library:Init()
    if self.HasInit then
        return
    end

    self.HasInit = true

    library:CreateWatermark("Break-Skill Hub - V1 | {game} | {fps}")

    self.Base = library:Create("ScreenGui", {
        Name = "Base",
        IgnoreGuiInset = true,
        ZIndexBehavior = Enum.ZIndexBehavior.Global
    })

    self.Main = self:Create("ImageButton", {
        AutoButtonColor = false,
        Position = UDim2.new(0, 100, 0, 46),
        Size = UDim2.new(0, 500, 0, 600),
        BackgroundColor3 = Color3.fromRGB(20, 20, 20),
        BorderColor3 = Color3.fromRGB(0, 0, 0),
        ScaleType = Enum.ScaleType.Tile,
        Modal = true,
        Parent = self.Base
    })

    self.Top = self:Create("Frame", {
        Size = UDim2.new(1, 0, 0, 50),
        BackgroundColor3 = Color3.fromRGB(30, 30, 30),
        BorderColor3 = Color3.fromRGB(0, 0, 0),
        Parent = self.Main
    })

    self:Create("TextLabel", {
        Position = UDim2.new(0, 6, 0, -1),
        Size = UDim2.new(0, 0, 0, 20),
        BackgroundTransparency = 1,
        Text = tostring(self.Title),
        Font = Enum.Font.Code,
        TextSize = 18,
        TextColor3 = Color3.fromRGB(255, 255, 255),
        TextXAlignment = Enum.TextXAlignment.Left,
        Parent = self.Main
    })

    table.insert(library.Theme, self:Create("Frame", {
        Size = UDim2.new(1, 0, 0, 1),
        Position = UDim2.new(0, 0, 0, 24),
        BackgroundColor3 = library.Flags["UI/Accent Color"],
        BorderSizePixel = 0,
        Parent = self.Main
    }))

    library:Create("ImageLabel", {
        Size = UDim2.new(1, 0, 1, 0),
        BackgroundTransparency = 1,
        Image = "rbxassetid://2454009026",
        ImageColor3 = Color3.fromRGB(0, 0, 0),
        ImageTransparency = 0.4,
        Parent = self.Top
    })

    self.TabHighlight = self:Create("Frame", {
        BackgroundColor3 = library.Flags["UI/Accent Color"],
        BorderSizePixel = 0,
        Parent = self.Main
    })

    table.insert(library.Theme, self.TabHighlight)

    self.ColumnHolder = self:Create("Frame", {
        Position = UDim2.new(0, 5, 0, 55),
        Size = UDim2.new(1, -10, 1, -60),
        BackgroundTransparency = 1,
        Parent = self.Main
    })

    self.ToolTip = self:Create("TextLabel", {
        ZIndex = 2,
        BackgroundTransparency = 1,
        BorderSizePixel = 0,
        TextSize = 15,
        Font = Enum.Font.Code,
        TextColor3 = Color3.fromRGB(255, 255, 255),
        Visible = true,
        Parent = self.Base
    })

    self:Create("Frame", {
        AnchorPoint = Vector2.new(0.5, 0),
        Position = UDim2.new(0.5, 0, 0, 0),
        Size = UDim2.new(1, 10, 1, 0),
        Style = Enum.FrameStyle.RobloxRound,
        Parent = self.ToolTip
    })

    self:Create("ImageLabel", {
        Size = UDim2.new(1, 0, 1, 0),
        BackgroundTransparency = 1,
        Image = "rbxassetid://2592362371",
        ImageColor3 = Color3.fromRGB(60, 60, 60),
        ScaleType = Enum.ScaleType.Slice,
        SliceCenter = Rect.new(2, 2, 62, 62),
        Parent = self.Main
    })

    self:Create("ImageLabel", {
        Size = UDim2.new(1, -2, 1, -2),
        Position = UDim2.new(0, 1, 0, 1),
        BackgroundTransparency = 1,
        Image = "rbxassetid://2592362371",
        ImageColor3 = Color3.fromRGB(0, 0, 0),
        ScaleType = Enum.ScaleType.Slice,
        SliceCenter = Rect.new(2, 2, 62, 62),
        Parent = self.Main
    })

    self.Top.InputBegan:Connect(function(input)
        if input.UserInputType.Name == "MouseButton1" then
            DragObject = self.Main

            Dragging = true

            DragStart = input.Position

            StartPos = DragObject.Position

            if library.Popup then
                library.Popup:Close()
            end
        end
    end)

    self.Top.InputChanged:Connect(function(input)
        if Dragging and input.UserInputType.Name == "MouseMovement" then
            DragInput = input
        end
    end)

    self.Top.InputEnded:Connect(function(input)
        if input.UserInputType.Name == "MouseButton1" then
            Dragging = false
        end
    end)

    spawn(function()
        while library do
            task.wait(1)

            local Configs = self:GetConfigs()

            for _, c in next, Configs do
                if not table.find(self.Options["Config List"].Values, c) then
                    self.Options["Config List"]:AddValue(c)
                end
            end

            for _, c in next, self.Options["Config List"].Values do
                if not table.find(Configs, c) then
                    self.Options["Config List"]:RemoveValue(c)
                end
            end
        end
    end)

    --[
    --SelectTab
    --]

    function self:SelectTab(tab)
        if self.CurrentTab == tab then
            return
        end

        if library.Popup then
            library.Popup:Close()
        end

        if self.CurrentTab then
            TweenService:Create(self.CurrentTab.Button, TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
                TextColor3 = Color3.fromRGB(255, 255, 255)
            }):Play()

            for _, c in next, self.CurrentTab.Columns do
                c.Main.Visible = false
            end
        end

        self.Main.Size = UDim2.new(0, 16 + ((#tab.Columns < 2 and 2 or #tab.Columns) * 239), 0, 600)

        self.CurrentTab = tab

        TweenService:Create(tab.Button, TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
            TextColor3 = library.Flags["UI/Accent Color"]
        }):Play()

        self.TabHighlight:TweenPosition(UDim2.new(0, tab.Button.Position.X.Offset, 0, 50), "Out", "Quad", 0.2, true)
        self.TabHighlight:TweenSize(UDim2.new(0, tab.Button.AbsoluteSize.X, 0, -1), "Out", "Quad", 0.2, true)

        for _, c in next, tab.Columns do
            c.Main.Visible = true
        end
    end

    for _, t in next, self.Tabs do
        if t.CanInit then
            t:Init()

            self:SelectTab(t)
        end
    end

    self:AddConnection(UserInputService.InputEnded, function(input)
        if input.UserInputType.Name == "MouseButton1" and self.Slider then
            local Tween = TweenService:Create(self.Slider.Slider, TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
                Color3.fromRGB(0, 0, 0)
            })

            Tween:Play()

            Tween.Completed:Wait()

            self.Slider = nil
        end
    end)

    self:AddConnection(UserInputService.InputChanged, function(input)
        if not self.Open then
            return
        end

        if input.UserInputType.Name == "MouseMovement" then
            if self.Slider then
                self.Slider:SetValue(self.Slider.Min + ((input.Position.X - self.Slider.Slider.AbsolutePosition.X) / self.Slider.Slider.AbsoluteSize.X) * (self.Slider.Max - self.Slider.Min))
            end
        end

        if input == DragInput and Dragging and library.Draggable then
            local Delta = input.Position - DragStart

            local YPos = (StartPos.Y.Offset + Delta.Y) < -36 and -36 or StartPos.Y.Offset + Delta.Y

            DragObject:TweenPosition(UDim2.new(StartPos.X.Scale, StartPos.X.Offset + Delta.X, StartPos.Y.Scale, YPos), "Out", "Quad", 0.2, true)
        end
    end)

    local OldIndex

    OldIndex = hookmetamethod(game, "__index", function(t, i)
        if checkcaller() then
            return OldIndex(t, i)
        end

        return OldIndex(t, i)
    end)

    local OldNewIndex

    OldNewIndex = hookmetamethod(game, "__newindex", function(t, i, v)
        if checkcaller() then
            return OldNewIndex(t, i, v)
        end

        return OldNewIndex(t, i, v)
    end)

    if not getgenv()["Silent"] then
        delay(1, function()
            self:Close()
        end)
    end
end

--[
--Close
--]

function library:Close()
    self.Open = not self.Open

    if self.Main then
        if self.Popup then
            self.Popup:Close()
        end

        self.Main.Visible = self.Open
    end
end
