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
        ["obj"] = Button,
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

    options.Watermark = library.Watermark or options.Name or "Break-Skill Hub - V1 | " .. MarketplaceService:GetProductInfo(game.PlaceId).Name

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
        pcall(function()
            UI.RobloxLocked = true
        end)

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

    local function StartDragging(...)
        local Init = library:InitDragging(...)

        for _, v in pairs(Init) do
            table.insert(library.Connections, v)
        end
    end

    Background.Top.Active = true

    UI.Watermark.Active = true

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
            OutlineColor3 = Color3.fromRGB(50, 50, 50)
        }
    }

    --[
    --RegisterCustomFlag
    --]

    function WindowFunctions:RegisterCustomFlag(flag)
        library:Require(not RegisteredFlags[flag], "Flag already registered pick another one (" .. flag .. ").")

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

    function WindowFunctions:CreatePage(name, icon)
        if type(name) == "table" then
            name = name.Name
            icon = name.Icon
        end

        library:Require(name, "Missing argument (Name) for Window:CreatePage")

        if icon then
            icon = library:FormatAsset(icon)
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

        Select.Frame.TextLabel.Text = name

        Select.Frame.Icon.Image = icon

        local function GetElementMethod(holder)
            local Elements = {}

            local ElementIncrement = 1

            --[
            --AddDivider
            --]

            function Elements:AddDivider()
                local Element = {}

                local Obj = Atlas.Objects.Divider:Clone()

                Obj.Name = string.rep("a", ElementIncrement)

                ElementIncrement = ElementIncrement + 1

                Obj.Parent = holder

                return Element
            end

            return Elements
        end

        local SectionIncrement = 1

        --[
        --_CreateSection
        --]

        function PageFunctions:_CreateSection(side, title)
            library:Require(title, "Missing argument (Name) for Page:CreateSection")

            local SectionObj = Atlas.Objects.Section:Clone()

            local Side = Holder:FindFirstChild(side)

            SectionObj.Name = string.rep("a", SectionIncrement)

            SectionIncrement = SectionIncrement + 1

            local Section = GetElementMethod(SectionObj)

            Section.Obj = SectionObj

            SectionObj["!Title"].Text = title
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

            local SectionTitle = SectionObj["!Title"].Inner

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

                TabNumObj.Name = "TabNum"
                TabNumObj.Value = TabNum

                TabNumObj:Clone().Parent = TabButton

                TabInner.Name = string.rep("a", TabNum)
                TabInner.Parent = SectionObj

                local Tab = GetElementMethod(TabInner)

                Tab.Button = TabButton
                Tab.Inner = TabInner

                return Tab
            end

            Connect(RunService.RenderStepped, function()
                for _, v in pairs(SectionObj:GetChildren()) do
                    if v:FindFirstChild("TabNum") then
                        local TabNum = v:FindFirstChild("TabNum")

                        v.Visible = CurrentTab == TabNum.Value
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
            PageFunctions:_CreateSection("Right", ...)
        end

        --[
        --CreateLeftTabBox
        --]

        function PageFunctions:CreateLeftTabBox(...)
            PageFunctions:_CreateTabBox("Left", ...)
        end

        --[
        --CreateRightSection
        --]

        function PageFunctions:CreateRightTabBox(...)
            PageFunctions:_CreateTabBox("Right", ...)
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
