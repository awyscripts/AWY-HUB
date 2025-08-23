local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")

local GodMode, AuraDamage = false, false
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

RunService.RenderStepped:Connect(function()
    if GodMode then applyGodMode() end
    if AuraDamage then applyAuraDamage() end
end)

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Parent = PlayerGui

local MainFrame = Instance.new("Frame")
MainFrame.Size = UDim2.new(0, 260, 0, 230)
MainFrame.Position = UDim2.new(0.5,0,0.5,0)
MainFrame.AnchorPoint = Vector2.new(0.5,0.5)
MainFrame.BackgroundColor3 = Color3.fromRGB(20,20,20)
MainFrame.BorderSizePixel = 0
MainFrame.Parent = ScreenGui

local Title = Instance.new("TextLabel", MainFrame)
Title.Size = UDim2.new(1,0,0,30)
Title.Position = UDim2.new(0,0,0,0)
Title.BackgroundTransparency = 1
Title.Text = "AWY SCRIPTS"
Title.TextColor3 = Color3.fromRGB(255,255,255)
Title.Font = Enum.Font.GothamBold
Title.TextSize = 20

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
    local state=false
    btn.MouseButton1Click:Connect(function()
        state = not state
        btn.Text = name..(state and ": ON" or ": OFF")
        btn.BackgroundColor3 = state and Color3.fromRGB(0,180,0) or Color3.fromRGB(150,0,0)
        callback(state)
    end)
end

createToggle("God Mode",50,function(s) GodMode=s end)
createToggle("Aura Damage",95,function(s) AuraDamage=s end)

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

    local handle = Instance.new("Frame",bar)
    handle.Size = UDim2.new(0,20,1,0)
    handle.Position = UDim2.new((default-min)/(max-min),0,0,0)
    handle.BackgroundColor3 = Color3.fromRGB(0,150,255)
    handle.AnchorPoint = Vector2.new(0.5,0.5)

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
            handle.Position = UDim2.new(pos,0,0.5,0)
            local value = math.floor(min + pos*(max-min))
            label.Text = name..": "..value
            callback(value)
        end
    end)
end

createSlider("Dano %",175,2,5,2,function(v) AuraDamagePercent=v end)
createSlider("Raio",210,10,40,10,function(v) AuraDamageRadius=v end)
