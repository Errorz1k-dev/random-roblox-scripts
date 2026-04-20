--Find Lua scripts online and paste them here!
local UserInputService = game:GetService("UserInputService")
local Players = game:GetService("Players")
local player = Players.LocalPlayer
local mouse = player:GetMouse()

local coordList = {}

-- UI Setup
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "MouseLoggerUI"
screenGui.Parent = player:WaitForChild("PlayerGui")

local frame = Instance.new("Frame")
frame.Size = UDim2.new(0, 200, 0, 180)
frame.Position = UDim2.new(0.5, -100, 0.4, 0)
frame.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
frame.Active = true
frame.Draggable = true
frame.Parent = screenGui

local title = Instance.new("TextLabel")
title.Text = "Mouse Tracker"
title.Size = UDim2.new(1, 0, 0.2, 0)
title.TextColor3 = Color3.new(1, 1, 1)
title.BackgroundTransparency = 1
title.Parent = frame

-- Live Display (Shows where your mouse is currently)
local liveDisplay = Instance.new("TextLabel")
liveDisplay.Text = "X: 0, Y: 0"
liveDisplay.Size = UDim2.new(1, 0, 0.2, 0)
liveDisplay.Position = UDim2.new(0, 0, 0.2, 0)
liveDisplay.TextColor3 = Color3.fromRGB(0, 255, 150)
liveDisplay.BackgroundTransparency = 1
liveDisplay.Parent = frame

-- Helper to create buttons
local function createBtn(text, pos, color)
    local b = Instance.new("TextButton")
    b.Text = text
    b.Size = UDim2.new(0.9, 0, 0.18, 0)
    b.Position = pos
    b.BackgroundColor3 = color
    b.TextColor3 = Color3.new(1, 1, 1)
    b.Parent = frame
    Instance.new("UICorner", b)
    return b
end

local recBtn = createBtn("RECORD POSITION", UDim2.new(0.05, 0, 0.45, 0), Color3.fromRGB(60, 60, 60))
local copyBtn = createBtn("COPY ALL", UDim2.new(0.05, 0, 0.65, 0), Color3.fromRGB(40, 100, 200))
local closeBtn = createBtn("X", UDim2.new(0.85, 0, 0, 0), Color3.fromRGB(200, 50, 50))
closeBtn.Size = UDim2.new(0, 25, 0, 25)

-- Update Live Display
game:GetService("RunService").RenderStepped:Connect(function()
    local mousePos = UserInputService:GetMouseLocation()
    liveDisplay.Text = string.format("X: %d, Y: %d", mousePos.X, mousePos.Y)
end)

-- Record Logic
local function record()
    local mousePos = UserInputService:GetMouseLocation()
    local entry = string.format("X: %d, Y: %d", mousePos.X, mousePos.Y)
    table.insert(coordList, entry)
    
    recBtn.Text = "LOGGED!"
    task.wait(0.3)
    recBtn.Text = "RECORD POSITION"
end

-- Copy Logic
copyBtn.MouseButton1Click:Connect(function()
    local result = table.concat(coordList, "\n")
    if setclipboard then
        setclipboard(result)
        copyBtn.Text = "COPIED!"
    else
        copyBtn.Text = "NO CLIPBOARD SUPPORT"
    end
    task.wait(1)
    copyBtn.Text = "COPY ALL"
end)

recBtn.MouseButton1Click:Connect(record)
closeBtn.MouseButton1Click:Connect(function() screenGui:Destroy() end)

-- Keybind support
UserInputService.InputBegan:Connect(function(input, gpe)
    if not gpe and input.KeyCode == Enum.KeyCode.Y then
        record()
    end
end)
