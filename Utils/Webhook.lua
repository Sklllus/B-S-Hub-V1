--//
--// Webhook Made By xS_Killus
--//

local HttpService = game:GetService("HttpService")

local Webhook = {}

Webhook.__index = Webhook

function Webhook.new(url)
    local self = setmetatable({}, Webhook)

    self._url = url

    return self
end

function Webhook:Send(data, yields)
    if (typeof(data) == "string") then
        data = {
            Content = data
        }
    end

    local function Send()
        request({
            Url = self._url,
            Method = "POST",
            Headers = {
                ["Content-Type"] = "application/json"
            },
            Body = HttpService:JSONEncode(data)
        })
    end

    if (yields) then
        pcall(Send)
    else
        task.spawn(Send)
    end
end

return Webhook
