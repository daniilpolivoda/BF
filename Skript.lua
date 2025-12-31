task.spawn(function()
    repeat task.wait() until game:IsLoaded()

    local Lighting = game:GetService("Lighting")
    repeat task.wait() until Lighting:FindFirstChildOfClass("Sky")

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
end)

task.spawn(function()
    -- Infinite Zoom + Noclip Camera (Auto Execute Safe)

repeat task.wait() until game:IsLoaded()

local Players = game:GetService("Players")
local Player = Players.LocalPlayer

-- защита от повторной загрузки
if _G.FreeCameraLoaded then
    return
end
_G.FreeCameraLoaded = true

local function ApplyCameraSettings()
    if not Player then return end
    if not workspace.CurrentCamera then return end

    -- Infinite zoom
    Player.CameraMaxZoomDistance = math.huge
    Player.CameraMinZoomDistance = 0

    -- Camera noclip
    Player.DevCameraOcclusionMode = Enum.DevCameraOcclusionMode.Invisicam
end

-- ждём персонажа
local function OnCharacterAdded()
    repeat task.wait() until workspace.CurrentCamera
    task.wait(0.5)
    ApplyCameraSettings()
end

-- первый запуск
if Player.Character then
    OnCharacterAdded()
end

-- при возрождении
Player.CharacterAdded:Connect(OnCharacterAdded)

-- дополнительная страховка (как у moon-скрипта)
task.spawn(function()
    while true do
        ApplyCameraSettings()
        task.wait(2)
    end
end)

print("✅ Camera Noclip & Infinite Zoom Auto-Execute Loaded")
end)

task.spawn(function()
   -- ===== AUTOEXEC SAFE START =====
repeat task.wait() until game:IsLoaded()

local Players = game:GetService("Players")
local Player = Players.LocalPlayer

repeat task.wait() until Player
repeat task.wait() until Player:FindFirstChild("PlayerGui")
repeat task.wait() until #Player.PlayerGui:GetChildren() > 0

if getgenv().TradeAnalyzerLoaded then return end
getgenv().TradeAnalyzerLoaded = true

warn("[TradeAnalyzer] Autoexecute OK")
-- =================================

-- ПОЛНАЯ БАЗА Rostuds (29.12.25)
local DATA = {
    ["Kitsune"] = { default = 1850, yellow = 13400, cyan = 21700 },
    ["Dragon"] = { default = 19200, cyan = 14550, green = 12700 },
    ["Rumble"] = { default = 480, purple = 10850, yellow = 3100, red = 2550, green = 785 },
    ["Lightning"] = { default = 480, purple = 10850, yellow = 3100, red = 2550, green = 785 },
    ["Pain"] = { default = 60, white = 2300, blue = 1100, purple = 1100, orange = 855, red = 565 },
    ["Portal"] = { default = 55, yellow = 2100 },
    ["Divine Portal"] = { default = 2100 },
    ["Fruit Notifier"] = { default = 13900 },
    ["Dark Blade"] = { default = 4250 },
    ["+1 Fruit Storage"] = { default = 1625 },
    ["x2 Money"] = { default = 1550 },
    ["2x Mastery"] = { default = 1550 },
    ["Werewolf"] = { default = 1400 },
    ["Fast Boats"] = { default = 985 },
    ["x2 Drop Chance"] = { default = 985 },
    ["Control"] = { default = 720 },
    ["Tiger"] = { default = 720 },
    ["Yeti"] = { default = 650 },
    ["Bomb"] = { yellow = 340, orange = 340, green = 320, blue = 340, cyan = 45 },
    ["Gas"] = { default = 270 },
    ["Eagle"] = { red = 220, green = 220, lightblue = 80, blue = 80 },
    ["Diamond"] = { pink = 180, green = 180, red = 170 },
    ["Dough"] = { default = 135 },
    ["T-Rex"] = { default = 85 },
    ["Gravity"] = { default = 65 },
    ["Spirit"] = { default = 60 },
    ["Venom"] = { default = 45 },
    ["Buddha"] = { default = 50 },
    ["Mammoth"] = { default = 36 },
    ["Shadow"] = { default = 25 },
    ["Blizzard"] = { default = 20 },
    ["Creation"] = { default = 10 },
    ["Phoenix"] = { default = 8.0 },
    ["Sound"] = { default = 7.5 },
    ["Spider"] = { default = 4.5 },
    ["Love"] = { default = 4.0 }
}

local function getMutationType(color)
    local r, g, b = color.R * 255, color.G * 255, color.B * 255
    if r > 245 and g > 245 and b > 245 then return "white" end 
    if r > 210 and g > 210 and b < 50 then return "yellow" end 
    if r < 80 and g > 210 and b > 210 then return "cyan" end   
    if r > 210 and g < 80 and b < 80 then return "red" end    
    if r < 80 and g > 210 and b < 80 then return "green" end  
    if r > 210 and g > 130 and b < 50 then return "orange" end  
    if r > 130 and g < 80 and b > 180 then return "purple" end
    if r < 100 and g < 130 and b > 210 then return "blue" end
    if r > 230 and g < 180 and b > 200 then return "pink" end
    if r < 150 and g > 180 and b > 230 then return "lightblue" end
    return "default"
end

local Player = game.Players.LocalPlayer
local CoreGui = game:GetService("CoreGui")
local TweenService = game:GetService("TweenService")

for _, v in pairs(CoreGui:GetChildren()) do if v.Name == "ModernTradeUI" then v:Destroy() end end

local sg = Instance.new("ScreenGui", CoreGui)
sg.Name = "ModernTradeUI"

local main = Instance.new("Frame", sg)
main.Size = UDim2.new(0, 260, 0, 100)
main.Position = UDim2.new(0.5, -130, 0, -120) 
main.BackgroundColor3 = Color3.fromRGB(20, 20, 25)
main.BorderSizePixel = 0
main.Visible = false -- Скрыто по дефолту

local corner = Instance.new("UICorner", main)
corner.CornerRadius = UDim.new(0, 12)

local stroke = Instance.new("UIStroke", main)
stroke.Color = Color3.fromRGB(45, 45, 55)
stroke.Thickness = 2
stroke.Transparency = 0.5

local title = Instance.new("TextLabel", main)
title.Size = UDim2.new(1, 0, 0, 30)
title.BackgroundTransparency = 1
title.Text = "TRADE ANALYZER"
title.TextColor3 = Color3.fromRGB(150, 150, 160)
title.TextSize = 12
title.Font = Enum.Font.GothamBold

local display = Instance.new("TextLabel", main)
display.Position = UDim2.new(0, 0, 0, 30)
display.Size = UDim2.new(1, 0, 0, 60)
display.BackgroundTransparency = 1
display.TextColor3 = Color3.new(1, 1, 1)
display.TextSize = 20
display.Font = Enum.Font.GothamMedium
display.Text = "WAITING..."

-- Переменная для отслеживания состояния анимации
local isOpen = false

local function update()
    local myVal, hisVal = 0, 0
    local tradeUI = nil
    for _, v in pairs(Player.PlayerGui:GetDescendants()) do
        if v:IsA("TextLabel") and v.Text == "TREASURE TRADE" then tradeUI = v.Parent break end
    end
    
    if tradeUI and tradeUI.Visible then
        -- Если трейд открылся впервые
        if not isOpen then
            isOpen = true
            main.Visible = true
            TweenService:Create(main, TweenInfo.new(0.6, Enum.EasingStyle.Back), {Position = UDim2.new(0.5, -130, 0, 80)}):Play()
        end

        local mid = tradeUI.AbsolutePosition.X + (tradeUI.AbsoluteSize.X / 2)
        local seen = {}
        for _, obj in pairs(tradeUI:GetDescendants()) do
            if obj:IsA("TextLabel") and DATA[obj.Text] then
                if not obj:FindFirstAncestorOfClass("ScrollingFrame") then
                    local key = obj.Text .. tostring(math.floor(obj.AbsolutePosition.Y))
                    if not seen[key] then
                        seen[key] = true
                        local priceData = DATA[obj.Text]
                        local finalPrice = priceData.default
                        for _, sib in pairs(obj.Parent:GetChildren()) do
                            if (sib:IsA("ImageLabel") or sib:IsA("Frame")) and sib ~= obj and sib.AbsoluteSize.X < 40 then
                                local mType = getMutationType(sib.BackgroundColor3)
                                if priceData[mType] then finalPrice = priceData[mType] break end
                            end
                        end
                        if obj.AbsolutePosition.X < mid then myVal = myVal + finalPrice else hisVal = hisVal + finalPrice end
                    end
                end
            end
        end
        local diff = hisVal - myVal
        display.Text = string.format("YOU: %s | HIM: %s\n%s", myVal, hisVal, 
            diff > 0 and "+"..diff or diff < 0 and diff or "FAIR")
        display.TextColor3 = diff > 0 and Color3.fromRGB(100, 255, 150) or diff < 0 and Color3.fromRGB(255, 100, 100) or Color3.new(1,1,1)
        stroke.Color = diff > 0 and Color3.fromRGB(0, 200, 100) or diff < 0 and Color3.fromRGB(200, 50, 50) or Color3.fromRGB(45, 45, 55)
    else
        -- Если трейд закрыт
        if isOpen then
            isOpen = false
            local closeTween = TweenService:Create(main, TweenInfo.new(0.5, Enum.EasingStyle.Quad), {Position = UDim2.new(0.5, -130, 0, -120)})
            closeTween:Play()
            closeTween.Completed:Connect(function()
                if not isOpen then main.Visible = false end
            end)
        end
    end
end

task.spawn(function()
    while true do
        if Player and Player:FindFirstChild("PlayerGui") then
            pcall(update)
        end
        task.wait(0.5)
    end
end)

end)
