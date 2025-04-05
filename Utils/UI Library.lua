--//
--// UI Library Made By xS_Killus
--//

local HttpService = game:GetService("HttpService")
local RunService = game:GetService("RunService")
local TextService = game:GetService("TextService")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local CoreGui = game:GetService("CoreGui")

if getgenv()["library"] then
    getgenv()["library"]:Unload()
end

local library = {
    Title = "Break-Skill Hub - V1",
    FolderName = "Break-Skill Hub - V1",
    FileExt = ".json",
    Draggable = true,
    Open = false,
    Popup = nil,
    TabSize = 0,
    Tabs = {},
    Flags = {},
    Instances = {},
    Connections = {},
    Options = {},
    Notifications = {},
    Theme = {},
    Design = getgenv()["Design"] == "kali" and "kali" or "uwuware",
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
    Enum.KeyCode.Escape
}

local WhitelistedMouseInputs = {
    Enum.UserInputType.MouseButton1,
    Enum.UserInputType.MouseButton2,
    Enum.UserInputType.MouseButton3
}

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

local ChromaColor

spawn(function()
    while library and wait() do
        ChromaColor = Color3.fromHSV(tick() % 6 / 6, 1, 1)
    end
end)

--// library:Create(class, props)

function library:Create(class, props)
    props = props or {}

    if not class then
        return
    end

    local A = class == "Square" or class == "Line" or class == "Text" or class == "Quad" or class == "Circle" or class == "Triangle"

    local T = A and Drawing or Instance

    local Inst = T.new(class)

    for p, v in next, props do
        Inst[p] = v
    end

    table.insert(self.Instances, {
        Object = Inst,
        Method = A
    })

    return Inst
end

--// library:AddConnection(connection, name, callback)

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

--// library:Unload()

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
        if o.Type == "toggle" then
            coroutine.resume(coroutine.create(o.SetValue, o))
        end
    end

    library = nil

    getgenv()["library"] = nil
end

--// library:LoadConfig(config)

function library:LoadConfig(config)
    if table.find(self:GetConfigs(), config) then
        local Read, Config = pcall(function()
            return HttpService:JSONDecode(readfile(self.FolderName .. "/" .. config .. self.FileExt))
        end)

        Config = Read and Config or {}

        for _, o in next, self.Options do
            if o.HasInit then
                if o.Type ~= "Button" and o.Flag and not o.SkipFlag then
                    if o.Type == "Toggle" then
                        spawn(function()
                            o:SetValue(Config[o.Flag] == 1)
                        end)
                    elseif o.Type == "ColorPicker" then
                        if Config[o.Flag] then
                            spawn(function()
                                o:SetColor(Config[o.Flag])
                            end)

                            if o.Transparency then
                                spawn(function()
                                    o:SetTransparency(Config[o.Flag] .. "_Transparency")
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

--// library:SaveConfig(config)

function library:SaveConfig(config)
    local Config = {}

    if table.find(self:GetConfigs(), config) then
        Config = HttpService:JSONDecode(readfile(self.FolderName .. "/" .. config .. self.FileExt))
    end

    for _, o in next, self.Options do
        if o.Type ~= "Button" and o.Flag and not o.SkipFlag then
            if o.Type == "Toggle" then
                Config[o.Flag] = o.Value and 1 or 0
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

    writefile(self.FolderName .. "/" .. config .. self.FileExt, HttpService:JSONEncode(Config))
end

--// library:GetConfigs()

function library:GetConfigs()
    if not isfolder(self.FolderName) then
        makefolder(self.FolderName)

        return {}
    end

    local Files = {}

    local A = 0

    for i, v in next, listfiles(self.FolderName) do
        if v:sub(#v - #self.FileExt + 1, #v) == self.FileExt then
            A = A + 1

            v = v:gsub(self.FolderName .. "\\", "")
            v = v:gsub(self.FileExt, "")

            table.insert(Files, A, v)
        end
    end

    return Files
end

--// library.CreateLabel

library.CreateLabel = function(option, parent)
    option.Main = library:Create("TextLabel", {
        LayoutOrder = option.Position,
        Position = UDim2.new(0, 6, 0, 0),
        Size = UDim2.new(1, -12, 0, 24),
        BackgroundTransparency = 1,
        TextSize = 15,
        Font = Enum.Font.Code,
        TextColor3 = Color3.fromRGB(255, 255, 255),
        TextXAlignment = Enum.TextXAlignment.Left,
        TextYAlignment = Enum.TextYAlignment.Top,
        TextWrapped = true,
        Parent = parent
    })

    --// option:SetText(text)

    function option:SetText(text)
        text = typeof(text) == "string" and text
        text = text or self.Text

        self.Text = text
        self.text = text

        option.Main.Text = text
        option.Main.Size = UDim2.new(1, -12, 0, TextService:GetTextSize(option.Main.Text, 15, Enum.Font.Code, Vector2.new(option.Main.AbsoluteSize.X, 9e9)).Y + 6)
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

--// library.CreateDivider

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
        TextColor3 = Color3.fromRGB(255, 255, 255),
        TextSize = 15,
        Font = Enum.Font.Code,
        TextXAlignment = Enum.TextXAlignment.Center,
        Parent = option.Main
    })

    --// option:SetText(text)

    function option:SetText(text)
        text = typeof(text) == "string" and text
        text = text or self.Text

        self.Text = text
        self.text = text

        option.Title.Text = text
        option.Title.Size = UDim2.new(0, TextService:GetTextSize(option.Title.Text, 15, Enum.Font.Code, Vector2.new(9e9, 9e9)).X + 12, 0, 20)

        option.Main.Size = UDim2.new(1, 0, 0, 18)
    end

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

--// library.CreateButton

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
        Text = option.Text,
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
        ScaleType = Enum.ScaleType.Slice,
        SliceCenter = Rect.new(2, 2, 62, 62),
        Parent = option.Title
    })

    library:Create("UIGradient", {
        Color = ColorSequence.new({
            ColorSequenceKeypoint.new(0, Color3.fromRGB(180, 180, 180)),
            ColorSequenceKeypoint.new(1, Color3.fromRGB(255, 255, 255))
        }),
        Rotation = -90,
        Parent = option.Title
    })

    option.Title.InputBegan:Connect(function(input)
        if input.UserInputType.Name == "MouseButton1" then
            option.Callback()

            if library then
                library.Flags[option.Flag] = true
            end

            if option.Tip then
                library.ToolTip.Text = option.Tip
                library.ToolTip.Size = UDim2.new(0, TextService:GetTextSize(option.Tip, 15, Enum.Font.Code, Vector2.new(9e9, 9e9)).X, 0, 20)
            end
        end

        if input.UserInputType.Name == "MouseMovement" then
            if not library.Warning and not library.Slider then
                TweenService:Create(option.Title, TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
                    BorderColor3 = library.Flags["Menu Accent Color"]
                }):Play()
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
            TweenService:Create(option.Title, TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
                BorderColor3 = Color3.fromRGB(0, 0, 0)
            }):Play()

            library.ToolTip.Position = UDim2.new(2)
        end
    end)
end

--// library.CreateToggle

library.CreateToggle = function(option, parent)
    option.HasInit = true

    option.Main = library:Create("Frame", {
        LayoutOrder = option.Position,
        Size = UDim2.new(1, 0, 0, 20),
        BackgroundTransparency = 1,
        Parent = parent
    })

    local TickBox
    local TickBoxOverlay

    if option.Style then
        TickBox = library:Create("ImageLabel", {
            Position = UDim2.new(0, 6, 0, 4),
            Size = UDim2.new(0, 12, 0, 12),
            BackgroundTransparency = 1,
            Image = "rbxassetid://3570695787",
            ImageColor3 = Color3.fromRGB(0, 0, 0),
            Parent = option.Main
        })

        library:Create("ImageLabel", {
            AnchorPoint = Vector2.new(0.5, 0.5),
            Position = UDim2.new(0.5, 0, 0.5, 0),
            Size = UDim2.new(1, -2, 1, -2),
            BackgroundTransparency = 1,
            Image = "rbxassetid://3570695787",
            ImageColor3 = Color3.fromRGB(60, 60, 60),
            Parent = TickBox
        })

        library:Create("ImageLabel", {
            AnchorPoint = Vector2.new(0.5, 0.5),
            Position = UDim2.new(0.5, 0, 0.5, 0),
            Size = UDim2.new(1, -6, 1, -6),
            BackgroundTransparency = 1,
            Image = "rbxassetid://3570695787",
            ImageColor3 = Color3.fromRGB(40, 40, 40),
            Parent = TickBox
        })

        TickBoxOverlay = library:Create("ImageLabel", {
            AnchorPoint = Vector2.new(0.5, 0.5),
            Position = UDim2.new(0.5, 0, 0.5, 0),
            Size = UDim2.new(1, -6, 1, -6),
            BackgroundTransparency = 1,
            Image = "rbxassetid://3570695787",
            ImageColor3 = library.Flags["Menu Accent Color"],
            Visible = option.Value,
            Parent = TickBox
        })

        library:Create("ImageLabel", {
            AnchorPoint = Vector2.new(0.5, 0.5),
            Position = UDim2.new(0.5, 0, 0.5, 0),
            Size = UDim2.new(1, 0, 1, 0),
            BackgroundTransparency = 1,
            Image = "rbxassetid://594135943",
            ImageTransparency = 0.6,
            Parent = TickBox
        })

        table.insert(library.Theme, TickBoxOverlay)
    else
        TickBox = library:Create("Frame", {
            Position = UDim2.new(0, 6, 0, 4),
            Size = UDim2.new(0, 12, 0, 12),
            BackgroundColor3 = library.Flags["Menu Accent Color"],
            BorderColor3 = Color3.fromRGB(0, 0, 0),
            Parent = option.Main
        })

        TickBoxOverlay = library:Create("ImageLabel", {
            Size = UDim2.new(1, 0, 1, 0),
            BackgroundTransparency = option.Value and 1 or 0,
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
    end

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
        Text = option.Text,
        TextColor3 = option.Value and Color3.fromRGB(210, 210, 210) or Color3.fromRGB(180, 180, 180),
        TextSize = 15,
        Font = Enum.Font.Code,
        TextXAlignment = Enum.TextXAlignment.Left,
        Parent = option.Interest
    })

    option.Interest.InputBegan:Connect(function(input)
        if input.UserInputType.Name == "MouseButton1" then
            option:SetValue(not option.Value)
        end

        if input.UserInputType.Name == "MouseMovement" then
            if not library.Warning and not library.Slider then
                if option.Style then
                    TweenService:Create(TickBox, TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
                        ImageColor3 = library.Flags["Menu Accent Color"]
                    }):Play()
                else
                    TweenService:Create(TickBox, TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
                        BorderColor3 = library.Flags["Menu Accent Color"]
                    }):Play()
                    TweenService:Create(TickBoxOverlay, TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
                        BorderColor3 = library.Flags["Menu Accent Color"]
                    }):Play()
                end
            end

            if option.Tip then
                library.ToolTip.Text = option.Tip
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
            if option.Style then
                TweenService:Create(TickBox, TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
                    ImageColor3 = Color3.fromRGB(0, 0, 0)
                }):Play()
            else
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

    --// option:SetValue(value, noCallback)

    function option:SetValue(value, noCallback)
        value = typeof(value) == "boolean" and value
        value = value or false

        library.Flags[self.Flag] = value

        self.Value = value

        option.Title.TextColor3 = value and Color3.fromRGB(210, 210, 210) or Color3.fromRGB(160, 160, 160)

        if option.Style then
            TickBoxOverlay.Visible = value
        else
            TickBoxOverlay.BackgroundTransparency = value and 1 or 0
        end

        if not noCallback then
            self.Callback(value)
        end
    end

    if option.Value ~= nil then
        delay(1, function()
            if library then
                option.Callback(option.Value)
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

--// library.CreateKeybind

library.CreateKeybind = function(option, parent)
    option.HasInit = true

    local Binding
    local Loop

    if option.Sub then
        option.Main = option:GetMain()
    else
        option.Main = option.Main or library:Create("Frame", {
            LayoutOrder = option.Position,
            Size = UDim2.new(1, 0, 0, 20),
            BackgroundTransparency = 1,
            Parent = parent
        })

        library:Create("TextLabel", {
            Position = UDim2.new(0, 6, 0, 0),
            Size = UDim2.new(1, -12, 1, 0),
            BackgroundTransparency = 1,
            Text = option.Text,
            TextSize = 15,
            Font = Enum.Font.Code,
            TextColor3 = Color3.fromRGB(210, 210, 210),
            TextXAlignment = Enum.TextXAlignment.Left,
            Parent = option.Main
        })
    end

    local BindInput = library:Create(option.Sub and "TextButton" or "TextLabel", {
        Position = UDim2.new(1, -6 - (option.SubPos or 0), 0, option.Sub and 2 or 3),
        SizeConstraint = Enum.SizeConstraint.RelativeYY,
        BackgroundColor3 = Color3.fromRGB(30, 30, 30),
        BorderSizePixel = 0,
        TextSize = 15,
        Font = Enum.Font.Code,
        TextColor3 = Color3.fromRGB(160, 160, 160),
        TextXAlignment = Enum.TextXAlignment.Right,
        Parent = option.Main
    })

    if option.Sub then
        BindInput.AutoButtonColor = false
    end

    local Interest = option.Sub and BindInput or option.Main

    Interest.InputEnded:Connect(function(input)
        if input.UserInputType.Name == "MouseButton1" then
            Binding = true

            BindInput.Text = "[...]"
            BindInput.Size = UDim2.new(0, -TextService:GetTextSize(BindInput.Text, 16, Enum.Font.Code, Vector2.new(9e9, 9e9)).X, 0, 16)

            TweenService:Create(BindInput, TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
                TextColor3 = library.Flags["Menu Accent Color"]
            }):Play()
        end
    end)

    library:AddConnection(UserInputService.InputBegan, function(input)
        if UserInputService:GetFocusedTextBox() then
            return
        end

        if Binding then
            local Key = (table.find(WhitelistedMouseInputs, input.UserInputType) and not option.NoMouse) and input.UserInputType

            option:SetKey(Key or (not table.find(BlacklistedKeys, input.KeyCode)) and input.KeyCode)
        else
            if (input.KeyCode.Name == option.Key or input.UserInputType.Name == option.Key) and not Binding then
                if option.Mode == "Toggle" then
                    library.Flags[option.Flag] = not library.Flags[option.Flag]

                    option.Callback(library.Flags[option.Flag], 0)
                else
                    library.Flags[option.Flag] = true

                    if Loop then
                        Loop:Disconnect()

                        option.Callback(true, 0)
                    end

                    Loop = library:AddConnection(RunService.RenderStepped, function(step)
                        if not UserInputService:GetFocusedTextBox() then
                            option.Callback(nil, step)
                        end
                    end)
                end
            end
        end
    end)

    library:AddConnection(UserInputService.InputEnded, function(input)
        if option.Key ~= "none" then
            if input.KeyCode.Name == option.Key or input.UserInputType.Name == option.Key then
                if Loop then
                    Loop:Disconnect()

                    library.Flags[option.Flag] = false

                    option.Callback(true, 0)
                end
            end
        end
    end)

    --// option:SetKey(key)

    function option:SetKey(key)
        Binding = false

        TweenService:Create(BindInput, TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
            TextColor3 = Color3.fromRGB(160, 160, 160)
        }):Play()

        if Loop then
            Loop:Disconnect()

            library.Flags[option.Flag] = false

            option.Callback(true, 0)
        end

        self.Key = (key and key.Name) or key or self.Key

        if self.Key == "Backspace" then
            self.Key = "none"

            BindInput.Text = "[NONE]"
        else
            local A = self.Key

            if self.Key:match("Mouse") then
                A = self.Key:gsub("Button", ""):gsub("Mouse", "M")
            elseif self.Key:match("Shift") or self.Key:match("Alt") or self.Key:match("Control") then
                A = self.Key:gsub("Left", "L"):gsub("Right", "R")
            end

            BindInput.Text = "[" .. A:gsub("Control", "CTRL"):upper() .. "]"
        end

        BindInput.Size = UDim2.new(0, -TextService:GetTextSize(BindInput.Text, 16, Enum.Font.Code, Vector2.new(9e9, 9e9)).X, 0, 16)
    end

    option:SetKey()
end

--// library.CreateSlider

library.CreateSlider = function(option, parent)
    option.HasInit = true

    if option.Sub then
        option.Main = option:GetMain()

        option.Main.Size = UDim2.new(1, 0, 0, 42)
    else
        option.Main = library:Create("Frame", {
            LayoutOrder = option.Position,
            Size = UDim2.new(1, 0, 0, option.TextPos and 24 or 40),
            BackgroundTransparency = 1,
            Parent = parent
        })
    end

    option.Slider = library:Create("Frame", {
        Position = UDim2.new(0, 6, 0, (option.Sub and 22 or option.TextPos and 4 or 20)),
        Size = UDim2.new(1, -12, 0, 16),
        BackgroundColor3 = Color3.fromRGB(50, 50, 50),
        BorderColor3 = Color3.fromRGB(0, 0, 0),
        Parent = option.Main
    })

    library:Create("ImageLabel", {
        Size = UDim2.new(1, 0, 1, 0),
        BackgroundTransparency = 1,
        Image = "rbxassetid://2454009026",
        ImageColor3 = Color3.fromRGB(0, 0, 0),
        ImageTransparency = 0.8,
        Parent = option.Slider
    })

    option.Fill = library:Create("Frame", {
        BackgroundColor3 = library.Flags["Menu Accent Color"],
        BorderSizePixel = 0,
        Parent = option.Slider
    })

    library:Create("ImageLabel", {
        Size = UDim2.new(1, 0, 1, 0),
        BackgroundTransparency = 1,
        Image = "rbxassetid://2592362371",
        ImageColor3 = Color3.fromRGB(60, 60, 60),
        ScaleType = Enum.ScaleType.Slice,
        SliceCenter = Rect.new(2, 2, 62, 62),
        Parent = option.Slider
    })

    library:Create("ImageLabel", {
        Size = UDim2.new(1, -2, 1, -2),
        Position = UDim2.new(0, 1, 0, 1),
        BackgroundTransparency = 1,
        Image = "rbxassetid://2592362371",
        ImageColor3 = Color3.fromRGB(0, 0, 0),
        ScaleType = Enum.ScaleType.Slice,
        SliceCenter = Rect.new(2, 2, 62, 62),
        Parent = option.Slider
    })

    option.Title = library:Create("TextBox", {
        Position = UDim2.new((option.Sub or option.TextPos) and 0.5 or 0, (option.Sub or option.TextPos) and 0 or 6, 0, 0),
        Size = UDim2.new(0, 0, 0, (option.Sub or option.TextPos) and 14 or 18),
        BackgroundTransparency = 1,
        Text = (option.Text == "nil" and "" or option.Text .. ": ") .. option.Value .. option.Suffix,
        TextSize = (option.Sub or option.TextPos) and 14 or 15,
        Font = Enum.Font.Code,
        TextColor3 = Color3.fromRGB(210, 210, 210),
        TextXAlignment = Enum.TextXAlignment[(option.Sub or option.TextPos) and "Center" or "Left"],
        Parent = (option.Sub or option.TextPos) and option.Slider or option.Main
    })

    table.insert(library.Theme, option.Fill)

    library:Create("UIGradient", {
        Color = ColorSequence.new({
            ColorSequenceKeypoint.new(0, Color3.fromRGB(115, 115, 155)),
            ColorSequenceKeypoint.new(1, Color3.fromRGB(255, 255, 255))
        }),
        Rotation = -90,
        Parent = option.Fill
    })

    if option.Min >= 0 then
        option.Fill.Size = UDim2.new((option.Value - option.Min) / (option.Max - option.Min), 0, 1, 0)
    else
        option.Fill.Position = UDim2.new((0 - option.Min) / (option.Max - option.Min), 0, 0, 0)
        option.Fill.Size = UDim2.new(option.Value / (option.Max - option.Min), 0, 1, 0)
    end

    local ManualInput

    option.Title.Focused:Connect(function()
        if not ManualInput then
            option.Title:ReleaseFocus()

            option.Title.Text = (option.Text == "nil" and "" or option.Text .. ": ") .. option.Value .. option.Suffix
        end
    end)

    option.Title.FocusLost:Connect(function()
        TweenService:Create(option.Slider, TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
            BorderColor3 = Color3.fromRGB(0, 0, 0)
        }):Play()

        if ManualInput then
            if tonumber(option.Title.Text) then
                option:SetValue(tonumber(option.Title.Text))
            else
                option.Title.Text = (option.Text == "nil" and "" or option.Text .. ": ") .. option.Value .. option.Suffix
            end
        end

        ManualInput = false
    end)

    local Interest = (option.Sub or option.TextPos) and option.Slider or option.Main

    Interest.InputBegan:Connect(function(input)
        if input.UserInputType.Name == "MouseButton1" then
            if UserInputService:IsKeyDown(Enum.KeyCode.LeftControl) or UserInputService:IsKeyDown(Enum.KeyCode.RightControl) then
                ManualInput = true

                option.Title:CaptureFocus()
            else
                library.Slider = option

                TweenService:Create(option.Slider, TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
                    BorderColor3 = library.Flags["Menu Accent Color"]
                }):Play()

                option:SetValue(option.Min + ((input.Position.X - option.Slider.AbsolutePosition.X) / option.Slider.AbsoluteSize.X) * (option.Max - option.Min))
            end
        end

        if input.UserInputType.Name == "MouseMovement" then
            if not library.Warning and not library.Slider then
                TweenService:Create(option.Slider, TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
                    BorderColor3 = library.Flags["Menu Accent Color"]
                }):Play()
            end

            if option.Tip then
                library.ToolTip.Text = option.Tip
                library.ToolTip.Size = UDim2.new(0, TextService:GetTextSize(option.Tip, 15, Enum.Font.Code, Vector2.new(9e9, 9e9)).X, 0, 20)
            end
        end
    end)

    Interest.InputChanged:Connect(function(input)
        if input.UserInputType.Name == "MouseMovement" then
            if option.Tip then
                library.ToolTip.Position = UDim2.new(0, input.Position.X + 26, 0, input.Position.Y + 36)
            end
        end
    end)

    Interest.InputEnded:Connect(function(input)
        if input.UserInputType.Name == "MouseMovement" then
            library.ToolTip.Position = UDim2.new(2)

            if option ~= library.Slider then
                TweenService:Create(option.Slider, TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
                    BorderColor3 = Color3.fromRGB(0, 0, 0)
                }):Play()
            end
        end
    end)

    --// option:SetValue(value, noCallback)

    function option:SetValue(value, noCallback)
        if typeof(value) ~= "number" then
            value = 0
        end

        value = library.Round(value, option.Float)
        value = math.clamp(value, self.Min, self.Max)

        if self.Min >= 0 then
            option.Fill:TweenSize(UDim2.new((value - self.Min) / (self.Max - self.Min), 0, 1, 0), "Out", "Quad", 0.05, true)
        else
            option.Fill:TweenPosition(UDim2.new((0 - self.Min) / (self.Max - self.Min), 0, 0, 0), "Out", "Quad", 0.05, true)
            option.Fill:TweenSize(UDim2.new(value / (self.Max - self.Min), 0, 1, 0), "Out", "Quad", 0.1, true)
        end

        library.Flags[self.Flag] = value

        self.Value = value

        option.Title.Text = (option.Text == "nil" and "" or option.Text .. ": ") .. option.Value .. option.Suffix

        if not noCallback then
            self.Callback(value)
        end
    end

    delay(1, function()
        if library then
            option:SetValue(option.Value)
        end
    end)
end

--// library.CreateDropdown

library.CreateDropdown = function(option, parent)
    option.HasInit = true

    if option.Sub then
        option.Main = option:GetMain()

        option.Main.Size = UDim2.new(1, 0, 0, 48)
    else
        option.Main = library:Create("Frame", {
            LayoutOrder = option.Position,
            Size = UDim2.new(1, 0, 0, option.Text == "nil" and 30 or 48),
            BackgroundTransparency = 1,
            Parent = parent
        })

        if option.Text ~= "nil" then
            library:Create("TextLabel", {
                Position = UDim2.new(0, 6, 0, 0),
                Size = UDim2.new(1, -12, 0, 18),
                BackgroundTransparency = 1,
                Text = option.Text,
                TextSize = 15,
                Font = Enum.Font.Code,
                TextColor3 = Color3.fromRGB(210, 210, 210),
                TextXAlignment = Enum.TextXAlignment.Left,
                Parent = option.Main
            })
        end
    end

    local function GetMultiText()
        local S = ""

        for _, v in next, option.Values do
            S = S .. (option.Value[v] and (tostring(v) .. ", ") or "")
        end

        return string.sub(S, 1, #S - 2)
    end

    option.ListValue = library:Create("TextLabel", {
        Position = UDim2.new(0, 6, 0, (option.Text == "nil" and not option.Sub) and 4 or 22),
        Size = UDim2.new(1, -12, 0, 22),
        BackgroundColor3 = Color3.fromRGB(50, 50, 50),
        BorderColor3 = Color3.fromRGB(0, 0, 0),
        Text = " " .. (typeof(option.Value) == "string" and option.Value or GetMultiText()),
        TextSize = 15,
        Font = Enum.Font.Code,
        TextColor3 = Color3.fromRGB(255, 255, 255),
        TextXAlignment = Enum.TextXAlignment.Left,
        TextTruncate = Enum.TextTruncate.AtEnd,
        Parent = option.Main
    })

    library:Create("ImageLabel", {
        Size = UDim2.new(1, 0, 1, 0),
        BackgroundTransparency = 1,
        Image = "rbxassetid://2454009026",
        ImageColor3 = Color3.fromRGB(0, 0, 0),
        ImageTransparency = 0.8,
        Parent = option.ListValue
    })

    library:Create("ImageLabel", {
        Size = UDim2.new(1, 0, 1, 0),
        BackgroundTransparency = 1,
        Image = "rbxassetid://2592362371",
        ImageColor3 = Color3.fromRGB(60, 60, 60),
        ScaleType = Enum.ScaleType.Slice,
        SliceCenter = Rect.new(2, 2, 62, 62),
        Parent = option.ListValue
    })

    library:Create("ImageLabel", {
        Size = UDim2.new(1, -2, 1, -2),
        Position = UDim2.new(0, 1, 0, 1),
        BackgroundTransparency = 1,
        Image = "rbxassetid://2592362371",
        ImageColor3 = Color3.fromRGB(0, 0, 0),
        ScaleType = Enum.ScaleType.Slice,
        SliceCenter = Rect.new(2, 2, 62, 62),
        Parent = option.ListValue
    })

    option.Arrow = library:Create("ImageLabel", {
        Position = UDim2.new(1, -16, 0, 7),
        Size = UDim2.new(0, 8, 0, 8),
        Rotation = 90,
        BackgroundTransparency = 1,
        Image = "rbxassetid://4918373417",
        ImageColor3 = Color3.fromRGB(255, 255, 255),
        ScaleType = Enum.ScaleType.Fit,
        ImageTransparency = 0.4,
        Parent = option.ListValue
    })

    option.Holder = library:Create("TextButton", {
        ZIndex = 4,
        BackgroundColor3 = Color3.fromRGB(40, 40, 40),
        BorderColor3 = Color3.fromRGB(0, 0, 0),
        Text = "",
        AutoButtonColor = false,
        Visible = false,
        Parent = library.Base
    })

    option.Content = library:Create("ScrollingFrame", {
        ZIndex = 4,
        Size = UDim2.new(1, 0, 1, 0),
        BackgroundTransparency = 1,
        BorderSizePixel = 0,
        ScrollBarImageColor3 = Color3.fromRGB(0, 0, 0),
        ScrollBarThickness = 3,
        ScrollingDirection = Enum.ScrollingDirection.Y,
        VerticalScrollBarInset = Enum.ScrollBarInset.Always,
        TopImage = "rbxasset://textures/ui/Scroll/scroll-middle.png",
        BottomImage = "rbxasset://textures/ui/Scroll/scroll-middle.png",
        Parent = option.Holder
    })

    library:Create("ImageLabel", {
        ZIndex = 4,
        Size = UDim2.new(1, 0, 1, 0),
        BackgroundTransparency = 1,
        Image = "rbxassetid://2592362371",
        ImageColor3 = Color3.fromRGB(60, 60, 60),
        ScaleType = Enum.ScaleType.Slice,
        SliceCenter = Rect.new(2, 2, 62, 62),
        Parent = option.Holder
    })

    library:Create("ImageLabel", {
        ZIndex = 4,
        Size = UDim2.new(1, -2, 1, -2),
        Position = UDim2.new(0, 1, 0, 1),
        BackgroundTransparency = 1,
        Image = "rbxassetid://2592362371",
        ImageColor3 = Color3.fromRGB(0, 0, 0),
        ScaleType = Enum.ScaleType.Slice,
        SliceCenter = Rect.new(2, 2, 62, 62),
        Parent = option.Holder
    })

    local Layout = library:Create("UIListLayout", {
        Padding = UDim.new(0, 2),
        Parent = option.Content
    })

    library:Create("UIPadding", {
        PaddingTop = UDim.new(0, 4),
        PaddingLeft = UDim.new(0, 4),
        Parent = option.Content
    })

    local ValueCount = 0

    Layout.Changed:Connect(function()
        option.Holder.Size = UDim2.new(0, option.ListValue.AbsoluteSize.X, 0, 8 + (ValueCount > option.Max and (-2 + (option.Max * 22)) or Layout.AbsoluteContentSize.Y))

        option.Content.CanvasSize = UDim2.new(0, 0, 0, 8 + Layout.AbsoluteContentSize.Y)
    end)

    local Interest = option.Sub and option.ListValue or option.Main

    option.ListValue.InputBegan:Connect(function(input)
        if input.UserInputType.Name == "MouseButton1" then
            if library.Popup == option then
                library.Popup:Close()

                return
            end

            if library.Popup then
                library.Popup:Close()
            end

            TweenService:Create(option.Arrow, TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
                Rotation = -90
            }):Play()

            option.Open = true

            option.Holder.Visible = true

            local Pos = option.Main.AbsolutePosition

            option.Holder.Position = UDim2.new(0, Pos.X + 6, 0, Pos.Y + ((option.Text == "nil" and not option.Sub) and 66 or 84))

            library.Popup = option

            TweenService:Create(option.ListValue, TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
                BorderColor3 = library.Flags["Menu Accent Color"]
            }):Play()
        end

        if input.UserInputType.Name == "MouseMovement" then
            if not library.Warning and not library.Slider then
                TweenService:Create(option.ListValue, TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
                    BorderColor3 = library.Flags["Menu Accent Color"]
                }):Play()
            end
        end
    end)

    option.ListValue.InputEnded:Connect(function(input)
        if input.UserInputType.Name == "MouseMovement" then
            if not option.Open then
                TweenService:Create(option.ListValue, TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
                    BorderColor3 = Color3.fromRGB(0, 0, 0)
                }):Play()
            end
        end
    end)

    Interest.InputBegan:Connect(function(input)
        if input.UserInputType.Name == "MouseMovement" then
            if option.Tip then
                library.ToolTip.Text = option.Tip
                library.ToolTip.Size = UDim2.new(0, TextService:GetTextSize(option.Tip, 15, Enum.Font.Code, Vector2.new(9e9, 9e9)).X, 0, 20)
            end
        end
    end)

    Interest.InputChanged:Connect(function(input)
        if input.UserInputType.Name == "MouseMovement" then
            if option.Tip then
                library.ToolTip.Position = UDim2.new(0, input.Position.X + 26, 0, input.Position.Y + 36)
            end
        end
    end)

    Interest.InputEnded:Connect(function(input)
        if input.UserInputType.Name == "MouseMovement" then
            library.ToolTip.Position = UDim2.new(2)
        end
    end)

    local Selected

    --// option:AddValue(value, state)

    function option:AddValue(value, state)
        if self.Labels[value] then
            return
        end

        ValueCount = ValueCount + 1

        if self.MultiSelect then
            self.Values[value] = state
        else
            if not table.find(self.Values, value) then
                table.insert(self.Values, value)
            end
        end

        local Label = library:Create("TextLabel", {
            ZIndex = 4,
            Size = UDim2.new(1, 0, 0, 20),
            BackgroundTransparency = 1,
            Text = value,
            TextSize = 15,
            Font = Enum.Font.Code,
            TextTransparency = self.MultiSelect and (self.Value[value] and 1 or 0) or self.Value == value and 1 or 0,
            TextColor3 = Color3.fromRGB(210, 210, 210),
            TextXAlignment = Enum.TextXAlignment.Left,
            Parent = option.Content
        })

        self.Labels[value] = Label

        local LabelOverlay = library:Create("TextLabel", {
            ZIndex = 4,
            Size = UDim2.new(1, 0, 1, 0),
            BackgroundTransparency = 0.8,
            Text = " " .. value,
            TextSize = 15,
            Font = Enum.Font.Code,
            TextColor3 = library.Flags["Menu Accent Color"],
            TextXAlignment = Enum.TextXAlignment.Left,
            Visible = self.MultiSelect and self.Value[value] or self.Value == value,
            Parent = Label
        })

        Selected = Selected or self.Value == value and LabelOverlay

        table.insert(library.Theme, LabelOverlay)

        Label.InputBegan:Connect(function(input)
            if input.UserInputType.Name == "MouseMovement" then
                if self.MultiSelect then
                    self.Value[value] = not self.Value[value]

                    self:SetValue(self.Value)
                else
                    self:SetValue(value)

                    self:Close()
                end
            end
        end)
    end

    for i, v in next, option.Values do
        option:AddValue(tostring(typeof(i) == "number" and v or i))
    end

    --// option:RemoveValue(value)

    function option:RemoveValue(value)
        local Label = self.Labels[value]

        if Label then
            Label:Destroy()

            self.Labels[value] = nil

            ValueCount = ValueCount - 1

            if self.MultiSelect then
                self.Values[value] = nil

                self:SetValue(self.Value)
            else
                table.remove(self.Values, table.find(self.Values, value))

                if self.Value == value then
                    Selected = nil

                    self:SetValue(self.Values[1] or "")
                end
            end
        end
    end

    --// option:SetValue(value, noCallback)

    function option:SetValue(value, noCallback)
        if self.MultiSelect and typeof(value) ~= "table" then
            value = {}

            for i, v in next, self.Values do
                value[v] = false
            end
        end

        self.Value = typeof(value) == "table" and value or tostring(table.find(self.Values, value) and value or self.Values[1])

        library.Flags[self.Flag] = self.Value

        option.ListValue.Text = " " .. (self.MultiSelect and GetMultiText() or self.Value)

        if self.MultiSelect then
            for n, l in next, self.Labels do
                l.TextTransparency = self.Value[n] and 1 or 0

                if l:FindFirstChild("TextLabel") then
                    l.TextLabel.Visible = self.Value[n]
                end
            end
        else
            if Selected then
                Selected.TextTransparency = 0

                if Selected:FindFirstChild("TextLabel") then
                    Selected.TextLabel.Visible = false
                end
            end

            if self.Labels[self.Value] then
                Selected = self.Labels[self.Value]

                Selected.TextTransparency = 1

                if Selected:FindFirstChild("TextLabel") then
                    Selected.TextLabel.Visible = true
                end
            end
        end

        if not noCallback then
            self.Callback(self.Value)
        end
    end

    delay(1, function()
        if library then
            option:SetValue(option.Value)
        end
    end)

    --// option:Close()

    function option:Close()
        library.Popup = nil

        TweenService:Create(option.Arrow, TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
            Rotation = 90
        }):Play()

        self.Open = false

        option.Holder.Visible = false

        TweenService:Create(option.ListValue, TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
            BorderColor3 = Color3.fromRGB(0, 0, 0)
        }):Play()
    end

    return option
end

--// library.CreateTextBox

library.CreateTextBox = function(option, parent)
    option.HasInit = true

    option.Main = library:Create("Frame", {
        LayoutOrder = option.Position,
        Size = UDim2.new(1, 0, 0, option.Text == "nil" and 28 or 44),
        BackgroundTransparency = 1,
        Parent = parent
    })

    if option.Text ~= "nil" then
        option.Title = library:Create("TextLabel", {
            Position = UDim2.new(0, 6, 0, 0),
            Size = UDim2.new(1, -12, 0, 18),
            BackgroundTransparency = 1,
            Text = option.Text,
            TextSize = 15,
            Font = Enum.Font.Code,
            TextColor3 = Color3.fromRGB(210, 210, 210),
            TextXAlignment = Enum.TextXAlignment.Left,
            Parent = option.Main
        })
    end

    option.Holder = library:Create("Frame", {
        Position = UDim2.new(0, 6, 0, option.Text == "nil" and 4 or 20),
        Size = UDim2.new(1, -12, 0, 20),
        BackgroundColor3 = Color3.fromRGB(50, 50, 50),
        BorderColor3 = Color3.fromRGB(0, 0, 0),
        Parent = option.Main
    })

    library:Create("ImageLabel", {
        Size = UDim2.new(1, 0, 1, 0),
        BackgroundTransparency = 1,
        Image = "rbxassetid://2454009026",
        ImageColor3 = Color3.fromRGB(0, 0, 0),
        ImageTransparency = 0.8,
        Parent = option.Holder
    })

    library:Create("ImageLabel", {
        Size = UDim2.new(1, 0, 1, 0),
        BackgroundTransparency = 1,
        Image = "rbxassetid://2592362371",
        ImageColor3 = Color3.fromRGB(60, 60, 60),
        ScaleType = Enum.ScaleType.Slice,
        SliceCenter = Rect.new(2, 2, 62, 62),
        Parent = option.Holder
    })

    library:Create("ImageLabel", {
        Size = UDim2.new(1, -2, 1, -2),
        Position = UDim2.new(0, 1, 0, 1),
        BackgroundTransparency = 1,
        Image = "rbxassetid://2592362371",
        ImageColor3 = Color3.fromRGB(0, 0, 0),
        ScaleType = Enum.ScaleType.Slice,
        SliceCenter = Rect.new(2, 2, 62, 62),
        Parent = option.Holder
    })

    local InputValue = library:Create("TextBox", {
        Position = UDim2.new(0, 4, 0, 0),
        Size = UDim2.new(1, -4, 1, 0),
        BackgroundTransparency = 1,
        Text = "  " .. option.Value,
        TextSize = 15,
        Font = Enum.Font.Code,
        TextColor3 = Color3.fromRGB(255, 255, 255),
        TextXAlignment = Enum.TextXAlignment.Left,
        TextWrapped = true,
        ClearTextOnFocus = false,
        Parent = option.Holder
    })

    InputValue.FocusLost:Connect(function(enter)
        TweenService:Create(option.Holder, TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
            BorderColor3 = Color3.fromRGB(0, 0, 0)
        }):Play()

        option:SetValue(InputValue.Text, enter)
    end)

    InputValue.Focused:Connect(function()
        TweenService:Create(option.Holder, TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
            BorderColor3 = library.Flags["Menu Accent Color"]
        }):Play()
    end)

    InputValue.InputBegan:Connect(function(input)
        if input.UserInputType.Name == "MouseButton1" then
            InputValue.Text = ""
        end

        if input.UserInputType.Name == "MouseMovement" then
            if not library.Warning and not library.Slider then
                TweenService:Create(option.Holder, TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
                    BorderColor3 = library.Flags["Menu Accent Color"]
                }):Play()
            end

            if option.Tip then
                library.ToolTip.Text = option.Tip
                library.ToolTip.Size = UDim2.new(0, TextService:GetTextSize(option.Tip, 15, Enum.Font.Code, Vector2.new(9e9, 9e9)).X, 0, 20)
            end
        end
    end)

    InputValue.InputChanged:Connect(function(input)
        if input.UserInputType.Name == "MouseMovement" then
            if option.Tip then
                library.ToolTip.Position = UDim2.new(0, input.Position.X + 26, 0, input.Position.Y + 36)
            end
        end
    end)

    InputValue.InputEnded:Connect(function(input)
        if input.UserInputType.Name == "MouseMovement" then
            if not InputValue:IsFocused() then
                TweenService:Create(option.Holder, TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
                    BorderColor3 = Color3.fromRGB(0, 0, 0)
                }):Play()
            end

            library.ToolTip.Position = UDim2.new(2)
        end
    end)

    --// option:SetValue(value, enter)

    function option:SetValue(value, enter)
        if tostring(value) == "" then
            InputValue.Text = self.Value
        else
            library.Flags[self.Flag] = tostring(value)

            self.Value = tostring(value)

            InputValue.Text = self.Value

            self.Callback(value, enter)
        end
    end

    delay(1, function()
        if library then
            option:SetValue(option.Value)
        end
    end)
end

--// library.CreateColorPickerWindow

library.CreateColorPickerWindow = function(option)
    option.MainHolder = library:Create("TextButton", {
        ZIndex = 4,
        Size = UDim2.new(0, option.Transparency and 200 or 184, 0, 264),
        BackgroundColor3 = Color3.fromRGB(40, 40, 40),
        BorderColor3 = Color3.fromRGB(0, 0, 0),
        AutoButtonColor = false,
        Visible = false,
        Parent = library.Base
    })

    option.RGBBox = library:Create("Frame", {
        Position = UDim2.new(0, 6, 0, 214),
        Size = UDim2.new(0, (option.MainHolder.AbsoluteSize.X - 12), 0, 20),
        BackgroundColor3 = Color3.fromRGB(55, 55, 55),
        BorderColor3 = Color3.fromRGB(0, 0, 0),
        ZIndex = 5,
        Parent = option.MainHolder
    })

    library:Create("ImageLabel", {
        Size = UDim2.new(1, 0, 1, 0),
        BackgroundTransparency = 1,
        Image = "rbxassetid://2454009026",
        ImageColor3 = Color3.fromRGB(0, 0, 0),
        ImageTransparency = 0.8,
        ZIndex = 6,
        Parent = option.RGBBox
    })

    library:Create("ImageLabel", {
        Size = UDim2.new(1, 0, 1, 0),
        BackgroundTransparency = 1,
        Image = "rbxassetid://2592362371",
        ImageColor3 = Color3.fromRGB(60, 60, 60),
        ScaleType = Enum.ScaleType.Slice,
        SliceCenter = Rect.new(2, 2, 62, 62),
        ZIndex = 6,
        Parent = option.RGBBox
    })

    library:Create("ImageLabel", {
        Size = UDim2.new(1, -2, 1, -2),
        Position = UDim2.new(0, 1, 0, 1),
        BackgroundTransparency = 1,
        Image = "rbxassetid://2592362371",
        ImageColor3 = Color3.fromRGB(0, 0, 0),
        ScaleType = Enum.ScaleType.Slice,
        SliceCenter = Rect.new(2, 2, 62, 62),
        ZIndex = 6,
        Parent = option.RGBBox
    })

    option.RGBInput = library:Create("TextBox", {
        Position = UDim2.new(0, 4, 0, 0),
        Size = UDim2.new(1, -4, 1, 0),
        BackgroundTransparency = 1,
        Text = tostring(option.Color),
        TextSize = 14,
        Font = Enum.Font.Code,
        TextColor3 = Color3.fromRGB(255, 255, 255),
        TextXAlignment = Enum.TextXAlignment.Center,
        TextWrapped = true,
        ClearTextOnFocus = false,
        ZIndex = 6,
        Parent = option.RGBBox
    })

    option.HEXBox = option.RGBBox:Clone()

    option.HEXBox.Position = UDim2.new(0, 6, 0, 238)
    option.HEXBox.Parent = option.MainHolder

    option.HEXInput = option.HEXBox.TextBox

    library:Create("ImageLabel", {
        ZIndex = 4,
        Size = UDim2.new(1, 0, 1, 0),
        BackgroundTransparency = 1,
        Image = "rbxassetid://2592362371",
        ImageColor3 = Color3.fromRGB(60, 60, 60),
        ScaleType = Enum.ScaleType.Slice,
        SliceCenter = Rect.new(2, 2, 62, 62),
        Parent = option.MainHolder
    })

    library:Create("ImageLabel", {
        ZIndex = 4,
        Size = UDim2.new(1, -2, 1, -2),
        Position = UDim2.new(0, 1, 0, 1),
        BackgroundTransparency = 1,
        Image = "rbxassetid://2592362371",
        ImageColor3 = Color3.fromRGB(0, 0, 0),
        ScaleType = Enum.ScaleType.Slice,
        SliceCenter = Rect.new(2, 2, 62, 62),
        Parent = option.MainHolder
    })

    local HUE, SAT, VAL = Color3.toHSV(option.Color)

    HUE, SAT, VAL = HUE == 0 and 1 or HUE, SAT + 0.005, VAL - 0.005

    local EditingHUE
    local EditingSATVAL
    local EditingTransparency

    local TransparencyMain

    if option.Transparency then
        TransparencyMain = library:Create("ImageLabel", {
            ZIndex = 5,
            Size = UDim2.new(1, 0, 1, 0),
            BackgroundTransparency = 1,
            Image = "rbxassetid://2454009026",
            ImageColor3 = Color3.fromHSV(HUE, 1, 1),
            Rotation = 180,
            Parent = library:Create("ImageLabel", {
                ZIndex = 4,
                AnchorPoint = Vector2.new(1, 0),
                Position = UDim2.new(1, -6, 0, 6),
                Size = UDim2.new(0, 10, 1, -60),
                BorderColor3 = Color3.fromRGB(0, 0, 0),
                Image = "rbxassetid://4632082392",
                ScaleType = Enum.ScaleType.Tile,
                TileSize = UDim2.new(0, 5, 0, 5),
                Parent = option.MainHolder
            })
        })

        option.TransparencySlider = library:Create("Frame", {
            ZIndex = 5,
            Position = UDim2.new(0, 0, option.Transparency, 0),
            Size = UDim2.new(1, 0, 0, 2),
            BackgroundColor3 = Color3.fromRGB(40, 40, 65),
            BorderColor3 = Color3.fromRGB(255, 255, 255),
            Parent = TransparencyMain
        })

        TransparencyMain.InputBegan:Connect(function(input)
            if input.UserInputType.Name == "MouseButton1" then
                EditingTransparency = true

                option:SetTransparency(1 - ((input.Position.Y - TransparencyMain.AbsolutePosition.Y) / TransparencyMain.AbsoluteSize.Y))
            end
        end)

        TransparencyMain.InputEnded:Connect(function(input)
            if input.UserInputType.Name == "MouseButton1" then
                EditingTransparency = false
            end
        end)
    end

    local HUEMain = library:Create("Frame", {
        ZIndex = 4,
        AnchorPoint = Vector2.new(0, 1),
        Position = UDim2.new(1, option.Transparency and -28 or -12, 0, 10),
        BackgroundColor3 = Color3.fromRGB(255, 255, 255),
        BorderColor3 = Color3.fromRGB(0, 0, 0),
        Parent = option.MainHolder
    })

    local Gradient = library:Create("UIGradient", {
        Color = ColorSequence.new({
            ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 0, 0)),
            ColorSequenceKeypoint.new(0.17, Color3.fromRGB(255, 0, 255)),
            ColorSequenceKeypoint.new(0.33, Color3.fromRGB(0, 0, 255)),
            ColorSequenceKeypoint.new(0.5, Color3.fromRGB(0, 255, 255)),
            ColorSequenceKeypoint.new(0.67, Color3.fromRGB(0, 255, 0)),
            ColorSequenceKeypoint.new(0.83, Color3.fromRGB(255, 255, 0)),
            ColorSequenceKeypoint.new(1, Color3.fromRGB(255, 0, 0))
        }),
        Parent = HUEMain
    })

    local HUESlider = library:Create("Frame", {
        ZIndex = 4,
        Position = UDim2.new(1 - HUE, 0, 0, 0),
        Size = UDim2.new(0, 2, 1, 0),
        BackgroundColor3 = Color3.fromRGB(40, 40, 65),
        BorderColor3 = Color3.fromRGB(255, 255, 255),
        Parent = HUEMain
    })

    HUEMain.InputBegan:Connect(function(input)
        if input.UserInputType.Name == "MouseButton1" then
            EditingHUE = true

            local X = (HUEMain.AbsolutePosition.X + HUEMain.AbsoluteSize.X) - HUEMain.AbsolutePosition.X

            X = math.clamp((input.Position.X - HUEMain.AbsolutePosition.X) / X, 0, 0.995)

            option:SetColor(Color3.fromHSV(1 - X, SAT, VAL))
        end
    end)

    HUEMain.InputEnded:Connect(function(input)
        if input.UserInputType.Name == "MouseButton1" then
            EditingHUE = false
        end
    end)

    local SATVAL = library:Create("ImageLabel", {
        ZIndex = 4,
        Position = UDim2.new(0, 6, 0, 6),
        Size = UDim2.new(1, option.Transparency and -28 or -12, 1, -74),
        BackgroundColor3 = Color3.fromHSV(HUE, 1, 1),
        BorderColor3 = Color3.fromRGB(0, 0, 0),
        Image = "rbxassetid://4155801252",
        ClipsDescendants = true,
        Parent = option.MainHolder
    })

    local SATVALSlider = library:Create("Frame", {
        ZIndex = 4,
        AnchorPoint = Vector2.new(0.5, 0.5),
        Position = UDim2.new(SAT, 0, 1 - VAL, 0),
        Size = UDim2.new(0, 4, 0, 4),
        Rotation = 45,
        BackgroundColor3 = Color3.fromRGB(255, 255, 255),
        Parent = SATVAL
    })

    SATVAL.InputBegan:Connect(function(input)
        if input.UserInputType.Name == "MouseButton1" then
            EditingSATVAL = true

            local X = (SATVAL.AbsolutePosition.X + SATVAL.AbsoluteSize.X) - SATVAL.AbsolutePosition.X
            local Y = (SATVAL.AbsolutePosition.Y + SATVAL.AbsoluteSize.Y) - SATVAL.AbsolutePosition.Y

            X = math.clamp((input.Position.X - SATVAL.AbsolutePosition.X) / X, 0.005, 1)
            Y = math.clamp((input.Position.Y - SATVAL.AbsolutePosition.Y) / Y, 0, 0.995)

            option:SetColor(Color3.fromHSV(HUE, X, 1 - Y))
        end
    end)

    library:AddConnection(UserInputService.InputChanged, function(input)
        if input.UserInputType.Name == "MouseMovement" then
            if EditingSATVAL then
                local X = (SATVAL.AbsolutePosition.X + SATVAL.AbsoluteSize.X) - SATVAL.AbsolutePosition.X
                local Y = (SATVAL.AbsolutePosition.Y + SATVAL.AbsoluteSize.Y) - SATVAL.AbsolutePosition.Y

                X = math.clamp((input.Position.X - SATVAL.AbsolutePosition.X) / X, 0.005, 1)
                Y = math.clamp((input.Position.Y - SATVAL.AbsolutePosition.Y) / Y, 0, 0.995)

                option:SetColor(Color3.fromHSV(HUE, X, 1 - Y))
            elseif EditingHUE then
                local X = (HUEMain.AbsolutePosition.X + HUEMain.AbsoluteSize.X) - HUEMain.AbsolutePosition.X

                X = math.clamp((input.Position.X - HUEMain.AbsolutePosition.X) / X, 0, 0.995)

                option:SetColor(Color3.fromHSV(1 - X, SAT, VAL))
            elseif EditingTransparency then
                option:SetTransparency(1 - ((input.Position.Y - TransparencyMain.AbsolutePosition.Y) / TransparencyMain.AbsoluteSize.Y))
            end
        end
    end)

    SATVAL.InputEnded:Connect(function(input)
        if input.UserInputType.Name == "MouseButton1" then
            EditingSATVAL = false
        end
    end)

    local R, G, B = library.Round(option.Color)

    option.HEXInput.Text = string.format("#%02x%02x%02x", R, G, B)

    option.RGBInput.Text = table.concat({
        R,
        G,
        B
    }, ",")

    option.RGBInput.FocusLost:Connect(function()
        R, G, B = option.RGBInput.Text:gsub("%s+", ""):match("(%d+),(%d+),(%d+)")

        if R and G and B then
            local Color = Color3.fromRGB(tonumber(R), tonumber(G), tonumber(B))

            return option:SetColor(Color)
        end

        R, G, B = library.Round(option.Color)

        option.RGBInput.Text = table.concat({
            R,
            G,
            B
        }, ",")
    end)

    option.HEXInput.FocusLost:Connect(function()
        R, G, B = option.HEXInput.Text:match("#?(..)(..)(..)")

        if R and G and B then
            local Color = Color3.fromRGB(tonumber("0x" .. R), tonumber("0x" .. G), tonumber("0x" .. B))

            return option:SetColor(Color)
        end

        R, G, B = library.Round(option.Color)

        option.HEXInput.Text = string.format("#%02x%02x%02x", R, G, B)
    end)

    --// option:UpdateVisuals(color)

    function option:UpdateVisuals(color)
        HUE, SAT, VAL = Color3.toHSV(color)

        HUE = HUE == 0 and 1 or HUE

        TweenService:Create(SATVALSlider, TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
            BackgroundColor3 = Color3.fromHSV(HUE, 1, 1)
        }):Play()

        if option.Transparency then
            TweenService:Create(TransparencyMain, TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
                ImageColor3 = Color3.fromHSV(HUE, 1, 1)
            }):Play()
        end

        HUESlider.Position = UDim2.new(1 - HUE, 0, 0, 0)

        SATVALSlider.Position = UDim2.new(SAT, 0, 1 - VAL, 0)

        local R, G, B = library.Round(Color3.fromHSV(HUE, SAT, VAL))

        option.HEXInput.Text = string.format("#%02x%02x%02x", R, G, B)

        option.RGBInput.Text = table.concat({
            R,
            G,
            B
        }, ",")
    end

    return option
end

--// library.CreateColorPicker

library.CreateColorPicker = function(option, parent)
    option.HasInit = true

    if option.Sub then
        option.Main = option:GetMain()
    else
        option.Main = library:Create("Frame", {
            LayoutOrder = option.Position,
            Size = UDim2.new(1, 0, 0, 20),
            BackgroundTransparency = 1,
            Parent = parent
        })

        option.Title = library:Create("TextLabel", {
            Position = UDim2.new(0, 6, 0, 0),
            Size = UDim2.new(1, -12, 1, 0),
            BackgroundTransparency = 1,
            Text = option.Text,
            TextSize = 15,
            Font = Enum.Font.Code,
            TextColor3 = Color3.fromRGB(210, 210, 210),
            TextXAlignment = Enum.TextXAlignment.Left,
            Parent = option.Main
        })
    end

    option.Visualize = library:Create(option.Sub and "TextButton" or "Frame", {
        Position = UDim2.new(1, -(option.SubPos or 0) - 24, 0, 4),
        Size = UDim2.new(0, 18, 0, 12),
        SizeConstraint = Enum.SizeConstraint.RelativeYY,
        BackgroundColor3 = option.Color,
        BorderColor3 = Color3.fromRGB(0, 0, 0),
        Parent = option.Main
    })

    library:Create("ImageLabel", {
        Size = UDim2.new(1, 0, 1, 0),
        BackgroundTransparency = 1,
        Image = "rbxassetid://2454009026",
        ImageColor3 = Color3.fromRGB(0, 0, 0),
        ImageTransparency = 0.6,
        Parent = option.Visualize
    })

    library:Create("ImageLabel", {
        Size = UDim2.new(1, 0, 1, 0),
        BackgroundTransparency = 1,
        Image = "rbxassetid://2592362371",
        ImageColor3 = Color3.fromRGB(60, 60, 60),
        ScaleType = Enum.ScaleType.Slice,
        SliceCenter = Rect.new(2, 2, 62, 62),
        Parent = option.Visualize
    })

    library:Create("ImageLabel", {
        Size = UDim2.new(1, -2, 1, -2),
        Position = UDim2.new(0, 1, 0, 1),
        BackgroundTransparency = 1,
        Image = "rbxassetid://2592362371",
        ImageColor3 = Color3.fromRGB(0, 0, 0),
        ScaleType = Enum.ScaleType.Slice,
        SliceCenter = Rect.new(2, 2, 62, 62),
        Parent = option.Visualize
    })

    local Interest = option.Sub and option.Visualize or option.Main

    if option.Sub then
        option.Visualize.Text = ""
        option.Visualize.AutoButtonColor = false
    end

    Interest.InputBegan:Connect(function(input)
        if input.UserInputType.Name == "MouseButton1" then
            if not option.MainHolder then
                library.CreateColorPickerWindow(option)
            end

            if library.Popup == option then
                library.Popup:Close()

                return
            end

            if library.Popup then
                library.Popup:Close()
            end

            option.Open = true

            local Pos = option.Main.AbsolutePosition

            option.MainHolder.Position = UDim2.new(0, Pos.X + 36 + (option.Transparency and -16 or 0), 0, Pos.Y + 56)
            option.MainHolder.Visible = true

            library.Popup = option

            TweenService:Create(option.Visualize, TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
                BorderColor3 = library.Flags["Menu Accent Color"]
            }):Play()
        end

        if input.UserInputType.Name == "MouseMovement" then
            if not library.Warning and not library.Slider then
                TweenService:Create(option.Visualize, TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
                    BorderColor3 = library.Flags["Menu Accent Color"]
                }):Play()
            end

            if option.Tip then
                library.ToolTip.Text = option.Tip
                library.ToolTip.Size = UDim2.new(0, TextService:GetTextSize(option.Tip, 15, Enum.Font.Code, Vector2.new(9e9, 9e9)).X, 0, 20)
            end
        end
    end)

    Interest.InputChanged:Connect(function(input)
        if input.UserInputType.Name == "MouseMovement" then
            if option.Tip then
                library.ToolTip.Position = UDim2.new(0, input.Position.X + 26, 0, input.Position.Y + 36)
            end
        end
    end)

    Interest.InputEnded:Connect(function(input)
        if input.UserInputType.Name == "MouseMovement" then
            if not option.Open then
                TweenService:Create(option.Visualize, TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
                    BorderColor3 = Color3.fromRGB(0, 0, 0)
                }):Play()
            end

            library.ToolTip.Position = UDim2.new(2)
        end
    end)

    --// option:SetColor(newColor, noCallback)

    function option:SetColor(newColor, noCallback)
        if typeof(newColor) == "table" then
            newColor = Color3.fromRGB(newColor[1], newColor[2], newColor[3])
        end

        newColor = newColor or Color3.fromRGB(255, 255, 255)

        if self.MainHolder then
            self:UpdateVisuals(newColor)
        end

        TweenService:Create(option.Visualize, TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
            BackgroundColor3 = newColor
        }):Play()

        library.Flags[self.Flag] = newColor

        self.Color = newColor

        if not noCallback then
            self.Callback(newColor)
        end
    end

    if option.Transparency then
        --// option:SetTransparency(value, manual)

        function option:SetTransparency(value, manual)
            value = math.clamp(tonumber(value) or 0, 0, 1)

            if self.TransparencySlider then
                self.TransparencySlider.Position = UDim2.new(0, 0, value, 0)
            end

            self.Transparency = value

            library.Flags[self.Flag .. "_Transparency"] = 1 - value

            self.CallbackTransparency(value)
        end

        option:SetTransparency(option.Transparency)
    end

    delay(1, function()
        if library then
            option:SetColor(option.Color)
        end
    end)

    --// option:Close()

    function option:Close()
        library.Popup = nil

        self.Open = false

        self.MainHolder.Visible = false

        TweenService:Create(option.Visualize, TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
            BorderColor3 = Color3.fromRGB(0, 0, 0)
        }):Play()
    end
end

--// library:CreateTab(title, pos)

function library:CreateTab(title, pos)
    local Tab = {
        CanInit = true,
        Tabs = {},
        Columns = {},
        Title = tostring(title)
    }

    table.insert(self.Tabs, pos or #self.Tabs + 1, Tab)

    --// Tab:CreateColumn()

    function Tab:CreateColumn()
        local Column = {
            Sections = {},
            Position = #self.Columns,
            CanInit = true,
            Tab = self
        }

        table.insert(self.Columns, Column)

        --// Column:CreateSection(title)

        function Column:CreateSection(title)
            local Section = {
                Title = tostring(title),
                Options = {},
                CanInit = true,
                Column = self
            }

            table.insert(self.Sections, Section)

            --// Section:AddLabel(text)

            function Section:AddLabel(text)
                local Option = {
                    Text = text
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

            --// Section:AddDivider(text)

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

            --// Section:AddButton(option)

            function Section:AddButton(option)
                option = typeof(option) == "table" and option or {}

                option.Section = self
                option.Text = tostring(option.Text)
                option.Callback = typeof(option.Callback) == "function" and option.Callback or function () end
                option.Type = "Button"
                option.Position = #self.Options
                option.Flag = (library.FlagPrefix and library.FlagPrefix .. " " or "") .. (option.Flag or option.Text)
                option.SubCount = 0
                option.CanInit = (option.CanInit ~= nil and option.CanInit) or true
                option.Tip = option.Tip and tostring(option.Tip)

                table.insert(self.Options, option)

                library.Options[option.Flag] = option

                --// option:AddKeybind(subOption)

                function option:AddKeybind(subOption)
                    subOption = typeof(subOption) == "table" and subOption or {}

                    subOption.Sub = true
                    subOption.SubPos = self.SubCount * 24

                    --// subOption:GetMain()

                    function subOption:GetMain()
                        option.Main.Size = UDim2.new(1, 0, 0, 40)

                        return option.Main
                    end

                    self.SubCount = self.SubCount + 1

                    return Section:AddKeybind(subOption)
                end

                --// option:AddColorPicker(subOption)

                function option:AddColorPicker(subOption)
                    subOption = typeof(subOption) == "table" and subOption or {}

                    subOption.Sub = true
                    subOption.SubPos = self.SubCount * 24

                    --// subOption:GetMain()

                    function subOption:GetMain()
                        option.Main.Size = UDim2.new(1, 0, 0, 40)

                        return option.Main
                    end

                    self.SubCount = self.SubCount + 1

                    return Section:AddColorPicker(subOption)
                end

                if library.HasInit and self.HasInit then
                    library.CreateButton(option, self.Content)
                else
                    option.Init = library.CreateButton
                end

                return option
            end

            --// Section:AddToggle(option)

            function Section:AddToggle(option)
                option = typeof(option) == "table" and option or {}

                option.Section = self
                option.Text = tostring(option.Text)
                option.Value = option.Value == nil and nil or (typeof(option.Value) == "boolean" and option.Value or false)
                option.Callback = typeof(option.Callback) == "function" and option.Callback or function () end
                option.Type = "Toggle"
                option.Position = #self.Options
                option.Flag = (library.FlagPrefix and library.FlagPrefix .. " " or "") .. (option.Flag or option.Text)
                option.SubCount = 0
                option.CanInit = (option.CanInit ~= nil and option.CanInit) or true
                option.Tip = option.Tip and tostring(option.Tip)
                option.Style = option.Style == 2

                library.Flags[option.Flag] = option.Value

                table.insert(self.Options, option)

                library.Options[option.Flag] = option

                --// option:AddColorPicker(subOption)

                function option:AddColorPicker(subOption)
                    subOption = typeof(subOption) == "table" and subOption or {}

                    subOption.Sub = true
                    subOption.SubPos = self.SubCount * 24

                    --// subOption:GetMain()

                    function subOption:GetMain()
                        return option.Main
                    end

                    self.SubCount = self.SubCount + 1

                    return Section:AddColorPicker(subOption)
                end

                --// option:AddKeybind(subOption)

                function option:AddKeybind(subOption)
                    subOption = typeof(subOption) == "table" and subOption or {}

                    subOption.Sub = true
                    subOption.SubPos = self.SubCount * 24

                    --// subOption:GetMain()

                    function subOption:GetMain()
                        return option.Main
                    end

                    self.SubCount = self.SubCount + 1

                    return Section:AddKeybind()
                end

                --// option:AddDropdown(subOption)

                function option:AddDropdown(subOption)
                    subOption = typeof(subOption) == "table" and subOption or {}

                    subOption.Sub = true

                    --// subOption:GetMain()

                    function subOption:GetMain()
                        return option.Main
                    end

                    self.SubCount = self.SubCount + 1

                    return Section:AddDropdown(subOption)
                end

                --// option:AddSlider(subOption)

                function option:AddSlider(subOption)
                    subOption = typeof(subOption) == "table" and subOption or {}

                    subOption.Sub = true

                    --// subOption:GetMain()

                    function subOption:GetMain()
                        return option.Main
                    end

                    self.SubCount = self.SubCount + 1

                    return Section:AddSlider(subOption)
                end

                if library.HasInit and self.HasInit then
                    library.CreateToggle(option, self.Content)
                else
                    option.Init = library.CreateToggle
                end

                return option
            end

            --// Section:AddKeybind(option)

            function Section:AddKeybind(option)
                option = typeof(option) == "table" and option or {}

                option.Section = self
                option.Text = tostring(option.Text)
                option.Key = (option.Key and option.Key.Name) or option.Key or "none"
                option.NoMouse = typeof(option.NoMouse) == "boolean" and option.NoMouse or false
                option.Mode = typeof(option.Mode) == "string" and (option.Mode == "Toggle" or option.Mode == "Hold" and option.Mode) or "Toggle"
                option.Callback = typeof(option.Callback) == "function" and option.Callback or function () end
                option.Type = "Keybind"
                option.Position = #self.Options
                option.Flag = (library.FlagPrefix and library.FlagPrefix .. " " or "") .. (option.Flag or option.Text)
                option.CanInit = (option.CanInit ~= nil and option.CanInit) or true
                option.Tip = option.Tip and tostring(option.Tip)

                table.insert(self.Options, option)

                library.Options[option.Flag] = option

                if library.HasInit and self.HasInit then
                    library.CreateKeybind(option, self.Content)
                else
                    option.Init = library.CreateKeybind
                end

                return option
            end

            --// Section:AddSlider(option)

            function Section:AddSlider(option)
                option = typeof(option) == "table" and option or {}

                option.Section = self
                option.Text = tostring(option.Text)
                option.Min = typeof(option.Min) == "number" and option.Min or 0
                option.Max = typeof(option.Max) == "number" and option.Max or 0
                option.Value = option.Min < 0 and 0 or math.clamp(typeof(option.Value) == "number" and option.Value or option.Min, option.Min, option.Max)
                option.Callback = typeof(option.Callback) == "function" and option.Callback or function () end
                option.Float = typeof(option.Value) == "number" and option.Float or 1
                option.Suffix = option.Suffix and tostring(option.Suffix) or ""
                option.TextPos = option.TextPos == 2
                option.Type = "Slider"
                option.Position = #self.Options
                option.Flag = (library.FlagPrefix and library.FlagPrefix .. " " or "") .. (option.Flag or option.Text)
                option.SubCount = 0
                option.CanInit = (option.CanInit ~= nil and option.CanInit) or true
                option.Tip = option.Tip and tostring(option.Tip)

                library.Flags[option.Flag] = option.Value

                table.insert(self.Options, option)

                library.Options[option.Flag] = option

                --// option:AddColorPicker(subOption)

                function option:AddColorPicker(subOption)
                    subOption = typeof(subOption) == "table" and subOption or {}

                    subOption.Sub = true
                    subOption.SubPos = self.SubCount * 24

                    --// subOption:GetMain()

                    function subOption:GetMain()
                        return option.Main
                    end

                    self.SubCount = self.SubCount + 1

                    return Section:AddColorPicker(subOption)
                end

                --// option:AddKeybind(subOption)

                function option:AddKeybind(subOption)
                    subOption = typeof(subOption) == "table" and subOption or {}

                    subOption.Sub = true
                    subOption.SubPos = self.SubCount * 24

                    --// subOption:GetMain()

                    function subOption:GetMain()
                        return option.Main
                    end

                    self.SubCount = self.SubCount + 1

                    return Section:AddKeybind(subOption)
                end

                if library.HasInit and self.HasInit then
                    library.CreateSlider(option, self.Content)
                else
                    option.Init = library.CreateSlider
                end

                return option
            end

            --// Section:AddDropdown(option)

            function Section:AddDropdown(option)
                option = typeof(option) == "table" and option or {}

                option.Section = self
                option.Text = tostring(option.Text)
                option.Values = typeof(option.Values) == "table" and option.Values or {}
                option.Callback = typeof(option.Callback) == "function" and option.Callback or function () end
                option.MultiSelect = typeof(option.MultiSelect) == "boolean" and option.MultiSelect or false
                option.Value = option.MultiSelect and (typeof(option.Value) == "table" and option.Value or {}) or tostring(option.Value or option.Values[1] or "")
                option.Max = option.Max or 4
                option.Open = false
                option.Type = "Dropdown"
                option.Position = #self.Options
                option.Labels = {}
                option.Flag = (library.FlagPrefix and library.FlagPrefix .. " " or "") .. (option.Flag or option.Text)
                option.SubCount = 0
                option.CanInit = (option.CanInit ~= nil and option.CanInit) or true
                option.Tip = option.Tip and tostring(option.Tip)

                if option.MultiSelect then
                    for i, v in next, option.Values do
                        option.Value[v] = false
                    end
                end

                library.Flags[option.Flag] = option.Value

                table.insert(self.Options, option)

                library.Options[option.Flag] = option

                --// option:AddValue(value, state)

                function option:AddValue(value, state)
                    if self.MultiSelect then
                        self.Values[value] = state
                    else
                        table.insert(self.Values, value)
                    end
                end

                --// option:AddColorPicker(subOption)

                function option:AddColorPicker(subOption)
                    subOption = typeof(subOption) == "table" and subOption or {}

                    subOption.Sub = true
                    subOption.SubPos = self.SubCount * 24

                    --// subOption:GetMain()

                    function subOption:GetMain()
                        return option.Main
                    end

                    self.SubCount = self.SubCount + 1

                    return Section:AddColorPicker(subOption)
                end

                --// option:AddKeybind(subOption)

                function option:AddKeybind(subOption)
                    subOption = typeof(subOption) == "table" and subOption or {}

                    subOption.Sub = true
                    subOption.SubPos = self.SubCount * 24

                    --// subOption:GetMain()

                    function subOption:GetMain()
                        return option.Main
                    end

                    self.SubCount = self.SubCount + 1

                    return Section:AddKeybind(subOption)
                end

                if library.HasInit and self.HasInit then
                    library.CreateDropdown(option, self.Content)
                else
                    option.Init = library.CreateDropdown
                end

                return option
            end

            --// Section:AddTextBox(option)

            function Section:AddTextBox(option)
                option = typeof(option) == "table" and option or {}

                option.Section = self
                option.Text = tostring(option.Text)
                option.Value = tostring(option.Value or "")
                option.Callback = typeof(option.Callback) == "function" and option.Callback or function () end
                option.Type = "TextBox"
                option.Position = #self.Options
                option.Flag = (library.FlagPrefix and library.FlagPrefix .. " " or "") .. (option.Flag or option.Text)
                option.CanInit = (option.CanInit ~= nil and option.CanInit) or true
                option.Tip = option.Tip and tostring(option.Tip)

                library.Flags[option.Flag] = option.Value

                table.insert(self.Options, option)

                library.Options[option.Flag] = option

                if library.HasInit and self.HasInit then
                    library.CreateTextBox(option, self.Content)
                else
                    option.Init = library.CreateTextBox
                end

                return option
            end

            --// Section:AddColorPicker(option)

            function Section:AddColorPicker(option)
                option = typeof(option) == "table" and option or {}

                option.Section = self
                option.Text = tostring(option.Text)
                option.Color = typeof(option.Color) == "table" and Color3.fromRGB(option.Color[1], option.Color[2], option.Color[3]) or option.Color or Color3.fromRGB(255, 255, 255)
                option.Callback = typeof(option.Callback) == "function" and option.Callback or function () end
                option.CallbackTransparency = typeof(option.CallbackTransparency) == "function" and option.CallbackTransparency or (option.CallbackTransparency == 1 and option.Callback) or function () end
                option.Open = false
                option.Transparency = tonumber(option.Transparency)
                option.SubCount = 1
                option.Type = "ColorPicker"
                option.Position = #self.Options
                option.Flag = (library.FlagPrefix and library.FlagPrefix .. " " or "") .. (option.Flag or option.Text)
                option.CanInit = (option.CanInit ~= nil and option.CanInit) or true
                option.Tip = option.Tip and tostring(option.Tip)

                library.Flags[option.Flag] = option.Color

                table.insert(self.Options, option)

                library.Options[option.Flag] = option

                --// option:AddColorPicker(subOption)

                function option:AddColorPicker(subOption)
                    subOption = typeof(subOption) == "table" and subOption or {}

                    subOption.Sub = true
                    subOption.SubPos = self.SubCount * 24

                    --// subOption:GetMain()

                    function subOption:GetMain()
                        return option.Main
                    end

                    self.SubCount = self.SubCount + 1

                    return Section:AddColorPicker(subOption)
                end

                if option.Transparency then
                    library.Flags[option.Flag .. "_Transparency"] = option.Transparency
                end

                if library.HasInit and self.HasInit then
                    library.CreateColorPicker(option, self.Content)
                else
                    option.Init = library.CreateColorPicker
                end

                return option
            end

            --// Section:SetTitle(newTitle)

            function Section:SetTitle(newTitle)
                self.Title = tostring(newTitle)

                if self.TitleText then
                    self.TitleText.Text = tostring(newTitle)
                end
            end

            --// Section:Init()

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
                    BackgroundColor3 = library.Flags["Menu Accent Color"],
                    BorderSizePixel = 0,
                    BorderMode = Enum.BorderMode.Inset,
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

        --// Column:Init()

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

    --// Tab:Init()

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

--// library:AddWarning(warning)

function library:AddWarning(warning)
    warning = typeof(warning) == "table" and warning or {}

    warning.Text = tostring(warning.Text)
    warning.Type = warning.Type == "Confirm" and "Confirm" or ""

    local Answer

    --// warning:Show()

    function warning:Show()
        library.Warning = warning

        if warning.Main and warning.Type == "" then
            return
        end

        if library.Popup then
            library.Popup:Close()
        end

        if not warning.Main then
            warning.Main = library:Create("TextButton", {
                ZIndex = 2,
                Size = UDim2.new(1, 0, 1, 0),
                BackgroundTransparency = 0.6,
                BackgroundColor3 = Color3.fromRGB(0, 0, 0),
                BorderSizePixel = 0,
                Text = "",
                AutoButtonColor = false,
                Parent = library.Main
            })

            warning.Message = library:Create("TextLabel", {
                ZIndex = 2,
                Position = UDim2.new(0, 20, 0.5, -60),
                Size = UDim2.new(1, -40, 0, 40),
                BackgroundTransparency = 1,
                TextSize = 16,
                Font = Enum.Font.Code,
                TextColor3 = Color3.fromRGB(255, 255, 255),
                TextWrapped = true,
                RichText = true,
                Parent = warning.Main
            })

            if warning.Type == "Confirm" then
                local Button = library:Create("TextLabel", {
                    ZIndex = 2,
                    Position = UDim2.new(0.5, -105, 0.5, -10),
                    Size = UDim2.new(0, 100, 0, 20),
                    BackgroundColor3 = Color3.fromRGB(40, 40, 40),
                    BorderColor3 = Color3.fromRGB(0, 0, 0),
                    Text = "Yes",
                    TextSize = 16,
                    Font = Enum.Font.Code,
                    TextColor3 = Color3.fromRGB(255, 255, 255),
                    Parent = warning.Main
                })

                library:Create("ImageLabel", {
                    ZIndex = 2,
                    Size = UDim2.new(1, 0, 1, 0),
                    BackgroundTransparency = 1,
                    Image = "rbxassetid://2454009026",
                    ImageColor3 = Color3.fromRGB(0, 0, 0),
                    ImageTransparency = 0.8,
                    Parent = Button
                })

                library:Create("ImageLabel", {
                    ZIndex = 2,
                    Size = UDim2.new(1, 0, 1, 0),
                    BackgroundTransparency = 1,
                    Image = "rbxassetid://2592362371",
                    ImageColor3 = Color3.fromRGB(60, 60, 60),
                    ScaleType = Enum.ScaleType.Slice,
                    SliceCenter = Rect.new(2, 2, 62, 62),
                    Parent = Button
                })

                local Button1 = library:Create("TextLabel", {
                    ZIndex = 2,
                    Position = UDim2.new(0.5, 5, 0.5, -10),
                    Size = UDim2.new(0, 100, 0, 20),
                    BackgroundColor3 = Color3.fromRGB(40, 40, 40),
                    BorderColor3 = Color3.fromRGB(0, 0, 0),
                    Text = "No",
                    TextSize = 16,
                    Font = Enum.Font.Code,
                    TextColor3 = Color3.fromRGB(255, 255, 255),
                    Parent = warning.Main
                })

                library:Create("ImageLabel", {
                    ZIndex = 2,
                    Size = UDim2.new(1, 0, 1, 0),
                    BackgroundTransparency = 1,
                    Image = "rbxassetid://2454009026",
                    ImageColor3 = Color3.fromRGB(0, 0, 0),
                    ImageTransparency = 0.8,
                    Parent = Button1
                })

                library:Create("ImageLabel", {
                    ZIndex = 2,
                    Size = UDim2.new(1, 0, 1, 0),
                    BackgroundTransparency = 1,
                    Image = "rbxassetid://2592362371",
                    ImageColor3 = Color3.fromRGB(60, 60, 60),
                    ScaleType = Enum.ScaleType.Slice,
                    SliceCenter = Rect.new(2, 2, 62, 62),
                    Parent = Button1
                })

                Button.InputBegan:Connect(function(input)
                    if input.UserInputType.Name == "MouseButton1" then
                        Answer = true
                    end
                end)

                Button1.InputBegan:Connect(function(input)
                    if input.UserInputType.Name == "MouseButton1" then
                        Answer = false
                    end
                end)
            else
                local Button = library:Create("TextLabel", {
                    ZIndex = 2,
                    Position = UDim2.new(0.5, -50, 0.5, -10),
                    Size = UDim2.new(0, 100, 0, 20),
                    BackgroundColor3 = Color3.fromRGB(30, 30, 30),
                    BorderColor3 = Color3.fromRGB(0, 0, 0),
                    Text = "Ok",
                    TextSize = 16,
                    Font = Enum.Font.Code,
                    TextColor3 = Color3.fromRGB(255, 255, 255),
                    Parent = warning.Main
                })

                library:Create("ImageLabel", {
                    ZIndex = 2,
                    Size = UDim2.new(1, 0, 1, 0),
                    BackgroundTransparency = 1,
                    Image = "rbxassetid://2454009026",
                    ImageColor3 = Color3.fromRGB(0, 0, 0),
                    ImageTransparency = 0.8,
                    Parent = Button
                })

                library:Create("ImageLabel", {
                    ZIndex = 2,
                    AnchorPoint = Vector2.new(0.5, 0.5),
                    Position = UDim2.new(0.5, 0, 0.5, 0),
                    Size = UDim2.new(1, -2, 1, -2),
                    BackgroundTransparency = 1,
                    Image = "rbxassetid://3570695787",
                    ImageColor3 = Color3.fromRGB(50, 50, 50),
                    Parent = Button
                })

                Button.InputBegan:Connect(function(input)
                    if input.UserInputType.Name == "MouseButton1" then
                        Answer = true
                    end
                end)
            end
        end

        warning.Main.Visible = true

        warning.Message.Text = warning.Text

        repeat
            task.wait()
        until Answer ~= nil

        spawn(warning.Close)

        library.Warning = nil

        return Answer
    end

    --// warning:Close()

    function warning:Close()
        Answer = nil

        if not warning.Main then
            return
        end

        warning.Main.Visible = false
    end

    return warning
end

--// library:Close()

function library:Close()
    self.Open = not self.Open

    if self.Main then
        if self.Popup then
            self.Popup:Close()
        end

        self.Main.Visible = self.Open
    end
end

--// library:Init()

function library:Init()
    if self.HasInit then
        return
    end

    self.HasInit = true

    self.Base = library:Create("ScreenGui", {
        IgnoreGuiInset = true,
        ZIndexBehavior = Enum.ZIndexBehavior.Global
    })

    if RunService:IsStudio() then
        self.Base.Parent = script.Parent.Parent
    elseif syn then
        pcall(function()
            self.Base.RobloxLocked = true
        end)

        self.Base.Parent = CoreGui
    end

    self.Main = self:Create("ImageButton", {
        AutoButtonColor = false,
        Position = UDim2.new(0, 100, 0, 46),
        Size = UDim2.new(0, 500, 0, 600),
        BackgroundColor3 = Color3.fromRGB(20, 20, 20),
        BorderColor3 = Color3.fromRGB(0, 0, 0),
        ScaleType = Enum.ScaleType.Tile,
        Modal = true,
        Visible = false,
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
        BackgroundColor3 = library.Flags["Menu Accent Color"],
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
        BackgroundColor3 = library.Flags["Menu Accent Color"],
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

    --// self:SelectTab(tab)

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
            TextColor3 = library.Flags["Menu Accent Color"]
        }):Play()

        self.TabHighlight:TweenPosition(UDim2.new(0, tab.Button.Position.X.Offset, 0, 50), "Out", "Quad", 0.2, true)
        self.TabHighlight:TweenSize(UDim2.new(0, tab.Button.AbsoluteSize.X, 0, -1), "Out", "Quad", 0.1, true)

        for _, c in next, tab.Columns do
            c.Main.Visible = true
        end
    end

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

    for _, t in next, self.Tabs do
        if t.CanInit then
            t:Init()

            self:SelectTab(t)
        end
    end

    self:AddConnection(UserInputService.InputEnded, function(input)
        if input.UserInputType.Name == "MouseButton1" and self.Slider then
            TweenService:Create(self.Slider.Slider, TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
                BorderColor3 = Color3.fromRGB(0, 0, 0)
            }):Play()

            repeat
                task.wait()
            until self.Slider.Slider.BorderColor3 == Color3.fromRGB(0, 0, 0)

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

            DragObject:TweenPosition(UDim2.new(StartPos.X.Scale, StartPos.X.Offset + Delta.X, StartPos.Y.Scale, YPos), "Out", "Quad", 0.1, true)
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

local function PromptLib()
    local ErrorPrompt = getrenv().require(CoreGui.RobloxGui.Modules.ErrorPrompt)

    local function NewScreen(screenName)
        local Screen = Instance.new("ScreenGui")

        Screen.Name = screenName
        Screen.ResetOnSpawn = false
        Screen.IgnoreGuiInset = true

        sethiddenproperty(Screen, "OnTopOfCoreBlur", true)

        Screen.RobloxLocked = true
        Screen.Parent = CoreGui

        return Screen
    end

    return function (title, message, buttons)
        local Screen = NewScreen("Prompt")

        local Prompt = ErrorPrompt.new("Default", {
            MessageTextScaled = false,
            PlayAnimation = false,
            HideErrorCode = true
        })

        for i, b in pairs(buttons) do
            local Old = b.Callback

            b.Callback = function(...)
                RunService:SetRobloxGuiFocused(false)

                Prompt:_close()

                Screen:Destroy()

                return Old(...)
            end
        end

        Prompt:setErrorTitle(title)
        Prompt:updateButtons(buttons)
        Prompt:setParent(Screen)

        RunService:SetRobloxGuiFocused(true)

        Prompt:_open(message)

        return Prompt, Screen
    end
end
