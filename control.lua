-- [[ CONFIG ]] --
local running = false
local startIndex = 1
local alive = true

-- [[ SERVICES ]] --
local UserInputService = game:GetService("UserInputService")
local VirtualInputManager = game:GetService("VirtualInputManager")
local Player = game.Players.LocalPlayer
local PlayerGui = Player:WaitForChild("PlayerGui")
local Camera = workspace.CurrentCamera

local coords = {
    {-235.83, 3.75, -118.40}, {-222.97, 3.75, -100.41}, {-244.63, 3.75, -104.96},
    {-230.03, 3.75, -84.74}, {-247.48, 3.75, -91.16}, {-244.15, 3.75, -72.97},
    {-262.26, 3.58, -79.37}, {-271.96, 3.75, -75.84}, {-287.38, 3.75, -85.68},
    {-303.44, 3.75, -80.53}, {-309.90, 3.75, -73.60}, {-323.81, 3.75, -73.20},
    {-341.20, 3.75, -66.98}, {-333.76, 3.75, -91.04}, {-312.08, 3.49, -101.74},
    {-280.22, 3.75, -112.21}, {-265.83, 3.75, -119.20}, {-253.15, 3.75, -127.77},
    {-226.19, 3.75, -138.64}, {-200.15, 3.75, -122.00}, {-194.39, 3.75, -137.07},
    {-213.79, 3.75, -150.15}, {-192.34, 3.75, -153.26}, {-183.51, 3.75, -164.44},
    {-168.58, 3.42, -153.23}, {-159.77, 3.75, -153.77}, {-147.93, 3.75, -151.23},
    {-145.18, 3.75, -167.97}, {-161.21, 3.75, -173.68}, {-148.19, 3.75, -186.76},
    {-156.68, 3.75, -202.54}, {-149.17, 3.75, -211.97}, {-175.05, 3.75, -188.81},
    {-189.51, 3.75, -178.65}, {-205.32, 3.75, -185.54}, {-229.49, 3.75, -199.83},
    {-241.01, 3.75, -215.79}, {-256.70, 3.75, -216.75}, {-251.40, 3.75, -240.67},
    {-277.76, 3.75, -240.53}, {-300.08, 3.75, -256.79}, {-326.10, 3.75, -198.40},
    {-295.17, 3.75, -174.93}
}

--- [[ UI ]] ---
local ScreenGui = Instance.new("ScreenGui", PlayerGui)
local Main = Instance.new("Frame", ScreenGui)
Main.Size = UDim2.new(0, 260, 0, 320)
Main.Position = UDim2.new(0.5, -130, 0.5, -160)
Main.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
Main.Active = true
Main.Draggable = true

local Title = Instance.new("TextLabel", Main)
Title.Size = UDim2.new(1, -35, 0, 30)
Title.Text = "Coord Runner Fast"
Title.TextColor3 = Color3.new(1,1,1)
Title.BackgroundColor3 = Color3.fromRGB(45, 45, 45)

local CloseBtn = Instance.new("TextButton", Main)
CloseBtn.Size = UDim2.new(0, 30, 0, 30)
CloseBtn.Position = UDim2.new(1, -30, 0, 0)
CloseBtn.Text = "X"
CloseBtn.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
CloseBtn.TextColor3 = Color3.new(1,1,1)

local InputBox = Instance.new("TextBox", Main)
InputBox.Size = UDim2.new(0.9, 0, 0, 30)
InputBox.Position = UDim2.new(0.05, 0, 0.12, 0)
InputBox.PlaceholderText = "Word to type here..."
InputBox.Text = "Hello"
InputBox.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
InputBox.TextColor3 = Color3.new(1,1,1)

local Scroll = Instance.new("ScrollingFrame", Main)
Scroll.Size = UDim2.new(0.9, 0, 0.45, 0)
Scroll.Position = UDim2.new(0.05, 0, 0.25, 0)
Scroll.CanvasSize = UDim2.new(0, 0, 0, #coords * 30)
Scroll.BackgroundColor3 = Color3.fromRGB(20, 20, 20)

for i, v in ipairs(coords) do
    local b = Instance.new("TextButton", Scroll)
    b.Size = UDim2.new(1, -10, 0, 25)
    b.Position = UDim2.new(0, 5, 0, (i-1)*28)
    b.Text = "Point " .. i
    b.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    b.TextColor3 = Color3.new(1,1,1)
    b.MouseButton1Click:Connect(function()
        startIndex = i
        Title.Text = "Start: Point " .. i
    end)
end

local Toggle = Instance.new("TextButton", Main)
Toggle.Size = UDim2.new(0.9, 0, 0, 40)
Toggle.Position = UDim2.new(0.05, 0, 0.75, 0)
Toggle.Text = "START"
Toggle.BackgroundColor3 = Color3.fromRGB(50, 150, 50)
Toggle.TextColor3 = Color3.new(1,1,1)

--- [[ FUNCTIONS ]] ---

local function click(x, y)
    VirtualInputManager:SendMouseMoveEvent(x, y, game)
    task.wait(0.1)
    VirtualInputManager:SendMouseButtonEvent(x, y, 0, true, game, 0)
    task.wait(0.05)
    VirtualInputManager:SendMouseButtonEvent(x, y, 0, false, game, 0)
end

local function typeText(txt)
    task.wait(0.2)
    local box = UserInputService:GetFocusedTextBox()
    if box then
        box.Text = txt
        box:ReleaseFocus(true)
    else
        for i = 1, #txt do
            local key = Enum.KeyCode[txt:sub(i,i):upper()]
            VirtualInputManager:SendKeyEvent(true, key, false, game)
            task.wait(0.02)
            VirtualInputManager:SendKeyEvent(false, key, false, game)
        end
        VirtualInputManager:SendKeyEvent(true, Enum.KeyCode.Return, false, game)
    end
end

local function main()
    running = true
    Toggle.Text = "STOP"
    Toggle.BackgroundColor3 = Color3.fromRGB(150, 50, 50)
    
    for i = startIndex, #coords do
        if not running or not alive then break end
        local v = coords[i]
        local char = Player.Character or Player.CharacterAdded:Wait()
        
        -- Speed: Minimal Teleport Wait
        Player.CameraMode = Enum.CameraMode.LockFirstPerson
        Camera.CFrame = CFrame.new(Camera.CFrame.Position, Camera.CFrame.Position + Vector3.new(0, -1, 0))
        char:MoveTo(Vector3.new(v[1], v[2], v[3]))
        task.wait(0.4)

        click(768, 400)
        task.wait(0.3)

        Player.CameraMode = Enum.CameraMode.Classic
        VirtualInputManager:SendMouseWheelEvent(960, 540, false, game)
        task.wait(0.3)

        for _=1, 4 do VirtualInputManager:SendMouseWheelEvent(900, 672, false, game) task.wait(0.02) end
        click(900, 672)
        task.wait(0.4)

        click(764, 233)
        typeText(InputBox.Text)
        task.wait(0.4)

        click(765, 312)
        task.wait(0.8)
    end
    
    running = false
    Toggle.Text = "START"
    Toggle.BackgroundColor3 = Color3.fromRGB(50, 150, 50)
end

--- [[ EVENTS ]] ---

Toggle.MouseButton1Click:Connect(function()
    if running then running = false else task.spawn(main) end
end)

CloseBtn.MouseButton1Click:Connect(function()
    alive = false
    running = false
    ScreenGui:Destroy()
end)

UserInputService.InputBegan:Connect(function(input, gp)
    if not gp and input.KeyCode == Enum.KeyCode.Y then
        running = false
    end
end)
