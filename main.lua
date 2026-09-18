local HttpService = game:GetService("HttpService")
local TeleportService = game:GetService("TeleportService")
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

-- LAPIS 1: COOLDOWN PERSISTEN DI ENVIRONMENT EXECUTOR TERATAS
local globalEnv = (getgenv and getgenv()) or shared or _G
globalEnv.ServerHop_CooldownEnd = globalEnv.ServerHop_CooldownEnd or 0

-- Hapus GUI lama jika ada
if game.CoreGui:FindFirstChild("ServerHopPanelGUI") then
    game.CoreGui.ServerHopPanelGUI:Destroy()
end

-- ScreenGui
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "ServerHopPanelGUI"
ScreenGui.Parent = game.CoreGui
ScreenGui.ResetOnSpawn = false

-- Main Frame
local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.Size = UDim2.new(0, 440, 0, 250)
MainFrame.Position = UDim2.new(0.5, -220, 0.5, -125)
MainFrame.BackgroundColor3 = Color3.fromRGB(15, 23, 42)
MainFrame.BorderSizePixel = 0
MainFrame.Active = true
MainFrame.Draggable = true
MainFrame.Parent = ScreenGui

local MainUICorner = Instance.new("UICorner")
MainUICorner.CornerRadius = UDim.new(0, 12)
MainUICorner.Parent = MainFrame

-- Border Cyan
local UIStroke = Instance.new("UIStroke")
UIStroke.Color = Color3.fromRGB(6, 182, 212)
UIStroke.Thickness = 2.5
UIStroke.Parent = MainFrame

-- Title Text
local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(0, 180, 0, 25)
Title.Position = UDim2.new(0, 15, 0, 10)
Title.BackgroundTransparency = 1
Title.Text = "SERVER HOP PANEL"
Title.TextColor3 = Color3.fromRGB(6, 182, 212)
Title.TextSize = 13
Title.Font = Enum.Font.GothamBold
Title.TextXAlignment = Enum.TextXAlignment.Left
Title.Parent = MainFrame

-- Red Close Button
local CloseBtn = Instance.new("TextButton")
CloseBtn.Size = UDim2.new(0, 24, 0, 24)
CloseBtn.Position = UDim2.new(1, -34, 0, 10)
CloseBtn.BackgroundColor3 = Color3.fromRGB(239, 68, 68)
CloseBtn.Text = "X"
CloseBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
CloseBtn.TextSize = 12
CloseBtn.Font = Enum.Font.GothamBold
CloseBtn.Parent = MainFrame

local CloseCorner = Instance.new("UICorner")
CloseCorner.CornerRadius = UDim.new(0, 6)
CloseCorner.Parent = CloseBtn

CloseBtn.MouseButton1Click:Connect(function()
    ScreenGui:Destroy()
end)

-- Left Side Components --
local LeftFrame = Instance.new("Frame")
LeftFrame.Size = UDim2.new(0, 185, 0, 180)
LeftFrame.Position = UDim2.new(0, 15, 0, 42)
LeftFrame.BackgroundTransparency = 1
LeftFrame.Parent = MainFrame

-- Max Player Label
local MaxPlayerLabel = Instance.new("TextLabel")
MaxPlayerLabel.Size = UDim2.new(1, 0, 0, 16)
MaxPlayerLabel.Position = UDim2.new(0, 0, 0, 0)
MaxPlayerLabel.BackgroundTransparency = 1
MaxPlayerLabel.Text = "Maksimal Player:"
MaxPlayerLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
MaxPlayerLabel.TextSize = 11
MaxPlayerLabel.Font = Enum.Font.GothamBold
MaxPlayerLabel.TextXAlignment = Enum.TextXAlignment.Left
MaxPlayerLabel.Parent = LeftFrame

-- Max Player TextBox
local MaxPlayerBox = Instance.new("TextBox")
MaxPlayerBox.Size = UDim2.new(1, 0, 0, 26)
MaxPlayerBox.Position = UDim2.new(0, 0, 0, 20)
MaxPlayerBox.BackgroundColor3 = Color3.fromRGB(23, 32, 54)
MaxPlayerBox.Text = "1"
MaxPlayerBox.TextColor3 = Color3.fromRGB(255, 255, 255)
MaxPlayerBox.TextSize = 12
MaxPlayerBox.Font = Enum.Font.GothamBold
MaxPlayerBox.Parent = LeftFrame

local MaxBoxCorner = Instance.new("UICorner")
MaxBoxCorner.CornerRadius = UDim.new(0, 6)
MaxBoxCorner.Parent = MaxPlayerBox

-- Hop Server Button
local HopBtn = Instance.new("TextButton")
HopBtn.Size = UDim2.new(1, 0, 0, 28)
HopBtn.Position = UDim2.new(0, 0, 0, 54)
HopBtn.BackgroundColor3 = Color3.fromRGB(14, 165, 233)
HopBtn.Text = "🚀 HOP SERVER"
HopBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
HopBtn.TextSize = 11
HopBtn.Font = Enum.Font.GothamBold
HopBtn.Parent = LeftFrame

local HopCorner = Instance.new("UICorner")
HopCorner.CornerRadius = UDim.new(0, 6)
HopCorner.Parent = HopBtn

-- Rejoin Server Button
local RejoinBtn = Instance.new("TextButton")
RejoinBtn.Size = UDim2.new(1, 0, 0, 28)
RejoinBtn.Position = UDim2.new(0, 0, 0, 88)
RejoinBtn.BackgroundColor3 = Color3.fromRGB(23, 32, 54)
RejoinBtn.Text = "🔄 REJOIN SERVER"
RejoinBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
RejoinBtn.TextSize = 11
RejoinBtn.Font = Enum.Font.GothamBold
RejoinBtn.Parent = LeftFrame

local RejoinCorner = Instance.new("UICorner")
RejoinCorner.CornerRadius = UDim.new(0, 6)
RejoinCorner.Parent = RejoinBtn

-- Random Server Button
local RandomBtn = Instance.new("TextButton")
RandomBtn.Size = UDim2.new(1, 0, 0, 28)
RandomBtn.Position = UDim2.new(0, 0, 0, 122)
RandomBtn.BackgroundColor3 = Color3.fromRGB(23, 32, 54)
RandomBtn.Text = "🎲 RANDOM SERVER"
RandomBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
RandomBtn.TextSize = 11
RandomBtn.Font = Enum.Font.GothamBold
RandomBtn.Parent = LeftFrame

local RandomCorner = Instance.new("UICorner")
RandomCorner.CornerRadius = UDim.new(0, 6)
RandomCorner.Parent = RandomBtn

-- Status Label
local StatusLabel = Instance.new("TextLabel")
StatusLabel.Size = UDim2.new(1, 0, 0, 16)
StatusLabel.Position = UDim2.new(0, 0, 0, 158)
StatusLabel.BackgroundTransparency = 1
StatusLabel.Text = "Status: Siap 💡"
StatusLabel.TextColor3 = Color3.fromRGB(74, 222, 128)
StatusLabel.TextSize = 10
StatusLabel.Font = Enum.Font.GothamBold
StatusLabel.TextXAlignment = Enum.TextXAlignment.Left
StatusLabel.Parent = LeftFrame

-- Right Side Components --
local RefreshBtn = Instance.new("TextButton")
RefreshBtn.Size = UDim2.new(0, 210, 0, 28)
RefreshBtn.Position = UDim2.new(0, 215, 0, 42)
RefreshBtn.BackgroundColor3 = Color3.fromRGB(6, 182, 212)
RefreshBtn.Text = "⚡ REFRESH LIST SERVER"
RefreshBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
RefreshBtn.TextSize = 10
RefreshBtn.Font = Enum.Font.GothamBold
RefreshBtn.Parent = MainFrame

local RefreshCorner = Instance.new("UICorner")
RefreshCorner.CornerRadius = UDim.new(0, 6)
RefreshCorner.Parent = RefreshBtn

-- Server List ScrollingFrame
local ServerListFrame = Instance.new("ScrollingFrame")
ServerListFrame.Size = UDim2.new(0, 210, 0, 148)
ServerListFrame.Position = UDim2.new(0, 215, 0, 78)
ServerListFrame.BackgroundTransparency = 1
ServerListFrame.BorderSizePixel = 0
ServerListFrame.ScrollBarThickness = 3
ServerListFrame.CanvasSize = UDim2.new(0, 0, 0, 0)
ServerListFrame.Parent = MainFrame

local UIListLayout = Instance.new("UIListLayout")
UIListLayout.Parent = ServerListFrame
UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
UIListLayout.Padding = UDim.new(0, 5)

-- Watermark
local Watermark = Instance.new("TextLabel")
Watermark.Size = UDim2.new(1, 0, 0, 12)
Watermark.Position = UDim2.new(0, 0, 1, -15)
Watermark.BackgroundTransparency = 1
Watermark.Text = "tt : iD1L"
Watermark.TextColor3 = Color3.fromRGB(148, 163, 184)
Watermark.TextSize = 9
Watermark.Font = Enum.Font.Gotham
Watermark.Parent = MainFrame

---------------------------------------------------------
-- ENGINE-LEVEL PROTECTION & STRICT LOCK
---------------------------------------------------------

local currentCursor = ""

-- LAPIS 5: NUKER ITEM JIKA TERJADI KEBOCORAN LEBIH DARI 20
ServerListFrame.ChildAdded:Connect(function(child)
    if child:IsA("TextButton") then
        local count = 0
        for _, btn in ipairs(ServerListFrame:GetChildren()) do
            if btn:IsA("TextButton") then
                count = count + 1
            end
        end
        if count > 20 then
            child:Destroy() -- PEMUSNAHAN PAKSA
        end
    end
end)

local function setStatus(text, statusType)
    StatusLabel.Text = "Status: " .. text
    if statusType == "loading" then
        StatusLabel.TextColor3 = Color3.fromRGB(250, 204, 21)
    elseif statusType == "ready" then
        StatusLabel.TextColor3 = Color3.fromRGB(74, 222, 128)
    elseif statusType == "error" then
        StatusLabel.TextColor3 = Color3.fromRGB(239, 68, 68)
    end
end

local function fetchServersApi()
    local placeId = game.PlaceId
    local url = 'https://games.roblox.com/v1/games/' .. placeId .. '/servers/Public?sortOrder=Asc&limit=100'
    
    if currentCursor ~= "" then
        url = url .. "&cursor=" .. currentCursor
    end
    
    local success, response = pcall(function()
        return game:HttpGet(url)
    end)
    
    if success then
        local data = HttpService:JSONDecode(response)
        if data then
            currentCursor = data.nextPageCursor or ""
            return data.data or {}
        end
    end
    return {}
end

local function populateServerList()
    -- BERSIHKAN SEMUA UI LAMA
    for _, child in pairs(ServerListFrame:GetChildren()) do
        if child:IsA("TextButton") then
            child:Destroy()
        end
    end

    setStatus("Memuat list...", "loading")

    local maxPlayersFilter = tonumber(MaxPlayerBox.Text) or 100
    local rawServers = fetchServersApi()
    local filteredServers = {}

    for _, s in ipairs(rawServers) do
        if s.playing ~= nil and s.playing <= maxPlayersFilter and s.id ~= game.JobId then
            table.insert(filteredServers, s)
        end
    end

    -- LAPIS 3: ARRAY TRUNCATION (POTONG MEMORI SISA MAX 20)
    local maxLimit = math.min(#filteredServers, 20)
    local lockedServers = {}
    table.move(filteredServers, 1, maxLimit, 1, lockedServers)

    -- LAPIS 4: ITERATIVE BREAK PROTECTION
    local createdCount = 0
    for i, s in ipairs(lockedServers) do
        if createdCount >= 20 then break end
        createdCount = createdCount + 1

        local ItemBtn = Instance.new("TextButton")
        ItemBtn.Name = "ServerBox_" .. tostring(createdCount)
        ItemBtn.Size = UDim2.new(1, -5, 0, 26)
        ItemBtn.BackgroundColor3 = Color3.fromRGB(23, 32, 54)
        ItemBtn.Text = "   👥 " .. tostring(s.playing) .. "/" .. tostring(s.maxPlayers) .. " player"
        ItemBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
        ItemBtn.TextSize = 10
        ItemBtn.Font = Enum.Font.GothamBold
        ItemBtn.TextXAlignment = Enum.TextXAlignment.Left
        ItemBtn.Parent = ServerListFrame

        local ItemCorner = Instance.new("UICorner")
        ItemCorner.CornerRadius = UDim.new(0, 5)
        ItemCorner.Parent = ItemBtn

        ItemBtn.MouseButton1Click:Connect(function()
            setStatus("Teleportasi...", "loading")
            TeleportService:TeleportToPlaceInstance(game.PlaceId, s.id, LocalPlayer)
        end)
    end

    if createdCount == 0 then
        setStatus("Server tidak ditemukan!", "error")
    else
        setStatus("Siap 💡", "ready")
    end

    ServerListFrame.CanvasSize = UDim2.new(0, 0, 0, UIListLayout.AbsoluteContentSize.Y)
end

-- MANAJEMEN COOLDOWN GLOBAL REAL-TIME
local function updateCooldownUI()
    RefreshBtn.BackgroundColor3 = Color3.fromRGB(71, 85, 105)
    
    task.spawn(function()
        while true do
            local remaining = math.ceil(globalEnv.ServerHop_CooldownEnd - os.time())
            
            if remaining <= 0 then
                break
            end
            
            RefreshBtn.Text = "⏳ COOLDOWN (" .. tostring(remaining) .. "s)"
            task.wait(0.2)
        end
        
        RefreshBtn.Text = "⚡ REFRESH LIST SERVER"
        RefreshBtn.BackgroundColor3 = Color3.fromRGB(6, 182, 212)
    end)
end

RefreshBtn.MouseButton1Click:Connect(function()
    local currentTime = os.time()
    
    -- JIKA MASIH DALAM MASA COOLDOWN: METODE DITOLAK TOTAL
    if currentTime < globalEnv.ServerHop_CooldownEnd then
        return
    end

    -- SET COOLDOWN BARU 10 DETIK
    globalEnv.ServerHop_CooldownEnd = currentTime + 10
    populateServerList()
    updateCooldownUI()
end)

local function hopServer()
    setStatus("Mencari Server...", "loading")
    local maxPlayersFilter = tonumber(MaxPlayerBox.Text) or 1
    local servers = fetchServersApi()

    for _, s in ipairs(servers) do
        if s.playing ~= nil and s.playing <= maxPlayersFilter and s.id ~= game.JobId then
            setStatus("Pindah Server...", "loading")
            TeleportService:TeleportToPlaceInstance(game.PlaceId, s.id, LocalPlayer)
            return
        end
    end
    setStatus("Gagal Ditemukan!", "error")
end

local function randomServer()
    setStatus("Mencari Server...", "loading")
    local servers = fetchServersApi()
    local validServers = {}

    for _, s in ipairs(servers) do
        if s.id ~= game.JobId and s.playing < s.maxPlayers then
            table.insert(validServers, s.id)
        end
    end

    if #validServers > 0 then
        local randomId = validServers[math.random(1, #validServers)]
        setStatus("Pindah Random...", "loading")
        TeleportService:TeleportToPlaceInstance(game.PlaceId, randomId, LocalPlayer)
    else
        setStatus("Gagal Ditemukan!", "error")
    end
end

local function rejoinServer()
    setStatus("Rejoin...", "loading")
    TeleportService:TeleportToPlaceInstance(game.PlaceId, game.JobId, LocalPlayer)
end

HopBtn.MouseButton1Click:Connect(hopServer)
RejoinBtn.MouseButton1Click:Connect(rejoinServer)
RandomBtn.MouseButton1Click:Connect(randomServer)

-- LAPIS 2: EXECUTION GATE BLOCK SAAT EXECUTE ULANG
task.spawn(function()
    local currentTime = os.time()
    
    if currentTime < globalEnv.ServerHop_CooldownEnd then
        -- RE-EXECUTE SAAT COOLDOWN: DILARANG MEMUAT SERVER BARU!
        updateCooldownUI()
        setStatus("Cooldown", "error")
    else
        -- EXECUTE NORMAL SAAT WAKTU COOLDOWN HABIS
        globalEnv.ServerHop_CooldownEnd = currentTime + 10
        populateServerList()
        updateCooldownUI()
    end
end)
