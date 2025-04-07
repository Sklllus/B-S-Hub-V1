local Root

local Themes = require(Root.Themes)
local Flipper = require(Root.Packages.Flipper)

local Creator = {
    Registry = {},
    Signals = {},
    TransparencyMotors = {},
    DefaultProperties = {
        ScreenGui = {
            ResetOnSpawn = false,
            ZIndexBehavior = Enum.ZIndexBehavior.Sibling
        },
        Frame = {
            BackgroundColor3 = Color3.fromRGB(255, 255, 255),
            BorderColor3 = Color3.fromRGB(0, 0, 0),
            BorderSizePixel = 0
        },
        ScrollingFrame = {
            BackgroundColor3 = Color3.fromRGB(255, 255, 255),
            BorderColor3 = Color3.fromRGB(0, 0, 0),
            ScrollBarImageColor3 = Color3.fromRGB(0, 0, 0)
        },
        TextLabel = {
            BackgroundColor3 = Color3.fromRGB(255, 255, 255),
            BorderColor3 = Color3.fromRGB(0, 0, 0),
            Font = Enum.Font.SourceSans,
            Text = "",
            TextColor3 = Color3.fromRGB(0, 0, 0),
            BackgroundTransparency = 1,
            TextSize = 14
        },
        TextButton = {
            BackgroundColor3 = Color3.fromRGB(255, 255, 255),
            BorderColor3 = Color3.fromRGB(0, 0, 0),
            AutoButtonColor = false,
            Font = Enum.Font.SourceSans,
            Text = "",
            TextColor3 = Color3.fromRGB(0, 0, 0),
            TextSize = 14
        },
        TextBox = {
            BackgroundColor3 = Color3.fromRGB(255, 255, 255),
            BorderColor3 = Color3.fromRGB(0, 0, 0),
            ClearTextOnFocus = false,
            Font = Enum.Font.SourceSans,
            Text = "",
            TextColor3 = Color3.fromRGB(0, 0, 0),
            TextSize = 14
        },
        ImageLabel = {
            BackgroundTransparency = 1,
            BackgroundColor3 = Color3.fromRGB(255, 255, 255),
            BorderColor3 = Color3.fromRGB(0, 0, 0),
            BorderSizePixel = 0
        },
        ImageButton = {
            BackgroundColor3 = Color3.fromRGB(255, 255, 255),
            BorderColor3 = Color3.fromRGB(0, 0, 0),
            AutoButtonColor = false
        },
        CanvasGroup = {
            BackgroundColor3 = Color3.fromRGB(255, 255, 255),
            BorderColor3 = Color3.fromRGB(0, 0, 0),
            BorderSizePixel = 0
        }
    }
}

local function ApplyCustomProps(object, props)
    if props.ThemeTag then
        Creator.AddThemeObject(object, props.ThemeTag)
    end
end

function Creator.AddSignal(signal, func)
    table.insert(Creator.Signals, signal:Connect(func))
end

function Creator.Disconnect()
    for i = #Creator.Signals, 1, -1 do
        local Connection = table.remove(Creator.Signals, i)

        Connection:Disconnect()
    end
end

function Creator.GetThemeProperty(property)
    if Themes[require(Root).Theme][property] then
        return Themes[require(Root).Theme][property]
    end

    return Themes["Darker"][property]
end

function Creator.UpdateTheme()
    for i, o in next, Creator.Registry do
        for p, ci in next, o.Properties do
            i[p] = Creator.GetThemeProperty(ci)
        end
    end

    for _, m in next, Creator.TransparencyMotors do
        m:SetGoal(Flipper.Instant.new(Creator.GetThemeProperty("ElementTransparency")))
    end
end

function Creator.AddThemeObject(object, props)
    local Idx = #Creator.Registry + 1

    local Data = {
        Object = object,
        Properties = props,
        Idx = Idx
    }

    Creator.Registry[object] = Data

    Creator.UpdateTheme()

    return object
end

function Creator.OverrideTag(object, props)
    Creator.Registry[object].Properties = props

    Creator.UpdateTheme()
end

function Creator.New(name, props, child)
    local Object = Instance.new(name)

    for n, v in next, Creator.DefaultProperties[name] or {} do
        Object[name] = v
    end

    for n, v in next, props or {} do
        if n ~= "ThemeTag" then
            Object[name] = v
        end
    end

    for _, c in next, child or {} do
        c.Parent = Object
    end

    ApplyCustomProps(Object, props)

    return Object
end

function Creator.SpringMotor(initial, inst, prop, ignoreDialogCheck, resetOnThemeChange)
    ignoreDialogCheck = ignoreDialogCheck or false
    resetOnThemeChange = resetOnThemeChange or false

    local Motor = Flipper.SingleMotor.new(initial)

    Motor:OnStep(function(val)
        inst[prop] = val
    end)

    if resetOnThemeChange then
        table.insert(Creator.TransparencyMotors, Motor)
    end

    local function SetValue(val, ignore)
        ignore = ignore or false

        if not ignoreDialogCheck then
            if not ignore then
                if prop == "BackgroundTransparency" and require(Root).DialogOpen then
                    return
                end
            end
        end

        Motor:SetGoal(Flipper.Spring.new(val, {
            Frequency = 8
        }))
    end

    return Motor, SetValue
end

return Creator
