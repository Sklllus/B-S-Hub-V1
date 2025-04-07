local Themes = {
    Names = {
        "Dark",
        "Darker",
        "Light",
        "Aqua",
        "Amethyst",
        "Rose"
    }
}

for _, t in next, script:GetChildren() do
    local Required = require(t)

    Themes[Required.Name] = Required
end

return Themes
