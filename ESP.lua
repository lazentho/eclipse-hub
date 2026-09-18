-- Eclipse Hub ESP - Roblox Studio LocalScript
-- Place this LocalScript in StarterPlayer > StarterPlayerScripts.
-- Intended for your own Roblox Studio experience.

local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local LocalPlayer = Players.LocalPlayer

local settings = {
    Enabled = true,
    Boxes = true,
    Health = true,
    Hats = true,
}

local gui = Instance.new("ScreenGui")
gui.Name = "EclipseHub"
gui.ResetOnSpawn = false
gui.Parent = LocalPlayer:WaitForChild("PlayerGui")

local window = Instance.new("Frame")
window.Size = UDim2.fromOffset(310, 245)
window.Position = UDim2.new(0, 25, 0.5, -122)
window.BackgroundColor3 = Color3.fromRGB(22, 18, 35)
window.BorderSizePixel = 0
window.Parent = gui

local corner = Instance.new("UICorner", window)
corner.CornerRadius = UDim.new(0, 10)

local stroke = Instance.new("UIStroke", window)
stroke.Color = Color3.fromRGB(120, 75, 220)
stroke.Thickness = 1.5

local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, -50, 0, 42)
title.Position = UDim2.fromOffset(15, 0)
title.BackgroundTransparency = 1
title.Text = "ECLIPSE HUB"
title.TextColor3 = Color3.fromRGB(235, 225, 255)
title.Font = Enum.Font.GothamBold
title.TextSize = 16
title.TextXAlignment = Enum.TextXAlignment.Left
title.Parent = window

local close = Instance.new("TextButton")
close.Size = UDim2.fromOffset(32, 32)
close.Position = UDim2.new(1, -40, 0, 5)
close.BackgroundColor3 = Color3.fromRGB(55, 35, 75)
close.Text = "×"
close.TextColor3 = Color3.fromRGB(255, 255, 255)
close.TextSize = 22
close.Font = Enum.Font.GothamBold
close.Parent = window
Instance.new("UICorner", close).CornerRadius = UDim.new(0, 8)

local tabs = Instance.new("Frame")
tabs.Size = UDim2.new(1, -30, 0, 34)
tabs.Position = UDim2.fromOffset(15, 48)
tabs.BackgroundTransparency = 1
tabs.Parent = window

local content = Instance.new("Frame")
content.Size = UDim2.new(1, -30, 1, -95)
content.Position = UDim2.fromOffset(15, 88)
content.BackgroundTransparency = 1
content.Parent = window

local function makeButton(parent, text, position, size)
    local b = Instance.new("TextButton")
    b.Size = size or UDim2.fromOffset(130, 32)
    b.Position = position or UDim2.new()
    b.BackgroundColor3 = Color3.fromRGB(45, 32, 65)
    b.TextColor3 = Color3.fromRGB(225, 215, 245)
    b.Text = text
    b.Font = Enum.Font.GothamMedium
    b.TextSize = 13
    b.AutoButtonColor = true
    b.Parent = parent
    Instance.new("UICorner", b).CornerRadius = UDim.new(0, 7)
    return b
end

local espTab = makeButton(tabs, "ESP", UDim2.fromOffset(0, 0), UDim2.new(0.5, -4, 1, 0))
local settingsTab = makeButton(tabs, "Settings", UDim2.new(0.5, 4, 0, 0), UDim2.new(0.5, -4, 1, 0))

local function clearContent()
    for _, child in ipairs(content:GetChildren()) do
        child:Destroy()
    end
end

local function toggleRow(label, key, y)
    local row = Instance.new("Frame")
    row.Size = UDim2.new(1, 0, 0, 34)
    row.Position = UDim2.fromOffset(0, y)
    row.BackgroundTransparency = 1
    row.Parent = content

    local text = Instance.new("TextLabel")
    text.Size = UDim2.new(1, -70, 1, 0)
    text.BackgroundTransparency = 1
    text.Text = label
    text.TextColor3 = Color3.fromRGB(225, 215, 245)
    text.Font = Enum.Font.Gotham
    text.TextSize = 14
    text.TextXAlignment = Enum.TextXAlignment.Left
    text.Parent = row

    local button = makeButton(row, settings[key] and "ON" or "OFF", UDim2.new(1, -58, 0, 1), UDim2.fromOffset(58, 30))
    local function refresh()
        button.Text = settings[key] and "ON" or "OFF"
        button.BackgroundColor3 = settings[key] and Color3.fromRGB(91, 55, 155) or Color3.fromRGB(45, 32, 65)
    end
    button.MouseButton1Click:Connect(function()
        settings[key] = not settings[key]
        refresh()
    end)
    refresh()
end

local function showESP()
    clearContent()
    toggleRow("Enable ESP", "Enabled", 0)
    toggleRow("Player boxes", "Boxes", 38)
    toggleRow("Health lines", "Health", 76)
    toggleRow("Chinese hats", "Hats", 114)
end

local function showSettings()
    clearContent()
    local info = Instance.new("TextLabel")
    info.Size = UDim2.new(1, 0, 1, 0)
    info.BackgroundTransparency = 1
    info.TextWrapped = true
    info.Text = "Eclipse Hub\n\nRightShift: reopen GUI\nDrag the title area to move it\nStudio-safe local ESP"
    info.TextColor3 = Color3.fromRGB(210, 195, 235)
    info.Font = Enum.Font.Gotham
    info.TextSize = 14
    info.Parent = content
end

espTab.MouseButton1Click:Connect(showESP)
settingsTab.MouseButton1Click:Connect(showSettings)
close.MouseButton1Click:Connect(function()
    gui.Enabled = false
end)

local dragging = false
local dragStart, startPosition
window.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = true
        dragStart = input.Position
        startPosition = window.Position
        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then
                dragging = false
            end
        end)
    end
end)
UserInputService.InputChanged:Connect(function(input)
    if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
        local delta = input.Position - dragStart
        window.Position = UDim2.new(startPosition.X.Scale, startPosition.X.Offset + delta.X, startPosition.Y.Scale, startPosition.Y.Offset + delta.Y)
    end
end)
UserInputService.InputBegan:Connect(function(input, processed)
    if not processed and input.KeyCode == Enum.KeyCode.RightShift then
        gui.Enabled = not gui.Enabled
    end
end)

showESP()

local drawings = {}
local function removePlayer(player)
    if drawings[player] then
        for _, object in pairs(drawings[player]) do
            object:Destroy()
        end
        drawings[player] = nil
    end
end

local function createPlayerVisual(player)
    if player == LocalPlayer then return end
    local folder = Instance.new("Folder")
    folder.Name = player.Name .. "_ESP"
    folder.Parent = gui

    local box = Instance.new("Frame")
    box.BackgroundTransparency = 1
    box.BorderSizePixel = 0
    box.Parent = folder

    local outline = Instance.new("UIStroke", box)
    outline.Color = Color3.fromRGB(180, 100, 255)
    outline.Thickness = 1

    local health = Instance.new("Frame")
    health.BackgroundColor3 = Color3.fromRGB(90, 255, 130)
    health.BorderSizePixel = 0
    health.Parent = folder

    local hat = Instance.new("TextLabel")
    hat.BackgroundTransparency = 1
    hat.Text = "▼"
    hat.TextColor3 = Color3.fromRGB(245, 190, 70)
    hat.Font = Enum.Font.GothamBold
    hat.TextSize = 26
    hat.Parent = folder

    drawings[player] = {folder = folder, box = box, health = health, hat = hat}
end

for _, player in ipairs(Players:GetPlayers()) do
    createPlayerVisual(player)
end
Players.PlayerAdded:Connect(createPlayerVisual)
Players.PlayerRemoving:Connect(removePlayer)

RunService.RenderStepped:Connect(function()
    local camera = workspace.CurrentCamera
    for player, objects in pairs(drawings) do
        local character = player.Character
        local humanoid = character and character:FindFirstChildOfClass("Humanoid")
        local root = character and character:FindFirstChild("HumanoidRootPart")
        local head = character and character:FindFirstChild("Head")
        local visible = settings.Enabled and character and humanoid and root and humanoid.Health > 0
        if not visible then
            objects.box.Visible = false
            objects.health.Visible = false
            objects.hat.Visible = false
            continue
        end

        local position, onScreen = camera:WorldToViewportPoint(root.Position)
        local headPosition = camera:WorldToViewportPoint(head and head.Position or root.Position + Vector3.new(0, 3, 0))
        if not onScreen then
            objects.box.Visible = false
            objects.health.Visible = false
            objects.hat.Visible = false
            continue
        end

        local height = math.abs(position.Y - headPosition.Y) * 2.2
        local width = height * 0.55
        local x = position.X - width / 2
        local y = position.Y - height / 2

        objects.box.Visible = settings.Boxes
        objects.box.Position = UDim2.fromOffset(x, y)
        objects.box.Size = UDim2.fromOffset(width, height)

        objects.health.Visible = settings.Health
        objects.health.Position = UDim2.fromOffset(x - 5, y)
        objects.health.Size = UDim2.fromOffset(2, height)
        objects.health.AnchorPoint = Vector2.new(0, 1)
        objects.health.Position = UDim2.fromOffset(x - 5, y + height)
        objects.health.Size = UDim2.fromOffset(2, height * math.clamp(humanoid.Health / humanoid.MaxHealth, 0, 1))

        objects.hat.Visible = settings.Hats
        objects.hat.Position = UDim2.fromOffset(position.X - 13, y - 28)
        objects.hat.Size = UDim2.fromOffset(26, 26)
    end
end)