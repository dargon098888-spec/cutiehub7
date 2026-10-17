--[[\
    Script Name: Noxus Apex Hub | Blox Fruits [Masterpiece Edition]
    Features: Next-Gen Cyber UI, High-Altitude Safe Tween Flight, Smart Tool Handling, Fast Attack, Hitbox, ESP
]]--

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local CoreGui = game:GetService("CoreGui")
local Workspace = game:GetService("Workspace")
local TweenService = game:GetService("TweenService")
local SoundService = game:GetService("SoundService")
local Lighting = game:GetService("Lighting")
local VirtualUser = game:GetService("VirtualUser")
local Terrain = Workspace:FindFirstChildOfClass("Terrain")
local LocalPlayer = Players.LocalPlayer
local Camera = Workspace.CurrentCamera
local PlayerGui = LocalPlayer:FindFirstChildOfClass("PlayerGui") or LocalPlayer:WaitForChild("PlayerGui")

-- Registry สำหรับจัดการ Connection ป้องกัน Memory Leak
local ActiveConnections = {}
local function RegisterConnection(conn)
    table.insert(ActiveConnections, conn)
    return conn
end

local function Cleanup()
    for _, conn in ipairs(ActiveConnections) do
        if conn and typeof(conn) == "RBXScriptConnection" then
            conn:Disconnect()
        end
    end
    table.clear(ActiveConnections)
end

-- Safe UI Cleanup
pcall(function()
    Cleanup()
    if CoreGui:FindFirstChild("NoxusApexUI") then CoreGui.NoxusApexUI:Destroy() end
    if PlayerGui:FindFirstChild("NoxusApexUI") then PlayerGui.PlayerGui.NoxusApexUI:Destroy() end
end)

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "NoxusApexUI"
ScreenGui.ResetOnSpawn = false
pcall(function() ScreenGui.Parent = CoreGui end)
if not ScreenGui.Parent then ScreenGui.Parent = PlayerGui end

-- Click Sound Effect
local ClickSound = Instance.new("Sound")
ClickSound.SoundId = "rbxassetid://139658322785649"
ClickSound.Volume = 1
ClickSound.Parent = SoundService

local function playClickSound()
    pcall(function() ClickSound:Play() end)
end

-- Premium Notification
local function sendNotification(title, text)
    pcall(function()
        local NotifHolder = ScreenGui:FindFirstChild("NotifHolder")
        if not NotifHolder then
            NotifHolder = Instance.new("Frame")
            NotifHolder.Name = "NotifHolder"
            NotifHolder.Size = UDim2.new(0, 280, 1, 0)
            NotifHolder.Position = UDim2.new(1, -290, 0, 15)
            NotifHolder.BackgroundTransparency = 1
            NotifHolder.Parent = ScreenGui
            
            local layout = Instance.new("UIListLayout")
            layout.SortOrder = Enum.SortOrder.LayoutOrder
            layout.Padding = UDim.new(0, 8)
            layout.Parent = NotifHolder
        end
        
        local NotifBox = Instance.new("Frame")
        NotifBox.Size = UDim2.new(1, 0, 0, 52)
        NotifBox.BackgroundColor3 = Color3.fromRGB(12, 14, 22)
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
        DescLabel.TextColor3 = Color3.fromRGB(200, 215, 235)
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

-- Floating Logo Button
local ToggleBtn = Instance.new("TextButton", ScreenGui)
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

-- Main Frame (Apex Next-Gen UI)
local MainFrame = Instance.new("Frame", ScreenGui)
MainFrame.Size = UDim2.new(0, 500, 0, 320)
MainFrame.Position = UDim2.new(0.5, -250, 0.5, -160)
MainFrame.BackgroundColor3 = Color3.fromRGB(14, 16, 24)
MainFrame.BorderSizePixel = 0
MainFrame.Active = true
MainFrame.Draggable = true
Instance.new("UICorner", MainFrame).CornerRadius = UDim.new(0, 18)
local MainStroke = Instance.new("UIStroke", MainFrame)
MainStroke.Color = Color3.fromRGB(0, 180, 255)
MainStroke.Thickness = 2

-- Top Bar Header
local TopBar = Instance.new("Frame", MainFrame)
TopBar.Size = UDim2.new(1, 0, 0, 42)
TopBar.BackgroundColor3 = Color3.fromRGB(18, 20, 30)
TopBar.BorderSizePixel = 0
Instance.new("UICorner", TopBar).CornerRadius = UDim.new(0, 18)

local HubTitle = Instance.new("TextLabel", TopBar)
HubTitle.Size = UDim2.new(0, 380, 1, 0)
HubTitle.Position = UDim2.new(0, 15, 0, 0)
HubTitle.BackgroundTransparency = 1
HubTitle.Text = "⚡ NOXUS APEX HUB | BLOX FRUITS [MASTERPIECE]"
HubTitle.TextColor3 = Color3.fromRGB(0, 230, 255)
HubTitle.TextSize = 11
HubTitle.Font = Enum.Font.FredokaOne
HubTitle.TextXAlignment = Enum.TextXAlignment.Left

local CloseBtn = Instance.new("TextButton", TopBar)
CloseBtn.Size = UDim2.new(0, 26, 0, 26)
CloseBtn.Position = UDim2.new(1, -36, 0, 8)
CloseBtn.BackgroundColor3 = Color3.fromRGB(220, 50, 60)
CloseBtn.Text = "✕"
CloseBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
CloseBtn.TextSize = 11
CloseBtn.Font = Enum.Font.GothamBold
CloseBtn.BorderSizePixel = 0
Instance.new("UICorner", CloseBtn).CornerRadius = UDim.new(0, 8)

RegisterConnection(CloseBtn.MouseButton1Click:Connect(function()
    playClickSound()
    MainFrame.Visible = false
end))

RegisterConnection(ToggleBtn.MouseButton1Click:Connect(function()
    playClickSound()
    MainFrame.Visible = not MainFrame.Visible
end))

-- Sidebar Tabs
local Sidebar = Instance.new("Frame", MainFrame)
Sidebar.Size = UDim2.new(0, 130, 1, -42)
Sidebar.Position = UDim2.new(0, 0, 0, 42)
Sidebar.BackgroundColor3 = Color3.fromRGB(16, 18, 26)
Sidebar.BorderSizePixel = 0

local SidebarLayout = Instance.new("UIListLayout", Sidebar)
SidebarLayout.SortOrder = Enum.SortOrder.LayoutOrder
SidebarLayout.Padding = UDim.new(0, 5)

-- Content Pages Container
local Container = Instance.new("Frame", MainFrame)
Container.Size = UDim2.new(1, -135, 1, -50)
Container.Position = UDim2.new(0, 135, 0, 46)
Container.BackgroundTransparency = 1

local pages = {}
local function createPage(name)
    local page = Instance.new("ScrollingFrame", Container)
    page.Size = UDim2.new(1, 0, 1, 0)
    page.BackgroundTransparency = 1
    page.Visible = false
    page.CanvasSize = UDim2.new(0, 0, 0, 350)
    page.ScrollBarThickness = 3
    
    local layout = Instance.new("UIListLayout", page)
    layout.SortOrder = Enum.SortOrder.LayoutOrder
    layout.Padding = UDim.new(0, 6)
    
    pages[name] = page
    return page
end

local farmPage = createPage("Farm")
local combatPage = createPage("Combat")
local telePage = createPage("Teleport")
local visualPage = createPage("Visuals")

local function showPage(name)
    for pName, pObj in pairs(pages) do
        pObj.Visible = (pName == name)
    end
end
showPage("Farm")

local function createTab(text, targetPage)
    local btn = Instance.new("TextButton", Sidebar)
    btn.Size = UDim2.new(1, -10, 0, 34)
    btn.BackgroundColor3 = Color3.fromRGB(22, 25, 36)
    btn.Text = text
    btn.TextColor3 = Color3.fromRGB(180, 195, 215)
    btn.TextSize = 11
    btn.Font = Enum.Font.GothamBold
    btn.BorderSizePixel = 0
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 8)
    
    RegisterConnection(btn.MouseButton1Click:Connect(function()
        playClickSound()
        showPage(targetPage)
    end))
end

createTab("🌾 Auto Farm", "Farm")
createTab("⚔️ Combat", "Combat")
createTab("🌍 Teleport", "Teleport")
createTab("⚙️ Visuals / FPS", "Visuals")

-- Component Builders
local function makeToggle(parent, text, callback)
    local btn = Instance.new("TextButton", parent)
    btn.Size = UDim2.new(1, -5, 0, 35)
    btn.BackgroundColor3 = Color3.fromRGB(20, 23, 32)
    btn.Text = text .. ": OFF"
    btn.TextColor3 = Color3.fromRGB(220, 230, 245)
    btn.TextSize = 11
    btn.Font = Enum.Font.GothamBold
    btn.BorderSizePixel = 0
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 8)
    
    local state = false
    RegisterConnection(btn.MouseButton1Click:Connect(function()
        playClickSound()
        state = not state
        btn.Text = text .. ": " .. (state and "ON" or "OFF")
        btn.TextColor3 = state and Color3.fromRGB(0, 255, 120) or Color3.fromRGB(220, 230, 245)
        callback(state)
    end))
    return btn
end

local function makeBox(parent, placeholder, callback)
    local box = Instance.new("TextBox", parent)
    box.Size = UDim2.new(1, -5, 0, 34)
    box.BackgroundColor3 = Color3.fromRGB(20, 23, 32)
    box.Text = ""
    box.TextColor3 = Color3.fromRGB(0, 230, 255)
    box.PlaceholderText = placeholder
    box.PlaceholderColor3 = Color3.fromRGB(120, 135, 155)
    box.TextSize = 11
    box.Font = Enum.Font.GothamBold
    box.BorderSizePixel = 0
    box.ClearTextOnFocus = false
    Instance.new("UICorner", box).CornerRadius = UDim.new(0, 8)
    
    RegisterConnection(box.FocusLost:Connect(function()
        playClickSound()
        callback(box.Text)
    end))
    return box
end

-- ==================== 1. FARM PAGE ====================
local autoFarmOn = false
local fastAttackOn = false

makeToggle(farmPage, "Auto Farm (Safe High-Flight)", function(v)
    autoFarmOn = v
    sendNotification("Auto Farm", v and "Apex High-Altitude Farm Active" or "Stopped")
end)

makeToggle(farmPage, "Fast Attack Boost", function(v)
    fastAttackOn = v
    sendNotification("Fast Attack", v and "Hyper-Speed Strikes Active" or "Disabled")
end)

-- ==================== 2. COMBAT PAGE ====================
local hitboxOn, espOn, aimbotOn = false, false, false
local hitboxSize = 5

makeToggle(combatPage, "Hitbox Extender", function(v)
    hitboxOn = v
    sendNotification("Hitbox", v and "Activated" or "Deactivated")
end)

makeBox(combatPage, "Hitbox Size (1-100)", function(txt)
    local num = tonumber(txt)
    if num then
        hitboxSize = math.clamp(math.floor(num), 1, 100)
        sendNotification("Hitbox Size", tostring(hitboxSize))
    end
end)

makeToggle(combatPage, "Player Box ESP", function(v)
    espOn = v
    sendNotification("ESP", v and "Activated" or "Deactivated")
end)

makeToggle(combatPage, "Camera Aimbot", function(v)
    aimbotOn = v
    sendNotification("Aimbot", v and "Activated" or "Deactivated")
end)

-- ==================== 3. TELEPORT PAGE ====================
local function addTpButton(name, cf)
    local btn = Instance.new("TextButton", telePage)
    btn.Size = UDim2.new(1, -5, 0, 35)
    btn.BackgroundColor3 = Color3.fromRGB(20, 23, 32)
    btn.Text = "📍 Teleport to " .. name
    btn.TextColor3 = Color3.fromRGB(220, 230, 245)
    btn.TextSize = 11
    btn.Font = Enum.Font.GothamBold
    btn.BorderSizePixel = 0
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 8)
    
    RegisterConnection(btn.MouseButton1Click:Connect(function()
        playClickSound()
        pcall(function()
            LocalPlayer.Character.HumanoidRootPart.CFrame = cf
            sendNotification("Teleport", "Moved to " .. name)
        end)
    end))
end

addTpButton("Safe Zone / Cafe", CFrame.new(386, 73, 316))
addTpButton("Marine Fortress", CFrame.new(-4513, 20, 4376))
addTpButton("Underwater City", CFrame.new(61123, 18, 1569))

-- ==================== 4. VISUALS / FPS PAGE ====================
local potatoOn = false

makeToggle(visualPage, "Potato Graphics (ดินน้ำมัน)", function(v)
    potatoOn = v
    sendNotification("Graphics", v and "Apex Potato Engine Enabled (Zero Lag)" or "Normal Graphics")
    pcall(function()
        if v then
            Lighting.GlobalShadows = false
            Lighting.FogEnd = 999999
            if Terrain then
                Terrain.WaterWaveSize = 0
                Terrain.WaterWaveSpeed = 0
            end
            for _, obj in ipairs(Workspace:GetDescendants()) do
                if obj:IsA("BasePart") then
                    obj.Material = Enum.Material.SmoothPlastic
                    obj.Reflectance = 0
                elseif obj:IsA("Decal") or obj:IsA("Texture") then
                    obj.Transparency = 1
                end
            end
        else
            Lighting.GlobalShadows = true
        end
    end)
end)

local RejoinBtn = Instance.new("TextButton", visualPage)
RejoinBtn.Size = UDim2.new(1, -5, 0, 35)
RejoinBtn.BackgroundColor3 = Color3.fromRGB(220, 60, 70)
RejoinBtn.Text = "🔄 Rejoin Server"
RejoinBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
RejoinBtn.TextSize = 11
RejoinBtn.Font = Enum.Font.GothamBold
RejoinBtn.BorderSizePixel = 0
Instance.new("UICorner", RejoinBtn).CornerRadius = UDim.new(0, 8)

RegisterConnection(RejoinBtn.MouseButton1Click:Connect(function()
    playClickSound()
    pcall(function()
        game:GetService("TeleportService"):TeleportToPlaceInstance(game.PlaceId, game.JobId, LocalPlayer)
    end)
end))

-- ==================== APEX MASTER CORE LOOP ====================
local currentTween = nil

RegisterConnection(RunService.RenderStepped:Connect(function()
    pcall(function()
        -- 1. High-Altitude Safe Tween Flight Engine (Fixed low flying bug)
        if autoFarmOn then
            local char = LocalPlayer.Character
            local hrp = char and char:FindFirstChild("HumanoidRootPart")
            local humanoid = char and char:FindFirstChildOfClass("Humanoid")
            local enemiesFolder = Workspace:FindFirstChild("Enemies")
            
            if hrp and humanoid and humanoid.Health > 0 and enemiesFolder then
                local targetEnemy = nil
                for _, enemy in ipairs(enemiesFolder:GetChildren()) do
                    local eHrp = enemy:FindFirstChild("HumanoidRootPart")
                    local eHum = enemy:FindFirstChildOfClass("Humanoid")
                    if eHrp and eHum and eHum.Health > 0 then
                        targetEnemy = eHrp
                        break
                    end
                end
                
                if targetEnemy then
                    -- บินลอยสูงขึ้นไป 28 หน่วยเหนือหัวมอนสเตอร์ ปลอดภัยจากการโดนโจมตีระยะประชิด
                    local targetCFrame = targetEnemy.CFrame + Vector3.new(0, 28, 0)
                    local dist = (hrp.Position - targetCFrame.Position).Magnitude
                    local speed = 320
                    local timeSec = dist / speed
                    
                    if not currentTween or currentTween.PlaybackState ~= Enum.PlaybackState.Playing then
                        if currentTween then currentTween:Cancel() end
                        currentTween = TweenService:Create(hrp, TweenInfo.new(timeSec, Enum.EasingStyle.Linear), {CFrame = targetCFrame})
                        currentTween:Play()
                    end
                    
                    -- บังคับถืออาวุธและจำลองการโจมตี
                    for _, tool in ipairs(LocalPlayer.Backpack:GetChildren()) do
                        if tool:IsA("Tool") then
                            tool.Parent = char
                        end
                    end
                    VirtualUser:Button1Down(Vector2.new(0,0))
                else
                    if currentTween then currentTween:Cancel() end
                end
            end
        else
            if currentTween then 
                currentTween:Cancel() 
                currentTween = nil 
            end
        end

        -- 2. Fast Attack Boost Logic
        if fastAttackOn then
            pcall(function()
                VirtualUser:Button1Down(Vector2.new(0,0))
                task.wait()
                VirtualUser:Button1Up(Vector2.new(0,0))
            end)
        end

        -- 3. Hitbox Extender Engine
        if hitboxOn then
            for _, p in ipairs(Players:GetPlayers()) do
                if p ~= LocalPlayer and p.Character then
                    local pHrp = p.Character:FindFirstChild("HumanoidRootPart")
                    if pHrp then
                        pHrp.Size = Vector3.new(hitboxSize, hitboxSize, hitboxSize)
                        pHrp.Transparency = 0.5
                        pHrp.CanCollide = false
                    end
                end
            end
        end

        -- 4. ESP Box Engine
        if espOn then
            for _, p in ipairs(Players:GetPlayers()) do
                if p ~= LocalPlayer and p.Character then
                    local pChar = p.Character
                    if not pChar:FindFirstChild("NoxusApexESP") then
                        local hl = Instance.new("Highlight", pChar)
                        hl.Name = "NoxusApexESP"
                        hl.FillColor = Color3.fromRGB(0, 230, 255)
                        hl.OutlineColor = Color3.fromRGB(255, 255, 255)
                        hl.FillTransparency = 0.5
                    end
                end
            end
        else
            for _, p in ipairs(Players:GetPlayers()) do
                if p.Character and p.Character:FindFirstChild("NoxusApexESP") then
                    p.Character.NoxusApexESP:Destroy()
                end
            end
        end
    end)
end))

sendNotification("Noxus Hub", "Apex Masterpiece Edition Loaded Successfully!")
