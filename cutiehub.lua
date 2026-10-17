--[[\
    Script Name: Cutie Hub V2 (Blox Fruits)
    Features: Glassy Hitbox, Clay Graphics V3, FPS Counter, Auto Fruit Teleport, ESP Categories (Players, Fruits, Mobs)
]]--

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local CoreGui = game:GetService("CoreGui")
local Workspace = game:GetService("Workspace")
local TweenService = game:GetService("TweenService")
local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer:FindFirstChildOfClass("PlayerGui") or LocalPlayer:WaitForChild("PlayerGui")

-- เคลียร์ของเก่าทิ้งกันซ้อนทับ
pcall(function()
    if CoreGui:FindFirstChild("CutieHub_UI") then CoreGui.CutieHub_UI:Destroy() end
    if PlayerGui:FindFirstChild("CutieHub_UI") then PlayerGui.PlayerGui.CutieHub_UI:Destroy() end
end)

-- สร้าง ScreenGui หลัก
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "CutieHub_UI"
ScreenGui.ResetOnSpawn = false

local success = pcall(function()
    ScreenGui.Parent = CoreGui
end)
if not success then
    ScreenGui.Parent = PlayerGui
end

-- ==================== ระบบแจ้งเตือน ====================
local function sendNotification(title, text)
    pcall(function()
        local NotifHolder = ScreenGui:FindFirstChild("NotifHolder")
        if not NotifHolder then
            NotifHolder = Instance.new("Frame")
            NotifHolder.Name = "NotifHolder"
            NotifHolder.Size = UDim2.new(0, 220, 1, 0)
            NotifHolder.Position = UDim2.new(1, -230, 0, 10)
            NotifHolder.BackgroundTransparency = 1
            NotifHolder.Parent = ScreenGui
            
            local layout = Instance.new("UIListLayout")
            layout.SortOrder = Enum.SortOrder.LayoutOrder
            layout.Padding = UDim.new(0, 8)
            layout.Parent = NotifHolder
        end
        
        local NotifBox = Instance.new("Frame")
        NotifBox.Size = UDim2.new(1, 0, 0, 50)
        NotifBox.BackgroundColor3 = Color3.fromRGB(250, 250, 255)
        NotifBox.Position = UDim2.new(1, 50, 0, 0)
        NotifBox.BorderSizePixel = 0
        NotifBox.Parent = NotifHolder
        
        local corner = Instance.new("UICorner")
        corner.CornerRadius = UDim.new(0, 10)
        corner.Parent = NotifBox
        
        local stroke = Instance.new("UIStroke")
        stroke.Color = Color3.fromRGB(220, 210, 240)
        stroke.Thickness = 1.5
        stroke.Parent = NotifBox
        
        local TitleLabel = Instance.new("TextLabel")
        TitleLabel.Size = UDim2.new(1, -15, 0, 20)
        TitleLabel.Position = UDim2.new(0, 12, 0, 5)
        TitleLabel.BackgroundTransparency = 1
        TitleLabel.Text = title
        TitleLabel.TextColor3 = Color3.fromRGB(30, 25, 40)
        TitleLabel.TextSize = 13
        TitleLabel.Font = Enum.Font.FredokaOne
        TitleLabel.TextXAlignment = Enum.TextXAlignment.Left
        TitleLabel.Parent = NotifBox
        
        local DescLabel = Instance.new("TextLabel")
        DescLabel.Size = UDim2.new(1, -15, 0, 20)
        DescLabel.Position = UDim2.new(0, 12, 0, 23)
        DescLabel.BackgroundTransparency = 1
        DescLabel.Text = text
        DescLabel.TextColor3 = Color3.fromRGB(100, 95, 115)
        DescLabel.TextSize = 11
        DescLabel.Font = Enum.Font.GothamBold
        DescLabel.TextXAlignment = Enum.TextXAlignment.Left
        DescLabel.Parent = NotifBox
        
        TweenService:Create(NotifBox, TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Position = UDim2.new(0, 0, 0, 0)}):Play()
        
        task.delay(2.5, function()
            if NotifBox and NotifBox.Parent then
                local tweenOut = TweenService:Create(NotifBox, TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {Position = UDim2.new(1, 50, 0, 0)})
                tweenOut:Play()
                tweenOut.Completed:Connect(function()
                    NotifBox:Destroy()
                end)
            end
        end)
    end)
end

-- ==================== หน้าต่างหลัก (Main Frame) ====================
local MainFrame = Instance.new("ScrollingFrame")
MainFrame.Size = UDim2.new(0, 260, 0, 360)
MainFrame.Position = UDim2.new(0.5, -130, 0.5, -180)
MainFrame.BackgroundColor3 = Color3.fromRGB(250, 250, 255)
MainFrame.BorderSizePixel = 0
MainFrame.Active = true
MainFrame.Draggable = true
MainFrame.CanvasSize = UDim2.new(0, 0, 0, 480)
MainFrame.ScrollBarThickness = 4
MainFrame.Parent = ScreenGui

local MainCorner = Instance.new("UICorner")
MainCorner.CornerRadius = UDim.new(0, 16)
MainCorner.Parent = MainFrame

local MainStroke = Instance.new("UIStroke")
MainStroke.Color = Color3.fromRGB(220, 210, 240)
MainStroke.Thickness = 1.5
MainStroke.Parent = MainFrame

-- แถบหัวข้อ (Title)
local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, 0, 0, 42)
Title.BackgroundColor3 = Color3.fromRGB(240, 235, 250)
Title.Text = "  ✨ Cutie Hub V2 ✨"
Title.TextColor3 = Color3.fromRGB(30, 25, 40)
Title.TextSize = 16
Title.Font = Enum.Font.FredokaOne
Title.TextXAlignment = Enum.TextXAlignment.Left
Title.BorderSizePixel = 0
Title.Parent = MainFrame

local TitleCorner = Instance.new("UICorner")
TitleCorner.CornerRadius = UDim.new(0, 16)
TitleCorner.Parent = Title

-- ปุ่ม Minimize (-)
local MinimizeBtn = Instance.new("TextButton")
MinimizeBtn.Size = UDim2.new(0, 28, 0, 28)
MinimizeBtn.Position = UDim2.new(1, -64, 0, 7)
MinimizeBtn.BackgroundColor3 = Color3.fromRGB(225, 220, 240)
MinimizeBtn.Text = "-"
MinimizeBtn.TextColor3 = Color3.fromRGB(30, 25, 40)
MinimizeBtn.TextSize = 16
MinimizeBtn.Font = Enum.Font.GothamBold
MinimizeBtn.BorderSizePixel = 0
MinimizeBtn.Parent = Title

local MinCorner = Instance.new("UICorner")
MinCorner.CornerRadius = UDim.new(0, 8)
MinCorner.Parent = MinimizeBtn

-- ปุ่ม Close (x)
local CloseBtn = Instance.new("TextButton")
CloseBtn.Size = UDim2.new(0, 28, 0, 28)
CloseBtn.Position = UDim2.new(1, -32, 0, 7)
CloseBtn.BackgroundColor3 = Color3.fromRGB(255, 120, 130)
CloseBtn.Text = "X"
CloseBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
CloseBtn.TextSize = 12
CloseBtn.Font = Enum.Font.GothamBold
CloseBtn.BorderSizePixel = 0
CloseBtn.Parent = Title

local CloseCorner = Instance.new("UICorner")
CloseCorner.CornerRadius = UDim.new(0, 8)
CloseCorner.Parent = CloseBtn

-- ปุ่มเปิดเมนูคืน
local OpenMenuBtn = Instance.new("TextButton")
OpenMenuBtn.Size = UDim2.new(0, 120, 0, 38)
OpenMenuBtn.Position = UDim2.new(0, 10, 0, 10)
OpenMenuBtn.BackgroundColor3 = Color3.fromRGB(240, 235, 250)
OpenMenuBtn.Text = "💖 Open Hub"
OpenMenuBtn.TextColor3 = Color3.fromRGB(30, 25, 40)
OpenMenuBtn.TextSize = 13
OpenMenuBtn.Font = Enum.Font.GothamBold
OpenMenuBtn.BorderSizePixel = 0
OpenMenuBtn.Visible = false
OpenMenuBtn.Active = true
OpenMenuBtn.Draggable = true
OpenMenuBtn.Parent = ScreenGui

local OpenCorner = Instance.new("UICorner")
OpenCorner.CornerRadius = UDim.new(0, 10)
OpenCorner.Parent = OpenMenuBtn

local OpenStroke = Instance.new("UIStroke")
OpenStroke.Color = Color3.fromRGB(210, 200, 230)
OpenStroke.Thickness = 1.5
OpenStroke.Parent = OpenMenuBtn

MinimizeBtn.MouseButton1Click:Connect(function()
    MainFrame.Visible = false
    OpenMenuBtn.Visible = true
end)

OpenMenuBtn.MouseButton1Click:Connect(function()
    MainFrame.Visible = true
    OpenMenuBtn.Visible = false
end)

CloseBtn.MouseButton1Click:Connect(function()
    ScreenGui:Destroy()
end)

-- ฟังก์ชันสร้างปุ่ม
local function createRoundedButton(posY, text)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0, 220, 0, 38)
    btn.Position = UDim2.new(0.5, -110, 0, posY)
    btn.BackgroundColor3 = Color3.fromRGB(240, 238, 248)
    btn.Text = text
    btn.TextColor3 = Color3.fromRGB(30, 25, 40)
    btn.TextSize = 13
    btn.Font = Enum.Font.GothamBold
    btn.BorderSizePixel = 0
    btn.Parent = MainFrame

    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 10)
    corner.Parent = btn
    return btn
end

-- สร้างปุ่มเมนูต่างๆ
local HitboxBtn = createRoundedButton(50, "Hitbox (Players): OFF")

local SizeBox = Instance.new("TextBox")
SizeBox.Size = UDim2.new(0, 220, 0, 32)
SizeBox.Position = UDim2.new(0.5, -110, 0, 95)
SizeBox.BackgroundColor3 = Color3.fromRGB(240, 238, 248)
SizeBox.Text = "5"
SizeBox.TextColor3 = Color3.fromRGB(30, 25, 40)
SizeBox.PlaceholderText = "Hitbox Size (1-100)"
SizeBox.PlaceholderColor3 = Color3.fromRGB(140, 135, 155)
SizeBox.TextSize = 13
SizeBox.Font = Enum.Font.GothamBold
SizeBox.BorderSizePixel = 0
SizeBox.ClearTextOnFocus = false
SizeBox.Parent = MainFrame

local SizeCorner = Instance.new("UICorner")
SizeCorner.CornerRadius = UDim.new(0, 10)
SizeCorner.Parent = SizeBox

local AutoFruitBtn = createRoundedButton(135, "Auto Teleport Fruit: OFF")
local EspPlayerBtn = createRoundedButton(180, "ESP Player: OFF")
local EspFruitBtn  = createRoundedButton(225, "ESP Fruit: OFF")
local EspMobBtn    = createRoundedButton(270, "ESP Monster/Boss: OFF")
local ClayBtn      = createRoundedButton(315, "Clay Graphics V3: OFF")
local FpsBtn       = createRoundedButton(360, "FPS Counter: OFF")

-- ตัวแสดง FPS
local FpsLabel = Instance.new("TextLabel")
FpsLabel.Size = UDim2.new(0, 110, 0, 35)
FpsLabel.Position = UDim2.new(0, 10, 0, 10)
FpsLabel.BackgroundColor3 = Color3.fromRGB(245, 245, 255)
FpsLabel.BackgroundTransparency = 0.1
FpsLabel.TextColor3 = Color3.fromRGB(0, 140, 90)
FpsLabel.TextSize = 15
FpsLabel.Font = Enum.Font.Code
FpsLabel.Text = "FPS: 0"
FpsLabel.Visible = false
FpsLabel.BorderSizePixel = 0
FpsLabel.Parent = ScreenGui

local FpsCorner = Instance.new("UICorner")
FpsCorner.CornerRadius = UDim.new(0, 10)
FpsCorner.Parent = FpsLabel

-- สถานะตัวแปร
local hitboxEnabled = false
local autoFruitEnabled = false
local espPlayerEnabled = false
local espFruitEnabled = false
local espMobEnabled = false
local clayEnabled = false
local fpsEnabled = false
local hitboxSize = 5

SizeBox.FocusLost:Connect(function()
    local num = tonumber(SizeBox.Text)
    if num then
        hitboxSize = math.clamp(math.floor(num), 1, 100)
        SizeBox.Text = tostring(hitboxSize)
        sendNotification("Settings", "Hitbox size: " .. hitboxSize)
    else
        SizeBox.Text = tostring(hitboxSize)
    end
end)

-- 1. FPS Counter
local lastTick = tick()
local frameCount = 0
RunService.RenderStepped:Connect(function()
    if fpsEnabled then
        frameCount = frameCount + 1
        local currentTick = tick()
        if currentTick - lastTick >= 1 then
            FpsLabel.Text = "FPS: " .. tostring(frameCount)
            frameCount = 0
            lastTick = currentTick
        end
    end
end)

FpsBtn.MouseButton1Click:Connect(function()
    fpsEnabled = not fpsEnabled
    FpsLabel.Visible = fpsEnabled
    FpsBtn.Text = "FPS Counter: " .. (fpsEnabled and "ON" or "OFF")
    FpsBtn.TextColor3 = fpsEnabled and Color3.fromRGB(0, 160, 100) or Color3.fromRGB(30, 25, 40)
end)

-- 2. Hitbox System
RunService.RenderStepped:Connect(function()
    if hitboxEnabled then
        for _, player in ipairs(Players:GetPlayers()) do
            if player ~= LocalPlayer and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
                local hrp = player.Character.HumanoidRootPart
                hrp.Size = Vector3.new(hitboxSize, hitboxSize, hitboxSize)
                hrp.Transparency = 0.65
                hrp.Color = Color3.fromRGB(245, 245, 250)
                hrp.Material = Enum.Material.Glass
                hrp.CanCollide = false
            end
        end
    else
        for _, player in ipairs(Players:GetPlayers()) do
            if player ~= LocalPlayer and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
                player.Character.HumanoidRootPart.Size = Vector3.new(2, 2, 1)
                player.Character.HumanoidRootPart.Transparency = 1
                player.Character.HumanoidRootPart.Material = Enum.Material.SmoothPlastic
            end
        end
    end
end)

HitboxBtn.MouseButton1Click:Connect(function()
    hitboxEnabled = not hitboxEnabled
    HitboxBtn.Text = "Hitbox (Players): " .. (hitboxEnabled and "ON" or "OFF")
    HitboxBtn.TextColor3 = hitboxEnabled and Color3.fromRGB(0, 160, 100) or Color3.fromRGB(30, 25, 40)
    sendNotification("Hitbox", hitboxEnabled and "Activated" or "Deactivated")
end)

-- 3. ระบบบินวาร์ปเก็บผลไม้ (Auto Teleport to Devil Fruit)
TaskActive = task.spawn(function()
    while true do
        task.wait(1)
        if autoFruitEnabled then
            pcall(function()
                for _, obj in ipairs(Workspace:GetChildren()) do
                    if obj:IsA("Tool") and obj:FindFirstChild("Handle") then
                        -- เช็คว่าเป็นผลไม้ (ปกติชื่อผลไม้ใน Blox Fruits จะลงท้ายด้วย Fruit หรือมี Handle)
                        if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
                            LocalPlayer.Character.HumanoidRootPart.CFrame = obj.Handle.CFrame + Vector3.new(0, 3, 0)
                            sendNotification("Auto Fruit", "Teleported to Fruit!")
                            task.wait(0.5)
                        end
                    end
                end
                -- ค้นหาในโฟกัสสำรอง
                for _, obj in ipairs(Workspace:GetDescendants()) do
                    if obj.Name:lower():find("fruit") and obj:IsA("BasePart") then
                        if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
                            LocalPlayer.Character.HumanoidRootPart.CFrame = obj.CFrame + Vector3.new(0, 3, 0)
                            sendNotification("Auto Fruit", "Found Fruit Dropped!")
                            task.wait(1)
                        end
                    end
                end
            end)
        end
    end
end)

AutoFruitBtn.MouseButton1Click:Connect(function()
    autoFruitEnabled = not autoFruitEnabled
    AutoFruitBtn.Text = "Auto Teleport Fruit: " .. (autoFruitEnabled and "ON" or "OFF")
    AutoFruitBtn.TextColor3 = autoFruitEnabled and Color3.fromRGB(0, 160, 100) or Color3.fromRGB(30, 25, 40)
    sendNotification("Auto Fruit", autoFruitEnabled and "Searching for Fruits..." : "Stopped")
end)

-- 4. ระบบ ESP (มองทะลุ) ฟังก์ชันพ่วงไฮไลท์
local function createHighlight(parent, color)
    if not parent:FindFirstChild("CutieESP") then
        local hl = Instance.new("Highlight")
        hl.Name = "CutieESP"
        hl.Adornee = parent
        hl.FillColor = color
        hl.OutlineColor = Color3.fromRGB(255, 255, 255)
        hl.FillTransparency = 0.4
        hl.Parent = parent
    end
end

local function removeHighlight(parent)
    if parent:FindFirstChild("CutieESP") then
        parent.CutieESP:Destroy()
    end
end

RunService.RenderStepped:Connect(function()
    -- ESP Player
    for _, p in ipairs(Players:GetPlayers()) do
        if p ~= LocalPlayer and p.Character then
            if espPlayerEnabled then
                createHighlight(p.Character, Color3.fromRGB(140, 100, 255))
            else
                removeHighlight(p.Character)
            end
        end
    end

    -- ESP Fruit
    if espFruitEnabled then
        for _, obj in ipairs(Workspace:GetDescendants()) do
            if obj.Name:lower():find("fruit") and obj:IsA("Model") then
                createHighlight(obj, Color3.fromRGB(255, 50, 50))
            elseif obj.Name:lower():find("fruit") and obj:IsA("BasePart") and not obj.Parent:FindFirstChild("Humanoid") then
                createHighlight(obj, Color3.fromRGB(255, 50, 50))
            end
        end
    end

    -- ESP Monster/Boss (เช็คใน Workspace.Enemies หรือโมเดลที่มี Humanoid)
    if espMobEnabled then
        local enemiesFolder = Workspace:FindFirstChild("Enemies")
        if enemiesFolder then
            for _, mob in ipairs(enemiesFolder:GetChildren()) do
                if mob:FindFirstChild("Humanoid") and mob:FindFirstChild("HumanoidRootPart") then
                    createHighlight(mob, Color3.fromRGB(255, 165, 0))
                end
            end
        end
    end
end)

EspPlayerBtn.MouseButton1Click:Connect(function()
    espPlayerEnabled = not espPlayerEnabled
    EspPlayerBtn.Text = "ESP Player: " .. (espPlayerEnabled and "ON" or "OFF")
    EspPlayerBtn.TextColor3 = espPlayerEnabled and Color3.fromRGB(0, 160, 100) or Color3.fromRGB(30, 25, 40)
end)

EspFruitBtn.MouseButton1Click:Connect(function()
    espFruitEnabled = not espFruitEnabled
    EspFruitBtn.Text = "ESP Fruit: " .. (espFruitEnabled and "ON" or "OFF")
    EspFruitBtn.TextColor3 = espFruitEnabled and Color3.fromRGB(0, 160, 100) or Color3.fromRGB(30, 25, 40)
end)

EspMobBtn.MouseButton1Click:Connect(function()
    espMobEnabled = not espMobEnabled
    EspMobBtn.Text = "ESP Monster/Boss: " .. (espMobEnabled and "ON" or "OFF")
    EspMobBtn.TextColor3 = espMobEnabled and Color3.fromRGB(0, 160, 100) or Color3.fromRGB(30, 25, 40)
end)

-- 5. Clay Graphics V3
ClayBtn.MouseButton1Click:Connect(function()
    clayEnabled = not clayEnabled
    ClayBtn.Text = "Clay Graphics V3: " .. (clayEnabled and "ON" or "OFF")
    ClayBtn.TextColor3 = clayEnabled and Color3.fromRGB(0, 160, 100) or Color3.fromRGB(30, 25, 40)
    sendNotification("Clay Graphics V3", clayEnabled and "Optimized" or "Normal")

    pcall(function()
        if clayEnabled then
            settings().Rendering.QualityLevel = Enum.QualityLevel.Level01
            for _, obj in ipairs(Workspace:GetDescendants()) do
                if obj:IsA("BasePart") then
                    obj.Material = Enum.Material.SmoothPlastic
                    obj.Reflectance = 0
                elseif obj:IsA("Texture") or obj:IsA("Decal") then
                    obj.Transparency = 1
                end
            end
        end
    end)
end)

sendNotification("Cutie Hub V2", "Successfully Loaded!")
