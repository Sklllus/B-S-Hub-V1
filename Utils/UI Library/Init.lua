--//
--// Init Made By xS_Killus
--//

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local CoreGui = game:GetService("CoreGui")

local Client = Players.LocalPlayer

local Root = script

local Components = Root.Components

local Creator = require(Root.Creator)
local ElementsTable = require(Root.Elements)
local Acrylic = require(Root.Acrylic)
local NotificationModule = require(Components.Notification)

local New = Creator.New

local ProtectGui = protectgui or (syn and syn.protect_gui) or function () end

local GUI = New("ScreenGui", {
    Parent = RunService:IsStudio() and Client.PlayerGui or CoreGui
})

ProtectGui(GUI)

NotificationModule:Init(GUI)

local library = {
    Theme = "Break-Skill Hub - V1",
    Version = "1.0.0",
    Window = nil,
    WindowFrame = nil,
    MinimizeKeybind = nil,
    Unloaded = false,
    DialogOpen = false,
    UseAcrylic = false,
    Acrylic = false,
    Transparency = true,
    MinimizeKey = Enum.KeyCode.LeftControl,
    OpenFrames = {},
    Options = {},
    Themes = require(Root.Themes).Names,
    GUI = GUI
}

function library:SafeCallback(func, ...)
    if not func then
        return
    end

    local Success, Event = pcall(func, ...)

    if not Success then
        local _, i = Event:find(":%d+: ")

        if not i then
            return library:Notify({
                Title = "Interface",
                Content = "Callback error",
                SubContent = Event,
                Duration = 5
            })
        end

        return library:Notify({
            Title = "Interface",
            Content = "Callback error",
            SubContent = Event:sub(i + 1),
            Duration = 5
        })
    end
end

function library:Round(number, factor)
    if factor == 0 then
        return math.floor(number)
    end

    number = tostring(number)

    return number:find("%.") and tonumber(number:sub(1, number:find("%.") + factor)) or number
end

local Icons = require(Root.Icons).Assets

function library:GetIcon(name)
    if name ~= nil and Icons["lucide-" .. name] then
        return Icons["lucide-" .. name]
    end

    return nil
end

local Elements = {}

Elements.__index = Elements

Elements.__namecall = function(tbl, key, ...)
    return Elements[key](...)
end

for _, ec in ipairs(ElementsTable) do
    Elements["Add" .. ec.__type] = function(self, idx, config)
        ec.Container = self.Container
        ec.Type = self.Type
        ec.ScrollFrame = self.ScrollFrame
        ec.Library = library

        return ec:New(idx, config)
    end
end

library.Elements = Elements

function library:CreateWindow(config)
    assert(config.Title, "Window - Missing Title")

    if library.Window then
        return
    end

    library.MinimizeKey = config.MinimizeKey or Enum.KeyCode.LeftControl
    library.UseAcrylic = config.Acrylic or false
    library.Acrylic = config.Acrylic or false
    library.Theme = config.Theme or "Break-Skill Hub - V1"

    if config.Acrylic then
        Acrylic.Init()
    end

    local Window = require(Components.Window)({
        Parent = GUI,
        Size = config.Size,
        Title = config.Title,
        SubTitle = config.SubTitle,
        TabWidth = config.TabWidth
    })

    library.Window = Window

    library:SetTheme(config.Theme)

    return Window
end

function library:SetTheme(value)
    if library.Window and table.find(library.Themes, value) then
        library.Theme = value

        Creator.UpdateTheme()
    end
end

function library:Destroy()
    if library.Window then
        library.Unloaded = true

        if library.UseAcrylic then
            library.Window.AcrylicPaint.Model:Destroy()
        end

        Creator.Disconnect()

        library.GUI:Destroy()
    end
end

function library:ToggleAcrylic(value)
    if library.Window then
        if library.UseAcrylic then
            library.Acrylic = value

            TweenService:Create(library.Window.AcrylicPaint.Model, TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
                Transparency = value and 0.98 or 1
            }):Play()

            if value then
                Acrylic.Enable()
            else
                Acrylic.Disable()
            end
        end
    end
end

function library:ToggleTransparency(value)
    if library.Window then
        TweenService:Create(library.Window.AcrylicPaint.Frame.Background, TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
            BackgroundTransparency = value and 0.35 or 0
        }):Play()
    end
end

function library:Notify(config)
    return NotificationModule:New(config)
end

if getgenv then
    getgenv()["library"] = library
end

return library
