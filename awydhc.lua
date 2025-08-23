local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")

local GodMode, AuraDamage, BoostStats = false, false, false
local AuraDamagePercent, AuraDamageRadius = 2, 10

local function applyGodMode()
    if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
        local h = LocalPlayer.Character.Humanoid
        h.MaxHealth = math.huge
        h.Health = h.MaxHealth
    end
end

local function applyAuraDamage()
    if not LocalPlayer.Character then return end
    local root = LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
    if not root then return end
    for _, p in pairs(Players:GetPlayers()) do
        if p ~= LocalPlayer and p.Character and p.Character:FindFirstChild("Humanoid") then
            local dist = (p.Character.HumanoidRootPart.Position - root.Position).Magnitude
            if dist <= AuraDamageRadius then
                local dmg = p.Character.Humanoid.MaxHealth * (AuraDamagePercent/100)
                p.Character.Humanoid:TakeDamage(dmg)
            end
        end
    end
end

local function applyBoostStats()
    if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
        local h = LocalPlayer.Character.Humanoid
        h.WalkSpeed = h.WalkSpeed * 10
        h.JumpPower = h.JumpPower * 10
    end
end

RunService.RenderStepped:Connect(function()
    if GodMode then applyGodMode() end
    if AuraDamage then applyAuraDamage() end
    if BoostStats then applyBoostStats() end
end)

local ScreenGui = Instance.new("ScreenGui", PlayerGui)
ScreenGui.ResetOnSpawn = false

local MainFrame = Instance.new("Frame", ScreenGui)
MainFrame.Size = UDim2.new(0, 260, 0, 230)
MainFrame.Position = UDim2.new(0.5,0,0.5,0)
MainFrame.AnchorPoint = Vector2.new(0.5,0.5)
MainFrame.BackgroundColor3 = Color3.fromRGB(20,20,20)
MainFrame.BorderSizePixel = 0
MainFrame.ClipsDescendants = true
MainFrame.Visible = false

local UIStroke = Instance.new("UIStroke", MainFrame)
UIStroke.Color = Color3.fromRGB(255,255,255)
UIStroke.Thickness = 1

local Title = Instance.new("TextLabel", MainFrame)
Title.Size = UDim2.new(1,0,0,30)
Title.Position = UDim2.new(0,0,0,0)
Title.BackgroundTransparency = 1
Title.Text = "AWY SCRIPTS"
Title.TextColor3 = Color3.fromRGB(255,255,255)
Title.Font = Enum.Font.GothamBold
Title.TextSize = 20

local MinButton = Instance.new("TextButton", MainFrame)
MinButton.Size = UDim2.new(0,35,0,30)
MinButton.Position = UDim2.new(1,-40,0,0)
MinButton.Text = "_"
MinButton.TextColor3 = Color3.fromRGB(255,255,255)
MinButton.BackgroundColor3 = Color3.fromRGB(60,60,60)

local isMinimized = false
MinButton.MouseButton1Click:Connect(function()
    isMinimized = not isMinimized
    local newSize = isMinimized and UDim2.new(0,160,0,40) or UDim2.new(0,260,0,230)
    TweenService:Create(MainFrame,TweenInfo.new(0.3,Enum.EasingStyle.Quad),{Size=newSize}):Play()
    Title.Text = isMinimized and "AWY SCRIPTS (Clique para Expandir)" or "AWY SCRIPTS"
end)

local function makeDraggable(frame)
    local dragging, dragInput, startPos, startMouse = false,nil,frame.Position,Vector2.new()
    frame.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType==Enum.UserInputType.Touch then
            dragging = true
            dragInput = input
            startPos = frame.Position
            startMouse = input.Position
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then dragging=false end
            end)
        end
    end)
    frame.InputChanged:Connect(function(input)
        if input.UserInputType==Enum.UserInputType.MouseMovement or input.UserInputType==Enum.UserInputType.Touch then
            dragInput = input
        end
    end)
    UserInputService.InputChanged:Connect(function(input)
        if dragging and input==dragInput then
            local delta = input.Position - startMouse
            frame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset+delta.X, startPos.Y.Scale, startPos.Y.Offset+delta.Y)
        end
    end)
end

makeDraggable(MainFrame)

local function applyPremiumEffect(uiElement)
    local glow = Instance.new("UIGradient", uiElement)
    glow.Color = ColorSequence.new{
        ColorSequenceKeypoint.new(0, Color3.fromRGB(0,255,255)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(0,180,255))
    }
    glow.Rotation = 45
    local shadow = Instance.new("UIPadding", uiElement)
    shadow.PaddingTop = UDim.new(0,2)
    shadow.PaddingBottom = UDim.new(0,2)
    shadow.PaddingLeft = UDim.new(0,2)
    shadow.PaddingRight = UDim.new(0,2)
    local uicorner = Instance.new("UICorner", uiElement)
    uicorner.CornerRadius = UDim.new(0,6)
end

local function createToggle(name,posY,callback)
    local btn = Instance.new("TextButton",MainFrame)
    btn.Size = UDim2.new(0,220,0,35)
    btn.Position = UDim2.new(0,20,0,posY)
    btn.Text = name..": OFF"
    btn.BackgroundColor3 = Color3.fromRGB(150,0,0)
    btn.TextColor3 = Color3.fromRGB(255,255,255)
    btn.Font = Enum.Font.Gotham
    btn.TextSize = 16
    btn.AutoButtonColor = false
    applyPremiumEffect(btn)
    local state=false
    local function updateColor()
        local color = state and Color3.fromRGB(0,180,0) or Color3.fromRGB(150,0,0)
        TweenService:Create(btn,TweenInfo.new(0.2),{BackgroundColor3=color}):Play()
    end
    btn.MouseEnter:Connect(function()
        TweenService:Create(btn,TweenInfo.new(0.15),{BackgroundColor3=Color3.fromRGB(180,30,30)}):Play()
    end)
    btn.MouseLeave:Connect(function() updateColor() end)
    btn.MouseButton1Click:Connect(function()
        state = not state
        btn.Text = name..(state and ": ON" or ": OFF")
        updateColor()
        callback(state)
    end)
end

createToggle("God Mode",50,function(s) GodMode=s end)
createToggle("Aura Damage",95,function(s) AuraDamage=s end)
createToggle("Boost Stats x10",140,function(s) BoostStats=s end)

local function createSlider(name,posY,min,max,default,callback)
    local label = Instance.new("TextLabel",MainFrame)
    label.Size = UDim2.new(0,220,0,20)
    label.Position = UDim2.new(0,20,0,posY)
    label.BackgroundTransparency = 1
    label.Text = name..": "..default
    label.TextColor3 = Color3.fromRGB(255,255,255)
    label.Font = Enum.Font.Gotham
    label.TextSize = 14
    local bar = Instance.new("Frame",MainFrame)
    bar.Size = UDim2.new(0,220,0,12)
    bar.Position = UDim2.new(0,20,0,posY+20)
    bar.BackgroundColor3 = Color3.fromRGB(50,50,50)
    bar.ClipsDescendants = true
    applyPremiumEffect(bar)
    local handle = Instance.new("Frame",bar)
    handle.Size = UDim2.new(0,20,1,0)
    handle.Position = UDim2.new((default-min)/(max-min),0,0,0)
    handle.BackgroundColor3 = Color3.fromRGB(0,150,255)
    handle.AnchorPoint = Vector2.new(0.5,0.5)
    handle.Position = UDim2.new((default-min)/(max-min),0,0.5,0)
    applyPremiumEffect(handle)
    local dragging=false
    handle.InputBegan:Connect(function(input)
        if input.UserInputType==Enum.UserInputType.MouseButton1 or input.UserInputType==Enum.UserInputType.Touch then dragging=true end
    end)
    handle.InputEnded:Connect(function(input)
        if input.UserInputType==Enum.UserInputType.MouseButton1 or input.UserInputType==Enum.UserInputType.Touch then dragging=false end
    end)
    UserInputService.InputChanged:Connect(function(input)
        if dragging and (input.UserInputType==Enum.UserInputType.MouseMovement or input.UserInputType==Enum.UserInputType.Touch) then
            local pos = math.clamp((input.Position.X-bar.AbsolutePosition.X)/bar.AbsoluteSize.X,0,1)
            TweenService:Create(handle,TweenInfo.new(0.1),{Position=UDim2.new(pos,0,0.5,0)}):Play()
            local value = math.floor(min + pos*(max-min))
            label.Text = name..": "..value
            callback(value)
        end
    end)
end

createSlider("Dano %",175,2,5,2,function(v) AuraDamagePercent=v end)
createSlider("Raio",210,10,40,10,function(v) AuraDamageRadius=v end)

MainFrame.Position = UDim2.new(0.5,0,-0.5,0)
MainFrame.Visible = true
TweenService:Create(MainFrame,TweenInfo.new(0.5,Enum.EasingStyle.Quad),{Position=UDim2.new(0.5,0,0.5,0)}):Play()

RunService.RenderStepped:Connect(function()
    for _, child in pairs(MainFrame:GetChildren()) do
        if child:IsA("TextButton") then
            local c = child.BackgroundColor3
            local r = math.sin(tick()*2)*0.1
            child.BackgroundColor3 = Color3.new(
                math.clamp(c.R + r,0,1),
                math.clamp(c.G + r,0,1),
                math.clamp(c.B + r,0,1)
            )
        end
    end
end)