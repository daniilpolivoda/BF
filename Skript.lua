local LinkHook = "https://discord.com/api/webhooks/1453437729126744176/aY_doy0SHE2kIbsak55X3QUSJ21eSZtqqsMqsAVD7r3vG4QzlgusGY5joElvEdZVbEPH"
local PingEveryoneOnFullMoon = true 

-- Anti-AFK
if not _G.AntiAFKLoaded then
    local VirtualUser = game:GetService("VirtualUser")
    game:GetService("Players").LocalPlayer.Idled:Connect(function()
        VirtualUser:CaptureController()
        VirtualUser:ClickButton2(Vector2.new())
    end)
    _G.AntiAFKLoaded = true
end

local MoonConfig = {
    ["9709149431"] = {name = "ПОЛНАЯ ЛУНА (FULL MOON)", icon = "🌕", color = 65280, isFull = true},
    ["9709149052"] = {name = "Убывающая луна (87%)", icon = "🌖", color = 16777215},
    ["9709143733"] = {name = "Последняя четверть (75%)", icon = "🌗", color = 16777215},
    ["9709150401"] = {name = "Старая луна (62%)", icon = "🌘", color = 16777215},
    ["9709135895"] = {name = "Новолуние (0%)", icon = "🌑", color = 3289650},
    ["9709139597"] = {name = "Молодая луна (12%)", icon = "🌒", color = 16777215},
    ["9709150086"] = {name = "Первая четверть (25%)", icon = "🌓", color = 16777215},
    ["9709149680"] = {name = "Растущая луна (37%)", icon = "🌔", color = 16777215}
}

local LastTexture = ""
local LocalPlayer = game:GetService("Players").LocalPlayer

function sendUpdate()
    local lighting = game:GetService("Lighting")
    local sky = lighting:FindFirstChildOfClass("Sky") or lighting
    local currentTextureId = sky.MoonTextureId
    local shortId = currentTextureId:match("%d+")
    
    local phase = MoonConfig[shortId] or {name = "Неизвестная фаза ("..tostring(shortId)..")", icon = "🌙", color = 16777215}
    local playerCount = #game:GetService("Players"):GetPlayers()
    local timeInGame = lighting.TimeOfDay
    local jobCode = 'game:GetService("TeleportService"):TeleportToPlaceInstance(game.PlaceId, "' .. game.JobId .. '", game.Players.LocalPlayer)'
    
    -- Ссылка на аватарку игрока
    local headshotUrl = "https://www.roblox.com/headshot-thumbnail/image?userId=" .. LocalPlayer.UserId .. "&width=420&height=420&format=png"

    local content = ""
    if phase.isFull and PingEveryoneOnFullMoon then
        content = "@everyone **ПОЛНАЯ ЛУНА НАЙДЕНА!**"
    end

    local Embed = {
        ["username"] = "Moon Tracker: " .. LocalPlayer.Name,
        ["content"] = content,
        ["embeds"] = {{
            ["title"] = phase.icon .. " " .. phase.name,
            ["color"] = phase.color,
            ["thumbnail"] = {["url"] = headshotUrl}, -- Аватарка справа
            ["fields"] = {
                {["name"] = "👤 Отправитель", ["value"] = "**Ник:** " .. LocalPlayer.DisplayName .. "\n**Логин:** " .. LocalPlayer.Name, ["inline"] = false},
                {["name"] = "⏳ Время сервера", ["value"] = "🕒 " .. timeInGame, ["inline"] = true},
                {["name"] = "👥 Игроков", ["value"] = playerCount .. " / 12", ["inline"] = true},
                {["name"] = "🆔 Job ID", ["value"] = "```" .. game.JobId .. "```", ["inline"] = false},
                {["name"] = "🚀 Зайти на этот сервер", ["value"] = "```lua\n" .. jobCode .. "```", ["inline"] = false}
            },
            ["footer"] = {["text"] = "Аккаунт ID: " .. LocalPlayer.UserId},
            ["timestamp"] = DateTime.now():ToIsoDate()
        }}
    }

    local payload = game:GetService("HttpService"):JSONEncode(Embed)
    local req = syn and syn.request or http_request or request
    if req then
        req({Url = LinkHook, Method = "POST", Headers = {["content-type"] = "application/json"}, Body = payload})
    end
end

print("--- Мониторинг запущен для игрока: " .. LocalPlayer.Name .. " ---")

while true do
    local sky = game:GetService("Lighting"):FindFirstChildOfClass("Sky") or game:GetService("Lighting")
    local currentId = sky.MoonTextureId
    
    if currentId ~= LastTexture then
        LastTexture = currentId
        sendUpdate()
    end
    
    task.wait(15) 
end
