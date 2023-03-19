--[
--Signal Made By xS_Killus
--]

--Instances And Functions

local HttpService = game:GetService("HttpService")

local EnableTraceback = false

local Signal = {}

Signal.__index = Signal
Signal.ClassName = "Signal"

--[
--Signal Functions
--]

--IsSignal

function Signal.IsSignal(val)
    return type(val) == "table" and getmetatable(val) == Signal
end

--new

function Signal.new()
    local self = setmetatable({}, Signal)

    self._BindableEvent = Instance.new("BindableEvent")
    self._ArgMap = {}
    self._Source = EnableTraceback and debug.traceback() or ""

    self._BindableEvent.Event:Connect(function(key)
        self._ArgMap[key] = nil

        if (not self._BindableEvent) and (not next(self._ArgMap)) then
            self._ArgMap = nil
        end
    end)

    return self
end

--[
--Fire
--]

function Signal:Fire(...)
    if not self._BindableEvent then
        warn(("Break-Skill Hub - V1 | Signal is already destroyed. %s"):format(self._Source))

        return
    end

    local Args = table.pack(...)

    local Key = HttpService:GenerateGUID(false)

    self._ArgMap[Key] = Args

    self._BindableEvent:Fire(Key)
end

--[
--Connect
--]

function Signal:Connect(handler)
    if not (type(handler) == "function") then
        error(("Break-Skill Hub - V1 | Connect(%s)"):format(typeof(handler)), 2)
    end

    return self._BindableEvent.Event:Connect(function(key)
        local Args = self._ArgMap[key]

        if Args then
            handler(table.unpack(Args, 1, Args.n))
        else
            error("Break-Skill Hub - V1 | Missing argument data, probably due to reentrance.")
        end
    end)
end

--[
--Once
--]

function Signal:Once(handler)
    if not (type(handler) == "function") then
        error(("Break-Skill Hub - V1 | Once(%s)"):format(typeof(handler)), 2)
    end

    return self._BindableEvent.Event:Once(function(key)
        local Args = self._ArgMap[key]

        if Args then
            handler(table.unpack(Args, 1, Args.n))
        else
            error("Break-Skill Hub - V1 | Missing argument data, probably due to reentrance.")
        end
    end)
end

--[
--Wait
--]

function Signal:Wait()
    local Key = self._BindableEvent.Event:Wait()

    local Args = self._ArgMap[Key]

    if Args then
        return table.unpack(Args, 1, Args.n)
    else
        error("Break-Skill Hub - V1 | Missing argument data, probably due to reentrance.")

        return nil
    end
end

--[
--Destroy
--]

function Signal:Destroy()
    if self._BindableEvent then
        self._BindableEvent:Destroy()

        self._BindableEvent = nil
    end

    setmetatable(self, nil)
end

return Signal
