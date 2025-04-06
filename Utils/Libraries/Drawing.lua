if not get_comm_channel or not create_comm_channel then
    return "1"
end

local cloneref = cloneref or function (obj)
    return obj
end

local RunService = cloneref(game:GetService("RunService"))
local HttpService = cloneref(game:GetService("HttpService"))

local IsActor = ...

local ID, commchannel

if IsActor then
    ID, commchannel = IsActor, get_comm_channel(IsActor)
else
    ID, commchannel = create_comm_channel()
end

local DrawingRefs, Queued, Thread = {}, {}

IsActor = IsActor and true or false

local Classes = {
    Base = {
        "Visible",
        "ZIndex",
        "Transparency",
        "Color"
    },
    Line = {
        "Thickness",
        "From",
        "To"
    },
    Text = {
        "Text",
        "Size",
        "Center",
        "Outline",
        "OutlineColor",
        "Position",
        "TextBounds",
        "Font"
    },
    Image = {
        "Data",
        "Size",
        "Position",
        "Rounding"
    },
    Circle = {
        "Thickness",
        "NumSides",
        "Radius",
        "Filled",
        "Position"
    },
    Square = {
        "Thickness",
        "Size",
        "Position",
        "Filled"
    },
    Quad = {
        "Thickness",
        "PointA",
        "PointB",
        "PointC",
        "PointD",
        "Filled"
    },
    Triangle = {
        "Thickness",
        "PointA",
        "PointB",
        "PointC",
        "Filled"
    }
}

commchannel.Event:Connect(function(...)
    local Actor, Key = ...

    local Args = {
        select(3, ...)
    }

    if IsActor and Actor then
        if Key == "New" then
            local Proxy = newproxy(true)
            local Meta = getmetatable(Proxy)

            local RealObj = {
                Changed = {}
            }

            function RealObj:Remove()
                commchannel:Fire(false, "Remove", Args[2])

                DrawingRefs[Args[2]] = nil
            end

            Meta.__index = RealObj

            Meta.__newindex = function(_, ind, val)
                rawset(RealObj.Changed, ind, val)

                return rawset(RealObj, ind, val)
            end

            for i, v in Args[1] do
                rawset(RealObj, i, v)
            end

            DrawingRefs[Args[2]] = Proxy
            Queued[Args[3]] = Proxy
        elseif Key == "Update" then
            for i, v in Args[1] do
                local Obj = DrawingRefs[i]

                if Obj then
                    for pn, p in v do
                        rawset(Obj, pn, p)
                    end
                end
            end
        end
    else
        if Key == "New" then
            local Obj = Drawing.New(Args[1])

            local Ref = HttpService:GenerateGUID():sub(1, 6)

            local Props = {}

            for _, v in Classes.Base do
                Props[v] = Obj[v]
            end

            for _, v in Classes[Args[1]] do
                Props[v] = Obj[v]
            end

            DrawingRefs[Ref] = Obj

            commchannel:Fire(true, "New", Props, Ref, Args[2])
        elseif Key == "Update" then
            for i, v in Args[1] do
                local Obj = DrawingRefs[i]

                if Obj then
                    for pn, p in v do
                        Obj[pn] = p
                    end
                end
            end
        elseif Key == "Remove" then
            local Obj = DrawingRefs[Args[1]]

            if Obj then
                pcall(function()
                    Obj:Remove()
                end)

                DrawingRefs[Args[1]] = nil
            end
        end
    end
end)

if IsActor and not Drawing then
    Thread = task.spawn(function()
        repeat
            local Changed, Set = {}

            for i, v in DrawingRefs do
                for pn, p in v.Changed do
                    if not Changed[i] then
                        Changed[i] = {}

                        Set = true
                    end

                    rawset(Changed[i], pn, p)
                end

                if Changed[i] then
                    table.clear(v.Changed)
                end
            end

            if Set then
                commchannel:Fire(false, "Update", Changed)
            end

            RunService.RenderStepped:Wait()
        until false
    end)

    getgenv().Drawing = {
        New = function(objType)
            local NewID = HttpService:GenerateGUID(true):sub(1, 6)

            commchannel:Fire(false, "New", objType, NewID)

            repeat
                task.wait()
            until Queued[NewID]

            local Obj = Queued[NewID]

            Queued[NewID] = nil

            return Obj
        end,
        Kill = function()
            task.cancel(Thread)

            for _, v in DrawingRefs do
                pcall(function()
                    v:Remove()
                end)
            end

            table.clear(DrawingRefs)
        end
    }
else
    return ID
end
