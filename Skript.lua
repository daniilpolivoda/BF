-- =================================================================
-- ОБЪЕДИНЕННЫЙ СКРИПТ (MOON TRACKER + CAMERA + TRADE ANALYZER)
-- =================================================================

-- 1. СКРИПТ: MOON TRACKER (УВЕДОМЛЕНИЯ В DISCORD)
task.spawn(function()
    repeat task.wait() until game:IsLoaded()
    
    local Players = game:GetService("Players")
    local LocalPlayer = Players.LocalPlayer
    
    if not LocalPlayer:FindFirstChild("PlayerGui") then
        repeat task.wait() until LocalPlayer:FindFirstChild("PlayerGui")
    end

    if getgenv().MoonTrackerLoaded then return end
    getgenv().MoonTrackerLoaded = true

    local LinkHook = "https://discord.com/api/webhooks/1453437729126744176/aY_doy0SHE2kIbsak55X3QUSJ21eSZtqqsMqsAVD7r3vG4QzlgusGY5joElvEdZVbEPH"
    local LastTexture = ""

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

    local function sendUpdate()
        local lighting = game:GetService("Lighting")
        local sky = lighting:FindFirstChildOfClass("Sky")
        local currentTextureId = sky and sky.MoonTextureId or ""
        local shortId = currentTextureId:match("%d+")
        
        if not shortId then return end
        local phase = MoonConfig[shortId] or {name = "Фаза "..shortId, icon = "🌙", color = 16777215}

        local Embed = {
            ["username"] = "Moon Tracker: " .. LocalPlayer.Name,
            ["content"] = phase.isFull and "@everyone **ПОЛНАЯ ЛУНА НАЙДЕНА!**" or "",
            ["embeds"] = {{
                ["title"] = phase.icon .. " " .. phase.name,
                ["color"] = phase.color,
                ["fields"] = {
                    {["name"] = "👤 Игрок", ["value"] = LocalPlayer.Name, ["inline"] = true},
                    {["name"] = "⏳ Время", ["value"] = lighting.TimeOfDay, ["inline"] = true},
                    {["name"] = "🆔 Job ID", ["value"] = "```" .. game.JobId .. "```", ["inline"] = false}
                },
                ["timestamp"] = DateTime.now():ToIsoDate()
            }}
        }

        local requestFunc = syn and syn.request or http_request or request
        if requestFunc then
            pcall(function()
                requestFunc({
                    Url = LinkHook,
                    Method = "POST",
                    Headers = {["Content-Type"] = "application/json"},
                    Body = game:GetService("HttpService"):JSONEncode(Embed)
                })
            end)
        end
    end

    while task.wait(15) do
        local sky = game:GetService("Lighting"):FindFirstChildOfClass("Sky")
        if sky and sky.MoonTextureId ~= LastTexture then
            LastTexture = sky.MoonTextureId
            sendUpdate()
        end
    end
end)

-- 2. СКРИПТ: CAMERA NOCLIP & INFINITE ZOOM
task.spawn(function()
    repeat task.wait() until game:IsLoaded()
    if _G.FreeCameraLoaded then return end
    _G.FreeCameraLoaded = true

    local Player = game:GetService("Players").LocalPlayer
    local function Apply()
        pcall(function()
            Player.CameraMaxZoomDistance = math.huge
            Player.CameraMinZoomDistance = 0
            Player.DevCameraOcclusionMode = Enum.DevCameraOcclusionMode.Invisicam
        end)
    end
    Player.CharacterAdded:Connect(Apply)
    if Player.Character then Apply() end
    while task.wait(5) do Apply() end
end)

-- 3. СКРИПТ: TRADE ANALYZER
task.spawn(function()
    repeat task.wait() until game:IsLoaded()
    local Players = game:GetService("Players")
    local Player = Players.LocalPlayer
    repeat task.wait() until Player and Player:FindFirstChild("PlayerGui")

    if getgenv().TradeAnalyzerLoaded then return end
    getgenv().TradeAnalyzerLoaded = true

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
    main.Visible = false
    Instance.new("UICorner", main).CornerRadius = UDim.new(0, 12)
    local stroke = Instance.new("UIStroke", main)
    stroke.Color = Color3.fromRGB(45, 45, 55)
    stroke.Thickness = 2

    local display = Instance.new("TextLabel", main)
    display.Size = UDim2.new(1, 0, 1, 0)
    display.BackgroundTransparency = 1
    display.TextColor3 = Color3.new(1, 1, 1)
    display.TextSize = 16
    display.Font = Enum.Font.GothamMedium
    display.Text = "WAITING FOR TRADE..."

    local isOpen = false

    local function update()
        local myVal, hisVal = 0, 0
        local tradeUI = nil
        for _, v in pairs(Player.PlayerGui:GetDescendants()) do
            if v:IsA("TextLabel") and v.Text == "TREASURE TRADE" then tradeUI = v.Parent break end
        end
        
        if tradeUI and tradeUI.Visible then
            if not isOpen then
                isOpen = true
                main.Visible = true
                TweenService:Create(main, TweenInfo.new(0.6, Enum.EasingStyle.Back), {Position = UDim2.new(0.5, -130, 0, 80)}):Play()
            end

            local mid = tradeUI.AbsolutePosition.X + (tradeUI.AbsoluteSize.X / 2)
            local seen = {}
            for _, obj in pairs(tradeUI:GetDescendants()) do
                if obj:IsA("TextLabel") and DATA[obj.Text] then
                    local key = obj.Text .. tostring(math.floor(obj.AbsolutePosition.Y))
                    if not seen[key] then
                        seen[key] = true
                        local price = DATA[obj.Text].default
                        if obj.AbsolutePosition.X < mid then myVal = myVal + price else hisVal = hisVal + price end
                    end
                end
            end
            local diff = hisVal - myVal
            display.Text = "YOU: "..myVal.." | HIM: "..hisVal.."\nDIFF: "..(diff > 0 and "+"..diff or diff)
            display.TextColor3 = diff >= 0 and Color3.new(0,1,0) or Color3.new(1,0,0)
        else
            if isOpen then
                isOpen = false
                TweenService:Create(main, TweenInfo.new(0.5), {Position = UDim2.new(0.5, -130, 0, -120)}):Play()
            end
        end
    end

    while task.wait(0.5) do pcall(update) end
end)
