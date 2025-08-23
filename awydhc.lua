local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local LocalPlayer = Players.LocalPlayer

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Parent = game:GetService("CoreGui")

local MainFrame = Instance.new("Frame")
MainFrame.Size = UDim2.new(0, 300, 0, 200)
MainFrame.Position = UDim2.new(0.5, -150, 0.5, -100)
MainFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
MainFrame.BorderSizePixel = 0
MainFrame.Parent = ScreenGui

local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, 0, 0, 30)
Title.BackgroundTransparency = 1
Title.Text = "Kill Aura"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.Font = Enum.Font.SourceSansBold
Title.TextSize = 20
Title.Parent = MainFrame

local KillAuraToggle = Instance.new("TextButton")
KillAuraToggle.Size = UDim2.new(0, 120, 0, 40)
KillAuraToggle.Position = UDim2.new(0, 10, 0, 50)
KillAuraToggle.Text = "Kill Aura: OFF"
KillAuraToggle.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
KillAuraToggle.TextColor3 = Color3.fromRGB(255, 255, 255)
KillAuraToggle.Font = Enum.Font.SourceSans
KillAuraToggle.TextSize = 16
KillAuraToggle.Parent = MainFrame

local KillAuraEnabled = false

KillAuraToggle.MouseButton1Click:Connect(function()
    KillAuraEnabled = not KillAuraEnabled
    KillAuraToggle.Text = "Kill Aura: " .. (KillAuraEnabled and "ON" or "OFF")
end)

local function KillAura()
    while RunService.RenderStepped:Wait() do
        if KillAuraEnabled then
            for _, enemy in pairs(workspace:GetChildren()) do
                if enemy:IsA("Model") and enemy:FindFirstChild("Humanoid") and enemy ~= LocalPlayer.Character then
                    local distance = (enemy.HumanoidRootPart.Position - LocalPlayer.Character.HumanoidRootPart.Position).Magnitude
                    if distance <= 50 then
                        enemy.Humanoid:TakeDamage(1000000)
                    end
                end
            end
        end
    end
end

spawn(KillAura)
