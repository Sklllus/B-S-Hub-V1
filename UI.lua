--[
--UI Library Made By xS_Killus
--]

--Instances And Functions

local CoreGui = game:GetService("CoreGui")
local HttpService = game:GetService("HttpService")
local MarketplaceService = game:GetService("MarketplaceService")
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")

local Client = Players.LocalPlayer

local Mouse = Client:GetMouse()

if not LPH_OBFUSCATED then
    local function R(f)
        return f
    end

    LPH_JIT_MAX = R
    LPH_NO_VIRTUALIZE = R
    LPH_JIT = R
end

local library = {
    Connections = {}
}

local Atlas = game:GetObjects("rbxassetid://11653746072")[1]

Atlas.Blank.Enabled = false

pcall(function()
    Atlas.Test:Destroy()
end)

--[
--UI Library Functions
--]

--[
--UpdateColorsUsingRegistry
--]

function library:UpdateColorsUsingRegistry()
    for _, obj in pairs(library.Registry) do
        for prop, color in next, obj.Properties do
            obj.Instance[prop] = library[color]
        end
    end
end

--[
--Lerp
--]

function library:Lerp(start, goal, alpha)
    return ((goal - start) * alpha) + start
end

--[
--Require
--]

function library:Require(a, m)
    if not a then
        error("Break-Skill Hub - V1 | " .. m)
    end
end

--[
--CreateInvisButton
--]

function library:CreateInvisButton(obj)
    local Button = Instance.new("Frame", obj)

    Button.Name = "Button"
    Button.Active = true
    Button.BackgroundTransparency = 1
    Button.Size = UDim2.new(1, 0, 1, 0)
    Button.ZIndex = 99999999

    local Selected = false

    local Activated = {}
    local MouseDown = {}
    local MouseUp = {}

    local ReturnValue = {
        ["Obj"] = Button,
        ["Activated"] = {},
        ["MouseButton1Down"] = {},
        ["MouseButton1Up"] = {},
        ["MouseLeave"] = Button.MouseLeave,
        ["MouseEnter"] = Button.MouseEnter
    }

    --[
    --Activated
    --]

    function ReturnValue.Activated:Connect(func)
        table.insert(Activated, func)
    end

    --[
    --MouseButton1Down
    --]

    function ReturnValue.MouseButton1Down:Connect(func)
        table.insert(MouseDown, func)
    end

    --[
    --MouseButton1Up
    --]

    function ReturnValue.MouseButton1Up:Connect(func)
        table.insert(MouseUp, func)
    end

    Button.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            Selected = true

            for _, v in pairs(MouseDown) do
                coroutine.wrap(v)()
            end
        end
    end)

    Button.MouseLeave:Connect(function()
        Selected = false
    end)

    Button.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 and Selected then
            Selected = false

            for _, v in pairs(Activated) do
                coroutine.wrap(v)()
            end
        end

        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            for _, v in pairs(MouseUp) do
                coroutine.wrap(v)()
            end
        end
    end)

    return ReturnValue
end

--[
--InitDragging
--]

function library:InitDragging(frame, button)
    button = button or frame

    assert(button and frame, "Break-Skill Hub - V1 | Need a frame in order to start dragging.")

    local Dragging = false
    local DraggingOffset

    local InputBegan = button.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            Dragging = true

            DraggingOffset = Vector2.new(Mouse.X, Mouse.Y) - frame.AbsolutePosition
        end
    end)

    local InputEnded = Mouse.Button1Up:Connect(function()
        Dragging = false

        DraggingOffset = nil
    end)

    local UpdateEvent

    LPH_JIT_MAX(function()
        UpdateEvent = RunService.RenderStepped:Connect(function(dt)
            if frame.Visible == false or not UserInputService:IsMouseButtonPressed(Enum.UserInputType.MouseButton1) then
                Dragging = false

                DraggingOffset = nil
            end

            if Dragging and DraggingOffset then
                local Lerp = 0.3

                local FinalPos = UDim2.fromOffset(Mouse.X - DraggingOffset.X + (frame.AbsoluteSize.X * frame.AnchorPoint.X), Mouse.Y - DraggingOffset.Y + 36 + (frame.AbsoluteSize.Y * frame.AnchorPoint.Y))

                frame.Position = frame.Position:Lerp(FinalPos, Lerp * (dt * 60))
            end
        end)
    end)()

    return {
        InputBegan,
        InputEnded, UpdateEvent
    }
end

--[
--FormatAsset
--]

function library:FormatAsset(asset)
    asset = asset or ""

    if type(asset) == "number" or (type(asset) == "string" and tonumber(asset)) then
        asset = tonumber(asset)

        return "rbxassetid://" .. tostring(asset)
    else
        return asset
    end
end

--[
--FormatNumber
--]

function library:FormatNumber(number)
    local Formatted = number

    while true do
        local k

        Formatted, k = string.gsub(Formatted, "^(-?%d+)(%d%d%d)", "%1,%2")

        if (k == 0) then
            break
        end
    end

    return Formatted
end

--[
--GetTextContrast
--]

function library:GetTextContrast(color)
    local R, G, B = color.R * 255, color.G * 255, color.B * 255

    return (((R * 0.299) + (G * 0.587) + (B * 0.114)) > 150) and Color3.fromRGB(0, 0, 0) or Color3.fromRGB(255, 255, 255)
end

--[
--BlankFunction
--]

library.BlankFunction = function()

end

--[
--CreateWindow
--]

function library:CreateWindow(options)
    library:Require(options.Name, "Missing argument (Name) for library:CreateWindow")

    options.Watermark = options.Watermark or options.Name or "Break-Skill Hub - V1 | " .. MarketplaceService:GetProductInfo(game.PlaceId).Name

    local FlagWatermark, Invite = "Watermark", "https://discord.com/ev8bxrAa9p"

    local Configs = {
        [FlagWatermark] = Invite
    }

    local RegisteredFlags = {
        [FlagWatermark] = true
    }

    local RemoveOldVar = "[BREAK-SKILL_STORAGE]"

    if not getgenv()[RemoveOldVar] then
        getgenv()[RemoveOldVar] = {}
    end

    if getgenv()[RemoveOldVar][options.Name] then
        getgenv()[RemoveOldVar][options.Name]()
    end

    local function Connect(connection, func)
        local Con = connection:Connect(func)

        table.insert(library.Connections, Con)

        return Con
    end

    if options.ConfigFolder then
        local ConfigPath = options.ConfigFolder .. "/configs.json"

        if not isfolder(options.ConfigFolder) then
            makefolder(options.ConfigFolder)
        end

        if isfile(ConfigPath) then
            Configs = HttpService:JSONDecode(readfile(ConfigPath))
        else
            writefile(ConfigPath, HttpService:JSONEncode(Configs))
        end

        local LastSave = os.clock()

        local SaveDelay = 0.1

        local function Save()
            local ToSave = {}

            for i, v in pairs(Configs) do
                ToSave[i] = v
            end

            ToSave[FlagWatermark] = Invite

            writefile(ConfigPath, HttpService:JSONEncode(ToSave))
        end

        Connect(RunService.RenderStepped, function()
            if os.clock() - LastSave > SaveDelay then
                LastSave = 9e9

                Save()

                LastSave = os.clock()
            end
        end)
    end

    local UI = Atlas.Blank:Clone()

    UI.Name = options.Name

    local Background = UI.Background

    Background.Top.Title.Text = options.Name

    UI.Watermark.TextLabel.Text = options.Watermark

    if RunService:IsStudio() then
        UI.Parent = script.Parent.Parent
    elseif gethui then
        UI.Parent = gethui()
    elseif syn.protect_gui then
        syn.protect_gui(UI)

        UI.Parent = CoreGui
    elseif protectgui then
        protectgui(UI)

        UI.Parent = CoreGui
    elseif CoreGui:FindFirstChild("RobloxGui") then
        UI.Parent = CoreGui:FindFirstChild("RobloxGui")
    else
        UI.Parent = CoreGui
    end

    Background.Top.Active = true

    UI.Watermark.Active = true

    local function StartDragging(...)
        local Init = library:InitDragging(...)

        for _, v in pairs(Init) do
            table.insert(library.Connections, v)
        end
    end

    StartDragging(Background, Background.Top)
    StartDragging(UI.Keybinds, UI.Keybinds)
    StartDragging(UI.Watermark, UI.Watermark)

    local WindowFunctions = {
        Obj = UI,
        Theme = {
            FontColor = Color3.fromRGB(215, 215, 215),
            MainColor = Color3.fromRGB(30, 30, 30),
            BackgroundColor = Color3.fromRGB(20, 20, 20),
            AccentColor = options.Color or Color3.fromRGB(255, 30, 30),
            OutlineColor = Color3.fromRGB(50, 50, 50)
        }
    }

    --[
    --RegisterCustomFlag
    --]

    function WindowFunctions:RegisterCustomFlag(flag)
        library:Require(not RegisteredFlags[flag], "Flag already registered, pick another one (" .. flag .. ").")

        RegisteredFlags[flag] = true

        return {
            ["Flag"] = flag,
            ["Get"] = function()
                return Configs[flag]
            end,
            ["Set"] = function(val)
                Configs[flag] = val
            end
        }
    end

    local CloseMenu do
        local MenuButton = library:CreateInvisButton(Background.Top.Menu)

        local State = false

        local Tween = nil

        local PagesInfo = TweenInfo.new(0.2, Enum.EasingStyle.Sine, Enum.EasingDirection.In, 0, false, 0)

        Background.Pages.Size = UDim2.new(0, 0, 1, 0)

        local function SetState(new)
            if State ~= new then
                State = new

                pcall(function()
                    Tween:Cancel()
                    Tween:Destroy()

                    Tween = nil
                end)

                Tween = TweenService:Create(Background.Pages, PagesInfo, {
                    ["Size"] = State and UDim2.new(0, 145, 1, 0) or UDim2.new(0, 0, 1, 0)
                })

                Tween:Play()
            end
        end

        Connect(RunService.RenderStepped, function()
            Background.Pages.Visible = Background.Pages.AbsoluteSize.X > 8
        end)

        Connect(MenuButton.Activated, function()
            SetState(not State)
        end)

        function CloseMenu()
            SetState(false)
        end
    end

    do
        local Last = nil

        Connect(RunService.Heartbeat, function()
            local Before = UserInputService.MouseIconEnabled

            if Background.Visible then
                local Pos = UserInputService:GetMouseLocation()

                UI.Mouse.Visible = true
                UI.Mouse.Position = UDim2.fromOffset(Pos.X, Pos.Y)

                UserInputService.MouseIconEnabled = false
            elseif Last then
                UI.Mouse.Visible = false

                UserInputService.MouseIconEnabled = Before
            end

            Last = Background.Visible
        end)
    end

    local LastPage = 0

    local CurrentPage do
        CurrentPage = 1

        Connect(RunService.RenderStepped, function()
            for _, v in pairs(Background.Content.Pages:GetChildren()) do
                if v:FindFirstChild("PageNum") then
                    v.Visible = v.PageNum.Value == CurrentPage
                end
            end

            for _, v in pairs(Background.Pages.Inner.ScrollingFrame:GetChildren()) do
                if v:FindFirstChild("PageNum") then
                    v.BackgroundTransparency = v.PageNum.Value == CurrentPage and 0 or 1
                end
            end
        end)
    end

    --[
    --CreatePage
    --]

    function WindowFunctions:CreatePage(p_Name, p_Icon)
        if type(p_Name) == "table" then
            p_Name = p_Name.Name
            p_Icon = p_Name.Icon
        end

        library:Require(p_Name, "Missing argument (Name) for Window:CreatePage")

        if p_Icon then
            p_Icon = library:FormatAsset(p_Icon)
        end

        local Select = Atlas.Objects.PageSelect:Clone()

        local Holder = Atlas.Objects.Page:Clone()

        LastPage = LastPage + 1

        local PageNum = LastPage

        do
            local IntValue = Instance.new("IntValue", Select)

            IntValue.Name = "PageNum"
            IntValue.Value = PageNum

            IntValue:Clone().Parent = Holder
        end

        local PageFunctions = {
            ["Select"] = Select,
            ["Holder"] = Holder
        }

        Connect(Select.Button.Activated, function()
            if CurrentPage ~= PageNum then
                CurrentPage = PageNum

                CloseMenu()
            end
        end)

        Select.Name = string.rep("a", PageNum)
        Select.Parent = Background.Pages.Inner.ScrollingFrame

        Holder.Name = string.rep("a", PageNum)
        Holder.Parent = Background.Content.Pages

        Select.Frame.TextLabel.Text = p_Name

        Select.Frame.Icon.Image = p_Icon

        local function GetElementMethods(holder)
            local Elements = {}

            local ElementIncrement = 1

            --[
            --AddDivider
            --]

            function Elements:AddDivider()
                local Element = {}

                local Obj = Atlas.Objects.Divider:Clone()

                Obj.Name = string.rep("a", ElementIncrement)
                Obj.Parent = holder

                ElementIncrement = ElementIncrement + 1

                return Element
            end

            --[
            --AddButton
            --]

            function Elements:AddButton(name, callback)
                library:Require(name, "Missing argument (Name) for Section:AddButton")

                callback = callback or library.BlankFunction

                local Element = {}

                local Obj = Atlas.Objects.Button:Clone()

                Obj.Name = string.rep("a", ElementIncrement)
                Obj.Title.Text = name
                Obj.Parent = holder

                ElementIncrement = ElementIncrement + 1

                --[
                --Trigger
                --]

                function Element:Trigger()
                    coroutine.wrap(pcall)(callback)
                end

                do
                    local Button = library:CreateInvisButton(Obj)

                    local Holding = false

                    local function SetHolding(state)
                        Holding = state

                        Obj.BackgroundColor3 = Holding and WindowFunctions.Theme.FontColor or WindowFunctions.Theme.MainColor

                        Obj.Title.TextColor3 = Holding and WindowFunctions.Theme.MainColor or WindowFunctions.Theme.FontColor
                    end

                    Connect(Button.MouseButton1Down, function()
                        SetHolding(true)
                    end)

                    Connect(Button.MouseButton1Up, function()
                        if Holding then
                            Element:Trigger()

                            SetHolding(false)
                        end
                    end)

                    Connect(Button.MouseLeave, function()
                        SetHolding(false)
                    end)
                end

                return Element
            end

            --[
            --AddSubButtons
            --]

            function Elements:AddSubButtons(name1, name2, callback1, callback2)
                library:Require(name1, "Missing argument (Name1) for Section:AddSubButtons")
                library:Require(name2, "Missing argument (Name2) for Section:AddSubButtons")

                callback1 = callback1 or library.BlankFunction
                callback2 = callback2 or library.BlankFunction

                local Element = {}

                local Obj = Atlas.Objects.SubButtons:Clone()

                Obj.Name = string.rep("a", ElementIncrement)
                Obj.Parent = holder

                Obj.Left.Title.Text = name1

                Obj.Right.Title.Text = name2

                ElementIncrement = ElementIncrement + 1

                --[
                --Trigger1
                --]

                function Element:Trigger1()
                    coroutine.wrap(pcall)(callback1)
                end

                --[
                --Trigger2
                --]

                function Element:Trigger2()
                    coroutine.wrap(pcall)(callback2)
                end

                do
                    local Button = library:CreateInvisButton(Obj.Left)

                    local Holding = false

                    local function SetHolding(state)
                        Holding = state

                        Obj.Left.BackgroundColor3 = Holding and WindowFunctions.Theme.FontColor or WindowFunctions.Theme.MainColor

                        Obj.Left.Title.TextColor3 = Holding and WindowFunctions.Theme.MainColor or WindowFunctions.Theme.FontColor
                    end

                    Connect(Button.MouseButton1Down, function()
                        SetHolding(true)
                    end)

                    Connect(Button.MouseButton1Up, function()
                        if Holding then
                            Element:Trigger1()

                            SetHolding(false)
                        end
                    end)

                    Connect(Button.MouseLeave, function()
                        SetHolding(false)
                    end)
                end

                do
                    local Button = library:CreateInvisButton(Obj.Right)

                    local Holding = false

                    local function SetHolding(state)
                        Holding = state

                        Obj.Right.BackgroundColor3 = Holding and WindowFunctions.Theme.FontColor or WindowFunctions.Theme.MainColor

                        Obj.Right.Title.TextColor3 = Holding and WindowFunctions.Theme.MainColor or WindowFunctions.Theme.FontColor
                    end

                    Connect(Button.MouseButton1Down, function()
                        SetHolding(true)
                    end)

                    Connect(Button.MouseButton1Up, function()
                        if Holding then
                            Element:Trigger2()

                            SetHolding(false)
                        end
                    end)

                    Connect(Button.MouseLeave, function()
                        SetHolding(false)
                    end)
                end

                return Element
            end

            --[
            --AddToggle
            --]

            function Elements:AddToggle(flag, options)
                library:Require(options.Name, "Missing argument (Name) for Section:AddToggle")
                library:Require(flag, "Missing argument (Flag) for Section:AddToggle")
                library:Require(not RegisteredFlags[flag], "Flag already registered, pick another one (" .. flag .. ").")

                RegisteredFlags[flag] = true

                if options.Default == nil then
                    options.Default = false
                end

                options.Callback = options.Callback or library.BlankFunction

                if options.SavingDisabled then
                    Configs[flag] = nil
                end

                if Configs[flag] == nil then
                    Configs[flag] = options.Default
                end

                local Element = {}

                local Obj = Atlas.Objects.Toggle:Clone()

                Obj.Name = string.rep("a", ElementIncrement)
                Obj.Parent = holder

                Obj.Title.Text = options.Name

                ElementIncrement = ElementIncrement + 1

                --[
                --Set
                --]

                function Element:Set(newValue)
                    if newValue ~= Configs[flag] then
                        Configs[flag] = newValue

                        coroutine.wrap(options.Callback)(Configs[flag])
                    end
                end

                --[
                --Toggle
                --]

                function Element:Toggle()
                    return Element:Set(not Configs[flag])
                end

                Element:Set(Configs[flag])

                do
                    local Last = Configs[flag]

                    local LastChanged = 0

                    local ToggleTweenTime = 0.1

                    Obj.Frame.ImageLabel.Visible = true

                    Connect(RunService.RenderStepped, function()
                        if Last ~= Configs[flag] then
                            LastChanged = os.clock()

                            Last = Configs[flag]
                        end

                        local TweenTime = os.clock() - LastChanged

                        local Alpha = math.clamp(TweenTime / ToggleTweenTime, 0, 1)

                        local Value = TweenService:GetValue(Alpha, Enum.EasingStyle.Sine, Enum.EasingDirection.In)

                        Obj.Frame.BackgroundColor3 = (Configs[flag] and WindowFunctions.Theme.BackgroundColor or WindowFunctions.Theme.AccentColor):Lerp(Configs[flag] and WindowFunctions.Theme.AccentColor or WindowFunctions.Theme.BackgroundColor, Value)

                        Obj.Frame.ImageLabel.ImageTransparency = Configs[flag] and 1 - Alpha or Alpha
                        Obj.Frame.ImageLabel.ImageColor3 = library:GetTextContrast(WindowFunctions.Theme.AccentColor)
                    end)

                    local Button = library:CreateInvisButton(Obj)

                    Button.Activated:Connect(function()
                        Element:Toggle()
                    end)
                end

                return Element
            end

            --[
            --AddSlider
            --]

            function Elements:AddSlider(flag, options)
                library:Require(options.Name, "Missing argument (Name) for Section:AddSlider")
                library:Require(flag, "Missing argument (Flag) for Section:AddSlider")
                library:Require(options.Min, "Missing argument (Min) for Section:AddSlider")
                library:Require(options.Max, "Missing argument (Max) for Section:AddSlider")
                library:Require(options.Min < options.Max, "Max argument must be greater than Min argument for Section:AddSlider")
                library:Require(not RegisteredFlags[flag], "Flag already registered, pick another one (" .. flag .. ").")

                RegisteredFlags[flag] = true

                if options.Default == nil then
                    options.Default = (options.Max + options.Min) / 2
                end

                options.DecimalPlaces = options.DecimalPlaces or 0

                if options.AllowValuesOutsideRange == nil then
                    options.AllowValuesOutsideRange = false
                end

                options.Callback = options.Callback or library.BlankFunction

                if options.SavingDisabled then
                    Configs[flag] = nil
                end

                if Configs[flag] == nil then
                    Configs[flag] = options.Default
                end

                if not options.AllowValuesOutsideRange then
                    options.Default = math.clamp(options.Default, options.Min, options.Max)

                    Configs[flag] = math.clamp(Configs[flag], options.Min, options.Max)
                end

                local Element = {}

                local Obj = Atlas.Objects.Slider:Clone()

                Obj.Name = string.rep("a", ElementIncrement)
                Obj.Parent = holder

                Obj.Title.Text = options.Name

                ElementIncrement = ElementIncrement + 1

                --[
                --UpdateText
                --]

                function Element:UpdateText()
                    Obj.TextBox.Text = library:FormatNumber(Configs[flag])
                end

                --[
                --Set
                --]

                function Element:Set(newValue)
                    newValue = math.round(newValue * (10 ^ options.DecimalPlaces)) / (10 ^ options.DecimalPlaces)

                    if not options.AllowValuesOutsideRange then
                        newValue = math.clamp(newValue, options.Min, options.Max)
                    end

                    if newValue ~= Configs[flag] then
                        Configs[flag] = newValue

                        coroutine.wrap(options.Callback)(Configs[flag])
                    end

                    Element:UpdateText()
                end

                Element:Set(Configs[flag])

                do
                    local Lerp = 0.3

                    local Button = library:CreateInvisButton(Obj.ImageLabel)

                    local Inside = Obj.ImageLabel.ImageLabel

                    Button.Obj.Size = UDim2.new(1, 0, 3, 0)
                    Button.Obj.AnchorPoint = Vector2.new(0, 0.5)
                    Button.Obj.Position = UDim2.fromScale(0, 0.5)

                    local Holding = false

                    Button.MouseButton1Down:Connect(function()
                        Holding = true
                    end)

                    Connect(UserInputService.InputEnded, function(input)
                        if input.UserInputType == Enum.UserInputType.MouseButton1 then
                            Holding = false
                        end
                    end)

                    Inside.ImageLabel.Size = UDim2.fromScale((Configs[flag] - options.Min) / options.Max, 1)

                    Connect(RunService.RenderStepped, function(dt)
                        if Holding then
                            local Percent = ((Mouse.X - (Inside.AbsolutePosition.X)) / Inside.AbsoluteSize.X)

                            if not options.AllowValuesOutsideRange then
                                Percent = math.clamp(Percent, 0, 1)
                            end

                            Element:Set(math.round((((options.Max - options.Min) * Percent) + options.Min) * (10 ^ options.DecimalPlaces)) / (10 ^ options.DecimalPlaces))
                        end

                        Inside.ImageLabel.Size = UDim2.fromScale(math.clamp(library:Lerp(Inside.ImageLabel.Size.X.Scale, (Configs[flag] - options.Min) / (options.Max - options.Min), math.clamp(Lerp * (dt * 60), 0, 1)), 0, 1), 1)
                    end)

                    Obj.TextBox.FocusLost:Connect(function(enterPressed)
                        local New = tonumber(Obj.TextBox.Text)

                        if New then
                            Element:Set(New)
                        else
                            Element:UpdateText()
                        end
                    end)
                end

                return Element
            end

            --[
            --AddSliderToggle
            --]

            function Elements:AddSliderToggle(sliderFlag, toggleFlag, options)
                library:Require(options.Name, "Missing argument (Name) for Section:AddSliderToggle")
                library:Require(sliderFlag, "Missing argument (SliderFlag) for Section:AddSliderToggle")
                library:Require(toggleFlag, "Missing argument (ToggleFlag) for Section:AddSliderToggle")
                library:Require(options.Min, "Missing argument (Min) for Section:AddSliderToggle")
                library:Require(options.Max, "Missing argument (Max) for Section:AddSliderToggle")
                library:Require(options.Min < options.Max, "Max argument must be greater than Min argument for Section:AddSliderToggle")
                library:Require(not RegisteredFlags[sliderFlag], "Flag already registered, pick another one (" .. sliderFlag .. ").")
                library:Require(not RegisteredFlags[toggleFlag], "Flag already registered, pick another one (" .. toggleFlag .. ").")

                RegisteredFlags[sliderFlag] = true
                RegisteredFlags[toggleFlag] = true

                if options.Default == nil then
                    options.Default = (options.Max + options.Min) / 2
                end

                options.DecimalPlaces = options.DecimalPlaces or 0

                if options.AllowValuesOutsideRange == nil then
                    options.AllowValuesOutsideRange = false
                end

                options.SliderCallback = options.SliderCallback or library.BlankFunction
                options.ToggleCallback = options.ToggleCallback or library.BlankFunction

                if options.SavingDisabled then
                    Configs[sliderFlag] = nil
                    Configs[toggleFlag] = nil
                end

                if Configs[sliderFlag] == nil then
                    Configs[sliderFlag] = options.SliderDefault
                end

                if Configs[toggleFlag] == nil then
                    Configs[toggleFlag] = options.ToggleDefault
                end

                if not options.AllowValuesOutsideRange then
                    options.SliderDefault = math.clamp(options.SliderDefault, options.Min, options.Max)

                    Configs[sliderFlag] = math.clamp(Configs[sliderFlag], options.Min, options.Max)
                end

                local Element = {}

                local Obj = Atlas.Objects.SliderToggle:Clone()

                Obj.Name = string.rep("a", ElementIncrement)
                Obj.Parent = holder

                Obj.Title.Text = options.Name

                ElementIncrement = ElementIncrement + 1

                --[
                --UpdateText
                --]

                function Element:UpdateText()
                    Obj.TextBox.Text = library:FormatNumber(Configs[sliderFlag])
                end

                --[
                --SetSlider
                --]

                function Element:SetSlider(newValue)
                    newValue = math.round(newValue * (10 ^ options.DecimalPlaces)) / (10 ^ options.DecimalPlaces)

                    if not options.AllowValuesOutsideRange then
                        newValue = math.clamp(newValue, options.Min, options.Max)
                    end

                    if newValue ~= Configs[sliderFlag] then
                        Configs[sliderFlag] = newValue

                        coroutine.wrap(options.SliderCallback)(Configs[sliderFlag])
                    end

                    Element:UpdateText()
                end

                Element:SetSlider(Configs[sliderFlag])

                --[
                --SetToggle
                --]

                function Element:SetToggle(newValue)
                    if newValue ~= Configs[toggleFlag] then
                        Configs[toggleFlag] = newValue

                        coroutine.wrap(options.ToggleCallback)(Configs[toggleFlag])
                    end
                end

                --[
                --Toggle
                --]

                function Element:Toggle()
                    return Element:SetToggle(not Configs[toggleFlag])
                end

                Element:SetToggle(Configs[toggleFlag])

                do
                    local Last = Configs[toggleFlag]

                    local LastChanged = 0

                    local ToggleTweenTime = 0.1

                    Obj.Frame.ImageLabel.Visible = true

                    Connect(RunService.RenderStepped, function()
                        if Last ~= Configs[toggleFlag] then
                            LastChanged = os.clock()

                            Last = Configs[toggleFlag]
                        end

                        local TweenTime = os.clock() - LastChanged

                        local Alpha = math.clamp(TweenTime / ToggleTweenTime, 0, 1)

                        local Value = TweenService:GetValue(Alpha, Enum.EasingStyle.Sine, Enum.EasingDirection.In)

                        Obj.Frame.BackgroundColor3 = (Configs[toggleFlag] and WindowFunctions.Theme.BackgroundColor or WindowFunctions.Theme.AccentColor):Lerp(Configs[toggleFlag] and WindowFunctions.Theme.AccentColor or WindowFunctions.Theme.BackgroundColor, Value)

                        Obj.Frame.ImageLabel.ImageTransparency = Configs[toggleFlag] and 1 - Alpha or Alpha
                    end)

                    local Button = library:CreateInvisButton(Obj)

                    Button.Obj.AnchorPoint = Vector2.new(0, 0)
                    Button.Obj.Position = UDim2.fromOffset(0, 0)
                    Button.Obj.Size = UDim2.fromScale(0.89, 0.5)

                    local Button2 = library:CreateInvisButton(Obj)

                    Button2.Obj.AnchorPoint = Vector2.new(1, 0)
                    Button2.Obj.Position = UDim2.fromScale(1, 0)
                    Button2.Obj.Size = UDim2.fromScale(0.11, 1)

                    local function Activated()
                        if not Obj.TextBox:IsFocused() then
                            Element:Toggle()
                        end
                    end

                    Button.Activated:Connect(Activated)
                    Button2.Activated:Connect(Activated)
                end

                do
                    local Lerp = 0.3

                    local Button = library:CreateInvisButton(Obj.ImageLabel)

                    local Inside = Obj.ImageLabel.ImageLabel

                    Button.Obj.Size = UDim2.new(1, 0, 3, 0)
                    Button.Obj.AnchorPoint = Vector2.new(0, 0.5)
                    Button.Obj.Position = UDim2.fromScale(0, 0.5)

                    local Holding = false

                    Button.MouseButton1Down:Connect(function()
                        Holding = true
                    end)

                    Connect(UserInputService.InputEnded, function(input)
                        if input.UserInputType == Enum.UserInputType.MouseButton1 then
                            Holding = false
                        end
                    end)

                    Inside.ImageLabel.Size = UDim2.fromScale((Configs[sliderFlag] - options.Min) / options.Max, 1)

                    Connect(RunService.RenderStepped, function(dt)
                        if Holding then
                            local Percent = ((Mouse.X - (Inside.AbsolutePosition.X)) / Inside.AbsoluteSize.X)

                            if not options.AllowValuesOutsideRange then
                                Percent = math.clamp(Percent, 0, 1)
                            end

                            Element:SetSlider(math.round((((options.Max - options.Min) * Percent) + options.Max) * (10 ^ options.DecimalPlaces)) / (10 ^ options.DecimalPlaces))
                        end

                        Inside.ImageLabel.Size = UDim2.fromScale(math.clamp(library:Lerp(Inside.ImageLabel.Size.X.Scale, (Configs[sliderFlag] - options.Min) / (options.Max - options.Min), math.clamp(Lerp * (dt * 60), 0, 1)), 0, 1), 1)
                    end)

                    Obj.TextBox.FocusLost:Connect(function(enterPressed)
                        local New = tonumber(Obj.TextBox.Text)

                        if New then
                            Element:SetSlider(New)
                        else
                            Element:UpdateText()
                        end
                    end)
                end

                return Element
            end

            --[
            --AddTextBox
            --]

            function Elements:AddTextBox(flag, options)
                library:Require(options.Name, "Missing argument (Name) for Section:AddTextBox")
                library:Require(flag, "Missing argument (Flag) for Section:AddTextBox")
                library:Require(not RegisteredFlags[flag], "Flag already registered, pick another one (" .. flag .. ").")

                RegisteredFlags[flag] = true

                options.DefaultText = options.DefaultText or ""
                options.PlaceholderText = options.PlaceholderText or "New TextBox"

                if options.ClearTextOnFocus == nil then
                    options.ClearTextOnFocus = true
                end

                options.Callback = options.Callback or library.BlankFunction
                options.TabComplete = options.TabComplete or library.BlankFunction
                options.OnlyCallbackOnEnterPressed = options.OnlyCallbackOnEnterPressed and true

                if options.SavingDisabled then
                    Configs[flag] = nil
                end

                if Configs[flag] == nil then
                    Configs[flag] = options.DefaultText
                end

                local Element = {}

                local Obj = Atlas.Objects.Textbox:Clone()

                Obj.Name = string.rep("a", ElementIncrement)
                Obj.Parent = holder

                Obj.Title.Text = options.Name

                ElementIncrement = ElementIncrement + 1

                local Inner = Obj.Textbox.Inner.Frame
                local TextBox = Inner.TextBox

                TextBox.PlaceholderText = options.PlaceholderText
                TextBox.ClearTextOnFocus = options.ClearTextOnFocus

                --[
                --UpdateTextBox
                --]

                function Element:UpdateTextBox()
                    TextBox.Text = Configs[flag]
                end

                --[
                --Set
                --]

                function Element:Set(new)
                    pcall(function()
                        TextBox:ReleaseFocus()
                    end)

                    Configs[flag] = new

                    Element:UpdateTextBox()

                    coroutine.wrap(options.Callback)(new)
                end

                do
                    Element:UpdateTextBox()

                    TextBox.FocusLost:Connect(function(enterPressed, input)
                        if input then
                            local RunCallback = false

                            if options.OnlyCallbackOnEnterPressed then
                                if enterPressed then
                                    RunCallback = true
                                end
                            else
                                RunCallback = true
                            end

                            if RunCallback then
                                Element:Set(TextBox.Text)
                            else
                                Element:UpdateTextBox()
                            end
                        end
                    end)

                    Connect(UserInputService.InputBegan, function(input)
                        if input.UserInputType == Enum.UserInputType.Keyboard and input.KeyCode == Enum.KeyCode.Tab and TextBox:IsFocused() then
                            local Result

                            local Success, Result2 = pcall(function()
                                Result = options.TabComplete(TextBox.Text)
                            end)

                            if not TextBox:IsFocused() then
                                return
                            end

                            if not Success then
                                warn("Break-Skill Hub - V1 | Error in tab completion function: " .. Result2)

                                error()
                            end

                            TextBox.Text = Result or TextBox.Text

                            TextBox:GetPropertyChangedSignal("Text"):Wait()

                            TextBox.Text = TextBox.Text:gsub("\t", ""):gsub("^%s+", ""):gsub("%s+$", "")
                        end
                    end)
                end

                return Element
            end

            --[
            --AddDropdown
            --]

            function Elements:AddDropdown(flag, options)
                library:Require(options.Name, "Missing argument (Name) for Section:AddDropdown")
                library:Require(flag, "Missing argument (Flag) for Section:AddDropdown")
                library:Require(options.Values and #options.Values > 0, "Missing argument (Flag) for Section:AddDropdown")
                library:Require(not RegisteredFlags[flag], "Flag already registered, pick another one (" .. flag .. ").")

                RegisteredFlags[flag] = true

                local Acceptable = {
                    "Single",
                    "Multi"
                }

                if options.SelectType and (not table.find(Acceptable, options.SelectType)) then
                    warn("Break-Skill Hub - V1 | Select type (" .. options.SelectType .. ") invalid. (Acceptable select types: " .. table.concat(Acceptable, ", ") .. ".")
                end

                if options.Default == nil then
                    options.Default = options.Values[1]
                end

                options.Callback = options.Callback or library.BlankFunction

                if options.SavingDisabled or options.SavingDisabled then
                    Configs[flag] = nil
                end

                if Configs[flag] == nil then
                    Configs[flag] = options.Default
                end

                local Element = {}

                local Obj = Atlas.Objects.Dropdown:Clone()

                Obj.Name = string.rep("a", ElementIncrement)
                Obj.Parent = holder

                Obj.Bar.Text = options.Name

                ElementIncrement = ElementIncrement + 1

                local Values = {}

                if options.SelectType == "Multi" and type(Configs[flag]) == "string" then
                    Configs[flag] = {
                        Configs[flag]
                    }
                end

                if options.SelectType == "Single" and type(Configs[flag]) == "table" then
                    Configs[flag] = Configs[flag][1]
                end

                if not options.SelectType then
                    Configs[flag] = nil
                end

                local function MakeDropdownButton()
                    local New = Atlas.Objects.DropdownButton:Clone()

                    New.Active = true

                    local Holding = false

                    local function SetHolding(state)
                        Holding = state

                        New.Inner.BackgroundColor3 = Holding and WindowFunctions.Theme.FontColor or WindowFunctions.Theme.BackgroundColor

                        New.Inner.Title.TextColor3 = Holding and WindowFunctions.Theme.BackgroundColor or WindowFunctions.Theme.FontColor
                    end

                    New.InputBegan:Connect(function(input)
                        if input.UserInputType == Enum.UserInputType.MouseButton1 then
                            SetHolding(true)
                        end
                    end)

                    New.InputEnded:Connect(function(input)
                        if Holding and input.UserInputType == Enum.UserInputType.MouseButton1 then
                            if Holding then
                                local Content = New.Inner.Title.Text

                                coroutine.wrap(options.Callback)(Content)

                                if options.SelectType == "Single" then
                                    Configs[flag] = Content
                                elseif options.SelectType == "Multi" then
                                    if table.find(Configs[flag], Content) then
                                        local Occ = table.find(Configs[flag], Content)

                                        table.remove(Configs[flag], Occ)
                                    else
                                        table.insert(Configs[flag], Content)
                                    end
                                end

                                SetHolding(false)
                            end
                        end
                    end)

                    New.MouseLeave:Connect(function()
                        SetHolding(false)
                    end)

                    New.Parent = Obj.Content.ScrollingFrame

                    return New
                end

                --[
                --Set
                --]

                function Element:Set(new)
                    if Values ~= new and #new > 0 then
                        local Seen = {}

                        for _, v in pairs(new) do
                            if Seen[v] then
                                warn("Break-Skill Hub - V1 | Items in dropdown cannot appear twice (" .. v .. ")")

                                return false
                            end

                            Seen[v] = true
                        end

                        local NewLength = #new
                        local OldLength = #Values

                        Values = new

                        if NewLength > OldLength then
                            for i = 1, NewLength - OldLength do
                                MakeDropdownButton()
                            end
                        elseif OldLength > NewLength then
                            for i = 1, OldLength - NewLength do
                                local Frame = Obj.Content.ScrollingFrame:FindFirstChildOfClass("Frame")

                                if Frame then
                                    Frame:Destroy()
                                end
                            end
                        end

                        local Count = 1

                        for _, v in pairs(Obj.Content.ScrollingFrame:GetChildren()) do
                            if v:IsA("Frame") then
                                v.Name = tostring(Count)

                                v.Inner.Title.Text = new[Count]

                                Count = Count + 1
                            end
                        end
                    end
                end

                if options.SelectType then
                    Connect(RunService.RenderStepped, function()
                        if options.SelectType == "Single" then
                            Obj.Bar.Text = options.Name .. ": " .. (Configs[flag] or "None")
                        else
                            Obj.Bar.Text = options.Name .. ": " .. (#Configs[flag] == 0 and "None" or table.concat(Configs[flag], ", "))
                        end
                    end)
                end

                --[
                --Select
                --]

                function Element:Select(new)
                    if options.SelectType then
                        if options.SelectType == "Multi" and type(new) == "table" then
                            Configs[flag] = new
                        elseif options.SelectType == "Single" and type(new) == "string" then
                            Configs[flag] = new
                        else
                            warn("Break-Skill Hub - V1 | Unable to select item's in dropdown bc parameter is invalid.")
                        end
                    else
                        warn("Break-Skill Hub - V1 | You can only use Dropdown:Select when SelectType is set.")
                    end
                end

                --[
                --Get
                --]

                function Element:Get()
                    if options.SelectType then
                        return Configs[flag]
                    else
                        warn("Break-Skill Hub - V1 | You can only use Dropdown:Get when SelectType is set.")
                    end
                end

                Element:Set(options.Values)

                do
                    local Bar = Obj.Bar
                    local Arrow = Bar.ImageLabel

                    local Tween1
                    local Tween2

                    local TweenInfo = TweenInfo.new(0.25, Enum.EasingStyle.Sine, Enum.EasingDirection.In, 0, false, 0)

                    Obj["BarPadding"].Visible = false

                    local SetState do
                        local State = false

                        Obj.Content.Visible = false
                        Obj.Content.Size = UDim2.new(0.95, 0, 0, 0)

                        Obj["!padding"].Size = UDim2.fromOffset(0, 6)

                        Obj["|padding"].Size = UDim2.fromOffset(0, 6)

                        Obj["BarPadding"].Size = UDim2.new(0, 0, 0, 4)

                        function SetState(new)
                            if new == State then
                                return
                            end

                            if new == nil then
                                new = not State
                            end

                            State = new

                            pcall(function()
                                Tween1:Cancel()
                                Tween1:Destroy()
                            end)

                            pcall(function()
                                Tween2:Cancel()
                                Tween2:Destroy()
                            end)

                            if State then
                                Tween1 = TweenService:Create(Obj.Content, TweenInfo, {
                                    ["Size"] = UDim2.new(0.95, 0, 0, 126)
                                })

                                Tween2 = TweenService:Create(Arrow, TweenInfo, {
                                    ["Rotation"] = 180
                                })

                                Obj.Content.Visible = true

                                Obj["BarPadding"].Visible = true

                                Tween1:Play()
                                Tween2:Play()
                            else
                                Tween1 = TweenService:Create(Obj.Content, TweenInfo, {
                                    ["Size"] = UDim2.new(0.95, 0, 0, 0)
                                })

                                Tween2 = TweenService:Create(Arrow, TweenInfo, {
                                    ["Rotation"] = 0
                                })

                                Tween1.Completed:Connect(function(playbackState)
                                    if playbackState == Enum.PlaybackState.Completed then
                                        Obj.Content.Visible = false

                                        Obj["BarPadding"].Visible = false
                                    end
                                end)

                                Tween1:Play()
                                Tween2:Play()
                            end
                        end
                    end

                    Bar.Active = true

                    local Selected = false

                    Bar.InputBegan:Connect(function(input)
                        if input.UserInputType == Enum.UserInputType.MouseButton1 then
                            Selected = true
                        end
                    end)

                    Bar.MouseLeave:Connect(function()
                        Selected = false
                    end)

                    Bar.InputEnded:Connect(function(input)
                        if input.UserInputType == Enum.UserInputType.MouseButton1 and Selected then
                            Selected = false

                            SetState()
                        end
                    end)
                end

                return Element
            end

            --[
            --AddLabel
            --]

            function Elements:AddLabel(name, textWrapped)
                library:Require(name, "Missing argument (Name) for Section:AddLabel")

                if textWrapped then
                    local Element = {}

                    local Obj = Atlas.Objects.Multiline:Clone()

                    Obj.Name = string.rep("a", ElementIncrement)
                    Obj.Parent = holder

                    Obj.Title.Text = name

                    ElementIncrement = ElementIncrement + 1

                    --[
                    --Update
                    --]

                    function Element:Update(new)
                        Obj.Title.Text = new
                    end

                    local function HelpForTheRetards()
                        error("Break-Skill Hub - V1 | You may only create Interactables, Key Pickers, Color Pickers, etc. When TextWrapped is set to false.")
                    end

                    Element.AddInteractable = HelpForTheRetards
                    Element.AddKeyPicker = HelpForTheRetards
                    Element.AddColorPicker = HelpForTheRetards

                    return Element
                else
                    local Parent = {}

                    local PObj = Atlas.Objects.SingleLine:Clone()

                    PObj.Name = string.rep("a", ElementIncrement)
                    PObj.Parent = holder

                    PObj.Bar.Title.Text = name

                    ElementIncrement = ElementIncrement + 1

                    local SubHolder = PObj.Bar.Addons

                    --[
                    --Update
                    --]

                    function Parent:Update(new)
                        PObj.Title.Text = new
                    end

                    local PickerFlag = nil
                    local PickerState = false
                    local PickerTween = nil

                    local PickerTweenInfo = TweenInfo.new(0.25, Enum.EasingStyle.Sine, Enum.EasingDirection.In, 0, false, 0)

                    PObj.Picker.Size = UDim2.new(0.95, 0, 0, 0)

                    local function OpenPicker()
                        pcall(function()
                            PickerTween:Cancel()
                            PickerTween:Destroy()
                        end)

                        PickerTween = TweenService:Create(PObj.Picker, PickerTweenInfo, {
                            ["Size"] = UDim2.new(0.95, 0, 0, 120)
                        })

                        PObj.Picker.Visible = true

                        PickerTween:Play()

                        PickerState = true
                    end

                    local function ClosePicker()
                        pcall(function()
                            PickerTween:Cancel()
                            PickerTween:Destroy()
                        end)

                        PickerTween = TweenService:Create(PObj.Picker, PickerTweenInfo, {
                            ["Size"] = UDim2.new(0.95, 0, 0, 0)
                        })

                        PickerTween.Completed:Connect(function(playbackState)
                            if playbackState == Enum.PlaybackState.Completed then
                                PObj.Picker.Visible = false
                            end
                        end)

                        PickerTween:Play()

                        PickerState = false
                    end

                    do
                        local Rainbow = PObj.Picker.Inner.Picker.Rainbow
                        local Second = PObj.Picker.Inner.Picker.Second
                        local HEX = PObj.Picker.Inner.Hex
                        local RGB = PObj.Picker.Inner.RGB

                        Rainbow.Active = true

                        Second.Active = true

                        local RDrag = false

                        local SDrag = false

                        Rainbow.InputBegan:Connect(function(input)
                            if input.UserInputType == Enum.UserInputType.MouseButton1 then
                                RDrag = true

                                SDrag = false
                            end
                        end)

                        Second.InputBegan:Connect(function(input)
                            if input.UserInputType == Enum.UserInputType.MouseButton1 then
                                RDrag = false

                                SDrag = true
                            end
                        end)

                        Connect(UserInputService.InputEnded, function(input)
                            if input.UserInputType == Enum.UserInputType.MouseButton1 then
                                RDrag = false

                                SDrag = false
                            end
                        end)

                        HEX.TextBox.FocusLost:Connect(function(enterPressed)
                            if enterPressed then
                                local Input = HEX.TextBox.Text

                                Input = string.gsub(Input, "#", "")
                                Input = string.gsub(Input, " ", "")

                                if #Input == 6 and PickerFlag then
                                    local NewColor = Color3.fromHex(Input)

                                    if NewColor then
                                        local H, S, V = NewColor:ToHSV()

                                        Configs[PickerFlag] = {
                                            H,
                                            S,
                                            V
                                        }
                                    end
                                end
                            end
                        end)

                        RGB.TextBox.FocusLost:Connect(function(enterPressed)
                            if enterPressed then
                                pcall(function()
                                    local Input = RGB.TextBox.Text

                                    Input = string.gsub(Input, " ", "")

                                    local NumCheck, _ = string.gsub(Input, ",", "")

                                    if tonumber(NumCheck) then
                                        local Split = string.split(Input, ",")

                                        if #Split == 3 then
                                            for i, v in pairs(Split) do
                                                Split[i] = math.round(math.clamp(v, 0, 255))
                                            end

                                            local FinalColor = Color3.fromRGB(Split[1], Split[2], Split[3])

                                            if FinalColor then
                                                local H, S, V = FinalColor:ToHSV()

                                                Configs[PickerFlag] = {
                                                    H,
                                                    S,
                                                    V
                                                }
                                            end
                                        end
                                    end
                                end)
                            end
                        end)

                        Rainbow.Frame.AnchorPoint = Vector2.new(0.5, 0.5)

                        local Used = {}

                        Connect(RunService.RenderStepped, function()
                            if PickerFlag then
                                if not Used[PickerFlag] then
                                    if Configs[PickerFlag][1] == 1 then
                                        local Old = {
                                            unpack(Configs[PickerFlag])
                                        }

                                        Old[1] = 0

                                        Configs[PickerFlag] = Old
                                    end
                                end

                                Used[PickerFlag] = true

                                if RDrag then
                                    local Percent = math.clamp((Mouse.Y - Rainbow.AbsolutePosition.Y) / Rainbow.AbsoluteSize.Y, 0, 1)

                                    local Old = {
                                        unpack(Configs[PickerFlag])
                                    }

                                    Old[1] = Percent

                                    Configs[PickerFlag] = Old
                                end

                                Rainbow.Frame.Position = UDim2.fromScale(0.5, Configs[PickerFlag][1])

                                if SDrag then
                                    local PercentX = math.clamp((Mouse.X - Second.AbsolutePosition.X) / Second.AbsoluteSize.X, 0, 1)
                                    local PercentY = math.clamp((Mouse.Y - Second.AbsolutePosition.Y) / Second.AbsoluteSize.Y, 0, 1)

                                    local Old = {
                                        unpack(Configs[PickerFlag])
                                    }

                                    Old[2] = PercentX
                                    Old[3] = 1 - PercentY

                                    Configs[PickerFlag] = Old
                                end

                                Second.Black.Frame.Position = UDim2.fromScale(Configs[PickerFlag][2], 1 - Configs[PickerFlag][3])

                                local Current = Configs[PickerFlag]

                                local Color = Color3.fromHSV(Current[1], 1, 1)

                                local Final = Color3.fromHSV(Current[1], Current[2], Current[3])

                                Second.UIGradient.Color = ColorSequence.new({
                                    ColorSequenceKeypoint.new(0.00, Color3.fromRGB(255, 255, 255)),
                                    ColorSequenceKeypoint.new(1.00, Color)
                                })

                                if not HEX.TextBox:IsFocused() then
                                    HEX.TextBox.Text = "#" .. Final:ToHex()
                                end

                                if not RGB.TextBox:IsFocused() then
                                    local C = {
                                        Final.R,
                                        Final.G,
                                        Final.B
                                    }

                                    for i, v in pairs(C) do
                                        C[i] = math.round(v * 255)
                                    end

                                    RGB.TextBox.Text = table.concat(C, ", ")
                                end
                            end
                        end)
                    end

                    local SubElementIncrement = 1

                    --[
                    --AddInteractable
                    --]

                    function Parent:AddInteractable(interactText, callback)
                        library:Require(interactText or callback, "Must include at least one argument in Section:AddInteractable")

                        interactText = interactText or "Interact"
                        callback = callback or library.BlankFunction

                        local Element = {}

                        local Obj = Atlas.Objects.Interactable:Clone()

                        Obj.Name = string.rep("a", SubElementIncrement)
                        Obj.Active = true
                        Obj.Parent = SubHolder

                        Obj.Inner:FindFirstChild("Content").Text = interactText

                        SubElementIncrement = SubElementIncrement + 1

                        local Running = false

                        Obj.InputBegan:Connect(function(input)
                            if input.UserInputType == Enum.UserInputType.MouseButton1 and not Running then
                                Running = true

                                Obj.Inner.Loading.Visible = true

                                Obj.Inner.Content.Visible = false

                                local Success, Result = pcall(callback)

                                if not Success then
                                    warn("Break-Skill Hub - V1 | Error occured when running Interactable callback: " .. Result)
                                end

                                Obj.Inner.Loading.Visible = false

                                Obj.Inner.Content.Visible = true

                                Running = false
                            end
                        end)

                        local Mult = 0.8

                        Connect(RunService.RenderStepped, function()
                            Obj.Inner.Loading.Loading.Rotation = (os.clock() * 550) % 360

                            local ABSP = Obj.AbsolutePosition
                            local ABSS = Obj.AbsoluteSize
                            local AP = Obj.AnchorPoint

                            local IsBoundsX = Mouse.X > (ABSP.X - ((1 - AP.X) * ABSS.X)) and Mouse.X < (ABSP.X - ((1 - AP.X) * ABSS.X) + ABSS.X)
                            local IsBoundsY = Mouse.Y > (ABSP.Y - ((1 - AP.X) * ABSS.Y) + (ABSS.Y / 2)) and Mouse.Y < (ABSP.Y - ((1 - AP.Y) * ABSS.Y) + ABSS.Y + (ABSS.Y / 2))

                            local Accent = WindowFunctions.Theme.AccentColor

                            Obj.Inner.BackgroundColor3 = (IsBoundsX and IsBoundsY and (not UserInputService:IsMouseButtonPressed(Enum.UserInputType.MouseButton1))) and Color3.new(Accent.R * Mult, Accent.G * Mult, Accent.B * Mult) or Accent
                        end)

                        return Element
                    end

                    --[
                    --AddKeyPicker
                    --]

                    function Parent:AddKeyPicker(flag, default, callback)
                        library:Require(flag, "Missing argument (Flag) for Section:AddKeyPicker")
                        library:Require(not RegisteredFlags[flag], "Flag already registered, pick another one (" .. flag .. ").")

                        RegisteredFlags[flag] = true

                        if typeof(default) == "EnumItem" then
                            default = default.Name
                        end

                        default = default or "None"
                        callback = callback or library.BlankFunction

                        if not Enum.KeyCode[default] then
                            default = "None"
                        end

                        if options.SavingDisabled then
                            Configs[flag] = nil
                        end

                        if Configs[flag] == nil then
                            Configs[flag] = default
                        end

                        if Configs.IncludeGameProcessedInput then
                            Configs.IncludeGameProcessedInput = false
                        end

                        local Element = {}

                        local Obj = Atlas.Objects.Keypicker:Clone()

                        Obj.Name = string.rep("a", SubElementIncrement)
                        Obj.Active = true
                        Obj.Parent = SubHolder

                        SubElementIncrement = SubElementIncrement + 1

                        do
                            local Listening = false

                            --[
                            --UpdateDisplay
                            --]

                            function Element:UpdateDisplay()
                                Obj.Inner.Key.Text = Listening and "[...]" or (Configs[flag] or "None")
                            end

                            Element:UpdateDisplay()

                            Obj.InputBegan:Connect(function(input, gpe)
                                if input.UserInputType == Enum.UserInputType.MouseButton1 and not gpe then
                                    Listening = true

                                    Element:UpdateDisplay()
                                end
                            end)

                            Connect(UserInputService.InputBegan, function(input, gpe)
                                if input.UserInputType == Enum.UserInputType.Keyboard then
                                    if Listening then
                                        Listening = false

                                        local KeyCode = input.KeyCode.Name

                                        if input.KeyCode == Enum.KeyCode.Backspace then
                                            KeyCode = "None"
                                        end

                                        Configs[flag] = KeyCode

                                        Element:UpdateDisplay()
                                    else
                                        if input.KeyCode.Name == Configs[flag] then
                                            if not Configs.IncludeGameProcessedInput then
                                                if gpe then
                                                    return
                                                end
                                            end

                                            coroutine.wrap(callback)(input.KeyCode)
                                        end
                                    end
                                end
                            end)
                        end

                        return Element
                    end

                    --[
                    --AddColorPicker
                    --]

                    function Parent:AddColorPicker(flag, default, callback)
                        library:Require(flag, "Missing argument (Flag) for Section:AddColorPicker")
                        library:Require(not RegisteredFlags[flag], "Flag already registered, pick another one (" .. flag .. ").")

                        RegisteredFlags[flag] = true

                        default = default or Color3.fromRGB(255, 255, 255)
                        callback = callback or library.BlankFunction

                        do
                            local H, S, V = default:ToHSV()

                            default = {
                                H,
                                S,
                                V
                            }
                        end

                        if options.SavingDisabled then
                            Configs[flag] = nil
                        end

                        if Configs[flag] == nil then
                            Configs[flag] = default
                        end

                        local Element = {}

                        local Obj = Atlas.Objects.Color:Clone()

                        Obj.Name = string.rep("a", SubElementIncrement)
                        Obj.Parent = SubHolder

                        SubElementIncrement = SubElementIncrement + 1

                        local Pencil = Obj.ImageLabel

                        local Last = nil

                        Connect(RunService.RenderStepped, function()
                            local ABSP = Obj.AbsolutePosition
                            local ABSS = Obj.AbsoluteSize
                            local AP = Obj.AnchorPoint

                            local IsBoundsX = Mouse.X > (ABSP.X - ((1 - AP.X) * ABSS.X) + ABSS.X) and Mouse.X < (ABSP.X - ((1 - AP.X) * ABSS.X) + (ABSS.X * 2))
                            local IsBoundsY = Mouse.Y > (ABSP.Y - ((1 - AP.Y) * ABSS.Y) + ABSS.Y) and Mouse.Y < (ABSP.Y - ((1 - AP.Y) * ABSS.Y) + (ABSS.Y * 2))

                            Pencil.Visible = IsBoundsX and IsBoundsY

                            local Current = Configs[flag]

                            local Color = Color3.fromHSV(Current[1], Current[2], Current[3])

                            Pencil.ImageColor3 = library:GetTextContrast(Color)

                            Obj.BackgroundColor3 = Color

                            if Last ~= Color then
                                coroutine.wrap(callback)(Color)

                                Last = Color
                            end
                        end)

                        Obj.Active = true

                        Obj.InputBegan:Connect(function(input)
                            if input.UserInputType == Enum.UserInputType.MouseButton1 then
                                if PickerState then
                                    if PickerFlag == flag then
                                        ClosePicker()
                                    else
                                        PickerFlag = flag
                                    end
                                else
                                    PickerFlag = flag

                                    OpenPicker()
                                end
                            end
                        end)

                        return Element
                    end

                    return Parent
                end
            end

            return Elements
        end

        local SectionIncrement = 1

        --[
        --_CreateSection
        --]

        function PageFunctions:_CreateSection(side, s_Name)
            library:Require(s_Name, "Missing argument (Name) for Page:CreateSection")

            local SectionObj = Atlas.Objects.Section:Clone()

            local Side = Holder:FindFirstChild(side)

            SectionObj.Name = string.rep("a", SectionIncrement)

            SectionIncrement = SectionIncrement + 1

            local Section = GetElementMethods(SectionObj)

            Section.Obj = SectionObj

            SectionObj["!title"].Text = s_Name
            SectionObj.Parent = Side

            return Section
        end

        --[
        --_CreateTabBox
        --]

        function PageFunctions:_CreateTabBox(side)
            local SectionObj = Atlas.Objects.Groupbox:Clone()

            local Side = Holder:FindFirstChild(side)

            SectionObj.Name = string.rep("a", SectionIncrement)

            SectionIncrement = SectionIncrement + 1

            local TabBoxFunctions = {
                ["Obj"] = SectionObj
            }

            local TabIncrement = 1
            local CurrentTab = 1

            local SectionTitle = SectionObj["!title"].Inner

            --[
            --CreateTab
            --]

            function TabBoxFunctions:CreateTab(options)
                library:Require(options.Name, "Missing argument (Name) for TabBox:CreateTab")

                local TabButton = Atlas.Objects.GroupButton:Clone()

                local TabNum = TabIncrement

                TabIncrement = TabIncrement + 1

                TabButton.Frame.TextLabel.Text = options.Name

                TabButton.Name = string.rep("a", TabNum)
                TabButton.Parent = SectionTitle
                TabButton.Active = true

                Connect(TabButton.InputBegan, function(input)
                    if input.UserInputType == Enum.UserInputType.MouseButton1 then
                        CurrentTab = TabNum
                    end
                end)

                local TabInner = Atlas.Objects.InnerTabbox:Clone()

                local TabNumObj = Instance.new("IntValue", TabInner)

                TabNumObj.Value = TabNum
                TabNumObj.Name = "TabNum"

                TabNumObj:Clone().Parent = TabButton

                TabInner.Name = string.rep("a", TabNum)
                TabInner.Parent = SectionObj

                local Tab = GetElementMethods(TabInner)

                Tab.Button = TabButton
                Tab.Inner = TabInner

                return Tab
            end

            Connect(RunService.RenderStepped, function()
                for _, v in pairs(SectionObj:GetChildren()) do
                    if v:FindFirstChild("TabNum") then
                        local TabNum = v:FindFirstChild("TabNum")

                        TabNum.Visible = CurrentTab == TabNum.Value
                    end
                end

                for _, v in pairs(SectionTitle:GetChildren()) do
                    if v:FindFirstChild("TabNum") then
                        local TabNum = v:FindFirstChild("TabNum")

                        local Page = CurrentTab == TabNum.Value

                        v.Frame.BackgroundColor3 = Page and WindowFunctions.Theme.FontColor or WindowFunctions.Theme.MainColor

                        v.Frame.TextLabel.TextColor3 = Page and WindowFunctions.Theme.MainColor or WindowFunctions.Theme.FontColor
                    end
                end
            end)

            SectionObj.Parent = Side

            return TabBoxFunctions
        end

        --[
        --CreateLeftSection
        --]

        function PageFunctions:CreateLeftSection(...)
            return PageFunctions:_CreateSection("Left", ...)
        end

        --[
        --CreateRightSection
        --]

        function PageFunctions:CreateRightSection(...)
            return PageFunctions:_CreateSection("Right", ...)
        end

        --[
        --CreateLeftTabBox
        --]

        function PageFunctions:CreateLeftTabBox(...)
            return PageFunctions:_CreateTabBox("Left", ...)
        end

        --[
        --CreateRightTabBox
        --]

        function PageFunctions:CreateRightTabBox(...)
            return PageFunctions:_CreateTabBox("Right", ...)
        end

        return PageFunctions
    end

    --[
    --Destroy
    --]

    function WindowFunctions:Destroy()
        for _, v in pairs(library.Connections) do
            pcall(function()
                v:Disconnect()
            end)
        end

        UI:Destroy()

        for i, v in pairs(WindowFunctions) do
            WindowFunctions[i] = nil
        end

        WindowFunctions = nil

        UserInputService.MouseIconEnabled = true

        getgenv()[RemoveOldVar][options.Name] = nil
    end

    getgenv()[RemoveOldVar][options.Name] = WindowFunctions.Destroy

    UI.Enabled = true

    return WindowFunctions
end

return library
