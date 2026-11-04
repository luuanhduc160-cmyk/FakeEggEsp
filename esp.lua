-- Roblox Fake a Egg: Ultimate Hub (ESP + Inf Jump + Speed + Draggable UI)
local CoreGui = game:GetService("CoreGui")
local Players = game:GetService("Players")
local Workspace = game:GetService("Workspace")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local LocalPlayer = Players.LocalPlayer

-- Trạng thái tính năng
local espEnabled = true
local infJumpEnabled = false
local speedEnabled = false
local speedValue = 30

-- Tạo thư mục chứa ESP
local espFolder = Instance.new("Folder")
espFolder.Name = "FieldESP_Container"
espFolder.Parent = CoreGui

---------------------------------------------------------
-- 1. GIAO DIỆN CHÍNH (MODERN UI & DRAGGABLE)
---------------------------------------------------------
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "UltimateHub_Gui"
ScreenGui.ResetOnSpawn = false
ScreenGui.Parent = CoreGui

-- Nút nổi thu nhỏ / mở rộng giao diện (Toggle Open/Close)
local ToggleButton = Instance.new("TextButton")
ToggleButton.Name = "ToggleMenuBtn"
ToggleButton.Size = UDim2.new(0, 110, 0, 40)
ToggleButton.Position = UDim2.new(0.05, 0, 0.2, 0)
ToggleButton.BackgroundColor3 = Color3.fromRGB(25, 28, 36)
ToggleButton.Text = "MENU HUB"
ToggleButton.TextColor3 = Color3.fromRGB(255, 255, 255)
ToggleButton.Font = Enum.Font.GothamBold
ToggleButton.TextSize = 13
ToggleButton.Parent = ScreenGui

local ToggleCorner = Instance.new("UICorner")
ToggleCorner.CornerRadius = UDim.new(0, 10)
ToggleCorner.Parent = ToggleButton

local ToggleStroke = Instance.new("UIStroke")
ToggleStroke.Color = Color3.fromRGB(255, 60, 60)
ToggleStroke.Thickness = 2
ToggleStroke.Parent = ToggleButton

-- Khung Menu Chính (Main Frame)
local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.Size = UDim2.new(0, 260, 0, 320)
MainFrame.Position = UDim2.new(0.05, 0, 0.28, 0)
MainFrame.BackgroundColor3 = Color3.fromRGB(18, 21, 28)
MainFrame.BorderSizePixel = 0
MainFrame.Parent = ScreenGui

local MainCorner = Instance.new("UICorner")
MainCorner.CornerRadius = UDim.new(0, 14)
MainCorner.Parent = MainFrame

local MainStroke = Instance.new("UIStroke")
MainStroke.Color = Color3.fromRGB(255, 60, 60)
MainStroke.Thickness = 1.5
MainStroke.Parent = MainFrame

-- Tiêu đề Menu (Thanh để kéo/draggable)
local TopBar = Instance.new("TextButton")
TopBar.Name = "TopBar"
TopBar.Size = UDim2.new(1, 0, 0, 40)
TopBar.BackgroundColor3 = Color3.fromRGB(25, 28, 36)
TopBar.Text = "  FARM & UTILS HUB"
TopBar.TextColor3 = Color3.fromRGB(255, 255, 255)
TopBar.Font = Enum.Font.GothamBold
TopBar.TextSize = 14
TopBar.TextXAlignment = Enum.TextXAlignment.Left
TopBar.Parent = MainFrame

local TopBarCorner = Instance.new("UICorner")
TopBarCorner.CornerRadius = UDim.new(0, 14)
TopBarCorner.Parent = TopBar

-- Container chứa các tính năng bên trong
local Container = Instance.new("ScrollingFrame")
Container.Name = "Container"
Container.Size = UDim2.new(1, -16, 1, -55)
Container.Position = UDim2.new(0, 8, 0, 48)
Container.BackgroundTransparency = 1
Container.CanvasSize = UDim2.new(0, 0, 0, 280)
Container.ScrollBarThickness = 4
Container.Parent = MainFrame

local UIListLayout = Instance.new("UIListLayout")
UIListLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
UIListLayout.Padding = UDim.new(0, 10)
UIListLayout.Parent = Container

---------------------------------------------------------
-- HÀM HỖ TRỢ: TẠO NÚT TOGGLE & TEXTBOX ĐẸP
---------------------------------------------------------
local function createButton(name, defaultText, callback)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(1, 0, 0, 40)
    btn.BackgroundColor3 = Color3.fromRGB(28, 33, 43)
    btn.Text = defaultText
    btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    btn.Font = Enum.Font.GothamSemibold
    btn.TextSize = 13
    btn.Parent = Container

    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 8)
    corner.Parent = btn

    local stroke = Instance.new("UIStroke")
    stroke.Color = Color3.fromRGB(60, 70, 90)
    stroke.Thickness = 1
    stroke.Parent = btn

    local active = false
    btn.MouseButton1Click:Connect(function()
        active = not active
        callback(active, btn, stroke)
    end)
    return btn
end

local function createTextBox(placeholder, defaultVal, callback)
    local boxFrame = Instance.new("Frame")
    boxFrame.Size = UDim2.new(1, 0, 0, 40)
    boxFrame.BackgroundColor3 = Color3.fromRGB(28, 33, 43)
    boxFrame.Parent = Container

    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 8)
    corner.Parent = boxFrame

    local stroke = Instance.new("UIStroke")
    stroke.Color = Color3.fromRGB(60, 70, 90)
    stroke.Thickness = 1
    stroke.Parent = boxFrame

    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(0.5, 0, 1, 0)
    label.Position = UDim2.new(0.05, 0, 0, 0)
    label.BackgroundTransparency = 1
    label.Text = placeholder
    label.TextColor3 = Color3.fromRGB(200, 200, 200)
    label.Font = Enum.Font.GothamMedium
    label.TextSize = 12
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Parent = boxFrame

    local textBox = Instance.new("TextBox")
    textBox.Size = UDim2.new(0.4, 0, 0.8, 0)
    textBox.Position = UDim2.new(0.55, 0, 0.1, 0)
    textBox.BackgroundColor3 = Color3.fromRGB(18, 21, 28)
    textBox.Text = tostring(defaultVal)
    textBox.TextColor3 = Color3.fromRGB(255, 255, 255)
    textBox.Font = Enum.Font.GothamBold
    textBox.TextSize = 13
    textBox.ClearTextOnFocus = false
    textBox.Parent = boxFrame

    local boxCorner = Instance.new("UICorner")
    boxCorner.CornerRadius = UDim.new(0, 6)
    boxCorner.Parent = textBox

    textBox.FocusLost:Connect(function(enterPressed)
        local num = tonumber(textBox.Text)
        if num then
            callback(num)
        else
            textBox.Text = tostring(defaultVal)
        end
    end)
end

---------------------------------------------------------
-- 2. TẠO CÁC TÍNH NĂNG TRONG MENU
---------------------------------------------------------

-- 1. Nút bật tắt Field ESP
createButton("ESPButton", "FIELD ESP: ON", function(state, btn, stroke)
    espEnabled = state
    if espEnabled then
        btn.Text = "FIELD ESP: ON"
        stroke.Color = Color3.fromRGB(255, 60, 60)
    else
        btn.Text = "FIELD ESP: OFF"
        stroke.Color = Color3.fromRGB(100, 100, 100)
        espFolder:ClearAllChildren()
    end
end)

-- 2. Nút bật tắt Infinite Jump
createButton("InfJumpButton", "INFINITE JUMP: OFF", function(state, btn, stroke)
    infJumpEnabled = state
    if infJumpEnabled then
        btn.Text = "INFINITE JUMP: ON"
        stroke.Color = Color3.fromRGB(60, 255, 100)
    else
        btn.Text = "INFINITE JUMP: OFF"
        stroke.Color = Color3.fromRGB(60, 70, 90)
    end
end)

-- 3. Nút bật tắt Custom Speed
createButton("SpeedToggle", "CUSTOM SPEED: OFF", function(state, btn, stroke)
    speedEnabled = state
    if speedEnabled then
        btn.Text = "CUSTOM SPEED: ON"
        stroke.Color = Color3.fromRGB(60, 150, 255)
    else
        btn.Text = "CUSTOM SPEED: OFF"
        stroke.Color = Color3.fromRGB(60, 70, 90)
    end
end)

-- 4. Ô nhập giá trị WalkSpeed
createTextBox("Speed Value:", speedValue, function(val)
    speedValue = val
end)

---------------------------------------------------------
-- 3. LOGIC XỬ LÝ TÍNH NĂNG (ESP, INF JUMP, SPEED)
---------------------------------------------------------

-- Xử lý Infinite Jump
UserInputService.JumpRequest:Connect(function()
    if infJumpEnabled then
        local char = LocalPlayer.Character
        if char then
            local humanoid = char:FindFirstChildOfClass("Humanoid")
            if humanoid then
                humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
            end
        end
    end
end)

-- Xử lý Custom Speed liên tục
RunService.Heartbeat:Connect(function()
    if speedEnabled then
        local char = LocalPlayer.Character
        if char then
            local humanoid = char:FindFirstChildOfClass("Humanoid")
            if humanoid then
                humanoid.WalkSpeed = speedValue
            end
        end
    end
end)

---------------------------------------------------------
-- 4. HỆ THỐNG SCAN MAP & FAKE EGG ESP
---------------------------------------------------------
local fieldBoundsMin = Vector3.new(-60, -10, -60)
local fieldBoundsMax = Vector3.new(60, 50, 60)

local function scanMapField()
    local foundParts = 0
    local minX, maxX = math.huge, -math.huge
    local minZ, maxZ = math.huge, -math.huge
    local minY = 0

    for _, obj in pairs(Workspace:GetDescendants()) do
        if obj:IsA("BasePart") then
            local name = string.lower(obj.Name)
            if string.find(name, "field") or string.find(name, "spawn") or string.find(name, "ground") or (obj.Size.X > 40 and obj.Size.Z > 40) then
                if obj.Position.Y > -20 and obj.Position.Y < 50 then
                    foundParts = foundParts + 1
                    local pPos = obj.Position
                    local pSize = obj.Size
                    if pPos.X - pSize.X/2 < minX then minX = pPos.X - pSize.X/2 end
                    if pPos.X + pSize.X/2 > maxX then maxX = pPos.X + pSize.X/2 end
                    if pPos.Z - pSize.Z/2 < minZ then minZ = pPos.Z - pSize.Z/2 end
                    if pPos.Z + pSize.Z/2 > maxZ then maxZ = pPos.Z + pSize.Z/2 end
                    minY = pPos.Y
                end
            end
        end
    end

    if foundParts > 0 then
        fieldBoundsMin = Vector3.new(minX + 5, minY - 5, minZ + 5)
        fieldBoundsMax = Vector3.new(maxX - 5, minY + 30, maxZ - 5)
    end
end
pcall(scanMapField)

local function isInsideField(pos)
    return pos.X >= fieldBoundsMin.X and pos.X <= fieldBoundsMax.X and
           pos.Z >= fieldBoundsMin.Z and pos.Z <= fieldBoundsMax.Z
end

local function isPlayerDisguisedAsEgg(character)
    if not character then return false end
    local head = character:FindFirstChild("Head")
    local torso = character:FindFirstChild("UpperTorso") or character:FindFirstChild("Torso")
    return (not head or head.Transparency >= 0.85) or (not torso or torso.Transparency >= 0.85)
end

local function createFakeESP(targetPart, playerName)
    local bg = Instance.new("BillboardGui")
    bg.Name = "FakeEgg_Tag"
    bg.Adornee = targetPart
    bg.Size = UDim2.new(0, 180, 0, 45)
    bg.StudsOffset = Vector3.new(0, 3.5, 0)
    bg.AlwaysOnTop = true
    bg.Parent = espFolder

    local txt = Instance.new("TextLabel")
    txt.Size = UDim2.new(1, 0, 1, 0)
    txt.BackgroundTransparency = 1
    txt.Text = "[FAKE EGG]\nPLAYER: " .. playerName
    txt.TextColor3 = Color3.fromRGB(255, 40, 40)
    txt.Font = Enum.Font.GothamBlack
    txt.TextSize = 13
    txt.TextStrokeTransparency = 0
    txt.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
    txt.Parent = bg
end

task.spawn(function()
    while true do
        pcall(function()
            espFolder:ClearAllChildren()
            if espEnabled then
                for _, player in pairs(Players:GetPlayers()) do
                    if player ~= LocalPlayer and player.Character then
                        local char = player.Character
                        local root = char:FindFirstChild("HumanoidRootPart") or char:FindFirstChild("Head")
                        if root and isInsideField(root.Position) then
                            if isPlayerDisguisedAsEgg(char) then
                                createFakeESP(root, player.DisplayName)
                            end
                        end
                    end
                end
            end
        end)
        task.wait(0.3)
    end
end)

---------------------------------------------------------
-- 5. TÍNH NĂNG KÉO THẢ (DRAGGABLE) & TOGGLE ẨN/HIỆN GUI
---------------------------------------------------------
local function makeDraggable(guiObj, dragTarget)
    dragTarget = dragTarget or guiObj
    local dragging, dragInput, dragStart, startPos

    dragTarget.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            dragStart = input.Position
            startPos = guiObj.Position

            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    dragging = false
                end
            end)
        end
    end)

    dragTarget.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
            dragInput = input
        end
    end)

    UserInputService.InputChanged:Connect(function(input)
        if input == dragInput and dragging then
            local delta = input.Position - dragStart
            guiObj.Position = UDim2.new(
                startPos.X.Scale, startPos.X.Offset + delta.X,
                startPos.Y.Scale, startPos.Y.Offset + delta.Y
            )
        end
    end)
end

-- Kéo thả cho cả Nút mở menu và Khung Menu chính
makeDraggable(ToggleButton)
makeDraggable(MainFrame, TopBar)

-- Sự kiện ẩn hiện Main Menu khi bấm nút Toggle
local menuVisible = true
ToggleButton.MouseButton1Click:Connect(function()
    menuVisible = not menuVisible
    MainFrame.Visible = menuVisible
    if menuVisible then
        ToggleButton.Text = "CLOSE MENU"
        ToggleStroke.Color = Color3.fromRGB(255, 60, 60)
    else
        ToggleButton.Text = "OPEN MENU"
        ToggleStroke.Color = Color3.fromRGB(60, 255, 100)
    end
end)

print("Đã tải thành công Ultimate Hub (ESP, Inf Jump, Speed, Draggable GUI)!")
