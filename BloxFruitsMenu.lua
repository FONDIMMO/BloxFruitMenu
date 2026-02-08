--[[
    TERMINATOR v7.0 // ULTIMATE OVERLORD EDITION
    - FULL BLOX FRUITS AUTOMATION
    - DISCORD WEBHOOK: INTEGRATED
    - GUI: PREMIUM NEON
    - CONTROLS: [L] TO HIDE
]]

pcall(function()
    local p = game:GetService("Players")
    local lp = p.LocalPlayer
    local tw = game:GetService("TweenService")
    local cg = game:GetService("CoreGui")
    local rs = game:GetService("ReplicatedStorage")
    local uis = game:GetService("UserInputService")
    local http = game:GetService("HttpService")

    -- ТВОЙ ВЕБХУК
    local WEBHOOK_URL = "https://discord.com/api/webhooks/1469664776639610880/ub2RL5ZybFoisLFAjtBWvtARaZO9m8ka2Gg7CqtNDG-aHQyt3jodDFwY2qn1F6cqXQDQ"

    -- ОЧИСТКА СТАРЫХ ВЕРСИЙ
    if cg:FindFirstChild("TerminatorFinal") then cg.TerminatorFinal:Destroy() end

    local sg = Instance.new("ScreenGui", cg)
    sg.Name = "TerminatorFinal"

    -- ГЛАВНОЕ ОКНО
    local main = Instance.new("Frame", sg)
    main.Size = UDim2.new(0, 450, 0, 550)
    main.Position = UDim2.new(0.5, -225, 0.5, -275)
    main.BackgroundColor3 = Color3.fromRGB(10, 10, 12)
    main.BorderSizePixel = 0
    main.Active = true
    main.Draggable = true
    Instance.new("UICorner", main).CornerRadius = UDim.new(0, 15)
    
    local stroke = Instance.new("UIStroke", main)
    stroke.Color = Color3.fromRGB(0, 255, 255)
    stroke.Thickness = 2

    -- ШАПКА
    local header = Instance.new("Frame", main)
    header.Size = UDim2.new(1, 0, 0, 60)
    header.BackgroundColor3 = Color3.fromRGB(20, 20, 25)
    Instance.new("UICorner", header)

    local title = Instance.new("TextLabel", header)
    title.Size = UDim2.new(1, 0, 1, 0)
    title.Text = "TERMINATOR v7.0 // OVERLORD"
    title.TextColor3 = Color3.new(1, 1, 1)
    title.Font = Enum.Font.GothamBold
    title.TextSize = 20
    title.BackgroundTransparency = 1

    -- КОНТЕЙНЕР
    local scroll = Instance.new("ScrollingFrame", main)
    scroll.Size = UDim2.new(1, -20, 1, -80)
    scroll.Position = UDim2.new(0, 10, 0, 70)
    scroll.BackgroundTransparency = 1
    scroll.ScrollBarThickness = 2
    scroll.CanvasSize = UDim2.new(0, 0, 1.5, 0)
    Instance.new("UIListLayout", scroll).Padding = UDim.new(0, 8)

    -- [ ФУНКЦИЯ DISCORD ]
    local function sendWebhook(fruitName)
        local data = {
            ["content"] = "@everyone",
            ["embeds"] = {{
                ["title"] = "🍎 ФРУКТ ОБНАРУЖЕН!",
                ["description"] = "На сервере найден: **" .. fruitName .. "**\nНик игрока: " .. lp.Name,
                ["color"] = 65535,
                ["timestamp"] = os.date("!%Y-%m-%dT%H:%M:%SZ")
            }}
        }
        local requestFunc = syn and syn.request or http_request or request or (http and http.request)
        if requestFunc then
            pcall(function()
                requestFunc({
                    Url = WEBHOOK_URL,
                    Method = "POST",
                    Headers = {["Content-Type"] = "application/json"},
                    Body = http:JSONEncode(data)
                })
            end)
        end
    end

    -- [ ШАБЛОН КНОПКИ ]
    local function makeBtn(txt, desc, color, cb)
        local b = Instance.new("TextButton", scroll)
        b.Size = UDim2.new(1, 0, 0, 60)
        b.BackgroundColor3 = Color3.fromRGB(25, 25, 30)
        b.Text = ""
        Instance.new("UICorner", b)
        
        local t = Instance.new("TextLabel", b)
        t.Size = UDim2.new(1, -20, 0, 30); t.Position = UDim2.new(0, 15, 0, 5)
        t.Text = txt; t.TextColor3 = color; t.Font = Enum.Font.GothamBold; t.TextSize = 14; t.TextXAlignment = 0; t.BackgroundTransparency = 1
        
        local d = Instance.new("TextLabel", b)
        d.Size = UDim2.new(1, -20, 0, 20); d.Position = UDim2.new(0, 15, 0, 30)
        d.Text = desc; d.TextColor3 = Color3.new(0.6, 0.6, 0.6); d.Font = Enum.Font.Gotham; d.TextSize = 10; d.TextXAlignment = 0; d.BackgroundTransparency = 1

        b.MouseButton1Click:Connect(function()
            tw:Create(b, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(40, 40, 50)}):Play()
            task.wait(0.1)
            tw:Create(b, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(25, 25, 30)}):Play()
            cb()
        end)
    end

    -- [ ФУНКЦИОНАЛ ]

    makeBtn("INFINITE ENERGY", "Твоя энергия всегда 100%", Color3.new(0, 1, 1), function()
        task.spawn(function()
            while true do
                pcall(function() lp.Character.Energy.Value = lp.Character.Energy.MaxValue end)
                task.wait(0.2)
            end
        end)
    end)

    makeBtn("FRUIT & PLAYER ESP", "Подсветка целей сквозь стены", Color3.new(1, 0, 1), function()
        -- Игроки
        for _, pl in pairs(p:GetPlayers()) do
            if pl ~= lp and pl.Character and not pl.Character:FindFirstChild("V7_ESP") then
                local h = Instance.new("Highlight", pl.Character); h.Name = "V7_ESP"
                h.FillColor = Color3.new(1, 0, 0); h.FillTransparency = 0.5
            end
        end
        -- Фрукты
        for _, v in pairs(workspace:GetChildren()) do
            if v:IsA("Tool") and (v.Name:find("Fruit") or v:FindFirstChild("Handle")) then
                local h = Instance.new("Highlight", v)
                h.FillColor = Color3.new(0, 1, 1); h.FillTransparency = 0
            end
        end
    end)

    makeBtn("TP & COLLECT FRUITS", "Собрать фрукты + Вебхук", Color3.new(0, 1, 0), function()
        local found = false
        for _, v in pairs(workspace:GetChildren()) do
            if v:IsA("Tool") and (v.Name:find("Fruit") or v:FindFirstChild("Handle")) then
                found = true
                sendWebhook(v.Name)
                local hrp = lp.Character.HumanoidRootPart
                local info = TweenInfo.new((hrp.Position - v.Handle.Position).Magnitude / 250, Enum.EasingStyle.Linear)
                local t = tw:Create(hrp, info, {CFrame = v.Handle.CFrame})
                t:Play(); t.Completed:Wait()
                lp.Character.Humanoid:EquipTool(v)
            end
        end
        if not found then print("Фруктов нет.") end
    end)

    makeBtn("AUTO-CHEST FARM", "Сбор сундуков на острове", Color3.new(1, 1, 0), function()
        _G.Chests = not _G.Chests
        task.spawn(function()
            while _G.Chests do
                for _, v in pairs(workspace:GetChildren()) do
                    if v.Name:find("Chest") then
                        local t = tw:Create(lp.Character.HumanoidRootPart, TweenInfo.new(1), {CFrame = v.CFrame})
                        t:Play(); t.Completed:Wait(); task.wait(0.2)
                    end
                end
                task.wait(1)
            end
        end)
    end)

    makeBtn("SERVER HOP", "Поиск на другом сервере", Color3.new(1, 1, 1), function()
        local Servers = http:JSONDecode(game:HttpGet("https://games.roblox.com/v1/games/" .. game.PlaceId .. "/servers/Public?sortOrder=Asc&limit=100"))
        for _, s in pairs(Servers.data) do
            if s.playing < s.maxPlayers and s.id ~= game.JobId then
                game:GetService("TeleportService"):TeleportToPlaceInstance(game.PlaceId, s.id)
            end
        end
    end)

    -- АВТО-ДЕТЕКТОР ДЛЯ ДИСКОРДА
    workspace.ChildAdded:Connect(function(child)
        task.wait(1)
        if child:IsA("Tool") and child.Name:find("Fruit") then
            sendWebhook(child.Name)
        end
    end)

    -- СКРЫТИЕ (L)
    uis.InputBegan:Connect(function(k, m)
        if not m and k.KeyCode == Enum.KeyCode.L then main.Visible = not main.Visible end
    end)

    print("--- TERMINATOR v7.0 ULTIMATE LOADED ---")
end)
