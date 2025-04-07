local RunService = game:GetService("RunService")
local Signal = require(script.Parent.Signal)

local Noop = function() end

local BaseMotor = {}

BaseMotor.__index = BaseMotor

function BaseMotor.new()
    return setmetatable({
        _OnStep = Signal.new(),
        _OnStart = Signal.new(),
        _OnComplete = Signal.new()
    }, BaseMotor)
end

function BaseMotor:OnStep(handler)
    return self._OnStep:Connect(handler)
end

function BaseMotor:OnStart(handler)
    return self._OnStart:Connect(handler)
end

function BaseMotor:OnComplete(handler)
    return self._OnComplete:Connect(handler)
end

function BaseMotor:Start()
    if not self._Connection then
        self._Connection = RunService.RenderStepped:Connect(function(deltaTime)
            self:Step(deltaTime)
        end)
    end
end

function BaseMotor:Stop()
    if self._Connection then
        self._Connection:Disconnect()

        self._Connection = nil
    end
end

BaseMotor.Destroy = BaseMotor.Stop
BaseMotor.Step = Noop
BaseMotor.GetValue = Noop
BaseMotor.SetGoal = Noop

function BaseMotor:__tostring()
    return "Motor"
end

return BaseMotor
