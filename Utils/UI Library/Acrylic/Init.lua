--//
--// Init Made By xS_Killus
--//

local Lighting = game:GetService("Lighting")
local Workspace = game:GetService("Workspace")

local Acrylic = {
    AcrylicBlur = require(script.AcrylicBlur),
    CreateAcrylic = require(script.CreateAcrylic),
    AcrylicPaint = require(script.AcrylicPaint)
}

function Acrylic.Init()
    local BaseEffect = Instance.new("DepthOfFieldEffect")

    BaseEffect.FarIntensity = 0
    BaseEffect.InFocusRadius = 0.1
    BaseEffect.NearIntensity = 1

    local DepthOfFieldDefaults = {}

    function Acrylic.Enable()
        for _, e in pairs(DepthOfFieldDefaults) do
            e.Enabled = false
        end

        BaseEffect.Parent = Lighting
    end

    function Acrylic.Disable()
        for _, e in pairs(DepthOfFieldDefaults) do
            e.Enabled = e.Enabled
        end

        BaseEffect.Parent = nil
    end

    local function RegisterDefaults()
        local function Register(object)
            if object:IsA("DepthOfFieldEffect") then
                DepthOfFieldDefaults[object] = {
                    Enabled = object.Enabled
                }
            end
        end

        for _, c in pairs(Lighting:GetChildren()) do
            Register(c)
        end

        if Workspace.CurrentCamera then
            for _, c in pairs(Workspace.CurrentCamera:GetChildren()) do
                Register(c)
            end
        end
    end

    RegisterDefaults()

    Acrylic.Enable()
end

return Acrylic
