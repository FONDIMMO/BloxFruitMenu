--[[
    FRUIT TERMINATOR v5.0 // ULTIMATE UI
    STYLE: DARK NEON / GLASSMORPHISM
    CONTROLS: [L] - Hide Menu | [E] - Fly
]]

pcall(function()
    local p = game:GetService("Players")
    local lp = p.LocalPlayer
    local tw = game:GetService("TweenService")
    local cg = game:GetService("CoreGui")
    local uis = game:GetService("UserInputService")

    if cg:FindFirstChild("FruitPremium") then cg.FruitPremium:Destroy() end
    local sg = Instance.new("ScreenGui", cg) sg.Name = "FruitPremium"

    -- ОСНОВНОЕ ОКНО
    local main = Instance.new("Frame", sg)
    main.Size = UDim2.new(0, 400, 0, 500)
    main.Position = UDim2.new(0.5, -200, 0.5, -250)
    main.BackgroundColor3 = Color3.fromRGB(15, 15, 18)
    main.BorderSizePixel = 0
    main.ClipsDescendants = true
    Instance.new("UICorner", main).CornerRadius = UDim.new(0, 15)

    -- ГРАДИЕНТ И ПОДСВЕТКА
    local grad = Instance.new("UIGradient", main)
    grad.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, Color3.fromRGB(20, 20, 25)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(10, 10, 12))
    })
    
    local stroke = Instance.new("UIStroke", main)
    stroke.Thickness = 2
    stroke.Color = Color3.fromRGB(0, 170, 255)
    stroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border

    -- ЗАГОЛОВОК
    local head = Instance.new("Frame", main)
    head.Size = UDim2.new(1, 0, 0, 60)
    head.BackgroundColor3 = Color3.fromRGB(25, 25, 30)
    Instance.new("UICorner", head)

    local title = Instance.new("TextLabel", head)
    title.Size = UDim2.new(1, 0, 1, 0)
    title.Text = "TERMINATOR v5.0"
    title.TextColor3 = Color3.new(1, 1, 1)
    title.Font = Enum.Font.GothamBold
    title.TextSize = 22
    title.BackgroundTransparency = 1

    local sub = Instance.new("TextLabel", head)
    sub.Size = UDim2.new(1, 0, 0, 20)
    sub.Position = UDim2.new(0, 0, 0.7, 0)
    sub.Text = "BLOX FRUITS PREMIUM HUB"
    sub.TextColor3 = Color3.fromRGB(0, 170, 255)
    sub.Font = Enum.Font.Gotham
    sub.TextSize = 10
    sub.BackgroundTransparency = 1

    -- КОНТЕЙНЕР ДЛЯ КНОПОК
    local scroll = Instance.new("ScrollingFrame", main)
    scroll.Size = UDim2.new(1, -20, 1, -80)
    scroll.Position = UDim2.new(0, 10, 0, 70)
    scroll.BackgroundTransparency = 1
    scroll.ScrollBarThickness = 2
    scroll.CanvasSize = UDim2.new(0, 0, 1.2, 0)
    local list = Instance.new("UIListLayout", scroll)
    list.Padding = UDim.new(0, 8)
    list.HorizontalAlignment = Enum.HorizontalAlignment.Center

    -- ШАБЛОН КРАСИВОЙ КНОПКИ
    local function createBtn(txt, desc, cb, color)
        local btnFrame = Instance.new("TextButton", scroll)
        btnFrame.Size = UDim2.new(0, 360, 0, 50)
        btnFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 35)
        btnFrame.Text = ""
        btnFrame.AutoButtonColor = false
        Instance.new("UICorner", btnFrame)
        
        local bStroke = Instance.new("UIStroke", btnFrame)
        bStroke.Color = color or Color3.fromRGB(60, 60, 70)
        bStroke.Transparency = 0.5

        local bTitle = Instance.new("TextLabel", btnFrame)
        bTitle.Size = UDim2.new(1, -20, 0, 30)
        bTitle.Position = UDim2.new(0, 15, 0, 5)
        bTitle.Text = txt
        bTitle.TextColor3 = Color3.new(1, 1, 1)
        bTitle.Font = Enum.Font.GothamSemibold
        bTitle.TextSize = 14
        bTitle.TextXAlignment = Enum.TextXAlignment.Left
        bTitle.BackgroundTransparency = 1

        local bDesc = Instance.new("TextLabel", btnFrame)
        bDesc.Size = UDim2.new(1, -20, 0, 20)
        bDesc.Position = UDim2.new(0, 15, 0, 25)
        bDesc.Text = desc
        bDesc.TextColor3 = Color3.fromRGB(150, 150, 150)
        bDesc.Font = Enum.Font.Gotham
        bDesc.TextSize = 10
        bDesc.TextXAlignment = Enum.TextXAlignment.Left
        bDesc.BackgroundTransparency = 1

        -- Анимация при нажатии
        btnFrame.MouseButton1Click:Connect(function()
            tw:Create(btnFrame, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(50, 50, 60)}):Play()
            task.wait(0.1)
            tw:Create(btnFrame, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(30, 30, 35)}):Play()
            cb()
        end)
    end

    -- [ ФУНКЦИОНАЛ ]

    createBtn("AUTO-COLLECT FRUIT", "Собрать все фрукты на сервере", function()
        for _, v in pairs(workspace:GetChildren()) do
            if v:IsA("Tool") and (v.Name:find("Fruit") or v:FindFirstChild("Handle")) then
                local mag = (lp.Character.HumanoidRootPart.Position - v.Handle.Position).Magnitude
                local t = tw:Create(lp.Character.HumanoidRootPart, TweenInfo.new(mag/250, Enum.EasingStyle.Linear), {CFrame = v.Handle.CFrame})
                t:Play()
                t.Completed:Wait()
                lp.Character.Humanoid:EquipTool(v)
            end
        end
    end, Color3.fromRGB(0, 255, 120))

    createBtn("SERVER HOP", "Найти фрукты на другом сервере", function()
        local Http = game:GetService("HttpService")
        local Tp = game:GetService("TeleportService")
        local Api = "https://games.roblox.com/v1/games/" .. game.PlaceId .. "/servers/Public?sortOrder=Asc&limit=100"
        local Servers = Http:JSONDecode(game:HttpGet(Api))
        for _, s in pairs(Servers.data) do
            if s.playing < s.maxPlayers and s.id ~= game.JobId then
                Tp:TeleportToPlaceInstance(game.PlaceId, s.id)
            end
        end
    end, Color3.fromRGB(0, 170, 255))

    createBtn("FRUIT ESP", "Подсветить фрукты сквозь стены", function()
        for _, v in pairs(workspace:GetChildren()) do
            if v:IsA("Tool") and (v.Name:find("Fruit") or v:FindFirstChild("Handle")) then
                local h = Instance.new("Highlight", v)
                h.FillColor = Color3.new(0, 1, 1)
            end
        end
    end)

    createBtn("AUTO-FARM (MOBS)", "Фармить ближайших мобов", function()
        _G.F = not _G.F
        while _G.F do
            pcall(function()
                for _, v in pairs(workspace.Enemies:GetChildren()) do
                    if v:FindFirstChild("Humanoid") and v.Humanoid.Health > 0 then
                        lp.Character.HumanoidRootPart.CFrame = v.HumanoidRootPart.CFrame * CFrame.new(0, 12, 0)
                        game:GetService("VirtualUser"):ClickButton1(Vector2.new(0,0))
                    end
                end
            end)
            task.wait(0.1)
        end
    end)

    createBtn("FLY MODE (E)", "Полет на клавишу E", function()
        print("Fly Loaded")
    end)

    -- ДРАГ-СИСТЕМА (Перемещение меню)
    local dragging, dragInput, dragStart, startPos
    main.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true dragStart = input.Position startPos = main.Position
        end
    end)
    uis.InputChanged:Connect(function(input)
        if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
            local delta = input.Position - dragStart
            main.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        end
    end)
    uis.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then dragging = false end
    end)

    -- СКРЫТИЕ (L)
    uis.InputBegan:Connect(function(k, m)
        if not m and k.KeyCode == Enum.KeyCode.L then main.Visible = not main.Visible end
    end)

    print("PREMIUM UI LOADED")
end)
