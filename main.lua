local Players = game:GetService("Players")
local TeleportService = game:GetService("TeleportService")
local HttpService = game:GetService("HttpService")

local LocalPlayer = Players.LocalPlayer
local PlaceId = game.PlaceId

-- GUI
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "CiaoHUB ServerHOPGUI"
ScreenGui.ResetOnSpawn = false

if syn and syn.protect_gui then
    syn.protect_gui(ScreenGui)
    ScreenGui.Parent = game.CoreGui
elseif gethui then
    ScreenGui.Parent = gethui()
else
    ScreenGui.Parent = game.CoreGui
end

-- ==============================
-- TOGGLE BUTTON (dengan resize slider)
-- ==============================
local ToggleBtn = Instance.new("TextButton")
ToggleBtn.Name = "ToggleButton"
ToggleBtn.Parent = ScreenGui
ToggleBtn.BackgroundColor3 = Color3.fromRGB(30, 30, 50)
ToggleBtn.BorderSizePixel = 0
ToggleBtn.Position = UDim2.new(0, 10, 0, 10)
ToggleBtn.Size = UDim2.new(0, 120, 0, 35)
ToggleBtn.Font = Enum.Font.GothamBold
ToggleBtn.Text = "◀ Hide Script"
ToggleBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
ToggleBtn.TextSize = 13
Instance.new("UICorner", ToggleBtn).CornerRadius = UDim.new(0, 8)

-- Shadow effect
local ToggleShadow = Instance.new("UIStroke", ToggleBtn)
ToggleShadow.Color = Color3.fromRGB(100, 100, 200)
ToggleShadow.Thickness = 1.5

-- ==============================
-- RESIZE PANEL (muncul di samping toggle)
-- ==============================
local ResizePanel = Instance.new("Frame")
ResizePanel.Parent = ScreenGui
ResizePanel.BackgroundColor3 = Color3.fromRGB(20, 20, 30)
ResizePanel.BorderSizePixel = 0
ResizePanel.Position = UDim2.new(0, 135, 0, 10)
ResizePanel.Size = UDim2.new(0, 0, 0, 35)
ResizePanel.Visible = false
ResizePanel.ClipsDescendants = true
Instance.new("UICorner", ResizePanel).CornerRadius = UDim.new(0, 8)

-- Panel stroke
local PanelStroke = Instance.new("UIStroke", ResizePanel)
PanelStroke.Color = Color3.fromRGB(80, 80, 200)
PanelStroke.Thickness = 1

-- Slider untuk resize
local Slider = Instance.new("Frame")
Slider.Parent = ResizePanel
Slider.BackgroundColor3 = Color3.fromRGB(50, 50, 80)
Slider.BorderSizePixel = 0
Slider.Position = UDim2.new(0, 10, 0, 10)
Slider.Size = UDim2.new(0, 0, 0, 15)
Instance.new("UICorner", Slider).CornerRadius = UDim.new(0, 4)

-- Slider fill (progress)
local SliderFill = Instance.new("Frame")
SliderFill.Parent = Slider
SliderFill.BackgroundColor3 = Color3.fromRGB(100, 100, 255)
SliderFill.BorderSizePixel = 0
SliderFill.Size = UDim2.new(0.5, 0, 1, 0)
Instance.new("UICorner", SliderFill).CornerRadius = UDim.new(0, 4)

-- Slider handle (bulat)
local SliderHandle = Instance.new("TextButton")
SliderHandle.Parent = Slider
SliderHandle.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
SliderHandle.BorderSizePixel = 0
SliderHandle.Position = UDim2.new(0.5, -8, 0, -3)
SliderHandle.Size = UDim2.new(0, 16, 0, 21)
SliderHandle.Text = ""
Instance.new("UICorner", SliderHandle).CornerRadius = UDim.new(0, 8)

-- Label ukuran
local SizeLabel = Instance.new("TextLabel")
SizeLabel.Parent = ResizePanel
SizeLabel.BackgroundTransparency = 1
SizeLabel.Position = UDim2.new(0, 130, 0, 0)
SizeLabel.Size = UDim2.new(0, 50, 0, 35)
SizeLabel.Font = Enum.Font.GothamBold
SizeLabel.Text = "120"
SizeLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
SizeLabel.TextSize = 14

-- Tombol +/- 
local MinusBtn = Instance.new("TextButton")
MinusBtn.Parent = ResizePanel
MinusBtn.BackgroundColor3 = Color3.fromRGB(40, 40, 60)
MinusBtn.BorderSizePixel = 0
MinusBtn.Position = UDim2.new(0, 185, 0, 5)
MinusBtn.Size = UDim2.new(0, 25, 0, 25)
MinusBtn.Font = Enum.Font.GothamBold
MinusBtn.Text = "−"
MinusBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
MinusBtn.TextSize = 18
Instance.new("UICorner", MinusBtn).CornerRadius = UDim.new(0, 6)

local PlusBtn = Instance.new("TextButton")
PlusBtn.Parent = ResizePanel
PlusBtn.BackgroundColor3 = Color3.fromRGB(40, 40, 60)
PlusBtn.BorderSizePixel = 0
PlusBtn.Position = UDim2.new(0, 215, 0, 5)
PlusBtn.Size = UDim2.new(0, 25, 0, 25)
PlusBtn.Font = Enum.Font.GothamBold
PlusBtn.Text = "+"
PlusBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
PlusBtn.TextSize = 18
Instance.new("UICorner", PlusBtn).CornerRadius = UDim.new(0, 6)

-- ==============================
-- ANIMASI PANEL
-- ==============================
local panelVisible = false
local currentSize = 120
local minSize = 60
local maxSize = 300
local targetWidth = 0

local function updatePanelWidth(width)
    targetWidth = width
    ResizePanel.Size = UDim2.new(0, width, 0, 35)
    Slider.Size = UDim2.new(0, width - 120, 0, 15)
end

local function updateToggleSize(size)
    size = math.clamp(size, minSize, maxSize)
    currentSize = size
    ToggleBtn.Size = UDim2.new(0, size, 0, 35)
    SizeLabel.Text = tostring(size)
    
    -- Update slider fill
    local percent = (size - minSize) / (maxSize - minSize)
    SliderFill.Size = UDim2.new(percent, 0, 1, 0)
    SliderHandle.Position = UDim2.new(percent, -8, 0, -3)
end

local function togglePanel()
    panelVisible = not panelVisible
    if panelVisible then
        ResizePanel.Visible = true
        updatePanelWidth(250)
        ToggleBtn.Text = "◀ Hide Script"
        -- Update posisi toggle
        ToggleBtn.Position = UDim2.new(0, 10, 0, 10)
    else
        updatePanelWidth(0)
        task.wait(0.2)
        ResizePanel.Visible = false
        ToggleBtn.Text = "▶ Show Script"
    end
end

-- ==============================
-- DRAG SLIDER
-- ==============================
local dragging = false

SliderHandle.MouseButton1Down:Connect(function()
    dragging = true
end)

game:GetService("UserInputService").InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = false
    end
end)

game:GetService("UserInputService").InputChanged:Connect(function(input)
    if dragging and input.UserInputType == Enum.UserInputType.MousePosition then
        local mousePos = input.Position.X
        local sliderPos = Slider.AbsolutePosition.X
        local sliderWidth = Slider.AbsoluteSize.X
        
        local percent = math.clamp((mousePos - sliderPos) / sliderWidth, 0, 1)
        local newSize = math.round(minSize + (maxSize - minSize) * percent)
        updateToggleSize(newSize)
    end
end)

-- ==============================
-- BUTTON +/- 
-- ==============================
MinusBtn.MouseButton1Click:Connect(function()
    updateToggleSize(currentSize - 5)
end)

PlusBtn.MouseButton1Click:Connect(function()
    updateToggleSize(currentSize + 5)
end)

-- ==============================
-- TOGGLE KLIK UNTUK HIDE/SHOW
-- ==============================
ToggleBtn.MouseButton1Click:Connect(function()
    if panelVisible then
        togglePanel() -- Tutup panel dulu
        task.wait(0.3)
    end
    -- Hide/show main frame
    MainFrame.Visible = not MainFrame.Visible
    if MainFrame.Visible then
        ToggleBtn.Text = "◀ Hide Script"
    else
        ToggleBtn.Text = "▶ Show Script"
    end
end)

-- Klik kanan untuk resize panel
ToggleBtn.MouseButton2Click:Connect(function()
    togglePanel()
end)

-- ==============================
-- MAIN FRAME
-- ==============================
local MainFrame = Instance.new("Frame")
MainFrame.Parent = ScreenGui
MainFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 30)
MainFrame.BorderSizePixel = 0
MainFrame.Position = UDim2.new(0.5, -145, 0.5, -110)
MainFrame.Size = UDim2.new(0, 290, 0, 220)
MainFrame.Active = true
MainFrame.Draggable = true
MainFrame.Visible = true
Instance.new("UICorner", MainFrame).CornerRadius = UDim.new(0, 8)

-- Main frame glow
local MainGlow = Instance.new("UIStroke", MainFrame)
MainGlow.Color = Color3.fromRGB(80, 80, 200)
MainGlow.Thickness = 1.5

local BorderGlow = Instance.new("UIGradient", MainGlow)
BorderGlow.Color = ColorSequence.new({
    ColorSequenceKeypoint.new(0, Color3.fromRGB(80, 80, 200)),
    ColorSequenceKeypoint.new(0.5, Color3.fromRGB(200, 80, 200)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(80, 80, 200))
})

-- Title
local Title = Instance.new("TextLabel", MainFrame)
Title.Size = UDim2.new(1, 0, 0, 36)
Title.BackgroundColor3 = Color3.fromRGB(35, 35, 55)
Title.BorderSizePixel = 0
Title.Font = Enum.Font.GothamBold
Title.Text = "✦ CiaoHUB ServerHop ✦"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.TextSize = 15
Instance.new("UICorner", Title).CornerRadius = UDim.new(0, 8)

local TitleGradient = Instance.new("UIGradient", Title)
TitleGradient.Color = ColorSequence.new({
    ColorSequenceKeypoint.new(0, Color3.fromRGB(40, 40, 70)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(30, 30, 50))
})

local CloseBtn = Instance.new("TextButton", MainFrame)
CloseBtn.BackgroundTransparency = 1
CloseBtn.Position = UDim2.new(1, -28, 0, 6)
CloseBtn.Size = UDim2.new(0, 22, 0, 22)
CloseBtn.Font = Enum.Font.GothamBold
CloseBtn.Text = "✕"
CloseBtn.TextColor3 = Color3.fromRGB(255, 70, 70)
CloseBtn.TextSize = 14
CloseBtn.MouseButton1Click:Connect(function() 
    ScreenGui:Destroy() 
end)

-- Player count
local NowLabel = Instance.new("TextLabel", MainFrame)
NowLabel.Position = UDim2.new(0, 10, 0, 44)
NowLabel.Size = UDim2.new(1, -20, 0, 22)
NowLabel.BackgroundTransparency = 1
NowLabel.Font = Enum.Font.GothamBold
NowLabel.TextXAlignment = Enum.TextXAlignment.Left
NowLabel.TextColor3 = Color3.fromRGB(100, 220, 100)
NowLabel.TextSize = 13
NowLabel.Text = "👥 Player: 0"

-- Status
local StatusLabel = Instance.new("TextLabel", MainFrame)
StatusLabel.Position = UDim2.new(0, 10, 0, 70)
StatusLabel.Size = UDim2.new(1, -20, 0, 30)
StatusLabel.BackgroundTransparency = 1
StatusLabel.Font = Enum.Font.Gotham
StatusLabel.TextXAlignment = Enum.TextXAlignment.Left
StatusLabel.TextColor3 = Color3.fromRGB(180, 180, 180)
StatusLabel.TextSize = 12
StatusLabel.TextWrapped = true
StatusLabel.Text = "⚡ Siap. Set angka lalu tekan Hop."

-- Max player
local MaxLabel = Instance.new("TextLabel", MainFrame)
MaxLabel.Position = UDim2.new(0, 10, 0, 105)
MaxLabel.Size = UDim2.new(1, -20, 0, 18)
MaxLabel.BackgroundTransparency = 1
MaxLabel.Font = Enum.Font.Gotham
MaxLabel.TextXAlignment = Enum.TextXAlignment.Left
MaxLabel.TextColor3 = Color3.fromRGB(160, 160, 160)
MaxLabel.TextSize = 11
MaxLabel.Text = "🎯 Hop jika player LEBIH dari:"

local MaxBox = Instance.new("TextBox", MainFrame)
MaxBox.Position = UDim2.new(0, 10, 0, 126)
MaxBox.Size = UDim2.new(1, -20, 0, 28)
MaxBox.BackgroundColor3 = Color3.fromRGB(35, 35, 55)
MaxBox.BorderSizePixel = 0
MaxBox.Font = Enum.Font.GothamBold
MaxBox.Text = "1"
MaxBox.TextColor3 = Color3.fromRGB(255, 255, 255)
MaxBox.TextSize = 14
MaxBox.ClearTextOnFocus = false
Instance.new("UICorner", MaxBox).CornerRadius = UDim.new(0, 6)

-- Buttons
local HopBtn = Instance.new("TextButton", MainFrame)
HopBtn.Position = UDim2.new(0, 10, 0, 162)
HopBtn.Size = UDim2.new(0, 125, 0, 45)
HopBtn.BackgroundColor3 = Color3.fromRGB(60, 60, 180)
HopBtn.BorderSizePixel = 0
HopBtn.Font = Enum.Font.GothamBold
HopBtn.Text = "🚀 Hop Sekali"
HopBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
HopBtn.TextSize = 13
Instance.new("UICorner", HopBtn).CornerRadius = UDim.new(0, 6)

local AutoBtn = Instance.new("TextButton", MainFrame)
AutoBtn.Position = UDim2.new(0, 145, 0, 162)
AutoBtn.Size = UDim2.new(0, 135, 0, 45)
AutoBtn.BackgroundColor3 = Color3.fromRGB(40, 120, 70)
AutoBtn.BorderSizePixel = 0
AutoBtn.Font = Enum.Font.GothamBold
AutoBtn.Text = "🔄 Auto Hop: OFF"
AutoBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
AutoBtn.TextSize = 13
Instance.new("UICorner", AutoBtn).CornerRadius = UDim.new(0, 6)

-- ==============================
-- LOGIC
-- ==============================

local autoEnabled = false
local autoThread = nil

-- Update player count
task.spawn(function()
    while ScreenGui.Parent do
        local count = #Players:GetPlayers()
        NowLabel.Text = "👥 Player: " .. count
        task.wait(1)
    end
end)

local function getRandomServer()
    local url = "https://games.roblox.com/v1/games/" .. PlaceId .. "/servers/Public?sortOrder=Asc&limit=100"
    local ok, raw = pcall(function() return game:HttpGet(url) end)
    if not ok or not raw or raw == "" then return nil end

    local ok2, data = pcall(HttpService.JSONDecode, HttpService, raw)
    if not ok2 or not data or not data.data or #data.data == 0 then return nil end

    local currentId = tostring(game.JobId)
    local candidates = {}
    for _, s in ipairs(data.data) do
        if s.id and tostring(s.id) ~= currentId then
            table.insert(candidates, tostring(s.id))
        end
    end

    if #candidates == 0 then return nil end
    return candidates[math.random(1, #candidates)]
end

local function hopOnce()
    local threshold = math.max(1, math.floor(tonumber(MaxBox.Text) or 1))
    local currentCount = #Players:GetPlayers()

    if currentCount <= threshold then
        StatusLabel.Text = "✅ Server ini sudah " .. currentCount .. " player. Tidak perlu hop."
        StatusLabel.TextColor3 = Color3.fromRGB(100, 220, 100)
        return false
    end

    StatusLabel.Text = "⏳ Server ini " .. currentCount .. " player. Mencari server lain..."
    StatusLabel.TextColor3 = Color3.fromRGB(255, 200, 50)
    task.wait(0.5)

    local serverId = getRandomServer()
    if not serverId then
        StatusLabel.Text = "❌ Gagal ambil server list. Cek HTTP Request di executor."
        StatusLabel.TextColor3 = Color3.fromRGB(255, 80, 80)
        return false
    end

    StatusLabel.Text = "🔄 Teleport ke server lain..."
    StatusLabel.TextColor3 = Color3.fromRGB(120, 180, 255)
    task.wait(0.5)

    local ok, err = pcall(function()
        TeleportService:TeleportToPlaceInstance(PlaceId, serverId, LocalPlayer)
    end)

    if not ok then
        StatusLabel.Text = "❌ Teleport error: " .. tostring(err):sub(1, 60)
        StatusLabel.TextColor3 = Color3.fromRGB(255, 80, 80)
        return false
    end

    return true
end

HopBtn.MouseButton1Click:Connect(function()
    HopBtn.Active = false
    hopOnce()
    task.wait(2)
    HopBtn.Active = true
end)

AutoBtn.MouseButton1Click:Connect(function()
    autoEnabled = not autoEnabled

    if autoEnabled then
        AutoBtn.Text = "🔄 Auto Hop: ON"
        AutoBtn.BackgroundColor3 = Color3.fromRGB(180, 50, 50)

        autoThread = task.spawn(function()
            while autoEnabled and ScreenGui.Parent do
                local threshold = math.max(1, math.floor(tonumber(MaxBox.Text) or 1))
                local count = #Players:GetPlayers()

                if count <= threshold then
                    StatusLabel.Text = "✅ " .. count .. " player di sini. Menunggu..."
                    StatusLabel.TextColor3 = Color3.fromRGB(100, 220, 100)
                    task.wait(3)
                else
                    hopOnce()
                    task.wait(5)
                end
            end
        end)
    else
        AutoBtn.Text = "🔄 Auto Hop: OFF"
        AutoBtn.BackgroundColor3 = Color3.fromRGB(40, 120, 70)
        if autoThread then
            task.cancel(autoThread)
            autoThread = nil
        end
        StatusLabel.Text = "⏹ Auto Hop dihentikan."
        StatusLabel.TextColor3 = Color3.fromRGB(180, 180, 180)
    end
end)

-- Init
StatusLabel.Text = "⚡ Siap. Set angka lalu tekan Hop."
StatusLabel.TextColor3 = Color3.fromRGB(180, 180, 180)

-- Inisialisasi ukuran toggle
updateToggleSize(120)
