local UserInputService = game:GetService("UserInputService")
local TextService = game:GetService("TextService")
local Players = game:GetService("Players")
local player = Players.LocalPlayer

-- Data Storage
local coordList = {}

-- UI Setup
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "MobileCoordLogger"
screenGui.ResetOnSpawn = false
screenGui.Parent = player:WaitForChild("PlayerGui")

-- Main Menu Frame
local frame = Instance.new("Frame")
frame.Size = UDim2.new(0, 180, 0, 160)
frame.Position = UDim2.new(0.5, -90, 0.2, 0)
frame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
frame.BorderSizePixel = 2
frame.Active = true
frame.Draggable = true -- Allows you to move it on mobile
frame.Parent = screenGui

local title = Instance.new("TextLabel")
title.Text = "Coord Logger"
title.Size = UDim2.new(1, 0, 0.25, 0)
title.TextColor3 = Color3.new(1, 1, 1)
title.BackgroundTransparency = 1
title.Parent = frame

-- Button Helper Function
local function createButton(text, pos, color)
    local btn = Instance.new("TextButton")
    btn.Text = text
    btn.Size = UDim2.new(0.8, 0, 0.2, 0)
    btn.Position = pos
    btn.BackgroundColor3 = color
    btn.TextColor3 = Color3.new(1, 1, 1)
    btn.Font = Enum.Font.SourceSansBold
    btn.Parent = frame
    
    -- Rounded corners
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 6)
    corner.Parent = btn
    
    return btn
end

local recBtn = createButton("RECORD (Y)", UDim2.new(0.1, 0, 0.3, 0), Color3.fromRGB(50, 150, 50))
local copyBtn = createButton("COPY ALL", UDim2.new(0.1, 0, 0.55, 0), Color3.fromRGB(50, 80, 150))
local closeBtn = createButton("CLOSE & EXIT", UDim2.new(0.1, 0, 0.8, 0), Color3.fromRGB(150, 50, 50))

-- Logic: Record Function
local function recordCoords()
    local character = player.Character
    if character and character:FindFirstChild("HumanoidRootPart") then
        local pos = character.HumanoidRootPart.Position
        local formatted = string.format("%.2f, %.2f, %.2f", pos.X, pos.Y, pos.Z)
        table.insert(coordList, formatted)
        
        -- Flash the button to show it worked
        recBtn.Text = "SAVED!"
        task.wait(0.5)
        recBtn.Text = "RECORD (Y)"
    end
end

-- Logic: Copy to Clipboard
local function copyToClipboard()
    local allCoords = table.concat(coordList, "\n")
    
    -- Check for executor clipboard support
    if setclipboard then
        setclipboard(allCoords)
        copyBtn.Text = "COPIED TO CLIPBOARD!"
    else
        copyBtn.Text = "ERR: NO CLIPBOARD SUPP."
    end
    
    task.wait(1)
    copyBtn.Text = "COPY ALL"
end

-- Connections
recBtn.MouseButton1Click:Connect(recordCoords)
copyBtn.MouseButton1Click:Connect(copyToClipboard)

closeBtn.MouseButton1Click:Connect(function()
    screenGui:Destroy()
end)

-- Still allow 'Y' key for PC players
UserInputService.InputBegan:Connect(function(input, processed)
    if not processed and input.KeyCode == Enum.KeyCode.Y then
        recordCoords()
    end
end)
