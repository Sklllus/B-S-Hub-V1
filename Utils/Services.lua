--//
--// Services Made By xS_Killus
--//

SX_VM_CNONE()

local Services = {}

local GVIM = getvirtualinputmanager and getvirtualinputmanager()

function Services:Get(...)
    local AllServices = {}

    for _, s in next, {
        ...
    } do
        table.insert(AllServices, self[s])
    end

    return unpack(AllServices)
end

setmetatable(Services, {
    __index = function(self, p)
        if (p == "VirtualInputManager" and GVIM) then
            return GVIM
        end

        local Service = game:GetService(p)

        if (p == "VirtualInputManager") then
            Services.Name = GetServerConstant("VirtualInputManager")
        end

        rawset(self, p, Service)

        return rawget(self, p)
    end
})

return Services
