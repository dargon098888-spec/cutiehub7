--[[\
    Script Name: Cutie Hub V3 (Aimbot + Maru Notification)
    Features: Maru Style Notification, Hitbox, Clay Graphics, Player ESP, Customizable Aimbot (FOV & Weapon Filter)
]]--

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local CoreGui = game:GetService("CoreGui")
local Workspace = game:GetService("Workspace")
local TweenService = game:GetService("TweenService")
local LocalPlayer = Players.LocalPlayer
local Camera = Workspace.CurrentCamera
local PlayerGui = LocalPlayer:FindFirstChildOfClass("PlayerGui") or LocalPlayer:WaitForChild("PlayerGui")

-- เคลียร์ของเก่าทิ้งกันซ้อนทับ
pcall(function()
    if CoreGui:FindFirstChild("CutieHub_UI") then CoreGui.CutieHub_UI:Destroy() end
    if PlayerGui:FindFirstChild("CutieHub_UI") then PlayerGui.PlayerGui.CutieHub_UI:Destroy() end
end)

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "CutieHub_UI"
ScreenGui.ResetOnSpawn = false
pcall(function() ScreenGui.Parent = CoreGui end)
if not ScreenGui.Parent then ScreenGui.Parent = PlayerGui end

-- ==================== ระบบแจ้งเตือนสไตล์ Maru Hub ====================
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
        
        -- แอนิเมชันเลื่อนเข้าแบบนุ่มนวล
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

-- สร้างหน้าต่างหลัก
local MainFrame = Instance.new("ScrollingFrame")
MainFrame.Size = UDim2.new(0, 260, 0, 380)
MainFrame.Position = UDim2.new(0.5, -130, 0.5, -190)
MainFrame.BackgroundColor3 = Color3.fromRGB(250, 250, 255)
MainFrame.BorderSizePixel = 0
MainFrame.Active = true
MainFrame.Draggable = true
MainFrame.CanvasSize = UDim2.new(0, 0, 0, 500)
MainFrame.ScrollBarThickness = 4
MainFrame.Parent = ScreenGui

local MainCorner = Instance.new("UICorner")
MainCorner.CornerRadius = UDim.new(0, 16)
MainCorner.Parent = MainFrame

local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, 0, 0, 40)
Title.BackgroundColor3 = Color3.fromRGB(240, 235, 250)
Title.Text = "  ✨ Cutie Hub V3 ✨"
Title.TextColor3 = Color3.fromRGB(30, 25, 40)
Title.TextSize = 14
Title.Font = Enum.Font.FredokaOne
Title.TextXAlignment = Enum.TextXAlignment.Left
Title.BorderSizePixel = 0
Title.Parent = MainFrame

local TitleCorner = Instance.new("UICorner")
TitleCorner.CornerRadius = UDim.new(0, 16)
TitleCorner.Parent = Title

local CloseBtn = Instance.new("TextButton")
CloseBtn.Size = UDim2.new(0, 26, 0, 26)
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

CloseBtn.MouseButton1Click:Connect(function()
    ScreenGui:Destroy()
end)

local function makeBtn(posY, text)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0, 220, 0, 36)
    btn.Position = UDim2.new(0.5, -110, 0, posY)
    btn.BackgroundColor3 = Color3.fromRGB(240, 238, 248)
    btn.Text = text
    btn.TextColor3 = Color3.fromRGB(30, 25, 40)
    btn.TextSize = 13
    btn.Font = Enum.Font.GothamBold
    btn.BorderSizePixel = 0
    btn.Parent = MainFrame
    local c = Instance.new("UICorner")
    c.CornerRadius = UDim.new(0, 10)
    c.Parent = btn
    return btn
end

-- สร้างปุ่มฟังก์ชัน
local HitboxBtn = makeBtn(50, "Hitbox: OFF")
local EspBtn = makeBtn(95, "ESP Players: OFF")
local ClayBtn = makeBtn(140, "Clay Graphics V3: OFF")
local AimbotBtn = makeBtn(185, "Aimbot: OFF")
local WeaponFilterBtn = makeBtn(230, "Weapon Filter: ALL")

-- ช่องปรับขนาด FOV
local FOVBox = Instance.new("TextBox")
FOVBox.Size = UDim2.new(0, 220, 0, 32)
FOVBox.Position = UDim2.new(0.5, -110, 0, 275)
FOVBox.BackgroundColor3 = Color3.fromRGB(240, 238, 248)
FOVBox.Text = "150"
FOVBox.TextColor3 = Color3.fromRGB(30, 25, 40)
FOVBox.PlaceholderText = "Aimbot FOV Size (e.g. 150)"
FOVBox.PlaceholderColor3 = Color3.fromRGB(140, 135, 155)
FOVBox.TextSize = 12
FOVBox.Font = Enum.Font.GothamBold
FOVBox.BorderSizePixel = 0
FOVBox.ClearTextOnFocus = false
FOVBox.Parent = MainFrame

local FOVCorner = Instance.new("UICorner")
FOVCorner.CornerRadius = UDim.new(0, 10)
FOVCorner.Parent = FOVBox

-- วงกลม FOV
local FOVCircle = Drawing.new("Circle")
FOVCircle.Visible = false
FOVCircle.Transparency = 0.7
FOVCircle.Thickness = 1.5
FOVCircle.Color = Color3.fromRGB(180, 120, 255)
FOVCircle.NumSides = 64
FOVCircle.Radius = 150
FOVCircle.Filled = false

-- สถานะตัวแปร
local hitboxOn, espOn, clayOn, aimbotOn = false, false, false, false
local aimbotFOV = 150
local weaponMode = 1
local weaponModes = {"ALL", "Melee/Sword", "Gun/Blox Fruit"}

FOVBox.FocusLost:Connect(function()
    local num = tonumber(FOVBox.Text)
    if num then
        aimbotFOV = math.clamp(num, 50, 500)
        FOVBox.Text = tostring(aimbotFOV)
        FOVCircle.Radius = aimbotFOV
        sendNotification("Settings", "FOV Size set to: " .. aimbotFOV)
    else
        FOVBox.Text = tostring(aimbotFOV)
    end
end)

WeaponFilterBtn.MouseButton1Click:Connect(function()
    weaponMode = weaponMode + 1
    if weaponMode > 3 then weaponMode = 1 end
    WeaponFilterBtn.Text = "Weapon Filter: " .. weaponModes[weaponMode]
    sendNotification("Weapon Filter", "Mode: " .. weaponModes[weaponMode])
end)

HitboxBtn.MouseButton1Click:Connect(function()
    hitboxOn = not hitboxOn
    HitboxBtn.Text = "Hitbox: " .. (hitboxOn and "ON" or "OFF")
    sendNotification("Hitbox System", hitboxOn and "Activated" or "Deactivated")
end)

EspBtn.MouseButton1Click:Connect(function()
    espOn = not espOn
    EspBtn.Text = "ESP Players: " .. (espOn and "ON" or "OFF")
    sendNotification("ESP System", espOn and "Activated" or "Deactivated")
    if not espOn then
        for _, p in ipairs(Players:GetPlayers()) do
            if p.Character and p.Character:FindFirstChild("CutieESP") then
                p.Character.CutieESP:Destroy()
            end
        end
    end
end)

ClayBtn.MouseButton1Click:Connect(function()
    clayOn = not clayOn
    ClayBtn.Text = "Clay Graphics V3: " .. (clayOn and "ON" or "OFF")
    sendNotification("Graphics", clayOn and "Clay V3 Enabled" or "Normal Graphics")
    pcall(function()
        if clayOn then
            for _, o in ipairs(Workspace:GetDescendants()) do
                if o:IsA("BasePart") then o.Material = Enum.Material.SmoothPlastic end
            end
        end
    end)
end)

AimbotBtn.MouseButton1Click:Connect(function()
    aimbotOn = not aimbotOn
    AimbotBtn.Text = "Aimbot: " .. (aimbotOn and "ON" or "OFF")
    FOVCircle.Visible = aimbotOn
    sendNotification("Aimbot System", aimbotOn and "Activated" or "Deactivated")
end)

local function checkWeapon()
    if weaponMode == 1 then return true end
    local char = LocalPlayer
