--//
--// CreateAcrylic Made By xS_Killus
--//

local Root = script.Parent.Parent

local Creator = require(Root.Creator)

local function CreateAcrylic()
    local Part = Creator.New("Part", {
        Name = "Body",
        Color = Color3.fromRGB(0, 0, 0),
        Material = Enum.Material.Glass,
        Size = Vector3.new(1, 1, 0),
        Anchored = true,
        CanCollide = false,
        Locked = true,
        CastShadow = false,
        Transparency = 0.98
    }, {
        Creator.New("SpecialMesh", {
            MeshType = Enum.MeshType.Brick,
            Offset = Vector3.new(0, 0, -0.000001)
        })
    })

    return Part
end

return CreateAcrylic
