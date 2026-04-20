local UserInputService = game:GetService("UserInputService")
local HttpService = game:GetService("HttpService")

-- Main ScreenGui
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "DeltaCoordTracker"
ScreenGui.Parent = game:GetService("CoreGui")

-- The Draggable Circle
local Circle = Instance.new("Frame")
Circle.Name = "DragCircle"
Circle.Size = UDim2.new(0, 50, 0, 50)
Circle.Position = UDim2.new(0.5, -25, 0.5, -25)
Circle.BackgroundColor3 = Color3.fromRGB(0, 255, 150)
Circle.BorderSizePixel = 0
Circle.Parent = ScreenGui

local UICorner = Instance.new("UICorner")
UICorner.CornerRadius = UDim(1, 0)
UICorner.Parent = Circle

-- Variables for Dragging
local dragging, dragInput, dragStart, startPos

local function update(input)
    local delta = input.Position - dragStart
    Circle.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
end

Circle.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragging = true
        dragStart = input.Position
        startPos = Circle.Position
        
        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then
                dragging = false
            end
        end)
    end
end)

Circle.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
        dragInput = input
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if input == dragInput and dragging then
        update(input)
    end
end)

-- The Menu
local Menu = Instance.new("Frame")
Menu.Size = UDim2.new(0, 150, 0, 120)
Menu.Position = UDim2.new(0, 10, 0.5, -60)
Menu.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
Menu.Parent = ScreenGui

local UIListLayout = Instance.new("UIListLayout")
UIListLayout.Parent = Menu
UIListLayout.Padding = UDim.new(0, 5)

local coordList = {}

-- Button Creator Function
local function createButton(text, color, callback)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(1, 0, 0, 35)
    btn.Text = text
    btn.BackgroundColor3 = color
    btn.TextColor3 = Color3.new(1, 1, 1)
    btn.Parent = Menu
    btn.MouseButton1Click:Connect(callback)
end

-- Add Coords Button
createButton("Add Current Coords", Color3.fromRGB(60, 60, 60), function()
    local pos = Circle.AbsolutePosition
    table.insert(coordList, string.format("X: %.1f, Y: %.1f", pos.X, pos.Y))
    print("Added: " .. coordList[#coordList])
end)

-- Copy List Button
createButton("Copy All Coords", Color3.fromRGB(0, 120, 200), function()
    local allCoords = table.concat(coordList, "\n")
    setclipboard(allCoords)
    print("Coordinates copied to clipboard!")
end)

-- Terminate Button (X)
createButton("X (Close Script)", Color3.fromRGB(150, 0, 0), function()
    ScreenGui:Destroy()
end)
