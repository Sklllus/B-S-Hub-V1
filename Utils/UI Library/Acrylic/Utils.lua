--//
--// Utils Made By xS_Killus
--//

local Workspace = game:GetService("Workspace")

local function Map(val, inMin, inMax, outMin, outMax)
    return (val - inMin) * (outMax - outMin) / (inMax - inMin) + outMin
end

local function ViewportPointToWorld(location, distance)
    local UnitRay = Workspace.CurrentCamera:ScreenPointToRay(location.X, location.Y)

    return UnitRay.Origin + UnitRay.Direction * distance
end

local function GetOffset()
    local ViewportSizeY = Workspace.CurrentCamera.ViewportSize.Y

    return Map(ViewportSizeY, 0, 2560, 8, 56)
end

return {
    ViewportPointToWorld,
    GetOffset
}
