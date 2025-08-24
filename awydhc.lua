local ScreenGui = Instance.new("ScreenGui", PlayerGui)
ScreenGui.ResetOnSpawn = false

local MainFrame = Instance.new("Frame", ScreenGui)
MainFrame.Size = UDim2.new(0, 300, 0, 150)
MainFrame.Position = UDim2.new(0.5,0,0.5,0)
MainFrame.AnchorPoint = Vector2.new(0.5,0.5)
MainFrame.BackgroundColor3 = Color3.fromRGB(20,20,20)
MainFrame.BorderSizePixel = 0

local TitleBar = Instance.new("Frame", MainFrame)
TitleBar.Size = UDim2.new(1,0,0,30)
TitleBar.Position = UDim2.new(0,0,0,0)
TitleBar.BackgroundColor3 = Color3.fromRGB(40,40,40)

local TitleLabel = Instance.new("TextLabel", TitleBar)
TitleLabel.Size = UDim2.new(1, -60, 1, 0)
TitleLabel.Position = UDim2.new(0,0,0,0)
TitleLabel.BackgroundTransparency = 1
TitleLabel.Text = "AWY SCRIPTS"
TitleLabel.TextColor3 = Color3.fromRGB(255,255,255)
TitleLabel.Font = Enum.Font.GothamBold
TitleLabel.TextSize = 16
TitleLabel.TextXAlignment = Enum.TextXAlignment.Left
TitleLabel.TextYAlignment = Enum.TextYAlignment.Center
TitleLabel.PaddingLeft = UDim.new(0, 10)

local MinButton = Instance.new("TextButton", TitleBar)
MinButton.Size = UDim2.new(0,25,0,25)
MinButton.Position = UDim2.new(1,-55,0,2)
MinButton.Text = "_"
MinButton.TextColor3 = Color3.fromRGB(255,255,255)
MinButton.BackgroundColor3 = Color3.fromRGB(80,80,80)
MinButton.Font = Enum.Font.GothamBold
MinButton.TextSize = 18

local CloseButton = Instance.new("TextButton", TitleBar)
CloseButton.Size = UDim2.new(0,25,0,25)
CloseButton.Position = UDim2.new(1,-25,0,2)
CloseButton.Text = "X"
CloseButton.TextColor3 = Color3.fromRGB(255,255,255)
CloseButton.BackgroundColor3 = Color3.fromRGB(150,0,0)
CloseButton.Font = Enum.Font.GothamBold
CloseButton.TextSize = 18

local isMinimized = false
MinButton.MouseButton1Click:Connect(function()
    isMinimized = not isMinimized
    MainFrame.Size = isMinimized and UDim2.new(0,300,0,30) or UDim2.new(0,300,0,150)
end)

CloseButton.MouseButton1Click:Connect(function()
    ScreenGui:Destroy()
end)

local function makeDraggable(frame)
    local dragging, dragInput, startPos, startMouse = false,nil,frame.Position,Vector2.new()
    frame.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
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
        if input.UserInputType==Enum.UserInputType.MouseMovement then
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

makeDraggable(TitleBar)

local function applyPremiumEffect(uiElement)
    local glow = Instance.new("UIGradient", uiElement)
    glow.Color = ColorSequence.new{
        ColorSequenceKeypoint.new(0, Color3.fromRGB(0,255,255)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(0,180,255))
    }
    glow.Rotation = 45
    local uicorner = Instance.new("UICorner", uiElement)
    uicorner.CornerRadius = UDim.new(0,6)
end

local function createToggle(name,posY,callback)
    local btn = Instance.new("TextButton",MainFrame)
    btn.Size = UDim2.new(0,260,0,35)
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
        btn.BackgroundColor3=color
    end
    btn.MouseButton1Click:Connect(function()
        state = not state
        btn.Text = name..(state and ": ON" or ": OFF")
        updateColor()
        callback(state)
    end)
end

createToggle("God Mode",50,function(s) GodMode=s end)
createToggle("Aura Damage",95,function(s) 
    AuraDamage=s 
    AuraDamagePercent = 500000
    AuraDamageRadius = 100
end)
createToggle("Boost Stats x10",140,function(s) BoostStats=s end)
