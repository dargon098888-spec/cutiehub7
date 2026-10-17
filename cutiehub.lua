--[[\
    Script Name: Cutie Hub V3 (Complete & Stable)
    Features: Minimize/Open Button, Maru Notification, Hitbox (1-100), ESP, Aimbot, Clay Graphics V3
]]--

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local CoreGui = game:GetService("CoreGui")
local Workspace = game:GetService("Workspace")
local TweenService = game:GetService("TweenService")
local LocalPlayer = Players.LocalPlayer
local Camera = Workspace.CurrentCamera
local PlayerGui = LocalPlayer:FindFirstChildOfClass("PlayerGui") or LocalPlayer:WaitForChild("PlayerGui")

pcall(function()
    if CoreGui:FindFirstChild("CutieHub_UI") then CoreGui.CutieHub_UI:Destroy() end
    if PlayerGui:FindFirstChild("CutieHub_UI") then PlayerGui.PlayerGui.CutieHub_UI:Destroy() end
end)

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "CutieHub_UI"
ScreenGui.ResetOnSpawn = false
pcall(function() ScreenGui.Parent = CoreGui end)
if not ScreenGui.Parent then ScreenGui.Parent = PlayerGui end

-- ระบบแจ้งเตือนสไตล์ Maru Hub
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
                tweenOut.Completed:Connect(function() NotifBox:Destroy() end)
            end
        end)
    end)
end

-- สร้างหน้าต่างหลัก
local MainFrame = Instance.new("Frame")
MainFrame.Size = UDim2.new(0, 260, 0, 310)
MainFrame.Position = UDim2.new(0.5, -130, 0.5, -155)
MainFrame.BackgroundColor3 = Color3.fromRGB(250, 250, 255)
MainFrame.BorderSizePixel = 0
MainFrame.Active = true
MainFrame.Draggable = true
MainFrame.Parent = ScreenGui

local MainCorner = Instance.new("UICorner")
MainCorner.CornerRadius = UDim.new(0, 16)
MainCorner.Parent = MainFrame

local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, 0, 0, 38)
Title.BackgroundColor3 = Color3.fromRGB(240, 235, 250)
Title.Text = "  ✨ Cutie Hub V3 ✨"
Title.TextColor3 = Color3.fromRGB(30, 25, 40)
Title.TextSize = 15
Title.Font = Enum.Font.FredokaOne
Title.TextXAlignment = Enum.TextXAlignment.Left
Title.BorderSizePixel = 0
Title.Parent = MainFrame

local TitleCorner = Instance.new("UICorner")
TitleCorner.CornerRadius = UDim.new(0, 16)
TitleCorner.Parent = Title

-- ปุ่ม Minimize (-)
local MinimizeBtn = Instance.new("TextButton")
MinimizeBtn.Size = UDim2.new(0, 26, 0, 26)
MinimizeBtn.Position = UDim2.new(1, -62, 0, 6)
MinimizeBtn.BackgroundColor3 = Color3.fromRGB(225, 220, 240)
MinimizeBtn
