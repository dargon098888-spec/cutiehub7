--[[\
    Script Name: Noxus Hub | Auto-Run, Speed 95 & Auto Store Fruit
    Features: Auto-Run on Join, Config Save/Load, Speed 95 Fruit Tween, Auto Store Fruit, Anti-AFK, Auto Rejoin
]]--

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local CoreGui = game:GetService("CoreGui")
local Workspace = game:GetService("Workspace")
local TweenService = game:GetService("TweenService")
local SoundService = game:GetService("SoundService")
local Lighting = game:GetService("Lighting")
local HttpService = game:GetService("HttpService")
local TeleportService = game:GetService("TeleportService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer:FindFirstChildOfClass("PlayerGui") or LocalPlayer:WaitForChild("PlayerGui")

-- [Config System File Name]
local ConfigFileName = "Noxus_Config_AutoRun.json"

local Config = {
    AutoFruit = true,
    AutoStore = true,  -- ระบบออโต้เก็บผลเข้าคลัง (เปิดใช้งานอัตโนมัติ)
    AutoRejoin = true,
    LiteGraphics = true
}

local function LoadConfig()
    if pcall(function() return isfile and isfile(ConfigFileName) end) and isfile(ConfigFileName) then
        local success, decoded = pcall(function()
            return HttpService:JSONDecode(readfile(ConfigFileName))
        end)
        if success and type(decoded) == "table" then
            for k, v in pairs(decoded) do
                Config[k] = v
            end
        end
    end
end

local function SaveConfig()
    pcall(function()
        if writefile then
            writefile(ConfigFileName, HttpService:JSONEncode(Config))
        end
    end)
end

LoadConfig()

local ProtectedParent = (gethui and gethui()) or CoreGui

pcall(function()
    if ProtectedParent:FindFirstChild("NoxusAutoRunUI") then 
        ProtectedParent.NoxusAutoRunUI:Destroy() 
    end
end)

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "NoxusAutoRunUI"
ScreenGui.ResetOnSpawn = false
ScreenGui.Parent = ProtectedParent

local ClickSound = Instance.new("Sound")
ClickSound.SoundId = "rbxassetid://139658322785649"
ClickSound.Volume = 1
pcall(function() ClickSound.Parent = SoundService end)

local function playClickSound()
    pcall(function() ClickSound:Play() end)
end

local function sendNotification(title, text)
    pcall(function()
        local NotifHolder = ScreenGui:FindFirstChild("NotifHolder")
        if not NotifHolder then
            NotifHolder = Instance.new("Frame")
            NotifHolder.Name = "NotifHolder"
            NotifHolder.Size = UDim2.new(0, 240, 1, 0)
            NotifHolder.Position = UDim2.new(1, -250, 0, 15)
            NotifHolder.BackgroundTransparency = 1
            NotifHolder.Parent = ScreenGui
            
            local layout = Instance.new("UIListLayout")
            layout.SortOrder = Enum.SortOrder.LayoutOrder
            layout.Padding = UDim.new(0, 8)
            layout.Parent = NotifHolder
        end
        
        local NotifBox = Instance.new("Frame")
        NotifBox.Size = UDim2.new(1, 0, 0, 52)
        NotifBox.BackgroundColor3 = Color3.fromRGB(12, 14, 20)
        NotifBox.Position = UDim2.new(1, 50, 0, 0)
        NotifBox.BorderSizePixel = 0
        NotifBox.Parent = NotifHolder
        
        Instance.new("UICorner", NotifBox).CornerRadius = UDim.new(0, 12)
        local stroke = Instance.new("UIStroke", NotifBox)
        stroke.Color = Color3.fromRGB(0, 230, 255)
        stroke.Thickness = 1.8
        
        local TitleLabel = Instance.new("TextLabel", NotifBox)
        TitleLabel.Size = UDim2.new(1, -15, 0, 20)
        TitleLabel.Position = UDim2.new(0, 12, 0, 6)
        TitleLabel.BackgroundTransparency = 1
        TitleLabel.Text = title
        TitleLabel.TextColor3 = Color3.fromRGB(0, 240, 255)
        TitleLabel.TextSize = 13
        TitleLabel.Font = Enum.Font.FredokaOne
        TitleLabel.TextXAlignment = Enum.TextXAlignment.Left
        
        local DescLabel = Instance.new("TextLabel", NotifBox)
        DescLabel.Size = UDim2.new(1, -15, 0, 20)
        DescLabel.Position = UDim2.new(0, 12, 0, 26)
        DescLabel.BackgroundTransparency = 1
        DescLabel.Text = text
        DescLabel.TextColor3 = Color3.fromRGB(190, 210, 230)
        DescLabel.TextSize = 11
        DescLabel.Font = Enum.Font.GothamBold
        DescLabel.TextXAlignment = Enum.TextXAlignment.Left
        
        TweenService:Create(NotifBox, TweenInfo.new(0.3, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {Position = UDim2.new(0, 0, 0, 0)}):Play()
        
        task.delay(3, function()
            if NotifBox and NotifBox.Parent then
                local tweenOut = TweenService:Create(NotifBox, TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {Position = UDim2.new(1, 50, 0, 0)})
                tweenOut:Play()
                tweenOut.Completed:Connect(function() NotifBox:Destroy() end)
            end
        end)
    end)
end

local ToggleBtn = Instance.new("TextButton")
ToggleBtn.Size = UDim2.new(0, 52, 0, 52)
ToggleBtn.Position = UDim2.new(0, 20, 0, 20)
ToggleBtn.BackgroundColor3 = Color3.fromRGB(10, 12, 18)
ToggleBtn.Text = "N"
ToggleBtn.TextColor3 = Color3.fromRGB(0, 230, 255)
ToggleBtn.TextSize = 24
ToggleBtn.Font = Enum.Font.FredokaOne
ToggleBtn.Active = true
ToggleBtn.Draggable = true
ToggleBtn.BorderSizePixel = 0
Instance.new("UICorner", ToggleBtn).CornerRadius = UDim.new(0, 16)
local ToggleStroke = Instance.new("UIStroke", ToggleBtn)
ToggleStroke.Color = Color3.fromRGB(0, 180, 255)
ToggleStroke.Thickness = 2.5
ToggleBtn.Parent = ScreenGui

-- ขยายขนาดหน้าต่าง MainFrame ให้พอดีกับปุ่มใหม่ (สูง 280)
local MainFrame = Instance.new("Frame", ScreenGui)
MainFrame.Size = UDim2.new(0, 260, 0, 280)
MainFrame.Position = UDim2.new(0.5, -130, 0.5, -140)
MainFrame.BackgroundColor3 = Color3.fromRGB(12, 14, 20)
MainFrame.BorderSizePixel = 0
MainFrame.Active = true
MainFrame.Draggable = true
Instance.new("UICorner", MainFrame).CornerRadius = UDim.new(0, 18)
local MainStroke = Instance.new("UIStroke", MainFrame)
MainStroke.Color = Color3.fromRGB(0, 180, 255)
MainStroke.Thickness = 2

local TopBar = Instance.new("Frame", MainFrame)
TopBar.Size = UDim2.new(1, 0, 0, 42)
TopBar.BackgroundColor3 = Color3.fromRGB(16, 18, 26)
TopBar.BorderSizePixel = 0
Instance.new("UICorner", TopBar).CornerRadius = UDim.new(0, 18)

local HubTitle = Instance.new("TextLabel", TopBar)
HubTitle.Size = UDim2.new(1, -45, 1, 0)
HubTitle.Position = UDim2.new(0, 15, 0, 0)
HubTitle.BackgroundTransparency = 1
HubTitle.Text = "⚡ NOXUS | AUTO STORE"
HubTitle.TextColor3 = Color3.fromRGB(0, 230, 255)
HubTitle.TextSize = 11
HubTitle.Font = Enum.Font.FredokaOne
HubTitle.TextXAlignment = Enum.TextXAlignment.Left

local CloseBtn = Instance.new("TextButton", TopBar)
CloseBtn.Size = UDim2.new(0, 26, 0, 26)
CloseBtn.Position = UDim2.new(1, -34, 0, 8)
CloseBtn.BackgroundColor3 = Color3.fromRGB(220, 50, 60)
CloseBtn.Text = "✕"
CloseBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
CloseBtn.TextSize = 11
CloseBtn.Font = Enum.Font.GothamBold
CloseBtn.BorderSizePixel = 0
Instance.new("UICorner", CloseBtn).CornerRadius = UDim.new(0, 8)

CloseBtn.MouseButton1Click:Connect(function()
    playClickSound()
    MainFrame.Visible = false
end)

ToggleBtn.MouseButton1Click:Connect(function()
    playClickSound()
    MainFrame.Visible = not MainFrame.Visible
end)

local function makeBtn(posY, text, initialState)
    local btn = Instance.new("TextButton", MainFrame)
    btn.Size = UDim2.new(0, 220, 0, 36)
    btn.Position = UDim2.new(0.5, -110, 0, posY)
    btn.BackgroundColor3 = Color3.fromRGB(18, 21, 30)
    btn.Text = text .. ": " .. (initialState and "ON" or "OFF")
    btn.TextColor3 = initialState and Color3.fromRGB(0, 255, 120) or Color3.fromRGB(210, 225, 240)
    btn.TextSize = 11
    btn.Font = Enum.Font.GothamBold
    btn.BorderSizePixel = 0
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 10)
    return btn
end

-- สร้างปุ่มฟังก์ชันทั้งหมด
local FruitBtn = makeBtn(52, "Auto Teleport to Fruit", Config.AutoFruit)
local StoreBtn = makeBtn(98, "Auto Store Fruit", Config.AutoStore)
local RejoinBtnState = makeBtn(144, "Auto Rejoin / Anti-AFK", Config.AutoRejoin)
local ManualSaveBtn = makeBtn(190, "💾 Save Current Settings", true)

FruitBtn.MouseButton1Click:Connect(function()
    playClickSound()
    Config.AutoFruit = not Config.AutoFruit
    FruitBtn.Text = "Auto Teleport to Fruit: " .. (Config.AutoFruit and "ON" or "OFF")
    FruitBtn.TextColor3 = Config.AutoFruit and Color3.fromRGB(0, 255, 120) or Color3.fromRGB(210, 225, 240)
    SaveConfig()
    sendNotification("Config Saved", "Auto Fruit set to: " .. tostring(Config.AutoFruit))
end)

StoreBtn.MouseButton1Click:Connect(function()
    playClickSound()
    Config.AutoStore = not Config.AutoStore
    StoreBtn.Text = "Auto Store Fruit: " .. (Config.AutoStore and "ON" or "OFF")
    StoreBtn.TextColor3 = Config.AutoStore and Color3.fromRGB(0, 255, 120) or Color3.fromRGB(210, 225, 240)
    SaveConfig()
    sendNotification("Config Saved", "Auto Store set to: " .. tostring(Config.AutoStore))
end)

RejoinBtnState.MouseButton1Click:Connect(function()
    playClickSound()
    Config.AutoRejoin = not Config.AutoRejoin
    RejoinBtnState.Text = "Auto Rejoin / Anti-AFK: " .. (Config.AutoRejoin and "ON" or "OFF")
    RejoinBtnState.TextColor3 = Config.AutoRejoin and Color3.fromRGB(0, 255, 120) or Color3.fromRGB(210, 225, 240)
    SaveConfig()
    sendNotification("Config Saved", "Auto Rejoin set to: " .. tostring(Config.AutoRejoin))
end)

ManualSaveBtn.MouseButton1Click:Connect(function()
    playClickSound()
    SaveConfig()
    sendNotification("Success", "Configuration saved manually!")
end)

local vu = game:GetService("VirtualUser")
LocalPlayer.Idled:Connect(function()
    if Config.AutoRejoin then
        vu:Button2Down(Vector2.new(0,0), Workspace.CurrentCamera.CFrame)
        task.wait(1)
        vu:Button2Up(Vector2.new(0,0), Workspace.CurrentCamera.CFrame)
    end
end)

local promptOverlay = CoreGui:FindFirstChild("RobloxPromptGui")
if promptOverlay then
    promptOverlay.DescendantAdded:Connect(function(msg)
        if Config.AutoRejoin and (msg.Name == "ErrorTitle" or msg.Name == "NoticeText") then
            task.wait(3)
            TeleportService:Teleport(game.PlaceId, LocalPlayer)
        end
    end)
end

local activeTween = nil
RunService.RenderStepped:Connect(function()
    pcall(function()
        -- 1. ระบบบินไปเก็บผล (ความเร็ว 95)
        if Config.AutoFruit then
            local myChar = LocalPlayer.Character
            local myRoot = myChar and myChar:FindFirstChild("HumanoidRootPart")
            
            if myRoot and (not activeTween or activeTween.PlaybackState ~= Enum.PlaybackState.Playing) then
                local targetFruit = nil
                
                for _, obj in ipairs(Workspace:GetChildren()) do
                    if obj:IsA("Tool") and obj:FindFirstChild("Handle") then
                        targetFruit = obj.Handle
                        break
                    end
                end
                
                if not targetFruit then
                    for _, v in ipairs(Workspace:GetDescendants()) do
                        if v:IsA("BasePart") and (string.find(v.Name:lower(), "fruit") or v.Parent:IsA("Tool")) then
                            targetFruit = v
                            break
                        end
                    end
                end
                
                if targetFruit then
                    local targetCFrame = targetFruit.CFrame + Vector3.new(0, 4, 0)
                    local dist = (myRoot.Position - targetCFrame.Position).Magnitude
                    local speed = 95 -- ความเร็ว 95 ตามที่ขอ
                    local timeSec = math.clamp(dist / speed, 0.5, 15)
                    
                    if activeTween then activeTween:Cancel() end
                    activeTween = TweenService:Create(myRoot, TweenInfo.new(timeSec, Enum.EasingStyle.Linear), {CFrame = targetCFrame})
                    activeTween:Play()
                end
            end
        end

        -- 2. ระบบออโต้เก็บผลเข้าคลัง (ตรวจสอบไอเทมในกระเป๋าและส่งรีโมทเก็บเข้าคลัง)
        if Config.AutoStore then
            pcall(function()
                local backpack = LocalPlayer.Backpack
                local commF = ReplicatedStorage:FindFirstChild("Remotes") and ReplicatedStorage.Remotes:FindFirstChild("CommF_")
                
                if commF then
                    for _, item in ipairs(backpack:GetChildren()) do
                        if item:IsA("Tool") and item:FindFirstChild("Handle") then
                            -- ตรวจสอบชื่อหรือประเภทคร่าวๆ เพื่อเก็บเข้าคลัง
                            commF:InvokeServer("StoreFruit", item)
                        end
                    end
                    -- เช็คในตัวละครด้วยเผื่อถืออยู่
                    local char = LocalPlayer.Character
                    if char then
                        for _, item in ipairs(char:GetChildren()) do
                            if item:IsA("Tool") and item:FindFirstChild("Handle") then
                                commF:InvokeServer("StoreFruit", item)
                            end
                        end
                    end
                end
            end)
        end
    end)
end)

sendNotification("Noxus Hub", "Auto Store & Speed 95 Loaded!")
