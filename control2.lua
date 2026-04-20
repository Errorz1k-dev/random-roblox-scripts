-- [[ CONFIG ]] --
local PageData = {
    {
        Name = "Main Farm",
        Coords = {
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
    },
    {
        Name = "Desert Area",
        Coords = {{100, 5, 100}, {150, 5, 200}}
    }
}

local running, curP, startI, alive = false, 1, 1, true

-- [[ SERVICES ]] --
local UIS = game:GetService("UserInputService")
local VIM = game:GetService("VirtualInputManager")
local Player = game.Players.LocalPlayer
local PlayerGui = Player:WaitForChild("PlayerGui")
local Camera = workspace.CurrentCamera

--- [[ UI GENERATION ]] ---
local ScreenGui = Instance.new("ScreenGui", PlayerGui)
ScreenGui.ResetOnSpawn = false
ScreenGui.IgnoreGuiInset = true -- Ensures UI doesn't shift on mobile notches

local Main = Instance.new("Frame", ScreenGui)
Main.Size = UDim2.new(0, 280, 0, 380)
Main.Position = UDim2.new(0.5, -140, 0.5, -190)
Main.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
Main.Active = true
Main.Draggable = true 

local Title = Instance.new("TextLabel", Main)
Title.Size = UDim2.new(1, -35, 0, 35)
Title.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
Title.TextColor3 = Color3.new(1,1,1)
Title.TextSize = 14

local CloseBtn = Instance.new("TextButton", Main)
CloseBtn.Size = UDim2.new(0, 35, 0, 35)
CloseBtn.Position = UDim2.new(1, -35, 0, 0)
CloseBtn.Text = "X"
CloseBtn.BackgroundColor3 = Color3.fromRGB(180, 50, 50)
CloseBtn.TextColor3 = Color3.new(1,1,1)

local InputBox = Instance.new("TextBox", Main)
InputBox.Size = UDim2.new(0.9, 0, 0, 30)
InputBox.Position = UDim2.new(0.05, 0, 0.12, 0)
InputBox.Text = "Hello"
InputBox.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
InputBox.TextColor3 = Color3.new(1,1,1)
InputBox.ClearTextOnFocus = false

local Scroll = Instance.new("ScrollingFrame", Main)
Scroll.Size = UDim2.new(0.9, 0, 0.4, 0)
Scroll.Position = UDim2.new(0.05, 0, 0.22, 0)
Scroll.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
Scroll.ScrollBarThickness = 4

local function updateButtons()
    Scroll:ClearAllChildren()
    local data = PageData[curP]
    Scroll.CanvasSize = UDim2.new(0, 0, 0, #data.Coords * 30)
    for i, _ in ipairs(data.Coords) do
        local b = Instance.new("TextButton", Scroll)
        b.Size = UDim2.new(1, -10, 0, 25)
        b.Position = UDim2.new(0, 5, 0, (i-1)*30)
        b.Text = "Point " .. i
        b.BackgroundColor3 = (startI == i) and Color3.fromRGB(80, 80, 150) or Color3.fromRGB(45, 45, 45)
        b.TextColor3 = Color3.new(1,1,1)
        b.MouseButton1Click:Connect(function()
            startI = i
            updateButtons()
        end)
    end
    Title.Text = data.Name .. " (" .. curP .. "/" .. #PageData .. ")"
end

local NextBtn = Instance.new("TextButton", Main)
NextBtn.Size = UDim2.new(0.42, 0, 0, 30)
NextBtn.Position = UDim2.new(0.53, 0, 0.65, 0)
NextBtn.Text = "Next >"
NextBtn.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
NextBtn.TextColor3 = Color3.new(1,1,1)

local PrevBtn = Instance.new("TextButton", Main)
PrevBtn.Size = UDim2.new(0.42, 0, 0, 30)
PrevBtn.Position = UDim2.new(0.05, 0, 0.65, 0)
PrevBtn.Text = "< Prev"
PrevBtn.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
PrevBtn.TextColor3 = Color3.new(1,1,1)

local Toggle = Instance.new("TextButton", Main)
Toggle.Size = UDim2.new(0.9, 0, 0, 50)
Toggle.Position = UDim2.new(0.05, 0, 0.8, 0)
Toggle.Text = "START"
Toggle.BackgroundColor3 = Color3.fromRGB(50, 150, 50)
Toggle.TextColor3 = Color3.new(1,1,1)

--- [[ LOGIC ]] ---

-- Delta/Mobile friendly tap function
local function tap(x, y)
    -- VirtualInputManager is used here, but coordinates are often local to the screen resolution.
    VIM:SendMouseButtonEvent(x, y, 0, true, game, 0)
    task.wait(0.1)
    VIM:SendMouseButtonEvent(x, y, 0, false, game, 0)
end

local function handleType(txt)
    task.wait(0.3)
    -- On mobile, focus-based text setting is much more reliable than key simulation
    local box = UIS:GetFocusedTextBox()
    if box then
        box.Text = txt
        task.wait(0.1)
        box:ReleaseFocus(true)
    else
        -- Mobile Delta fallback: Some executors provide a 'setrbxclipboard' or similar, 
        -- but here we stick to VIM for learning.
        for i = 1, #txt do
            local char = txt:sub(i,i)
            pcall(function()
                local code = Enum.KeyCode[char:upper()] or Enum.KeyCode[char]
                VIM:SendKeyEvent(true, code, false, game)
                task.wait(0.02)
                VIM:SendKeyEvent(false, code, false, game)
            end)
        end
        VIM:SendKeyEvent(true, Enum.KeyCode.Return, false, game)
    end
end

local function startLoop()
    running = true
    Toggle.Text = "STOP"
    Toggle.BackgroundColor3 = Color3.fromRGB(150, 50, 50)
    
    -- Using a while loop to allow for page progression if desired
    while running and alive do
        local page = PageData[curP]
        for i = startI, #page.Coords do
            if not running or not alive then break end
            
            local v = page.Coords[i]
            local char = Player.Character or Player.CharacterAdded:Wait()
            local root = char:WaitForChild("HumanoidRootPart", 5)
            
            if root then
                -- Countdown (Adjusted for UI feedback)
                for count = 2, 1, -1 do
                    if not running then break end
                    Title.Text = "Teleporting: " .. count
                    task.wait(1)
                end
                
                if not running then break end

                Title.Text = "Active: Pt " .. i
                
                -- Teleport Logic
                root.CFrame = CFrame.new(v[1], v[2], v[3])
                task.wait(0.5)

                -- Interaction Logic (Ensure these X/Y match your specific game UI on mobile)
                tap(768, 400)
                task.wait(0.4)

                -- Mobile doesn't have a "Wheel", we simulate a small wait or 
                -- movement to ensure the game registers the state change.
                task.wait(0.4)

                tap(900, 672)
                task.wait(0.5)

                tap(764, 233)
                handleType(InputBox.Text)
                task.wait(0.5)

                tap(765, 312)
                task.wait(1)
            end
        end
        -- Auto-stop after one loop through the page
        running = false 
    end
    
    Toggle.Text = "START"
    Toggle.BackgroundColor3 = Color3.fromRGB(50, 150, 50)
    updateButtons()
end

--- [[ UI EVENTS ]] ---

NextBtn.MouseButton1Click:Connect(function()
    if PageData[curP + 1] then
        curP = curP + 1
        startI = 1
        updateButtons()
    end
end)

PrevBtn.MouseButton1Click:Connect(function()
    if PageData[curP - 1] then
        curP = curP - 1
        startI = 1
        updateButtons()
    end
end)

Toggle.MouseButton1Click:Connect(function()
    if running then 
        running = false 
    else 
        task.spawn(startLoop) 
    end
end)

CloseBtn.MouseButton1Click:Connect(function()
    alive = false
    running = false
    ScreenGui:Destroy()
end)

updateButtons()
