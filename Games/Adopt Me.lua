--//
--// Script Made By xS_Killus
--//

--//
--// Libraries
--//

getgenv()["IrisAd"] = true

local Notification = loadstring(game:HttpGet("https://api.irisapp.ca/Scripts/IrisBetterNotifications.lua"))()

loadstring("https://raw.githubusercontent.com/Sklllus/B-S-Hub-V1/refs/heads/main/Utils/UI%20Library.lua")()

local Services = loadstring(game:HttpGet("https://raw.githubusercontent.com/Sklllus/B-S-Hub-V1/refs/heads/main/Utils/Services.lua"))()
local Webhook = loadstring(game:HttpGet("https://raw.githubusercontent.com/Sklllus/B-S-Hub-V1/refs/heads/main/Utils/Webhook.lua"))()

--//
--// Instances And Functions
--//

local GuiService = game:GetService("GuiService")
local MarketplaceService = game:GetService("MarketplaceService")
local MemoryStoreService = game:GetService("MemoryStoreService")
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local TeleportService = game:GetService("TeleportService")
local NetworkClient = game:GetService("NetworkClient")
local UserInputService = game:GetService("UserInputService")
local Workspace = game:GetService("Workspace")

local Client = Players.LocalPlayer

library.title = "Break-Skill Hub - V1 | " .. MarketplaceService:GetProductInfo(game.PlaceId).Name
library.foldername = "Break-Skill Hub - V1"
library.fileext = ".txt"

local InvokeServer = Instance.new("RemoteFunction").InvokeServer

local FSYSModule = ReplicatedStorage.Fsys

repeat
    task.wait()
until table.find(getloadedmodules(), FSYSModule)

local FSYS = require(FSYSModule)

local function ReJoinServer()
    while (true) do
        TeleportService:TeleportToPlaceInstance(game.PlaceId, game.JobId)

        GuiService:ClearError()

        task.wait(5)
    end
end

task.spawn(function()
    while task.wait(1) do
        if (not NetworkClient:FindFirstChild("ClientReplicator")) then
            ReJoinServer()

            break
        end
    end
end)

local function Loader(name)
    local Cache = getupvalue(FSYS.load, 1)

    repeat
        task.wait()
    until typeof(Cache[name]) == "table"

    return Cache[name]
end

local RouterClient = Loader("RouterClient")
local InteriorsM = Loader("InteriorsM")
local ClientData = Loader("ClientData")
local UIManager = Loader("UIManager")
local ObbyList = Loader("ObbyDB")
local Door = Loader("Door")

local PetsDB = Loader("InventoryPetsSubDB").entries

local Inventory = ClientData.get("inventory")

repeat
    task.wait()
until ClientData.get("loaded_in")

local Remotes = getupvalue(getfenv(RouterClient.get).get_remote_from_cache, 1)

local DoorMT = getupvalue(Door.new, 1)

local OldEnter = DoorMT.enter

OldEnter = hookfunction(OldEnter, function(...)
    if (library.Flags.PetAutoFarm) then
        return
    end

    return OldEnter(...)
end)

library.OnLoad:Connect(function()
    if (not Client.Character) then
        Remotes["TeamAPI/ChooseTeam"]:InvokeServer(library.Flags.SwitchTeam)

        UIManager.set_app_visibility("MainMenuApp", false)
        UIManager.set_app_visibility("NewsApp", false)
    end
end)

local Funcs = {}

function Funcs.SetDataloss()
    InvokeServer(Remotes["RadioAPI/Add"], "\128", 123)

    Notification.Notify(
        "Break-Skill Hub - V1 | Script",
        "<b><font color=\"rgb(255, 30, 30)\">DataLoss set.</font></b> Anything after this point won\'t save.",
        "rbxassetid://7771536804",
        {
            Duration = 5,
            TitleSettings = {
                TextXAlignment = Enum.TextXAlignment.Left,
                Font = Enum.Font.SourceSansBold
            },
            GradientSettings = {
                GradientEnabled = false,
                SolidColorEnabled = true,
                Retract = true,
                SolidColor = Color3.fromRGB(255, 30, 30)
            }
        }
    )
end

function Funcs.UnSetDataLoss()
    InvokeServer(Remotes["RadioAPI/Remove"], 123)

    Notification.Notify(
        "Break-Skill Hub - V1 | Script",
        "<b><font color=\"rgb(255, 30, 30)\">DataLoss unset.</font></b>",
        "rbxassetid://7771536804",
        {
            Duration = 5,
            TitleSettings = {
                TextXAlignment = Enum.TextXAlignment.Left,
                Font = Enum.Font.SourceSansBold
            },
            GradientSettings = {
                GradientEnabled = false,
                SolidColorEnabled = true,
                Retract = true,
                SolidColor = Color3.fromRGB(255, 30, 30)
            }
        }
    )
end

local function TeleportTo(location, door, data)
    setthreadidentity(2)

    InteriorsM.enter(location, door, data)

    setthreadidentity(7)
end

local function GetFood(id)
    for _, v in next, Inventory.food do
        if not id or v.id == id then
            return v.unique
        end
    end
end

local function GetFurniture(name)
    for _, v in next, Workspace.HouseInteriors.furniture:GetChildren() do
        local Model = v:FindFirstChildOfClass("Model")

        local UseID = Model and Model:FindFirstChild("UseBlocks") and Model:FindFirstChildWhichIsA("StringValue", true)

        if UseID and UseID.Name == "use_id" and UseID.Value == name then
            return v:FindFirstChildWhichIsA("Model"):GetAttribute("furniture_unique")
        end
    end
end

local function IsInMainMap()
    return InteriorsM:get_current_location().destination_id == "MainMap"
end

local function IsInNursery()
    return InteriorsM:get_current_location().destination_id == "Nursery"
end

local PetsToFarm = {}

coroutine.wrap(function()
    while true do
        table.clear(PetsToFarm)

        Inventory = ClientData.get("inventory")

        if (not Inventory or not Inventory.pets) then
            task.wait()

            continue
        end

        for _, v in next, Inventory.pets do
            table.insert(PetsToFarm, v.id .. " | age: " .. tostring(v.properties.age))
        end

        task.wait(1)
    end
end)()

local CurrentPet

local Stores = {
    "CoffeeShop",
    "Supermarket",
    "PizzaPlace",
    "ToyShop",
    "Obbies",
    "Neighborhood",
    "CampingShop",
    "AutoShop",
    "Nursery",
    "Cave",
    "IceCream",
    "PotionShop",
    "SkyCastle",
    "Hospital",
    "HatShop",
    "PetShop",
    "School",
    "BabyShop",
    "HotSpringHouse",
    "SafetyHub",
    "DebugInterior"
}

local function OnAilmentAdded(ailment)
    if ailment:IsA("Frame") then
        Remotes["MonitorAPI/AddRate"]:InvokeServer(ailment.Name, 100)
    end
end

local WantedPets = {}

for _, v in next, PetsDB do
    if (v.rarity == "legendary" and not v.is_egg and not v.origin_entry.robux) then
        table.insert(WantedPets, v.name)
    end
end

table.sort(WantedPets, function(a, b)
    return a < b
end)

--//
--// Misc Tab
--//

local MiscTab = library:AddTab("Misc")

local Column1 = MiscTab:AddColumn()
local Column2 = MiscTab:AddColumn()

--// Auto Farm Section

local AutoFarmSection = Column1:AddSection("AutoFarm")

local PetFarm = AutoFarmSection:AddToggle({
    text = "Pet Farm",
    flag = "PetFarm"
})

local BabyFarm = AutoFarmSection:AddToggle({
    text = "Baby Farm",
    flag = "BabyFarm",
    callback = function(val)
        if val then
            for _, a in next, Client.PlayerGui.AilmentsMonitorApp.Ailments:GetChildren() do
                OnAilmentAdded(a)
            end
        end
    end
})

local AutoFarmSettings = AutoFarmSection:AddDivider("AutoFarm Settings")

local AutoPaycheck = AutoFarmSection:AddToggle({
    text = "Auto PayCheck",
    flag = "AutoPayCheck"
})

local FarmAllPets = AutoFarmSection:AddToggle({
    text = "Farm All Pets",
    flag = "FarmAllPets"
})

local FarmUntilFullGrown = AutoFarmSection:AddToggle({
    text = "Farm Until Full Grown",
    flag = "FarmUntilFullGrown"
})

local NoRendering = AutoFarmSection:AddToggle({
    text = "No Rendering",
    callback = function(val)
        RunService:Set3dRenderingEnabled(not val)
    end
})

local PetToFarm = AutoFarmSection:AddList({
    text = "Select pet",
    values = PetsToFarm,
    callback = function(val)
        for i, v in next, Inventory.pets do
            if v.id .. " | age: " .. tostring(v.properties.age) == val then
                CurrentPet = v
            end
        end
    end
})

local WantedPet = AutoFarmSection:AddList({
    text = "Wanted Pets",
    flag = "WantedPets",
    multiselect = true,
    values = WantedPets
})

local WebhookUrl = AutoFarmSection:AddBox({
    text = "Webhook URL",
    flag = "WebhookUrl"
})

--// Misc Section

local MiscSection = Column1:AddSection("Misc")

local CompleteAllObbies = MiscSection:AddButton({
    text = "Complete All Obbies",
    callback = function()
        for i in next, ObbyList do
            Remotes["MinigameAPI/FinishObby"]:FireServer(i)
        end
    end
})

local SetDataLoss = MiscSection:AddButton({
    text = "Set Dataloss",
    callback = Funcs.SetDataloss
})

local UnSetDataLoss = MiscSection:AddButton({
    text = "UnSet Dataloss",
    callback = Funcs.UnSetDataLoss
})

local MakePetsFlyable = MiscSection:AddButton({
    text = "Make pets flyable",
    callback = function()
        for _, v in next, Inventory.pets do
            v.properties.flyable = true
        end
    end
})

local MakePetsRideable = MiscSection:AddButton({
    text = "Make pets rideable",
    callback = function()
        for _, v in next, Inventory.pets do
            v.properties.rideable = true
        end
    end
})

local SwitchTeam = MiscSection:AddList({
    text = "Switch Team",
    noload = true,
    skipflag = true,
    values = {
        "Babies",
        "Parents"
    },
    callback = function(val)
        Remotes["TeamAPI/ChooseTeam"]:InvokeServer(val, true)
    end
})

--// Local Section

local LocalSection = Column2:AddSection("Local")

local WalkSpeed = LocalSection:AddSlider({
    text = "WalkSpeed",
    flag = "WalkSpeed",
    textpos = 2,
    min = 0,
    max = 200,
    default = 16
})

local JumpPower = LocalSection:AddSlider({
    text = "Jump Power",
    flag = "JumpPower",
    textpos = 2,
    min = 0,
    max = 200,
    default = 50
})

local Noclip = LocalSection:AddSlider({
    text = "Noclip",
    flag = "Noclip"
})

local TeleportToMainMap = LocalSection:AddButton({
    text = "Teleport to main map",
    callback = function()
        TeleportTo("MainMap", "Neighborhood/MainDoor", {})
    end
})

local TeleportToHome = LocalSection:AddButton({
    text = "Teleport to home",
    callback = function()
        TeleportTo("housing", "MainDoor", {
            ["house_owner"] = Client
        })
    end
})

local TeleportToStore = LocalSection:AddList({
    text = "Teleport to store",
    noload = true,
    skipflag = true,
    values = Stores,
    callback = function(val)
        if not IsInMainMap() then
            TeleportTo("MainMap", "Neighborhood/MainDoor", {})

            repeat
                task.wait()
            until IsInMainMap()
        end

        TeleportTo(val, "MainDoor", {})
    end
})

--XD

local function GetPetID()
    if not library.flags.FarmAllPets then
        return CurrentPet and CurrentPet.unique
    end

    local AllPets = {}

    for _, p in next, Inventory.pets do
        if (p.properties.age == 6) then
            continue
        end

        local IsEgg = PetsDB[p.id].is_egg

        if (IsEgg) then
            table.insert(AllPets, {
                properties = {
                    age = 0
                },
                id = p.id,
                unique = p.unique
            })

            continue
        end

        table.insert(AllPets, p)
    end

    if (library.flags.FarmUntilFullGrown) then
        table.sort(AllPets, function(a, b)
            return a.unique < b.unique
        end)

        return AllPets[1] and AllPets[1].unique
    end

    table.sort(AllPets, function(a, b)
        return a.properties.age < b.properties.age
    end)

    local LowestAge = AllPets[1] and AllPets[1].properties.age

    if (not LowestAge) then
        return
    end

    local SmallestAgePets = {}

    for _, p in next, AllPets do
        if (p.properties.age == LowestAge) then
            table.insert(SmallestAgePets, p)
        end
    end

    table.sort(SmallestAgePets, function(a, b)
        return a.unique < b.unique
    end)

    return SmallestAgePets[1].unique
end

local Actions = {
    Hungry = function(data)
        local Food = GetFood()

        if not Food then
            repeat
                Remotes["ShopAPI/BuyItem"]:InvokeServer("food", "apple", {})

                task.wait(1)
            until GetFood()
        end

        Food = GetFood()

        if not Food then
            return
        end

        Remotes["ToolAPI/Equip"]:InvokeServer(Food)

        Remotes["PetAPI/ConsumeFoodItem"]:FireServer(Food)

        local RanAt = tick()

        repeat
            task.wait()
        until data.progress == 1 or tick() - RanAt > 60
    end,
    PizzaParty = function(data)
        TeleportTo("PizzaShop", "MainDoor", {})

        local RanAt = tick()

        repeat
            task.wait()
        until data.progress == 1 or tick() - RanAt > 60
    end,
    PoolParty = function(data)
        TeleportTo("MainMap", "Neighborhood/MainDoor", {})

        local PoolSiteCF = Workspace:WaitForChild("StaticMap"):WaitForChild("Pool"):WaitForChild("PoolOrigin")

        local RanAt = tick()

        pcall(function()
            Client.Character:SetPrimaryPartCFrame(PoolSiteCF.CFrame * CFrame.new(0, 5, 0))
        end)

        repeat
            task.wait()
        until data.progress == 1 or tick() - RanAt > 60
    end,
    Salon = function(data)
        TeleportTo("Salon", "MainDoor", {})

        local RanAt = tick()

        repeat
            task.wait()
        until data.progress == 1 or tick() - RanAt > 60
    end,
    Dirty = function(data, pet)
        TeleportTo("housing", "MainDoor", {
            ["house_owner"] = Client
        })

        repeat
            task.wait()
        until GetFurniture("generic_shower")

        task.spawn(function()
            Remotes["HousingAPI/ActivateFurniture"]:InvokeServer(Client, GetFurniture("generic_shower"), "UseBlock", {
                ["cframe"] = Client.Character.PrimaryPart.CFrame
            }, pet)
        end)

        local RanAt = tick()

        repeat
            task.wait()
        until data.progress == 1 or tick() - RanAt > 60

        local PetID = GetPetID()

        Remotes["ToolAPI/Unequip"]:InvokeServer(PetID)
        Remotes["ToolAPI/Equip"]:InvokeServer(PetID)
    end,
    Sleepy = function(data, pet)
        repeat
            TeleportTo("housing", "MainDoor", {
                ["house_owner"] = Client
            })

            task.wait(1)
        until GetFurniture("generic_crib")

        task.spawn(function()
            Remotes["HousingAPI/ActivateFurniture"]:InvokeServer(Client, GetFurniture("generic_crib"), "UseBlock", {
                ["cframe"] = Client.Character.PrimaryPart.CFrame
            }, pet)
        end)

        local RanAt = tick()

        repeat
            task.wait()
        until data.progress == 1 or tick() - RanAt > 60

        local PetID = GetPetID()

        Remotes["ToolAPI/Unequip"]:InvokeServer(PetID)
        Remotes["ToolAPI/Equip"]:Inventory(PetID)
    end,
    Bored = function(data)
        TeleportTo("MainMap", "Neighborhood/MainDoor", {})

        local BoredAilmentTarget = Workspace:WaitForChild("StaticMap"):WaitForChild("Park"):WaitForChild("BoredAilmentTarget")

        local RanAt = tick()

        repeat
            pcall(function()
                Client.Character:SetPrimaryPartCFrame(BoredAilmentTarget.CFrame * CFrame.new(0, 5, 0))
            end)

            RunService.Heartbeat:Wait()
        until data.progress == 1 or tick() - RanAt > 60
    end,
    Thirsty = function(data, pet)
        repeat
            TeleportTo("Nursery", "MainDoor", {})

            task.wait(1)
        until IsInNursery()

        local RootPart = Client.Character and Client.Character:WaitForChild("HumanoidRootPart", 10)

        if (not RootPart) then
            return
        end

        task.wait(2)

        local RanAt = tick()

        repeat
            task.spawn(function()
                Remotes["HousingAPI/ActivateInteriorFurniture"]:InvokeServer("f-8", "UseBlock", {
                    cframe = RootPart.CFrame
                }, pet)
            end)

            task.wait(10)
        until data.progress == 1 or tick() - RanAt > 60

        local PetID = GetPetID()

        Remotes["ToolAPI/Unequip"]:InvokeServer(PetID)
        Remotes["ToolAPI/Equip"]:InvokeServer(PetID)

        task.wait(2)
    end,
    Sick = function(data)
        TeleportTo("Hospital", "MainDoor", {})

        local RanAt = tick()

        repeat
            Remotes["MonitorAPI/HealWithDoctor"]:FireServer()

            task.wait(1)
        until data.progress == 1 or tick() - RanAt > 60
    end,
    AdoptionParty = function(data)
        TeleportTo("Nursury", "MainDoor", {})

        local RanAt = tick()

        repeat
            task.wait()
        until data.progress == 1 or tick() - RanAt > 60
    end,
    School = function(data)
        TeleportTo("School", "MainDoor", {})

        local RanAt = tick()

        repeat
            task.wait()
        until data.progress == 1 or tick() - RanAt > 60
    end,
    HotSpring = function(data)
        TeleportTo("MainMap", "Neighborhood/MainDoor", {})

        local HotSpringCF = Workspace:WaitForChild("StaticMap"):WaitForChild("HotSpring"):WaitForChild("HotSpringOrigin")

        local RanAt = tick()

        pcall(function()
            Client.Character:SetPrimaryPartCFrame(HotSpringCF.CFrame * CFrame.new(0, 5, 0))
        end)

        repeat
            task.wait()
        until data.progress == 1 or tick() - RanAt > 60
    end,
    Camping = function(data)
        TeleportTo("MainMap", "Neighborhood/MainDoor", {})

        local CampSiteCF = Workspace:WaitForChild("StaticMap"):WaitForChild("Campsite"):WaitForChild("CampsiteOrigin")

        local RanAt = tick()

        pcall(function()
            Client.Character:SetPrimaryPartCFrame(CampSiteCF.CFrame * CFrame.new(0, 5, 0))
        end)

        repeat
            task.wait()
        until data.progress == 1 or tick() - RanAt > 60
    end
}

local function CalculateNeeded(ailments, percentage)
    return math.ceil(ailments / percentage)
end

coroutine.wrap(function()
    while task.wait(1) do
        if (not library.flags.PetFarm) then
            continue
        end

        Inventory = ClientData.get("inventory")

        local PetCharWrapper = ClientData.get("pet_char_wrapper")
        local EquipManager = ClientData.get("equip_manager")

        local AutoDataLoss = library.flags.AutoDataLoss

        if (not EquipManager) then
            continue
        end

        local PetID = GetPetID()

        local CurrentEquippedPet = EquipManager.pets

        if not CurrentEquippedPet or CurrentEquippedPet.unique ~= PetID or not PetCharWrapper then
            Remotes["ToolAPI/Unequip"]:InvokeServer(PetID)
            Remotes["ToolAPI/Equip"]:InvokeServer(PetID)
        end

        CurrentEquippedPet = EquipManager.pets

        if (not CurrentEquippedPet or not CurrentEquippedPet.properties) then
            continue
        end

        local AilmentsCompleted = CurrentEquippedPet.properties.ailments_completed

        if (not AilmentsCompleted) then
            continue
        end

        if (not PetCharWrapper or not PetCharWrapper.ailments_monitor or not PetCharWrapper.ailments_monitor.ailments) then
            continue
        end

        local Percentage = PetCharWrapper.pet_progression.percentage

        if (not Percentage) then
            continue
        end

        local WillHatch = CalculateNeeded(AilmentsCompleted, Percentage) - 1 == AilmentsCompleted

        local IsEgg = PetsDB[CurrentEquippedPet.id].is_egg

        if (IsEgg and AilmentsCompleted > 0 and WillHatch and not MemoryStoreService:HasItem(PetID) and AutoDataLoss) then
            MemoryStoreService:SetItem(PetID, "true")

            ReJoinServer()

            continue
        end

        local function GetAllAilments(noMT)
            local Ailments = {}

            for _, ad in next, UIManager.apps.AilmentsMonitorApp.ailments_data do
                for _, p in next, ad.props.babies do
                    if (not p.is_pet) then
                        continue
                    end

                    if (noMT) then
                        table.insert(Ailments, p)

                        continue
                    end

                    p = table.clone(p)

                    p.progress = nil

                    setmetatable(p, {
                        __index = function(self, p1)
                            if (p1 == "progress") then
                                for _, a in next, GetAllAilments(true) do
                                    if (a.unique == p.unique) then
                                        return a.progress
                                    end
                                end

                                return 1
                            end

                            return rawget(self, p1)
                        end
                    })

                    table.insert(Ailments, p)
                end
            end

            return Ailments
        end

        local Ailments = GetAllAilments()

        local function GetAilment()
            for _, v in next, Ailments do
                if (v.id == "sleepy") then
                    return v
                end
            end

            return Ailments[1]
        end

        local Ailment = GetAilment()

        if (not Ailment) then
            continue
        end

        if (not Actions[Ailment.id]) then
            continue
        end

        if (WillHatch and AutoDataLoss) then
            Funcs.SetDataloss()

            task.spawn(function()
                local _, pet = Remotes["PetAPI/OwnedEggHatched"].OnClientEvent:Wait()

                if (library.flags.WantedPets[pet.name]) then
                    Webhook.new(library.flags.WebhookUrl):Send(string.format("You got a %s %s", pet.rarity, pet.name), true)

                    Funcs.UnSetDataLoss()
                else
                    Webhook.new(library.flags.WebhookUrl):Send(string.format("You got a unwanted %s %s", pet.rarity, pet.name), true)
                end

                task.wait(1)

                ReJoinServer()
            end)
        end

        Actions[Ailment.id](Ailment, PetCharWrapper.char)

        task.wait(2.5)

        if (WillHatch and AutoDataLoss) then
            return
        end
    end
end)()

Client.PlayerGui.AilmentsMonitorApp.Ailments.ChildAdded:Connect(function(ailment)
    if library.flags.BabyFarm then
        OnAilmentAdded(ailment)
    end
end)

coroutine.wrap(function()
    while task.wait(1) do
        if library.flags.AutoPayCheck then
            Remotes["PayAPI/CashOut"]:InvokeServer()
        end
    end
end)()

UserInputService.JumpRequest:Connect(function()
    if library.flags.InfiniteJump and Client.Character and Client.Character:FindFirstChild("Humanoid") then
        Client.Character.Humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
    end
end)

RunService.Stepped:Connect(function()
    if Client.Character and Client.Character:FindFirstChild("Humanoid") and Client.Character:FindFirstChild("HumanoidRootPart") then
        Client.Character.Humanoid.WalkSpeed = library.flags.WalkSpeed
        Client.Character.Humanoid.JumpPower = library.flags.JumpPower

        if (not library.flags.Noclip or library.flags.PetFarm) then
            return
        end

        for _, v in next, Client.Character:GetChildren() do
            if v:IsA("BasePart") then
                v.CanCollide = false
            end
        end
    end
end)
