--[
--UI Library Made By xS_Killus (xX_XSI)
--]

--[
--Instances And Functions
--]

local CoreGui = game:GetService("CoreGui")
local HttpService = game:GetService("HttpService")
local MarketplaceService = game:GetService("MarketplaceService")
local Players = game:GetService("Players")
local StarterGui = game:GetService("StarterGui")
local TextService = game:GetService("TextService")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")

local Client = Players.LocalPlayer

local library = {
    Version = "1.0",
    WorkspaceName = "Break-Skill Hub - V1",
    Flags = {},
    Connections = {},
    Objects = {},
    Elements = {},
    Globals = {},
    Subs = {},
    Colored = {},
    ColorPickerConflicts = {},
    RainbowFlags = {},
    Configuration = {
        EasingStyle = Enum.EasingStyle.Quart,
        EasingDirection = Enum.EasingDirection.Out,
        HideKeybind = Enum.KeyCode.RightShift,
        SmoothDragging = false
    },
    Colors = {
        Main = Color3.fromRGB(255, 30, 30),
        Background = Color3.fromRGB(35, 35, 35),
        OuterBorder = Color3.fromRGB(10, 10, 10),
        InnerBorder = Color3.fromRGB(75, 65, 75),
        TopGradient = Color3.fromRGB(35, 35, 35),
        BottomGradient = Color3.fromRGB(30, 30, 30),
        SectionBackground = Color3.fromRGB(35, 35, 35),
        Section = Color3.fromRGB(175, 175, 175),
        OtherElementText = Color3.fromRGB(130, 125, 130),
        ElementText = Color3.fromRGB(145, 145, 145),
        ElementBorder = Color3.fromRGB(20, 20, 20),
        SelectedOption = Color3.fromRGB(55, 55, 55),
        UnSelectedOption = Color3.fromRGB(40, 40, 40),
        HoveredOptionTop = Color3.fromRGB(65, 65, 65),
        UnHoveredOptionTop = Color3.fromRGB(50, 50, 50),
        HoveredOptionBottom = Color3.fromRGB(45, 45, 45),
        UnHoveredOptionBottom = Color3.fromRGB(35, 35, 35),
        TabText = Color3.fromRGB(185, 185, 185)
    },
    GUIParent = (function()
        local x, c = pcall(function()
            return CoreGui
        end)

        if x and c then
            return c
        end

        x, c = pcall(function()
            return (game:IsLoaded() or (game.Loaded:Wait() or 1)) and Client:WaitForChild("PlayerGui")
        end)

        if x and c then
            return c
        end

        x, c = pcall(function()
            return StarterGui
        end)

        if x and c then
            return c
        end
    end),
    ColorPicker = false,
    RainbowS = 0,
    RainbowSG = 0
}

local Flags = library.Flags
local Colored = library.Colored
local Colors = library.Colors
local Elements = library.Elements

local ResolverCache = {}

local LastHideBind = 0

local IsDraggingSomething = false

library.Flags = Flags

local MainScreenGui
local ResolveVarArg
local ConvertFileName
local TextToSize
local JSONEncode
local JSONDecode

local JSONEncodeFunc = HttpService.JSONEncode
local JSONDecodeFunc = HttpService.JSONDecode

do
    local VarArgResolve = {
        Window = {"Name", "Theme"},
        Tab = {"Name", "Image"},
        Section = {"Name", "Side"},
        Label = {"Text", "Flag", "UnloadValue", "UnloadFunc"},
        Button = {"Name", "Callback", "Locked", "Condition"},
        Toggle = {"Name", "Value", "Callback", "Flag", "Location", "LocationFlag", "UnloadValue", "UnloadFunc", "Locked", "Keybind", "Condition", "AllowDuplicateCalls"},
        Slider = {"Name", "Value", "Callback", "Flag", "Location", "LocationFlag", "UnloadValue", "UnloadFunc", "Min", "Max", "Decimals", "Format", "IllegalInput", "Textbox", "AllowDuplicateCalls"},
        Dropdown = {"Name", "Value", "Callback", "Flag", "Location", "LocationFlag", "UnloadValue", "UnloadFunc", "List", "Filter", "Method", "Nothing", "Sort", "MultiSelect", "ItemAdded","ItemRemoved", "ItemChanged", "ItemsCleared", "ScrollUpButton", "ScrollDownButton", "ScrollButtonRate", "DisablePrecisionScrolling", "AllowDuplicateCalls"},
        SearchBox = {"Name", "Value", "Callback", "Flag", "Location", "LocationFlag", "UnloadValue", "UnloadFunc", "List", "Filter", "Method", "Nothing", "Sort", "MultiSelect", "ItemAdded", "ItemRemoved", "ItemChanged", "ItemsCleared", "ScrollUpButton", "ScrollDownButton", "ScrollButtonRate", "DisablePrecisionScrolling", "RegEx", "AllowDuplicateCalls"},
        Keybind = {"Name", "Value", "Callback", "Flag", "Location", "LocationFlag", "UnloadValue", "UnloadFunc", "Pressed", "KeyNames", "AllowDuplicateCalls"},
        Textbox = {"Name", "Value", "Callback", "Flag", "Location", "LocationFlag", "UnloadValue", "UnloadFunc", "Placeholder", "Type", "Min", "Max", "Decimals", "Hex", "Binary", "Base", "RichTextBox", "MultiLine", "TextScaled", "TextFont", "PreFormat", "PostFormat", "CustomProperties", "AllowDuplicateCalls"},
        Colorpicker = {"Name", "Value", "Callback", "Flag", "Location", "LocationFlag", "UnloadValue", "UnloadFunc", "Rainbow", "Random", "AllowDuplicateCalls"},
        Persistence = {"Name", "Value", "Callback", "Flag", "Location", "LocationFlag", "UnloadValue", "UnloadFunc", "Workspace", "Persistive", "Suffix", "LoadCallback", "SaveCallback", "PostLoadCallback", "PostSaveCallback", "ScrollUpButton", "ScrollDownButton", "ScrollButtonRate", "DisablePrecisionScrolling", "AllowDuplicateCalls"}
    }

    function ResolveVarArg(objType, ...)
        local Data = VarArgResolve[objType]

        local Table = {}

        if Data then
            for i, v in next, {
                ...
            } do
                Table[Data[i]] = v
            end
        end

        return Table
    end

    function ConvertFileName(str, default, replace)
        replace = replace or "_"

        local Corrections = 0

        local PredName = string.gsub(str, "%W", function(c)
            local Byte = c:byte()

            if ((Byte == 0) or (Byte == 32) or (Byte == 33) or (Byte == 59) or (Byte == 61) or ((Byte >= 35) and (Byte <= 41)) or ((Byte >= 43) and (Byte <= 57)) or ((Byte >= 64) and (Byte <= 123)) or ((Byte >= 125) and (Byte <= 127))) then

            else
                Corrections = 1 + Corrections

                return replace
            end
        end)

        return (default and Corrections == #PredName and tostring(default)) or PredName
    end

    function TextToSize(object)
        return TextService:GetTextSize(object.Text, object.TextSize, object.Font, Vector2.one * math.huge)
    end

    function JSONEncode(...)
        return pcall(JSONEncodeFunc, HttpService, ...)
    end

    function JSONDecode(...)
        return pcall(JSONDecodeFunc, HttpService, ...)
    end

    library.Subs.TextToSize = TextToSize
    library.Subs.ConvertFileName = ConvertFileName
end

local InstanceNew = (syn and syn.protect_gui and not gethui and function (...)
    local x = {
        Instance.new(...)
    }

    if x[1] then
        library.Objects[1 + #library.Objects] = x[1]

        pcall(syn.protect_gui, x[1])
    end

    return unpack(x)
end or gethui and function (...)
    local x = {
        Instance.new(...)
    }

    if x[1] then
        library.Objects[1 + #library.Objects] = x[1]

        gethui(x[1])
    end

    return unpack(x)
end) or function (...)
    local x = {
        Instance.new(...)
    }

    if x[1] then
        library.Objects[1 + #library.Objects] = x[1]
    end

    return unpack(x)
end

local function MakeDraggable(topBarObject, object)
    local Dragging = nil
    local DragInput = nil
    local DragStart = nil
    local StartPos = nil

    library.Connections[1 + #library.Connections] = topBarObject.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            Dragging = true

            DragStart = input.Position
            StartPos = object.Position

            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    Dragging = false
                end
            end)
        end
    end)

    library.Connections[1 + #library.Connections] = topBarObject.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
            DragInput = input
        end
    end)

    library.Connections[1 + #library.Connections] = UserInputService.InputChanged:Connect(function(input)
        if input == DragInput and Dragging then
            local Delta = input.Position - DragStart

            if not IsDraggingSomething and library.Configuration.SmoothDragging then
                TweenService:Create(object, TweenInfo.new(0.25, library.Configuration.EasingStyle, library.Configuration.EasingDirection), {
                    Position = UDim2.new(StartPos.X.Scale, StartPos.X.Offset + Delta.X, StartPos.Y.Scale, StartPos.Y.Offset + Delta.Y)
                }):Play()
            elseif not IsDraggingSomething and not library.Configuration.SmoothDragging then
                object.Position = UDim2.new(StartPos.X.Scale, StartPos.X.Offset + Delta.X, StartPos.Y.Scale, StartPos.Y.Offset + Delta.Y)
            end
        end
    end)
end

local function ResolveID(image, flag)
    if image then
        if type(image) == "string" then
            if (#image > 14 and string.sub(image, 1, 13) == "rbxassetid://") or (#image > 12 and string.sub(image, 1, 11) == "rbxasset://") or (#image > 12 and string.sub(image, 1, 11) ~= "rbxthumb://") then
                if flag then
                    local Thing = library.Elements[flag] or library.DesignerElements[flag]

                    if Thing and Thing.Set then
                        task.spawn(Thing.Set, Thing, image)
                    end
                end

                return image
            end
        end

        local Original = image

        if ResolverCache[Original] then
            if flag then
                local Thing = library.Elements[flag] or library.DesignerElements[flag]

                if Thing and Thing.Set then
                    task.spawn(Thing.Set, Thing, ResolverCache[Original])
                end
            end

            return ResolverCache[Original]
        end

        image = tonumber(image) or image

        local Success = pcall(function()
            local Type = type(image)

            if Type == "string" then
                if getsynasset then
                    if #image > 11 and (string.sub(image, 1, 11) == "synasset://") then
                        return getsynasset(string.sub(image, 12))
                    elseif (#image > 14) and (string.sub(image, 1, 14) == "synasseturl://") then
                        local x, e = pcall(function()
                            local CodeName, Fixes = string.gsub(image, ".", function(c)
                                if c:lower() == c:upper() and not tonumber(c) then
                                    return ""
                                end
                            end)

                            CodeName = string.sub(CodeName, 1, 24) .. tostring(Fixes)

                            local Folder = isfolder("./" .. library.WorkspaceName)

                            if not Folder then
                                makefolder("./" .. library.WorkspaceName)
                            end

                            Folder = isfolder("./" .. library.WorkspaceName .. "/UI")

                            if not Folder then
                                makefolder("./" .. library.WorkspaceName .. "/UI")
                            end

                            Folder = isfolder("./" .. library.WorkspaceName .. "/UI/Themes")

                            if not Folder then
                                makefolder("./" .. library.WorkspaceName .. "/UI/Themes")
                            end

                            Folder = isfolder("./" .. library.WorkspaceName .. "/UI/Themes/SynapseAssetsCache")

                            if not Folder then
                                makefolder("./" .. library.WorkspaceName .. "/UI/Themes/SynapseAssetsCache")
                            end

                            if not Folder or not isfile("./" .. library.WorkspaceName .. "/UI/Themes/SynapseAssetsCache/" .. CodeName .. ".dat") then
                                local Result = game:HttpGet(string.sub(image, 15))

                                if Result ~= nil then
                                    writefile("./" .. library.WorkspaceName .. "/UI/Themes/SynapseAssetsCache/" .. CodeName .. ".dat", Result)
                                end
                            end

                            return getsynasset(readfile("./" .. library.WorkspaceName .. "/UI/Themes/SynapseAssetsCache/" .. CodeName .. ".dat"))
                        end)

                        if x and e ~= nil then
                            return e
                        end
                    end
                end

                if (#image < 11) or ((string.sub(image, 1, 13) ~= "rbxassetid://") and (string.sub(image, 1, 11) ~= "rbxasset://") and string.sub(image, 1, 11) ~= "rbxthumb://") then
                    image = tonumber(image:gsub("%D", ""), 10) or image

                    Type = type(image)
                end
            end

            if (Type == "number") and (image > 0) then
                pcall(function()
                    local Info = MarketplaceService and MarketplaceService:GetProductInfo(image)

                    image = tostring(image)

                    if Info and Info.AssetTypeId == 1 then
                        image = "rbxassetid://" .. image
                    elseif Info.AssetTypeId == 13 then
                        local Decal = game:GetObjects("rbxassetid://" .. image)[1]

                        image = "rbxassetid://" .. ((Decal and Decal.Texture) or "0"):match("%d+$")

                        Decal = (Decal and Decal:Destroy() and nil) or nil
                    end
                end)
            else
                image = nil
            end
        end)

        if Success and image then
            if Original then
                ResolverCache[Original] = image
            end

            ResolverCache[image] = image

            if flag then
                local Thing = library.Elements[flag] or library.DesignerElements[flag]

                if Thing and Thing.Set then
                    task.spawn(Thing.Set, Thing, image)
                end
            end
        end
    end

    return image
end

library.Subs.InstanceNew = InstanceNew
library.Subs.MakeDraggable = MakeDraggable
library.Subs.ResolveID = ResolveID
library.ResolverCache = ResolverCache

--[
--UI Library Functions
--]

--[
--CreateWindow
--]

function library:CreateWindow(options, ...)
    options = (options and type(options) == "string" and ResolveVarArg("Window", options, ...)) or options

    local HomePage = nil

    local WindowOptions = options
    local WindowName = options.Name or "New Window"

    options.Name = WindowName

    if WindowName and #WindowName > 0 and library.WorkspaceName == "Break-Skill Hub - V1" then
        library.WorkspaceName = ConvertFileName(WindowName, "Break-Skill Hub - V1")
    end

    local Window = InstanceNew("ScreenGui")
    local MainFrame = InstanceNew("Frame")
    local MainBorder = InstanceNew("Frame")
    local TabSlider = InstanceNew("Frame")
    local InnerMain = InstanceNew("Frame")
    local InnerMainBorder = InstanceNew("Frame")
    local InnerBackdrop = InstanceNew("ImageLabel")
    local InnerMainHolder = InstanceNew("Frame")
    local TabsHolder = InstanceNew("ImageLabel")
    local TabsHolderList = InstanceNew("UIListLayout")
    local TabsHolderPadding = InstanceNew("UIPadding")
    local HeadLine = InstanceNew("TextLabel")
    local Splitter = InstanceNew("TextLabel")

    library.MainScreenGui, MainScreenGui = Window, Window

    local SubMenuOpen

    library.Globals["__Window" .. options.Name] = {
        SubMenuOpen = SubMenuOpen
    }

    Window.Name = "Window"
    Window.ResetOnSpawn = false
    Window.DisplayOrder = 10
    Window.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    Window.Parent = library.GUIParent

    MainFrame.Name = "MainFrame"
    MainFrame.AnchorPoint = Vector2.new(0.5, 0.5)
    MainFrame.Parent = Window
    MainFrame.BackgroundColor3 = library.Colors.Background
    MainFrame.BorderColor3 = library.Colors.OuterBorder
    MainFrame.Position = UDim2.fromScale(0.5, 0.5)
    MainFrame.Size = UDim2.fromOffset(500, 600)

    MakeDraggable(MainFrame, MainFrame)

    MainBorder.Name = "MainBorder"
    MainBorder.Parent = MainFrame
    MainBorder.AnchorPoint = Vector2.new(0.5, 0.5)
    MainBorder.BackgroundColor3 = library.Colors.Background
    MainBorder.BorderColor3 = library.Colors.InnerBorder
    MainBorder.BorderMode = Enum.BorderMode.Inset
    MainBorder.Position = UDim2.fromScale(0.5, 0.5)
    MainBorder.Size = UDim2.fromScale(1, 1)

    InnerMain.Name = "InnerMain"
    InnerMain.Parent = MainFrame
    InnerMain.AnchorPoint = Vector2.new(0.5, 0.5)
    InnerMain.BackgroundColor3 = library.Colors.Background
    InnerMain.BorderColor3 = library.Colors.OuterBorder
    InnerMain.Position = UDim2.fromScale(0.5, 0.5)
    InnerMain.Size = UDim2.new(1, -4, 1, -4)

    InnerMainBorder.Name = "InnerMainBorder"
    InnerMainBorder.Parent = InnerMain
    InnerMainBorder.AnchorPoint = Vector2.new(0.5, 0.5)
    InnerMainBorder.BackgroundColor3 = library.Colors.Background
    InnerMainBorder.BorderColor3 = library.Colors.InnerBorder
    InnerMainBorder.BorderMode = Enum.BorderMode.Inset
    InnerMainBorder.Position = UDim2.fromScale(0.5, 0.5)
    InnerMainBorder.Size = UDim2.fromScale(1, 1)

    InnerMainHolder.Name = "InnerMainHolder"
    InnerMainHolder.Parent = InnerMain
    InnerMainHolder.BackgroundTransparency = 1
    InnerMainHolder.Position = UDim2:fromOffset(25)
    InnerMainHolder.Size = UDim2.new(1, 0, 1, -25)

    InnerBackdrop.Name = "InnerBackdrop"
    InnerBackdrop.Parent = InnerMainHolder
    InnerBackdrop.BackgroundTransparency = 1
    InnerBackdrop.Size = UDim2.fromScale(1, 1)
    InnerBackdrop.ZIndex = -1
    InnerBackdrop.Visible = Flags["__Designer.Background.UseBackgroundImage"] and true
    InnerBackdrop.ImageColor3 = Flags["__Designer.Background.ImageColor3"] or Color3.fromRGB(255, 255, 255)
    InnerBackdrop.ImageTransparency = (Flags["__Designer.Background.ImageTransparency"] or 95) / 100
    InnerBackdrop.Image = ResolveID(Flags["__Designer.Background.ImageAssetID"], "__Designer.Background.ImageAssetID") or ""

    library.Backdrop = InnerBackdrop

    TabsHolder.Name = "TabsHolder"
    TabsHolder.Parent = InnerMain
    TabsHolder.BackgroundColor3 = library.Colors.TopGradient
    TabsHolder.BorderSizePixel = 0
    TabsHolder.Position = UDim2.fromOffset(1, 1)
    TabsHolder.Size = UDim2.new(1, -2, 0, 23)
    TabsHolder.Image = "rbxassetid://2454009026"
    TabsHolder.ImageColor3 = library.Colors.BottomGradient

    TabsHolderList.Name = "TabsHolderList"
    TabsHolderList.Parent = TabsHolder
    TabsHolderList.FillDirection = Enum.FillDirection.Horizontal
    TabsHolderList.SortOrder = Enum.SortOrder.LayoutOrder
    TabsHolderList.VerticalAlignment = Enum.VerticalAlignment.Center
    TabsHolderList.Padding = UDim:new(3)

    TabsHolderPadding.Name = "TabsHolderPadding"
    TabsHolderPadding.Parent = TabsHolder
    TabsHolderPadding.PaddingLeft = UDim:new(7)

    HeadLine.Name = "HeadLine"
    HeadLine.Parent = TabsHolder
    HeadLine.BackgroundTransparency = 1
    HeadLine.LayoutOrder = 1
    HeadLine.Font = Enum.Font.Code
    HeadLine.Text = (WindowName and tostring(WindowName)) or "New Window"
    HeadLine.TextColor3 = library.Colors.Main
    HeadLine.TextSize = 14
    HeadLine.TextStrokeColor3 = library.Colors.OuterBorder
    HeadLine.TextStrokeTransparency = 0.75
    HeadLine.Size = UDim2:new(TextToSize(HeadLine).X + 4, 1)

    Splitter.Name = "Splitter"
    Splitter.Parent = TabsHolder
    Splitter.BackgroundTransparency = 1
    Splitter.LayoutOrder = 2
    Splitter.Size = UDim2:new(6, 1)
    Splitter.Font = Enum.Font.Code
    Splitter.Text = "|"
    Splitter.TextColor3 = library.Colors.TabText
    Splitter.TextSize = 14
    Splitter.TextStrokeColor3 = library.Colors.TabText
    Splitter.TextStrokeTransparency = 0.75

    TabSlider.Name = "TabSlider"
    TabSlider.Parent = MainFrame
    TabSlider.BackgroundColor3 = library.Colors.Main
    TabSlider.BorderSizePixel = 0
    TabSlider.Position = UDim2.fromOffset(100, 30)
    TabSlider.Size = UDim2:fromOffset(1)
    TabSlider.Visible = false

    Colored[1 + #Colored] = {MainFrame, "BackgroundColor3", "Background"}
    Colored[1 + #Colored] = {MainBorder, "BackgroundColor3", "Background"}
    Colored[1 + #Colored] = {InnerMain, "BackgroundColor3", "Background"}
    Colored[1 + #Colored] = {InnerMainBorder, "BackgroundColor3", "Background"}
    Colored[1 + #Colored] = {TabsHolder, "BackgroundColor3", "TopGradient"}
    Colored[1 + #Colored] = {TabSlider, "BackgroundColor3", "Main"}
    Colored[1 + #Colored] = {MainFrame, "BorderColor3", "OuterBorder"}
    Colored[1 + #Colored] = {MainBorder, "BorderColor3", "InnerBorder"}
    Colored[1 + #Colored] = {InnerMain, "BorderColor3", "OuterBorder"}
    Colored[1 + #Colored] = {InnerMainBorder, "BorderColor3", "InnerBorder"}
    Colored[1 + #Colored] = {HeadLine, "TextColor3", "Main"}
    Colored[1 + #Colored] = {Splitter, "TextColor3", "TabText"}
    Colored[1 + #Colored] = {HeadLine, "TextStrokeColor3", "OuterBorder"}
    Colored[1 + #Colored] = {Splitter, "TextStrokeColor3", "TabText"}
    Colored[1 + #Colored] = {TabsHolder, "ImageColor3", "BottomGradient"}

    local IgnoreCoreInputs

    do
        local OsClock = os.clock

        library.Connections[1 + #library.Connections] = UserInputService.InputBegan:Connect(function(input)
            if IgnoreCoreInputs or UserInputService:GetFocusedTextBox() then
                return
            elseif input.KeyCode == library.Configuration.HideKeybind then
                if not LastHideBind or ((OsClock() - LastHideBind) > 12) then
                    MainFrame.Visible = not MainFrame.Visible
                end

                LastHideBind = nil
            end
        end)
    end

    local WindowFunctions = {
        TabCount = 0,
        Selected = {},
        Flags = Elements
    }

    library.Globals["__Window" .. WindowName].WindowFunctions = WindowFunctions

    --[
    --Show
    --]

    function WindowFunctions:Show(x)
        MainFrame.Visible = (x == nil) or (x == true) or (x == 1)

        return MainFrame.Visible
    end

    --[
    --Hide
    --]

    function WindowFunctions:Hide(x)
        MainFrame.Visible = (x == false) or (x == 0)

        return MainFrame.Visible
    end

    --[
    --Visibility
    --]

    function WindowFunctions:Visibility(x)
        if x == nil then
            MainFrame.Visible = not MainFrame.Visible
        else
            MainFrame.Visible = x and true
        end

        return MainFrame.Visible
    end

    --[
    --MoveTabSlider
    --]

    function WindowFunctions:MoveTabSlider(tabObject)
        spawn(function()
            TabSlider.Visible = true

            TweenService:Create(TabSlider, TweenInfo.new(0.35, library.Configuration.EasingStyle, library.Configuration.EasingDirection), {
                Size = UDim2.fromOffset(tabObject.AbsoluteSize.X, 1),
                Position = UDim2.fromOffset(tabObject.AbsolutePosition.X, tabObject.AbsolutePosition.Y + tabObject.AbsoluteSize.Y) - UDim2.fromOffset(MainFrame.AbsolutePosition.X, MainFrame.AbsolutePosition.Y)
            }):Play()
        end)
    end

    WindowFunctions.LastTab = nil

    --[
    --UpdateAll
    --]

    function WindowFunctions:UpdateAll()
        local Target = self or WindowFunctions

        if Target and type(Target) == "table" and Target.Flags then
            for _, e in next, Target.Flags do
                if e and type(e) == "table" then
                    if e.Update then
                        pcall(e.Update)
                    end

                    if e.UpdateAll then
                        pcall(e.Update)
                    end
                end
            end

            pcall(function()
                if library.Backdrop then
                    library.Backdrop.Visible = Flags["__Designer.Background.UseBackgroundImage"] and true
                    library.Backdrop.Image = ResolveID(Flags["__Designer.Background.ImageAssetID"], "__Designer.Background.ImageAssetID") or ""
                    library.Backdrop.ImageColor3 = Flags["__Designer.Background.ImageColor3"] or Color3.fromRGB(255, 255, 255)
                    library.Backdrop.ImageTransparency = (Flags["__Designer.Background.ImageTransparency"] or 95) / 100
                end
            end)
        end
    end

    library.UpdateAll = WindowFunctions.UpdateAll

    if options.Themeable or options.DefaultTheme or options.Theme then
        spawn(function()
            local OsClock = os.clock

            local StartTime = OsClock()

            while OsClock() - StartTime < 12 do
                if HomePage then
                    WindowFunctions.GoHome = HomePage

                    local x, e = pcall(HomePage)

                    if not x and e then
                        warn("Error going to HomePage: ", e)
                    end

                    x, e = nil

                    break
                end

                task.wait()
            end

            local WhatDoILookLike = options.Themeable or options.DefaultTheme or options.Theme

            if type(WhatDoILookLike) == "table" then
                WhatDoILookLike.LockTheme = WhatDoILookLike.LockTheme or options.LockTheme or nil
                WhatDoILookLike.HideTheme = WhatDoILookLike.HideTheme or options.HideTheme or nil
            else
                WhatDoILookLike = nil
            end

            if getgenv()["Developer_345RTHD1"] then
                WindowFunctions:CreateDesigner(WhatDoILookLike)
            end

            if options.DefaultTheme or options.Theme then
                spawn(function()
                    local Content = options.DefaultTheme or options.Theme or options.JSON or options.ThemeJSON

                    if Content and type(Content) == "string" and #Content > 1 then
                        local Good, JContent = JSONDecode(Content)

                        if Good and JContent then
                            for cf, v in next, JContent do
                                local Data = Elements[cf]

                                if Data and (Data.Type ~= "Persistence") then
                                    if Data.Set then
                                        Data:Set(v)
                                    elseif Data.RawSet then
                                        Data:RawSet(v)
                                    else
                                        library.Flags[cf] = v
                                    end
                                end
                            end
                        end
                    end
                end)
            end

            OsClock, StartTime = nil
        end)
    end

    return WindowFunctions
end

return library, Flags, library.Subs
