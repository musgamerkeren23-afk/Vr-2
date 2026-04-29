local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")

local player = Players.LocalPlayer
local camera = workspace.CurrentCamera

-- Fix First Person
player.CameraMode = Enum.CameraMode.LockFirstPerson

local HAND_MESH_ID = "rbxassetid://6340141840"
local leftJoyX, leftJoyY = 0, 0
local rightJoyX, rightJoyY = 0, 0
local vrEnabled = true

local leftHandOffset = CFrame.new(-1.5, -1.5, -2)
local rightHandOffset = CFrame.new(1.5, -1.5, -2)

-- ══════════════════════════════
--         CREATE HANDS
-- ══════════════════════════════

local function createHand(name)
    local hand = Instance.new("Part")
    hand.Name = name
    hand.Size = Vector3.new(1, 1, 1)
    hand.CanCollide = false
    hand.Anchored = true
    hand.CastShadow = false
    hand.Color = Color3.fromRGB(255, 220, 177)
    hand.Material = Enum.Material.SmoothPlastic
    hand.Parent = workspace

    local mesh = Instance.new("SpecialMesh")
    mesh.MeshType = Enum.MeshType.FileMesh
    mesh.MeshId = HAND_MESH_ID
    mesh.Scale = Vector3.new(1, 1, 1)
    mesh.Parent = hand

    return hand
end

local leftHand = createHand("LeftVRHand")
local rightHand = createHand("RightVRHand")

-- ══════════════════════════════
--         UPDATE HANDS
-- ══════════════════════════════

RunService.RenderStepped:Connect(function()
    if not vrEnabled then return end
    local camCF = camera.CFrame
    leftHand.CFrame = camCF * leftHandOffset * CFrame.new(leftJoyX * 2, leftJoyY * 2, 0)
    rightHand.CFrame = camCF * rightHandOffset * CFrame.new(rightJoyX * 2, rightJoyY * 2, 0)
end)

-- ══════════════════════════════
--         GUI
-- ══════════════════════════════

local C_BG = Color3.fromRGB(10, 0, 0)
local C_DARK = Color3.fromRGB(20, 0, 0)
local C_RED = Color3.fromRGB(180, 0, 0)
local C_BRIGHTRED = Color3.fromRGB(220, 0, 0)
local C_GREEN = Color3.fromRGB(0, 180, 0)
local C_WHITE = Color3.fromRGB(255, 255, 255)

local screenGui = Instance.new("ScreenGui")
screenGui.Name = "VRHandsGui"
screenGui.ResetOnSpawn = false
screenGui.Parent = player:WaitForChild("PlayerGui")

local mainFrame = Instance.new("Frame")
mainFrame.Size = UDim2.new(0, 300, 0, 220)
mainFrame.Position = UDim2.new(0.5, -150, 0, 10)
mainFrame.BackgroundColor3 = C_BG
mainFrame.BorderSizePixel = 0
mainFrame.Active = true
mainFrame.Draggable = true
mainFrame.ClipsDescendants = true
mainFrame.Parent = screenGui
Instance.new("UICorner", mainFrame).CornerRadius = UDim.new(0, 12)

local mainStroke = Instance.new("UIStroke")
mainStroke.Color = C_RED
mainStroke.Thickness = 2
mainStroke.Parent = mainFrame

local titleBar = Instance.new("Frame")
titleBar.Size = UDim2.new(1, 0, 0, 46)
titleBar.BackgroundColor3 = C_DARK
titleBar.BorderSizePixel = 0
titleBar.Parent = mainFrame
Instance.new("UICorner", titleBar).CornerRadius = UDim.new(0, 12)

local titleIcon = Instance.new("TextLabel")
titleIcon.Size = UDim2.new(0, 36, 1, 0)
titleIcon.Position = UDim2.new(0, 8, 0, 0)
titleIcon.BackgroundTransparency = 1
titleIcon.Text = "💀"
titleIcon.TextSize = 20
titleIcon.Font = Enum.Font.GothamBold
titleIcon.Parent = titleBar

local titleLabel = Instance.new("TextLabel")
titleLabel.Size = UDim2.new(1, -110, 1, 0)
titleLabel.Position = UDim2.new(0, 46, 0, 0)
titleLabel.BackgroundTransparency = 1
titleLabel.Text = "h4ll0 w0rld | VR Hands"
titleLabel.TextColor3 = C_BRIGHTRED
titleLabel.TextSize = 13
titleLabel.Font = Enum.Font.GothamBold
titleLabel.TextXAlignment = Enum.TextXAlignment.Left
titleLabel.Parent = titleBar

coroutine.wrap(function()
    while titleLabel and titleLabel.Parent do
        titleLabel.TextTransparency = 0.6
        task.wait(0.05)
        titleLabel.TextTransparency = 0
        task.wait(math.random(3, 7))
    end
end)()

local minBtn = Instance.new("TextButton")
minBtn.Size = UDim2.new(0, 30, 0, 28)
minBtn.Position = UDim2.new(1, -38, 0.5, -14)
minBtn.BackgroundColor3 = Color3.fromRGB(60, 0, 0)
minBtn.Text = "—"
minBtn.TextColor3 = C_WHITE
minBtn.TextSize = 13
minBtn.Font = Enum.Font.GothamBold
minBtn.BorderSizePixel = 0
minBtn.Parent = titleBar
Instance.new("UICorner", minBtn).CornerRadius = UDim.new(0, 6)

local sep = Instance.new("Frame")
sep.Size = UDim2.new(1, -20, 0, 1)
sep.Position = UDim2.new(0, 10, 0, 50)
sep.BackgroundColor3 = C_RED
sep.BorderSizePixel = 0
sep.Parent = mainFrame

local contentFrame = Instance.new("Frame")
contentFrame.Size = UDim2.new(1, -20, 1, -60)
contentFrame.Position = UDim2.new(0, 10, 0, 58)
contentFrame.BackgroundTransparency = 1
contentFrame.Parent = mainFrame

local layout = Instance.new("UIListLayout")
layout.SortOrder = Enum.SortOrder.LayoutOrder
layout.Padding = UDim.new(0, 8)
layout.Parent = contentFrame

local function makeToggleRow(text, order, defaultOn, callback)
    local row = Instance.new("Frame")
    row.Size = UDim2.new(1, 0, 0, 44)
    row.BackgroundColor3 = C_DARK
    row.BorderSizePixel = 0
    row.LayoutOrder = order
    row.Parent = contentFrame
    Instance.new("UICorner", row).CornerRadius = UDim.new(0, 8)
    local rs = Instance.new("UIStroke")
    rs.Color = C_RED
    rs.Thickness = 1
    rs.Parent = row

    local lbl = Instance.new("TextLabel")
    lbl.Size = UDim2.new(0.65, 0, 1, 0)
    lbl.Position = UDim2.new(0, 12, 0, 0)
    lbl.BackgroundTransparency = 1
    lbl.Text = text
    lbl.TextColor3 = Color3.fromRGB(200, 200, 200)
    lbl.TextSize = 12
    lbl.Font = Enum.Font.Gotham
    lbl.TextXAlignment = Enum.TextXAlignment.Left
    lbl.Parent = row

    local togBtn = Instance.new("TextButton")
    togBtn.Size = UDim2.new(0, 55, 0, 26)
    togBtn.Position = UDim2.new(1, -65, 0.5, -13)
    togBtn.BackgroundColor3 = defaultOn and Color3.fromRGB(0, 60, 0) or Color3.fromRGB(60, 0, 0)
    togBtn.Text = defaultOn and "ON" or "OFF"
    togBtn.TextColor3 = defaultOn and C_GREEN or C_BRIGHTRED
    togBtn.TextSize = 11
    togBtn.Font = Enum.Font.GothamBold
    togBtn.BorderSizePixel = 0
    togBtn.Parent = row
    Instance.new("UICorner", togBtn).CornerRadius = UDim.new(0, 6)

    local state = defaultOn
    togBtn.MouseButton1Click:Connect(function()
        state = not state
        if state then
            togBtn.Text = "ON"
            togBtn.TextColor3 = C_GREEN
            TweenService:Create(togBtn, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(0, 60, 0)}):Play()
        else
            togBtn.Text = "OFF"
            togBtn.TextColor3 = C_BRIGHTRED
            TweenService:Create(togBtn, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(60, 0, 0)}):Play()
        end
        callback(state)
    end)
end

makeToggleRow("🥽 VR Hands", 1, true, function(state)
    vrEnabled = state
    leftHand.Transparency = state and 0 or 1
    rightHand.Transparency = state and 0 or 1
end)

makeToggleRow("✋ Left Hand", 2, true, function(state)
    leftHand.Transparency = state and 0 or 1
end)

makeToggleRow("🤚 Right Hand", 3, true, function(state)
    rightHand.Transparency = state and 0 or 1
end)

local closeBtn = Instance.new("TextButton")
closeBtn.Size = UDim2.new(1, 0, 0, 36)
closeBtn.BackgroundColor3 = Color3.fromRGB(60, 0, 0)
closeBtn.Text = "💀 Close VR"
closeBtn.TextColor3 = C_WHITE
closeBtn.TextSize = 12
closeBtn.Font = Enum.Font.GothamBold
closeBtn.BorderSizePixel = 0
closeBtn.LayoutOrder = 4
closeBtn.Parent = contentFrame
Instance.new("UICorner", closeBtn).CornerRadius = UDim.new(0, 6)

closeBtn.MouseButton1Click:Connect(function()
    vrEnabled = false
    player.CameraMode = Enum.CameraMode.Classic
    leftHand:Destroy()
    rightHand:Destroy()
    screenGui:Destroy()
end)

local minimized = false
minBtn.MouseButton1Click:Connect(function()
    minimized = not minimized
    minBtn.Text = minimized and "+" or "—"
    TweenService:Create(mainFrame, TweenInfo.new(0.3, Enum.EasingStyle.Quart), {
        Size = minimized and UDim2.new(0, 300, 0, 46) or UDim2.new(0, 300, 0, 220)
    }):Play()
end)

-- ══════════════════════════════
--         JOYSTICKS
-- ══════════════════════════════

local function createJoystick(name, posX, posY, onMove)
    local baseSize = 120
    local knobSize = 50

    local base = Instance.new("Frame")
    base.Name = name .. "Base"
    base.Size = UDim2.new(0, baseSize, 0, baseSize)
    base.Position = UDim2.new(0, posX, 1, posY)
    base.BackgroundColor3 = Color3.fromRGB(20, 0, 0)
    base.BackgroundTransparency = 0.3
    base.BorderSizePixel = 0
    base.Active = true
    base.Parent = screenGui
    Instance.new("UICorner", base).CornerRadius = UDim.new(1, 0)

    local baseStroke = Instance.new("UIStroke")
    baseStroke.Color = C_RED
    baseStroke.Thickness = 2
    baseStroke.Parent = base

    local baseLabel = Instance.new("TextLabel")
    baseLabel.Size = UDim2.new(1, 0, 0, 20)
    baseLabel.Position = UDim2.new(0, 0, 0, -26)
    baseLabel.BackgroundTransparency = 1
    baseLabel.Text = name == "Left" and "✋ Kiri" or "🤚 Kanan"
    baseLabel.TextColor3 = C_BRIGHTRED
    baseLabel.TextSize = 11
    baseLabel.Font = Enum.Font.GothamBold
    baseLabel.Parent = base

    local knob = Instance.new("Frame")
    knob.Size = UDim2.new(0, knobSize, 0, knobSize)
    knob.Position = UDim2.new(0.5, -knobSize/2, 0.5, -knobSize/2)
    knob.BackgroundColor3 = C_RED
    knob.BorderSizePixel = 0
    knob.Parent = base
    Instance.new("UICorner", knob).CornerRadius = UDim.new(1, 0)

    local knobIcon = Instance.new("TextLabel")
    knobIcon.Size = UDim2.new(1, 0, 1, 0)
    knobIcon.BackgroundTransparency = 1
    knobIcon.Text = "💀"
    knobIcon.TextSize = 18
    knobIcon.Font = Enum.Font.GothamBold
    knobIcon.Parent = knob

    local touching = false
    local touchId = nil
    local maxDist = (baseSize - knobSize) / 2

    base.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.Touch then
            touching = true
            touchId = input
        end
    end)

    UserInputService.InputEnded:Connect(function(input)
        if input == touchId then
            touching = false
            touchId = nil
            knob.Position = UDim2.new(0.5, -knobSize/2, 0.5, -knobSize/2)
            onMove(0, 0)
        end
    end)

    UserInputService.InputChanged:Connect(function(input)
        if input == touchId and touching then
            local absPos = base.AbsolutePosition
            local absSize = base.AbsoluteSize
            local cx = absPos.X + absSize.X / 2
            local cy = absPos.Y + absSize.Y / 2
            local dx = input.Position.X - cx
            local dy = input.Position.Y - cy
            local dist = math.sqrt(dx*dx + dy*dy)
            if dist > maxDist then
                dx = dx / dist * maxDist
                dy = dy / dist * maxDist
            end
            knob.Position = UDim2.new(0.5, dx - knobSize/2, 0.5, dy - knobSize/2)
            onMove(dx / maxDist, dy / maxDist)
        end
    end)
end

createJoystick("Left", 20, -150, function(x, y)
    leftJoyX = x
    leftJoyY = -y
end)

createJoystick("Right", -140, -150, function(x, y)
    rightJoyX = x
    rightJoyY = -y
end)

player.CharacterAdded:Connect(function()
    task.wait(1)
    player.CameraMode = Enum.CameraMode.LockFirstPerson
    leftHand.Parent = workspace
    rightHand.Parent = workspace
end)

print("💀 h4ll0 w0rld | VR Hands loaded!")
