--//
--// Prison Life script made by xS_Killus
--//

--//
--// Instances And Functions
--//

local Debris = game:GetService("Debris")
local MarketplaceService = game:GetService("MarketplaceService")
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local Workspace = game:GetService("Workspace")

local Client = Players.LocalPlayer
local Camera = Workspace.CurrentCamera

local CurrentTarget

local Remotes = {
    Remote = ReplicatedStorage:WaitForChild("GunRemotes"):WaitForChild("ShootEvent"),
    ArrestRemote = ReplicatedStorage:WaitForChild("Remotes"):WaitForChild("ArrestPlayer"),
    MeleeRemote = ReplicatedStorage:WaitForChild("meleeEvent"),
    TasedRemote = ReplicatedStorage:WaitForChild("GunRemotes"):WaitForChild("PlayerTased")
}

local GunArray = {}

local EffectsFolder = Workspace:FindFirstChild("Effects") or Instance.new("Folder", Workspace)

EffectsFolder.Name = "Effects"

local PositionsInfo = {
    ["Armory"] = Vector3.new(826.2001953125, 101.46707153320312, 2294.853759765625),
    ["Inside Prison"] = Vector3.new(915.2999267578125, 101.49960327148438, 2388.000244140625),
    ["Secret Room"] = Vector3.new(701.4503173828125, 101.45552062988281, 2354.30126953125),
    ["Prison Yard"] = Vector3.new(795.7847900390625, 99.6580581665039, 2541.0048828125),
    ["Criminal Base"] = Vector3.new(-975.0344848632812, 109.82368469238281, 2057.951171875),
    ["Prison Car Spawner"] = Vector3.new(598.9443359375, 99.66586303710938, 2504.1630859375),
    ["Prison Kitchen"] = Vector3.new(924.5208129882812, 101.48553466796875, 2227.595947265625)
}

local HitSoundID = {
    Bameware = "3124331820",
    Bell = "6534947240",
    Bubble = "6534947588",
    Pick = "1347140027",
    Pop = "198598793",
    Rust = "1255040462",
    Sans = "3188795283",
    Fart = "130833677",
    Big = "5332005053",
    Vine = "5332680810",
    Bruh = "4578740568",
    Skeet = "5633695679",
    Neverlose = "6534948092",
    Fatality = "6534947869",
    Bonk = "5766898159",
    Minecraft = "4018616850"
}

local HitSounds = {
    "Bameware",
    "Bubble",
    "Pop",
    "Sans",
    "Big",
    "Bruh",
    "Neverlose",
    "Bell",
    "Pick",
    "Rust",
    "Fart",
    "Vine",
    "Skeet",
    "Fatality",
    "Minecraft"
}

local GunShootSoundID = {
    ["AWP"] = "132602247378058",
    ["Desert Eagle"] = "82286818216627",
    ["Glock"] = "6581933860",
    ["MP40"] = "103807799095792",
    ["Ray Gun"] = "131179973",
    ["Laser"] = "94084778213749",
    ["Tank"] = "138839154527248",
    ["Galaga"] = "3038719943",
    ["Barrett Cal"] = "3383318550",
    ["Pindad SS2"] = "18620503407",
    ["Revolver"] = "120771468205926",
    ["Dart Gun"] = "5924183835"
}

local GunShootSounds = {
    "AWP",
    "Desert Eagle",
    "Glock",
    "MP40",
    "Ray Gun",
    "Laser",
    "Tank",
    "Galaga",
    "Barrett Cal",
    "Pindad SS2",
    "Revolver",
    "Dart Gun"
}

local Textures = {
    CIRCLE_TEXTURE = "rbxassetid://243660364",
    STAR_TEXTURE = "rbxassetid://2273224484",
    SMOKE_TEXTURE = "rbxassetid://1084969748"
}

local RayParams = RaycastParams.new()

RayParams.FilterType = Enum.RaycastFilterType.Exclude
RayParams.IgnoreWater = true
RayParams.FilterDescendantsInstances = {
    Client.Character
}

local function IsVisible(tPart, org)
    local Result = Workspace:Raycast(org, tPart.Position - org, RayParams)

    return (not Result) or Result.Instance:IsDescendantOf(tPart.Parent)
end

local HitEffects = {}

HitEffects.BloodSplat = function(pos)
    local Part = Instance.new("Part")

    Part.Size = Vector3.new(1, 1, 1)
    Part.Anchored = true
    Part.CanCollide = false
    Part.Position = pos
    Part.Transparency = 1
    Part.CanQuery = false
    Part.Parent = Workspace

    local Emitter = Instance.new("ParticleEmitter")

    Emitter.Texture = Textures.CIRCLE_TEXTURE
    Emitter.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 0, 0)),
        ColorSequenceKeypoint.new(0.3, Color3.fromRGB(200, 0, 0)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(100, 0, 0))
    })
    Emitter.Size = NumberSequence.new({
        NumberSequenceKeypoint.new(0, 1.5),
        NumberSequenceKeypoint.new(0.3, 1.0),
        NumberSequenceKeypoint.new(1, 0.3)
    })
    Emitter.Transparency = NumberSequence.new({
        NumberSequenceKeypoint.new(0, 0),
        NumberSequenceKeypoint.new(0.6, 0.3),
        NumberSequenceKeypoint.new(1, 1)
    })
    Emitter.Speed = NumberRange.new(10, 25)
    Emitter.SpreadAngle = Vector2.new(180, 180)
    Emitter.Lifetime = NumberRange.new(0.5, 1.0)
    Emitter.Acceleration = Vector3.new(0, -50, 0)
    Emitter.Drag = 2
    Emitter.RotSpeed = NumberRange.new(-180, 180)
    Emitter.Rotation = NumberRange.new(0, 360)
    Emitter.Rate = 0
    Emitter.Parent = Part

    local Droplets = Instance.new("ParticleEmitter")

    Droplets.Texture = Textures.CIRCLE_TEXTURE
    Droplets.Color = ColorSequence.new(Color3.fromRGB(180, 0, 0))
    Droplets.Size = NumberSequence.new({
        NumberSequenceKeypoint.new(0, 0.8),
        NumberSequenceKeypoint.new(1, 0.2)
    })
    Droplets.Transparency = NumberSequence.new({
        NumberSequenceKeypoint.new(0, 0.1),
        NumberSequenceKeypoint.new(1, 1)
    })
    Droplets.Speed = NumberRange.new(15, 15)
    Droplets.SpreadAngle = Vector2.new(120, 120)
    Droplets.Lifetime = NumberRange.new(0.3, 0.7)
    Droplets.Acceleration = Vector3.new(0, -80, 0)
    Droplets.Drag = 1
    Droplets.Rate = 0
    Droplets.Parent = Part

    local Mist = Instance.new("ParticleEmitter")

    Mist.Texture = Textures.SMOKE_TEXTURE
    Mist.Color = ColorSequence.new(Color3.fromRGB(150, 0, 0))
    Mist.Size = NumberSequence.new({
        NumberSequenceKeypoint.new(0, 0.5),
        NumberSequenceKeypoint.new(1, 3)
    })
    Mist.Transparency = NumberSequence.new({
        NumberSequenceKeypoint.new(0, 0.4),
        NumberSequenceKeypoint.new(1, 1)
    })
    Mist.Speed = NumberRange.new(2, 6)
    Mist.SpreadAngle = Vector2.new(360, 360)
    Mist.Lifetime = NumberRange.new(0.4, 0.8)
    Mist.Rate = 0
    Mist.Parent = Part

    local Flash = Instance.new("Part")

    Flash.Size = Vector3.new(2, 2, 2)
    Flash.Shape = Enum.PartType.Ball
    Flash.Position = pos
    Flash.Anchored = true
    Flash.CanCollide = false
    Flash.Material = Enum.Material.Neon
    Flash.Color = Color3.fromRGB(255, 0, 0)
    Flash.Transparency = 0.3
    Flash.CanQuery = false
    Flash.Parent = Workspace

    local FlashTween = TweenService:Create(Flash, TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
        Size = Vector3.new(4, 4, 4),
        Transparency = 1
    })

    FlashTween:Play()

    FlashTween.Completed:Connect(function()
        Flash:Destroy()
    end)

    Emitter:Emit(50)
    Droplets:Emit(30)
    Mist:Emit(20)

    Debris:AddItem(Part, 2)
end

HitEffects.ElectricBurst = function(pos)
    local Part = Instance.new("Part")

    Part.Size = Vector3.new(0.5, 0.5, 0.5)
    Part.Anchored = true
    Part.CanCollide = false
    Part.Position = pos
    Part.Transparency = 1
    Part.CanQuery = false
    Part.Parent = Workspace

    local Core = Instance.new("Part")

    Core.Size = Vector3.new(1, 1, 1)
    Core.Shape = Enum.PartType.Ball
    Core.Position = pos
    Core.Anchored = true
    Core.CanCollide = false
    Core.Material = Enum.Material.Neon
    Core.Color = Color3.fromRGB(100, 200, 255)
    Core.Transparency = 0
    Core.CanQuery = false
    Core.Parent = Workspace

    local CoreLight = Instance.new("PointLight")

    CoreLight.Brightness = 2.5
    CoreLight.Range = 15
    CoreLight.Color = Color3.fromRGB(100, 200, 255)
    CoreLight.Parent = Core

    local Electric = Instance.new("ParticleEmitter")

    Electric.Texture = Textures.STAR_TEXTURE
    Electric.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, Color3.fromRGB(200, 240, 255)),
        ColorSequenceKeypoint.new(0.5, Color3.fromRGB(100, 180, 255)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(50, 100, 255))
    })
    Electric.Size = NumberSequence.new({
        NumberSequenceKeypoint.new(0, 0.4),
        NumberSequenceKeypoint.new(0.5, 0.2),
        NumberSequenceKeypoint.new(1, 0)
    })
    Electric.Transparency = NumberSequence.new({
        NumberSequenceKeypoint.new(0, 0),
        NumberSequenceKeypoint.new(0.7, 0.3),
        NumberSequenceKeypoint.new(1, 1)
    })
    Electric.LightEmission = 1
    Electric.LightInfluence = 0
    Electric.Speed = NumberRange.new(20, 40)
    Electric.SpreadAngle = Vector2.new(360, 360)
    Electric.Lifetime = NumberRange.new(0.1, 0.3)
    Electric.Drag = 5
    Electric.Rate = 0
    Electric.Parent = Part

    local Bolts = Instance.new("ParticleEmitter")

    Bolts.Texture = Textures.CIRCLE_TEXTURE
    Bolts.Color = ColorSequence.new(Color3.fromRGB(220, 240, 255))
    Bolts.Size = NumberSequence.new({
        NumberSequenceKeypoint.new(0, 0.15),
        NumberSequenceKeypoint.new(1, 0.05)
    })
    Bolts.Transparency = NumberSequence.new({
        NumberSequenceKeypoint.new(0, 0),
        NumberSequenceKeypoint.new(1, 1)
    })
    Bolts.LightEmission = 1
    Bolts.Speed = NumberRange.new(30, 50)
    Bolts.SpreadAngle = Vector2.new(360, 360)
    Bolts.Lifetime = NumberRange.new(0.05, 0.15)
    Bolts.Rate = 0
    Bolts.Parent = Part

    for _ = 1, 6 do
        local Beam = Instance.new("Part")

        Beam.Size = Vector3.new(0.1, 0.1, math.random(3, 6))
        Beam.CFrame = CFrame.new(pos) * CFrame.Angles(math.random() * math.pi * 2, math.random() * math.pi * 2, 0)
        Beam.Anchored = true
        Beam.CanCollide = false
        Beam.Material = Enum.Material.Neon
        Beam.Color = Color3.fromRGB(150, 220, 255)
        Beam.Transparency = 0.2
        Beam.CanQuery = false
        Beam.Parent = Workspace

        local BeamTween = TweenService:Create(Beam, TweenInfo.new(0.15, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
            Transparency = 1,
            Size = Vector3.new(0.05, 0.05, Beam.Size.Z + 2)
        })

        BeamTween:Play()

        BeamTween.Completed:Connect(function()
            Beam:Destroy()
        end)
    end

    local CoreTween = TweenService:Create(Core, TweenInfo.new(0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
        Size = Vector3.new(3, 3, 3),
        Transparency = 1
    })

    local LightTween = TweenService:Create(CoreLight, TweenInfo.new(0.25), {
        Brightness = 0
    })

    CoreTween:Play()
    LightTween:Play()

    CoreTween.Completed:Connect(function()
        Core:Destroy()
    end)

    Electric:Emit(70)
    Bolts:Emit(40)

    Debris:AddItem(Part, 1)
end

HitEffects.Shockwave = function(pos)
    local Sphere = Instance.new("Part")

    Sphere.Shape = Enum.PartType.Ball
    Sphere.Size = Vector3.new(1, 1, 1)
    Sphere.CFrame = CFrame.new(pos)
    Sphere.Anchored = true
    Sphere.CanCollide = false
    Sphere.Transparency = 0.4
    Sphere.Material = Enum.Material.ForceField
    Sphere.CanQuery = false
    Sphere.Parent = Workspace

    local InnerSphere = Instance.new("Part")

    InnerSphere.Shape = Enum.PartType.Ball
    InnerSphere.Size = Vector3.new(0.5, 0.5, 0.5)
    InnerSphere.CFrame = CFrame.new(pos)
    InnerSphere.Anchored = true
    InnerSphere.CanCollide = false
    InnerSphere.Transparency = 0.2
    InnerSphere.Material = Enum.Material.Neon
    InnerSphere.Color = Color3.fromRGB(255, 255, 100)
    InnerSphere.CanQuery = false
    InnerSphere.Parent = Workspace

    local Light = Instance.new("PointLight")

    Light.Brightness = 3
    Light.Range = 20
    Light.Color = Color3.fromRGB(255, 230, 100)
    Light.Parent = Sphere

    local RingPart = Instance.new("Part")

    RingPart.Size = Vector3.new(0.5, 0.5, 0.5)
    RingPart.Position = pos
    RingPart.Anchored = true
    RingPart.CanCollide = false
    RingPart.Transparency = 1
    RingPart.Parent = Workspace

    local RingEmitter = Instance.new("ParticleEmitter")

    RingEmitter.Texture = Textures.CIRCLE_TEXTURE
    RingEmitter.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 255, 150)),
        ColorSequenceKeypoint.new(0.5, Color3.fromRGB(255, 220, 50)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(255, 180, 0))
    })
    RingEmitter.Size = NumberSequence.new({
        NumberSequenceKeypoint.new(0, 0.4),
        NumberSequenceKeypoint.new(1, 0.1)
    })
    RingEmitter.Transparency = NumberSequence.new({
        NumberSequenceKeypoint.new(0, 0.2),
        NumberSequenceKeypoint.new(1, 1)
    })
    RingEmitter.LightEmission = 1
    RingEmitter.Speed = NumberRange.new(20, 30)
    RingEmitter.SpreadAngle = Vector2.new(360, 360)
    RingEmitter.Lifetime = NumberRange.new(0.2, 0.4)
    RingEmitter.Rate = 0
    RingEmitter.Parent = RingPart

    RingEmitter:Emit(80)

    local tweenInfo = TweenInfo.new(0.5, Enum.EasingStyle.Quint, Enum.EasingDirection.Out)

    local SphereTween = TweenService:Create(Sphere, tweenInfo, {
        Size = Vector3.new(12, 12, 12),
        Transparency = 1
    })

    local InnerTweenInfo = TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)

    local InnerTween = TweenService:Create(InnerSphere, InnerTweenInfo, {
        Size = Vector3.new(6, 6, 6),
        Transparency = 1
    })

    local LightTween = TweenService:Create(Light, tweenInfo, {
        Brightness = 0,
        Range = 30
    })

    SphereTween:Play()
    InnerTween:Play()
    LightTween:Play()

    SphereTween.Completed:Connect(function()
        Sphere:Destroy()
        InnerSphere:Destroy()
    end)

    Debris:AddItem(RingPart, 1)
end

local FloatingTextIO = "67"

HitEffects.FloatingText = function(pos)
    local AnchorPart = Instance.new("Part")

    AnchorPart.Size = Vector3.new(0.1, 0.1, 0.1)
    AnchorPart.Position = pos
    AnchorPart.Anchored = true
    AnchorPart.CanCollide = false
    AnchorPart.Transparency = 1
    AnchorPart.CanQuery = false
    AnchorPart.Parent = Workspace

    local Billboard = Instance.new("BillboardGui")

    Billboard.Size = UDim2.new(0, 120, 0, 60)
    Billboard.Adornee = AnchorPart
    Billboard.AlwaysOnTop = true
    Billboard.StudsOffset = Vector3.new(0, 0, 0)
    Billboard.Parent = AnchorPart

    local Text = Instance.new("TextLabel")

    Text.Size = UDim2.new(1, 0, 1, 0)
    Text.BackgroundTransparency = 1
    Text.Text = FloatingTextIO
    Text.TextColor3 = Color3.fromRGB(255, 255, 100)
    Text.TextStrokeColor3 = Color3.fromRGB(180, 50, 0)
    Text.TextStrokeTransparency = 0
    Text.TextScaled = false
    Text.TextSize = 20
    Text.Font = Enum.Font.GothamBlack
    Text.Parent = Billboard

    local ScaleUp = TweenService:Create(Billboard, TweenInfo.new(0.1, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
        Size = UDim2.new(0, 140, 0, 70)
    })

    ScaleUp:Play()

    local tweenInfo = TweenInfo.new(1, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)

    local FloatTween = TweenService:Create(Billboard, tweenInfo, {
        StudsOffset = Vector3.new(0, 4, 0)
    })

    local FadeTween = TweenService:Create(Text, TweenInfo.new(0.8, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {
        TextTransparency = 1,
        TextStrokeTransparency = 1
    })

    task.delay(0.1, function()
        FloatTween:Play()
    end)

    task.delay(0.4, function()
        FadeTween:Play()
    end)

    Debris:AddItem(AnchorPart, 1.5)
end

HitEffects.Flash = function(pos)
    local Core = Instance.new("Part")

    Core.Size = Vector3.new(1, 1, 1)
    Core.Shape = Enum.PartType.Ball
    Core.Position = pos
    Core.Anchored = true
    Core.CanCollide = false
    Core.Material = Enum.Material.Neon
    Core.Color = Color3.fromRGB(255, 255, 255)
    Core.Transparency = 0
    Core.CanQuery = false
    Core.Parent = Workspace

    local Glow = Instance.new("Part")

    Glow.Size = Vector3.new(2, 2, 2)
    Glow.Shape = Enum.PartType.Ball
    Glow.Anchored = true
    Glow.Position = pos
    Glow.CanCollide = false
    Glow.Material = Enum.Material.Neon
    Glow.Color = Color3.fromRGB(255, 255, 200)
    Glow.Transparency = 0.5
    Glow.CanQuery = false
    Glow.Parent = Workspace

    local Light = Instance.new("PointLight")

    Light.Brightness = 3.5
    Light.Range = 25
    Light.Color = Color3.fromRGB(255, 255, 230)
    Light.Parent = Core

    local CoreInfo = TweenInfo.new(0.2, Enum.EasingStyle.Quint, Enum.EasingDirection.Out)

    local CoreTween = TweenService:Create(Core, CoreInfo, {
        Size = Vector3.new(4, 4, 4),
        Transparency = 1
    })

    local GlowTween = TweenService:Create(Glow, TweenInfo.new(0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
        Size = Vector3.new(8, 8, 8),
        Transparency = 1
    })

    local LightTween = TweenService:Create(Light, TweenInfo.new(0.2), {
        Brightness = 0
    })

    CoreTween:Play()
    GlowTween:Play()
    LightTween:Play()

    CoreTween.Completed:Connect(function()
        Core:Destroy()
        Glow:Destroy()
    end)
end

local SkyBoxes = {
    ["Purple Nebula"] = {
        SkyboxUp = "rbxassetid://159454288",
        SkyboxRt = "rbxassetid://159454300",
        SkyboxLf = "rbxassetid://159454286",
        SkyboxFt = "rbxassetid://159454293",
        SkyboxBk = "rbxassetid://159454299",
        SkyboxDn = "rbxassetid://159454296"
    },
    ["Christmas"] = {
        SkyboxUp = "rbxassetid://155674931",
        SkyboxRt = "rbxassetid://155657619",
        SkyboxLf = "rbxassetid://155657671",
        SkyboxFt = "rbxassetid://155657609",
        SkyboxBk = "rbxassetid://155657655",
        SkyboxDn = "rbxassetid://155674246"
    },
    ["Tattletail"] = {
        SkyboxUp = "rbxassetid://120327360847306",
        SkyboxRt = "rbxassetid://104710795412949",
        SkyboxLf = "rbxassetid://75856428387182",
        SkyboxFt = "rbxassetid://123928107244181",
        SkyboxBk = "rbxassetid://140303809601361",
        SkyboxDn = "rbxassetid://120327360847306"
    },
    ["Clouds"] = {
        SkyboxUp = "rbxassetid://225469380",
        SkyboxRt = "rbxassetid://225469372",
        SkyboxLf = "rbxassetid://225469364",
        SkyboxFt = "rbxassetid://225469359",
        SkyboxBk = "rbxassetid://225469345",
        SkyboxDn = "rbxassetid://225469349"
    },
    ["Sunrise"] = {
        SkyboxUp = "rbxassetid://600835177",
        SkyboxRt = "rbxassetid://600833862",
        SkyboxLf = "rbxassetid://600886090",
        SkyboxFt = "rbxassetid://600832720",
        SkyboxBk = "rbxassetid://600830446",
        SkyboxDn = "rbxassetid://600831635"
    },
    ["Dark Storms"] = {
        SkyboxUp = "rbxassetid://150283877",
        SkyboxRt = "rbxassetid://150283748",
        SkyboxLf = "rbxassetid://150283702",
        SkyboxFt = "rbxassetid://150283781",
        SkyboxBk = "rbxassetid://150283828",
        SkyboxDn = "rbxassetid://150283728"
    },
    ["Night Sky"] = {
        SkyboxUp = "rbxassetid://12064131",
        SkyboxRt = "rbxassetid://12064115",
        SkyboxLf = "rbxassetid://12063984",
        SkyboxFt = "rbxassetid://12064121",
        SkyboxBk = "rbxassetid://12064107",
        SkyboxDn = "rbxassetid://12064152"
    },
    ["Pink Daylight"] = {
        SkyboxUp = "rbxassetid://271077958",
        SkyboxRt = "rbxassetid://271042467",
        SkyboxLf = "rbxassetid://271042310",
        SkyboxFt = "rbxassetid://271042556",
        SkyboxBk = "rbxassetid://271042516",
        SkyboxDn = "rbxassetid://271077243"
    },
    ["Morning Glow"] = {
        SkyboxUp = "rbxassetid://1417494643",
        SkyboxRt = "rbxassetid://1417494499",
        SkyboxLf = "rbxassetid://1417494402",
        SkyboxFt = "rbxassetid://1417494253",
        SkyboxBk = "rbxassetid://1417494030",
        SkyboxDn = "rbxassetid://1417494146"
    },
    ["Setting Sun"] = {
        SkyboxUp = "rbxassetid://626460625",
        SkyboxRt = "rbxassetid://626458639",
        SkyboxLf = "rbxassetid://626473032",
        SkyboxFt = "rbxassetid://626460513",
        SkyboxBk = "rbxassetid://626460377",
        SkyboxDn = "rbxassetid://626460216"
    },
    ["Fade Blue"] = {
        SkyboxUp = "rbxassetid://153695471",
        SkyboxRt = "rbxassetid://153695383",
        SkyboxLf = "rbxassetid://153695320",
        SkyboxFt = "rbxassetid://153695452",
        SkyboxBk = "rbxassetid://153695414",
        SkyboxDn = "rbxassetid://153695352"
    },
    ["Elegant Morning"] = {
        SkyboxUp = "rbxassetid://153767288",
        SkyboxRt = "rbxassetid://153767231",
        SkyboxLf = "rbxassetid://153767200",
        SkyboxFt = "rbxassetid://153767266",
        SkyboxBk = "rbxassetid://153767241",
        SkyboxDn = "rbxassetid://153767216"
    },
    ["Neptune"] = {
        SkyboxUp = "rbxassetid://218950090",
        SkyboxRt = "rbxassetid://218957134",
        SkyboxLf = "rbxassetid://218958493",
        SkyboxFt = "rbxassetid://218954524",
        SkyboxBk = "rbxassetid://218955819",
        SkyboxDn = "rbxassetid://218953419"
    },
    ["Redshift"] = {
        SkyboxUp = "rbxassetid://401664936",
        SkyboxRt = "rbxassetid://401664901",
        SkyboxLf = "rbxassetid://401664881",
        SkyboxFt = "rbxassetid://401664960",
        SkyboxBk = "rbxassetid://401664839",
        SkyboxDn = "rbxassetid://401664862"
    },
    ["Aesthetic Night"] = {
        SkyboxUp = "rbxassetid://1045962969",
        SkyboxRt = "rbxassetid://1045964655",
        SkyboxLf = "rbxassetid://1045964655",
        SkyboxFt = "rbxassetid://1045964655",
        SkyboxBk = "rbxassetid://1045964490",
        SkyboxDn = "rbxassetid://1045964368"
    }
}

local EffectNames = {
    "BloodSplat",
    "ElectricBurst",
    "Shockwave",
    "FloatingText",
    "Flash"
}

local GunList = {}

for _, g in pairs(ReplicatedStorage.Tools.Guns:GetChildren()) do
    table.insert(GunList, g.Name)
end

local function GetMesh(tool)
    for _, v in ipairs(tool:GetDescendants()) do
        if v:IsA("MeshPart") then
            return v
        end
    end
end

local function UpdateProperty(tool, property, val)
    local Tool = GetMesh(tool)

    if Tool then
        Tool[property] = val
    end
end

local function UpdateColor(tool, color)
    UpdateProperty(tool, "Color", color)
    UpdateProperty(tool, "TextureID", "")
end

local function UpdateTransparency(tool, val)
    UpdateProperty(tool, "Transparency", val)
end

local function UpdateMaterial(tool, val)
    local Mesh = GetMesh(tool)

    if Mesh then
        Mesh.Material = Enum.Material[val]
    end
end

local function RemoveTextureID(tool)
    local Mesh = tool:FindFirstChildWhichIsA("MeshPart", true)

    if Mesh then
        Mesh.TextureID = ""
    end
end

local function RevertTextureID(tool)
    local Mesh = tool:FindFirstChildWhichIsA("MeshPart", true)

    local ReplicaTool = ReplicatedStorage.Tools.Guns:FindFirstChild(tool.Name)
    local ReplicaMesh = ReplicaTool:FindFirstChildWhichIsA("MeshPart", true)

    if not ReplicaMesh then
        return
    end

    Mesh.TextureID = ReplicaMesh.TextureID
end

if ReplicatedStorage.Scripts:FindFirstChild("CharacterCollision") then
    ReplicatedStorage.Scripts:FindFirstChild("CharacterCollision"):Destroy()
end

local Friends = {}

local function IsFriends(userId)
    if Friends[userId] ~= nil then
        return Friends[userId]
    end

    local Success, Result = pcall(function()
        return Client:IsFriendsWith(userId)
    end)

    Friends[userId] = Success and Result or false

    return Friends[userId]
end

local SilentCircle = Drawing.new("Circle")

SilentCircle.Visible = true
SilentCircle.Transparency = 0
SilentCircle.Color = Color3.fromRGB(255, 255, 255)
SilentCircle.Thickness = 2
SilentCircle.NumSides = 64
SilentCircle.Filled = false
SilentCircle.Radius = 100
SilentCircle.Position = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y / 2)

local Mods = {}

local GettingGun = false

local function GetGun(toolName)
    if GettingGun == false then
        GettingGun = true

        local Char = Client.Character
        local Root = Char and Char:FindFirstChild("HumanoidRootPart")

        if not (Char and Root) then
            GettingGun = false

            return
        end

        if Char:FindFirstChild("ForceField") then
            getgenv()["library"]:Notification({
                Title = "Break-Skill Hub | V1 | Error",
                Content = "Cannot get gun's while you have forcefield.",
                Icon = getgenv()["NebulaIcons"]:GetIcon("warning_error", "Fluency"),
                Duration = 30
            }, "ERROR_ForceField")

            GettingGun = false

            return
        end

        if Client.Backpack:FindFirstChild(toolName) or Char:FindFirstChild(toolName) then
            getgenv()["library"]:Notification({
                Title = "Break-Skill Hub | V1 | Error",
                Content = "You already have " .. toolName,
                Icon = getgenv()["NebulaIcons"]:GetIcon("warning_error", "Fluency"),
                Duration = 30
            }, "ERROR_AlreadyHave")

            GettingGun = false

            return
        end

        local Giver

        for _, v in ipairs(Workspace:GetDescendants()) do
            if v.Name == "TouchGiver" and v:GetAttribute("ToolName") == toolName then
                Giver = v:FindFirstChildWhichIsA("BasePart")

                break
            end
        end

        if not Giver then
            getgenv()["library"]:Notification({
                Title = "Break-Skill Hub | V1 | Error",
                Content = "Giver not found for: " .. toolName,
                Icon = getgenv()["NebulaIcons"]:GetIcon("warning_error", "Fluency"),
                Duration = 30
            }, "ERROR_GiverNotFound")

            GettingGun = false

            return
        end

        local OriginalGiverCFrame = Giver.CFrame
        local OldCharCFrame = Root.CFrame
        local UndergroundCFrame = OriginalGiverCFrame - Vector3.new(0, 15.5, 0)

        Giver.CanTouch = true
        Giver.CFrame = UndergroundCFrame

        Char:PivotTo(UndergroundCFrame + Vector3.new(0, 5, 0))

        task.wait(0.25)

        firetouchinterest(Giver, Root, 0)

        task.wait(0.3)

        firetouchinterest(Giver, Root, 1)

        task.wait(0.05)

        Giver.CFrame = OriginalGiverCFrame

        Char:PivotTo(OldCharCFrame)

        wait(0.1)

        GettingGun = false
    end
end

local HitBoxes = {}

local function CreateHitbox(char)
    if not char then
        return
    end

    local hrp = char:FindFirstChild("HumanoidRootPart")

    if not hrp then
        return
    end

    if not HitBoxes[hrp] then
        HitBoxes[hrp] = {
            origin = hrp.Size
        }
    end

    hrp.CanCollide = false

    return hrp
end

local function RemoveHitBox(hrp)
    if HitBoxes[hrp] then
        hrp.Size = HitBoxes[hrp].origin
        hrp.Transparency = 1
        hrp.CanCollide = true

        HitBoxes[hrp] = nil
    end
end

local function IsTrue(v)
    return v == true
end

--//
--// Window
--//

local Window = getgenv()["library"]:CreateWindow({
    Name = "Break-Skill Hub | " .. MarketplaceService:GetProductInfo(game.PlaceId).Name,
    Subtitle = "V1.0",
    Icon = 7771536804,
    InterfaceAdvertisingPrompts = false,
    NotifyOnCallbackError = true,
    BuildWarnings = true,
    LoadingEnabled = true,
    LoadingSettings = {
        Title = "Break-Skill Hub | " .. MarketplaceService:GetProductInfo(game.PlaceId).Name,
        Subtitle = "V1.0",
        Logo = 7771536804
    },
    FileSettings = {
        RootFolder = "Break-Skill Hub - V1",
        ConfigFolder = "Games",
        ThemesInRoot = true
    }
})

--//
--// Combat Tab
--//

local CombatTabSection = Window:CreateTabSection("Combat")

local CombatTab = CombatTabSection:CreateTab({
    Name = "Combat",
    Columns = 3,
    Icon = getgenv()["NebulaIcons"]:GetIcon("weapon_sword", "Fluency")
}, "CombatTab")

--// Silent Aim GroupBox

local SilentAimGroupBox = CombatTab:CreateGroupbox({
    Name = "Silent Aim",
    Column = 1
}, "SilentAim")

local SilentAimToggle = SilentAimGroupBox:CreateToggle({
    Name = "Enabled",
    Style = 2
}, "SilentAimToggle")

local BodyPartsDropdownLabel = SilentAimGroupBox:CreateLabel({
    Name = "Body Parts"
}, "BodyPartsDropdownLabel")

local BodyPartsDropdown = BodyPartsDropdownLabel:AddDropdown({
    Options = {
        "Head",
        "Left Arm",
        "Right Arm",
        "Left Leg",
        "Right Leg",
        "HumanoidRootPart"
    },
    CurrentOption = "Head"
})

local SilentAimHitChance = SilentAimGroupBox:CreateSlider({
    Name = "Hit Chance",
    Suffix = "%",
    CurrentValue = 50,
    Range = {
        Minimum = 1,
        Maximum = 100
    }
})

local SilentAimDivider1 = SilentAimGroupBox:CreateDivider()

local SilentAimTeamCheck = SilentAimGroupBox:CreateToggle({
    Name = "Team Check",
    Style = 2
})

local SilentAimWallCheck = SilentAimGroupBox:CreateToggle({
    Name = "Wall Check",
    Style = 2
})

local SilentAimDivider2 = SilentAimGroupBox:CreateDivider()

local SilentAimIgnoreGuards = SilentAimGroupBox:CreateToggle({
    Name = "Ignore Guards",
    Style = 2
})

local SilentAimIgnoreCriminals = SilentAimGroupBox:CreateToggle({
    Name = "Ignore Criminals",
    Style = 2
})

local SilentAimIgnoreInnocent = SilentAimGroupBox:CreateToggle({
    Name = "Ignore Innocent",
    Style = 2
})

local SilentAimIgnoreHostile = SilentAimGroupBox:CreateToggle({
    Name = "Ignore Hostile",
    Style = 2
})

local SilentAimIgnoreTrespass = SilentAimGroupBox:CreateToggle({
    Name = "Ignore Trespass",
    Style = 2
})

local SilentAimIgnoreForceField = SilentAimGroupBox:CreateToggle({
    Name = "Ignore ForceField",
    Style = 2
})

local SilentAimDivider3 = SilentAimGroupBox:CreateDivider()

local SilentAimShowFOV = SilentAimGroupBox:CreateToggle({
    Name = "Show FOV",
    Style = 2,
    Callback = function(val)
        SilentCircle.Transparency = val and 1 or 0
    end
})

local SilentAimFOVFollowMouse = SilentAimGroupBox:CreateToggle({
    Name = "Follow Mouse",
    Style = 2
})

local SilentAimFOVSize = SilentAimGroupBox:CreateSlider({
    Name = "FOV Size",
    CurrentValue = 100,
    Range = {
        Minimum = 1,
        Maximum = 500
    },
    Callback = function(val)
        SilentCircle.Radius = val
    end
})

--//
--// XD
--//

local function GetClosestPlayer()
    local Closest, ClosestDistance = nil, math.huge
    local Center = SilentCircle.Position
    local Origin = Camera.CFrame.Position

    for _, p in pairs(Players:GetPlayers()) do
        if p == Client then
            return
        end

        if SilentAimTeamCheck.Values.CurrentValue and p.Team and p.Team == Client.Team then
            continue
        end

        if p.Team then
            if SilentAimIgnoreCriminals.Values.CurrentValue and p.Team.Name == "Criminals" then
                continue
            end

            if SilentAimIgnoreGuards.Values.CurrentValue and p.Team.Name == "Guards" then
                continue
            end
        end

        local Char = p.Character

        if not Char then
            continue
        end

        local IsHostile = Char:GetAttribute("Hostile") == true
        local IsTrespassing = Char:GetAttribute("Trespassing") == true

        if SilentAimIgnoreHostile.Values.CurrentValue and p.Team and p.Team.Name == "Inmates" and IsHostile then
            continue
        end

        if SilentAimIgnoreInnocent.Values.CurrentValue and p.Team and p.Team.Name == "Inmates" and (not IsHostile and not IsTrespassing) then
            continue
        end

        local Hum = Char:FindFirstChild("Humanoid")
        local HRP = Char:FindFirstChild("HumanoidRootPart")

        local TargetPart = Char:FindFirstChild(BodyPartsDropdown.Values.CurrentValue)

        if (not Hum and HRP and Hum.Health > 0) then
            continue
        end

        local ScreenPos, OnScreen = Camera:WorldToViewportPoint(HRP.Position)

        if not OnScreen then
            continue
        end

        if SilentAimWallCheck.Values.CurrentValue and not IsVisible(TargetPart, Origin) then
            continue
        end

        if SilentAimIgnoreForceField.Values.CurrentValue and Char:FindFirstChild("ForceField") then
            continue
        end

        local Distance = (Vector2.new(ScreenPos.X, ScreenPos.Y) - Center).Magnitude

        if Distance <= SilentCircle.Radius and Distance < ClosestDistance then
            Closest = p
            ClosestDistance = Distance
        end
    end

    return Closest
end

RunService.Heartbeat:Connect(function()
    CurrentTarget = GetClosestPlayer()
end)

local function DidHit()
    return math.random(1, 100) <= SilentAimHitChance.Values.CurrentValue
end

local function GetMissOffset(partPos, origin)
    local Distance = (partPos - origin).Magnitude

    local Scale = math.clamp(Distance / 3, 3, 4)

    return Vector3.new(math.random(-Scale, Scale), math.random(-Scale / 2, Scale / 2), math.random(-Scale, Scale))
end

task.spawn(function()
    RunService.RenderStepped:Connect(function()
        if Workspace.CurrentCamera then
            Camera = Workspace.CurrentCamera

            if SilentAimFOVFollowMouse.Values.CurrentValue then
                local MousePos = UserInputService:GetMouseLocation()

                SilentCircle.Position = Vector2.new(MousePos.X, MousePos.Y)
            else
                SilentCircle.Position = Camera.ViewportSize / 2
            end
        end
    end)
end)

local CastRayF = filtergc("function", {
    Name = "castRay"
}, true)

local OldCastRay

if type(CastRayF) == "function" and hookfunction then
    OldCastRay = hookfunction(CastRayF, function(...)
        local Args = {
            ...
        }

        if SilentAimToggle.Values.CurrentValue and CurrentTarget and CurrentTarget.Character then
            local Part = CurrentTarget.Character:FindFirstChild(BodyPartsDropdown.Values.CurrentValue)

            if Part then
                if DidHit() then
                    Args[2] = Part.Position
                else
                    local Origin = Args[1]

                    local MissPart = CurrentTarget.Character:FindFirstChild("LeftLeg") or CurrentTarget.Character:FindFirstChild("RightLeg") or CurrentTarget.Character:FindFirstChild("Head")

                    if MissPart and typeof(Origin) == "Vector3" then
                        Args[2] = MissPart.Position + GetMissOffset(MissPart.Position, Origin)
                    end
                end
            end
        end

        return OldCastRay(table.unpack(Args))
    end)
end
