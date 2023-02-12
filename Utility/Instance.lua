--[
--Utility Made By xS_Killus
--]

--[
--Instances And Functions
--]

local Utility = {}

--[
--Utility Functions
--]

--Instance

function Utility:Instance(instance, props)
    local Corner, Stroke

    local CreatedInstance = Instance.new(instance)

    for p, v in next, props do
        if tostring(p) ~= "CornerRadius" and tostring(p) ~= "Stroke" then
            CreatedInstance[p] = v
        elseif tostring(p) == "Stroke" then
            Stroke = Instance.new("UIStroke", CreatedInstance)

            Stroke.Name = CreatedInstance.Name .. "_Stroke"
            Stroke.Color = v["Color"]
            Stroke.Thickness = v["Thick"]
            Stroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
            Stroke.Transparency = v["Transparency"]
            Stroke.LineJoinMode = Enum.LineJoinMode.Round
        elseif tostring(p) == "CornerRadius" then
            Corner = Instance.new("UICorner", CreatedInstance)

            Corner.Name = CreatedInstance.Name .. "_Corner"
            Corner.CornerRadius = v
        end
    end

    return CreatedInstance
end

return Utility
