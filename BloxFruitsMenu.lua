--[[
    BLOX HUB v3.0 // FRUIT UPDATE
    ФУНКЦИИ: Поиск фруктов, Телепорт к фруктам, Фейк-фрукт (визуал).
]]

pcall(function()
    local p = game:GetService("Players")
    local lp = p.LocalPlayer
    local cg = game:GetService("CoreGui")

    if cg:FindFirstChild("BloxFruitMaster") then cg.BloxFruitMaster:Destroy() end
    local sg = Instance.new("ScreenGui", cg) sg.Name = "BloxFruitMaster"

    local main = Instance.new("Frame", sg)
    main.Size = UDim2.new(0, 380, 0, 400)
    main.Position = UDim2.new(0.5, -190, 0.5, -200)
    main.BackgroundColor3 = Color3.fromRGB(15, 10, 20)
    Instance.new("UICorner", main)
    local stroke = Instance.new("UIStroke", main) stroke.Color = Color3.new(0.6, 0.2, 1)

    local title = Instance.new("TextLabel", main)
    title.Size = UDim2.new(1, 0, 0, 40)
    title.Text = "BLOX HUB v3.0 // FRUIT MASTER"
    title.TextColor3 = Color3.new(1, 1, 1)
    title.BackgroundColor3 = Color3.fromRGB(50, 20, 100)
    Instance.new("UICorner", title)

    local scroll = Instance.new("ScrollingFrame", main)
    scroll.Size = UDim2.new(1, -20, 1, -60)
    scroll.Position = UDim2.new(0, 10, 0, 50)
    scroll.BackgroundTransparency = 1
    Instance.new("UIListLayout", scroll).Padding = UDim.new(0, 5)

    local function btn(txt, cb, col)
        local b = Instance.new("TextButton", scroll)
        b.Size = UDim2.new(1, 0, 0, 40)
        b.Text = txt
        b.BackgroundColor3 = col or Color3.fromRGB(40, 30, 50)
        b.TextColor3 = Color3.new(1, 1, 1)
        b.Font = Enum.Font.Code
        b.MouseButton1Click:Connect(cb)
        Instance.new("UICorner", b)
    end

    -- [ ФУНКЦИИ ]

    btn("TELEPORT TO SPAWNED FRUIT", function()
        local found = false
        for _, v in pairs(workspace:GetChildren()) do
            if v:IsA("Tool") and (v.Name:find("Fruit") or v:FindFirstChild("Handle")) then
                game:GetService("TweenService"):Create(lp.Character.HumanoidRootPart, TweenInfo.new(2), {CFrame = v.Handle.CFrame}):Play()
                found = true
                print("Фрукт найден: " .. v.Name)
            end
        end
        if not found then print("На карте сейчас нет свободных фруктов.") end
    end, Color3.fromRGB(0, 120, 0))

    btn("FRUIT NOTIFIER (ON)", function()
        -- Оповещение, если в мире появится фрукт
        workspace.ChildAdded:Connect(function(child)
            if child:IsA("Tool") and child.Name:find("Fruit") then
                print("!!! ВНИМАНИЕ: Фрукт заспавнился: " .. child.Name)
            end
        end)
    end)

    btn("FAKE FRUIT (VISUAL ONLY)", function()
        -- Создает модель фрукта в руках (только ты его видишь)
        local fruit = Instance.new("Part", lp.Character)
        fruit.Name = "FakeDough"
        fruit.Size = Vector3.new(1,1,1)
        fruit.Color = Color3.new(1, 0, 1)
        local m = Instance.new("SpecialMesh", fruit)
        m.MeshId = "rbxassetid://15217426179" -- Пример ID модели
        
        local weld = Instance.new("Weld", fruit)
        weld.Part0 = fruit
        weld.Part1 = lp.Character["Right Hand"]
        weld.C0 = CFrame.new(0, -1, 0)
        print("Визуальный фрукт выдан. (Он не работает для еды!)")
    end, Color3.fromRGB(100, 50, 0))

    btn("AUTO-BUY RANDOM FRUIT", function()
        -- Пытается купить случайный фрукт у торговца (нужны деньги!)
        game:GetService("ReplicatedStorage").Remotes.Validator:FireServer("PurchaseRandomFruit")
    end)

end)
