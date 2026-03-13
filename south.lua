-- FastWare - Premium Edition (with Universal Anti-TP Bypass)
local player = game.Players.LocalPlayer
local workspace = game:GetService("Workspace")
local userInputService = game:GetService("UserInputService")
local players = game:GetService("Players")
local runService = game:GetService("RunService")
local replicatedStorage = game:GetService("ReplicatedStorage")
local coreGui = game:GetService("CoreGui")
local starterGui = game:GetService("StarterGui")
local tweenService = game:GetService("TweenService")
local virtualInput = game:GetService("VirtualInputManager")

-- Main GUI
local gui = Instance.new("ScreenGui")
gui.Name = "FastWare"
gui.Parent = player:WaitForChild("PlayerGui")
gui.ResetOnSpawn = false
gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
gui.DisplayOrder = 999

-- Main container
local main = Instance.new("Frame")
main.Size = UDim2.new(0, 420, 0, 650)
main.Position = UDim2.new(0, 20, 0, 20)
main.BackgroundColor3 = Color3.fromRGB(8, 8, 12)
main.BorderSizePixel = 0
main.Parent = gui
main.Active = true
main.Draggable = true

-- Shadow effect
local shadow = Instance.new("ImageLabel")
shadow.Size = UDim2.new(1, 30, 1, 30)
shadow.Position = UDim2.new(0, -15, 0, -15)
shadow.BackgroundTransparency = 1
shadow.Image = "rbxasset://textures/ui/GuiImagePlaceholder.png"
shadow.ImageColor3 = Color3.fromRGB(0, 0, 0)
shadow.ImageTransparency = 0.7
shadow.ScaleType = Enum.ScaleType.Slice
shadow.SliceCenter = Rect.new(10, 10, 10, 10)
shadow.Parent = main
shadow.ZIndex = -1

-- Main corner
local mainCorner = Instance.new("UICorner")
mainCorner.CornerRadius = UDim.new(0, 16)
mainCorner.Parent = main

-- Gradient overlay
local gradient = Instance.new("UIGradient")
gradient.Color = ColorSequence.new({
    ColorSequenceKeypoint.new(0, Color3.fromRGB(20, 20, 30)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(5, 5, 10))
})
gradient.Rotation = 90
gradient.Parent = main

-- Accent glow
local glow = Instance.new("Frame")
glow.Size = UDim2.new(1, -40, 0, 3)
glow.Position = UDim2.new(0, 20, 0, 0)
glow.BackgroundColor3 = Color3.fromRGB(0, 200, 255)
glow.BorderSizePixel = 0
glow.Parent = main

local glowCorner = Instance.new("UICorner")
glowCorner.CornerRadius = UDim.new(0, 2)
glowCorner.Parent = glow

-- Header
local header = Instance.new("Frame")
header.Size = UDim2.new(1, 0, 0, 70)
header.BackgroundTransparency = 1
header.Parent = main

local logo = Instance.new("TextLabel")
logo.Size = UDim2.new(0, 50, 0, 50)
logo.Position = UDim2.new(0, 15, 0, 10)
logo.Text = "⚡"
logo.TextColor3 = Color3.fromRGB(0, 200, 255)
logo.BackgroundTransparency = 1
logo.Font = Enum.Font.GothamBold
logo.TextSize = 40
logo.Parent = header

local title = Instance.new("TextLabel")
title.Size = UDim2.new(0, 200, 0, 30)
title.Position = UDim2.new(0, 70, 0, 15)
title.Text = "FASTWARE"
title.TextColor3 = Color3.fromRGB(255, 255, 255)
title.BackgroundTransparency = 1
title.Font = Enum.Font.GothamBold
title.TextSize = 28
title.TextXAlignment = Enum.TextXAlignment.Left
title.Parent = header

local version = Instance.new("TextLabel")
version.Size = UDim2.new(0, 200, 0, 18)
version.Position = UDim2.new(0, 70, 0, 42)
version.Text = "PREMIUM EDITION v7"
version.TextColor3 = Color3.fromRGB(150, 150, 180)
version.BackgroundTransparency = 1
version.Font = Enum.Font.Gotham
version.TextSize = 12
version.TextXAlignment = Enum.TextXAlignment.Left
version.Parent = header

-- Status dot
local statusDot = Instance.new("Frame")
statusDot.Size = UDim2.new(0, 10, 0, 10)
statusDot.Position = UDim2.new(1, -25, 0, 30)
statusDot.BackgroundColor3 = Color3.fromRGB(0, 255, 0)
statusDot.BorderSizePixel = 0
statusDot.Parent = header

local dotCorner = Instance.new("UICorner")
dotCorner.CornerRadius = UDim.new(1, 0)
dotCorner.Parent = statusDot

-- Tab bar
local tabBar = Instance.new("Frame")
tabBar.Size = UDim2.new(1, -30, 0, 50)
tabBar.Position = UDim2.new(0, 15, 0, 70)
tabBar.BackgroundColor3 = Color3.fromRGB(15, 15, 20)
tabBar.BackgroundTransparency = 0.3
tabBar.BorderSizePixel = 0
tabBar.Parent = main

local tabCorner = Instance.new("UICorner")
tabCorner.CornerRadius = UDim.new(0, 12)
tabCorner.Parent = tabBar

local tabIndicator = Instance.new("Frame")
tabIndicator.Size = UDim2.new(0.166, -3, 0, 3)
tabIndicator.Position = UDim2.new(0, 2, 1, -5)
tabIndicator.BackgroundColor3 = Color3.fromRGB(0, 200, 255)
tabIndicator.BorderSizePixel = 0
tabIndicator.Parent = tabBar

local indicatorCorner = Instance.new("UICorner")
indicatorCorner.CornerRadius = UDim.new(0, 2)
indicatorCorner.Parent = tabIndicator

-- Tab buttons
local tabs = {}
local tabNames = {"COMBAT", "ESP", "MONEY", "FARM", "DUPE", "PRIVACY"}
local tabIcons = {"⚔️", "👁️", "💰", "🌾", "📦", "🔒"}

for i = 1, 6 do
    local tab = Instance.new("TextButton")
    tab.Size = UDim2.new(0.166, -3, 1, -10)
    tab.Position = UDim2.new((i-1) * 0.166, (i-1) * 3, 0, 5)
    tab.Text = tabIcons[i] .. "  " .. tabNames[i]
    tab.BackgroundTransparency = 1
    tab.TextColor3 = i == 1 and Color3.fromRGB(0, 200, 255) or Color3.fromRGB(150, 150, 150)
    tab.Font = Enum.Font.GothamBold
    tab.TextSize = 11
    tab.Parent = tabBar
    tabs[i] = tab
end

-- Content container
local content = Instance.new("Frame")
content.Size = UDim2.new(1, -30, 1, -170)
content.Position = UDim2.new(0, 15, 0, 130)
content.BackgroundTransparency = 1
content.Parent = main

-- Pages
local pages = {}
for i = 1, 6 do
    local page = Instance.new("ScrollingFrame")
    page.Size = UDim2.new(1, 0, 1, 0)
    page.BackgroundTransparency = 1
    page.BorderSizePixel = 0
    page.ScrollBarThickness = 4
    page.ScrollBarImageColor3 = Color3.fromRGB(0, 200, 255)
    page.CanvasSize = UDim2.new(0, 0, 0, 0)
    page.AutomaticCanvasSize = Enum.AutomaticSize.Y
    page.Visible = i == 1
    page.Parent = content
    pages[i] = page
end

-- Tab switching
for i, tab in ipairs(tabs) do
    tab.MouseButton1Click:Connect(function()
        tabIndicator:TweenPosition(
            UDim2.new((i-1) * 0.166, (i-1) * 3, 1, -5),
            "Out",
            "Quad",
            0.2,
            true
        )
        
        for j, t in ipairs(tabs) do
            t.TextColor3 = j == i and Color3.fromRGB(0, 200, 255) or Color3.fromRGB(150, 150, 150)
        end
        
        for j, page in ipairs(pages) do
            page.Visible = (j == i)
        end
    end)
end

-- Button creator
local function createButton(parent, text, yPos, color, icon, width)
    width = width or 1
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(width, -10, 0, 45)
    btn.Position = UDim2.new((1-width)/2, 5, 0, yPos)
    btn.BackgroundColor3 = color or Color3.fromRGB(25, 25, 35)
    btn.Text = (icon or "•") .. "  " .. text
    btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    btn.Font = Enum.Font.GothamBold
    btn.TextSize = 14
    btn.Parent = parent
    
    local btnCorner = Instance.new("UICorner")
    btnCorner.CornerRadius = UDim.new(0, 10)
    btnCorner.Parent = btn
    
    -- Hover effect
    btn.MouseEnter:Connect(function()
        tweenService:Create(btn, TweenInfo.new(0.2), {BackgroundColor3 = color and color:Lerp(Color3.fromRGB(255,255,255), 0.2) or Color3.fromRGB(35, 35, 45)}):Play()
    end)
    btn.MouseLeave:Connect(function()
        tweenService:Create(btn, TweenInfo.new(0.2), {BackgroundColor3 = color or Color3.fromRGB(25, 25, 35)}):Play()
    end)
    
    return btn
end

-- Status bar
local statusBar = Instance.new("Frame")
statusBar.Size = UDim2.new(1, -30, 0, 40)
statusBar.Position = UDim2.new(0, 15, 1, -50)
statusBar.BackgroundColor3 = Color3.fromRGB(15, 15, 20)
statusBar.BackgroundTransparency = 0.2
statusBar.BorderSizePixel = 0
statusBar.Parent = main

local statusCorner = Instance.new("UICorner")
statusCorner.CornerRadius = UDim.new(0, 10)
statusCorner.Parent = statusBar

local statusText = Instance.new("TextLabel")
statusText.Size = UDim2.new(1, -20, 1, 0)
statusText.Position = UDim2.new(0, 10, 0, 0)
statusText.Text = "⚡ SYSTEM READY"
statusText.TextColor3 = Color3.fromRGB(0, 255, 100)
statusText.BackgroundTransparency = 1
statusText.Font = Enum.Font.GothamBold
statusText.TextSize = 13
statusText.TextXAlignment = Enum.TextXAlignment.Left
statusText.Parent = statusBar

-- ================ COMBAT PAGE ================
local combatY = 5
local ammoBtn = createButton(pages[1], "INFINITE AMMO", combatY, Color3.fromRGB(40, 40, 55), "🔫")
combatY = combatY + 50
local speedBtn = createButton(pages[1], "SPEED BOOST", combatY, Color3.fromRGB(40, 40, 55), "⚡")

-- Combat state
local ammoActive = false
local speedActive = false

-- Infinite ammo
ammoBtn.MouseButton1Click:Connect(function()
    ammoActive = not ammoActive
    if ammoActive then
        ammoBtn.BackgroundColor3 = Color3.fromRGB(0, 150, 0)
        ammoBtn.Text = "🔫  INFINITE AMMO [ON]"
        statusText.Text = "🔫 INFINITE AMMO ACTIVE"
        
        spawn(function()
            while ammoActive do
                local char = player.Character
                if char then
                    for _, tool in pairs(char:GetChildren()) do
                        if tool:IsA("Tool") then
                            local ammo = tool:FindFirstChild("Ammo") or tool:FindFirstChild("CurrentAmmo") or tool:FindFirstChild("AmmoCount")
                            if ammo then
                                ammo.Value = 9999
                            end
                        end
                    end
                end
                wait(0.2)
            end
        end)
    else
        ammoBtn.BackgroundColor3 = Color3.fromRGB(40, 40, 55)
        ammoBtn.Text = "🔫  INFINITE AMMO [OFF]"
        statusText.Text = "🔫 AMMO OFF"
    end
end)

-- Speed boost
speedBtn.MouseButton1Click:Connect(function()
    speedActive = not speedActive
    local char = player.Character
    if char and char:FindFirstChild("Humanoid") then
        if speedActive then
            speedBtn.BackgroundColor3 = Color3.fromRGB(0, 150, 0)
            speedBtn.Text = "⚡  SPEED BOOST [ON]"
            char.Humanoid.WalkSpeed = 50
            statusText.Text = "⚡ SPEED BOOSTED"
        else
            speedBtn.BackgroundColor3 = Color3.fromRGB(40, 40, 55)
            speedBtn.Text = "⚡  SPEED BOOST [OFF]"
            char.Humanoid.WalkSpeed = 16
            statusText.Text = "⚡ SPEED NORMAL"
        end
    end
end)

-- ================ ESP PAGE with UNIVERSAL ANTI-TP BYPASS ================
local espY = 5
local nittyEspBtn = createButton(pages[2], "NITTY ESP", espY, Color3.fromRGB(40, 40, 55), "👁️")
espY = espY + 50
local refreshBtn = createButton(pages[2], "REFRESH NITTIES", espY, Color3.fromRGB(40, 40, 55), "🔄")
espY = espY + 50
local tpNearestBtn = createButton(pages[2], "📍 TP TO NEAREST NITTY", espY, Color3.fromRGB(0, 100, 200), "📍")
espY = espY + 50
local tpAnyBtn = createButton(pages[2], "🌍 TP TO ANY NITTY", espY, Color3.fromRGB(150, 0, 150), "🚀")
espY = espY + 50
local espRange = createButton(pages[2], "📏 ESP RANGE: 100", espY, Color3.fromRGB(40, 40, 55), "📏")
espY = espY + 50

-- Nitty list display
local nittyListFrame = Instance.new("ScrollingFrame")
nittyListFrame.Size = UDim2.new(0.9, 0, 0, 150)
nittyListFrame.Position = UDim2.new(0.05, 0, 0, espY)
nittyListFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 25)
nittyListFrame.Parent = pages[2]

local nittyListLayout = Instance.new("UIListLayout")
nittyListLayout.Parent = nittyListFrame

-- ESP state
local espActive = false
local espHighlights = {}
local currentRange = 100
local allNitties = {}

-- ================ UNIVERSAL ANTI-TP BYPASS TELEPORT ================
local function teleportToNitty(nitty)
    local char = player.Character
    if not char or not char:FindFirstChild("HumanoidRootPart") or not nitty:FindFirstChild("HumanoidRootPart") then
        statusText.Text = "❌ CAN'T TP"
        return false
    end
    
    local root = char.HumanoidRootPart
    local humanoid = char.Humanoid
    local startPos = root.Position
    local targetPos = nitty.HumanoidRootPart.Position + Vector3.new(0, 2, 0) -- Stand on them
    local distance = (targetPos - startPos).Magnitude
    
    statusText.Text = "🎯 TP TO " .. nitty.Name .. " (" .. math.floor(distance) .. " studs)"
    
    -- Store original values
    local originalSpeed = humanoid.WalkSpeed
    local originalJump = humanoid.JumpPower
    
    -- ANTI-TP BYPASS: Multi-stage approach based on distance
    
    -- STAGE 1: Extremely far (5000+ studs) - "Server hop" style
    if distance > 5000 then
        humanoid.WalkSpeed = 500
        root.Velocity = (targetPos - startPos).Unit * 500
        
        local chunks = math.ceil(distance / 500)
        for i = 1, chunks do
            if not char or not char:FindFirstChild("HumanoidRootPart") then break end
            
            local progress = i / chunks
            local currentPos = startPos:Lerp(targetPos, progress)
            
            -- Random offset to look natural
            local offset = Vector3.new(
                math.random(-5, 5),
                math.random(-2, 2),
                math.random(-5, 5)
            )
            
            root.CFrame = CFrame.new(currentPos + offset)
            wait(0.05 + math.random() * 0.1)
        end
    end
    
    -- STAGE 2: Very far (1000-5000 studs)
    elseif distance > 1000 then
        humanoid.WalkSpeed = 300
        local chunks = math.ceil(distance / 300)
        
        for i = 1, chunks do
            if not char or not char:FindFirstChild("HumanoidRootPart") then break end
            
            local progress = i / chunks
            local currentPos = startPos:Lerp(targetPos, progress)
            root.CFrame = CFrame.new(currentPos)
            
            wait(0.05 + math.random() * 0.15)
        end
    end
    
    -- STAGE 3: Far (500-1000 studs)
    elseif distance > 500 then
        humanoid.WalkSpeed = 200
        root.Velocity = (targetPos - startPos).Unit * 200
        
        local steps = math.ceil(distance / 100)
        for i = 1, steps do
            if not char or not char:FindFirstChild("HumanoidRootPart") then break end
            
            local progress = i / steps
            local currentPos = startPos:Lerp(targetPos, progress)
            root.CFrame = CFrame.new(currentPos)
            
            wait(0.03 + math.random() * 0.1)
        end
    end
    
    -- STAGE 4: Medium (100-500 studs)
    elseif distance > 100 then
        humanoid.WalkSpeed = 150
        humanoid.JumpPower = 100
        
        local arcHeight = 15
        local steps = math.ceil(distance / 50)
        
        for i = 1, steps do
            if not char or not char:FindFirstChild("HumanoidRootPart") then break end
            
            local progress = i / steps
            local basePos = startPos:Lerp(targetPos, progress)
            
            -- Add arc effect
            local heightOffset = math.sin(progress * math.pi) * arcHeight
            local currentPos = basePos + Vector3.new(0, heightOffset, 0)
            
            root.CFrame = CFrame.new(currentPos)
            wait(0.02 + math.random() * 0.08)
        end
    end
    
    -- STAGE 5: Short (<100 studs)
    else
        humanoid.Jump = true
        wait(0.1)
        root.CFrame = CFrame.new(targetPos)
        wait(0.1)
    end
    
    -- Final position - RIGHT on the Nitty
    root.CFrame = CFrame.new(targetPos)
    root.Velocity = Vector3.new(0, 0, 0)
    
    -- Restore original values
    humanoid.WalkSpeed = originalSpeed
    humanoid.JumpPower = originalJump
    
    statusText.Text = "📍 STANDING ON " .. nitty.Name
    return true
end

-- Find ALL Nitties (no range limit)
local function findAllNitties()
    local nitties = {}
    for _, obj in pairs(workspace:GetDescendants()) do
        if obj:IsA("Model") and obj:FindFirstChild("Humanoid") then
            local name = obj.Name:lower()
            if name:find("nitty") then
                local isPlayer = false
                for _, plr in pairs(players:GetPlayers()) do
                    if plr.Character == obj then
                        isPlayer = true
                        break
                    end
                end
                if not isPlayer and obj:FindFirstChild("HumanoidRootPart") then
                    table.insert(nitties, obj)
                end
            end
        end
    end
    return nitties
end

-- Find Nitties within range
local function findNittiesInRange(range)
    range = range or currentRange
    local nitties = {}
    local char = player.Character
    if not char or not char:FindFirstChild("HumanoidRootPart") then return nitties end
    
    local myPos = char.HumanoidRootPart.Position
    local all = findAllNitties()
    
    for _, nitty in ipairs(all) do
        if nitty:FindFirstChild("HumanoidRootPart") then
            local dist = (nitty.HumanoidRootPart.Position - myPos).Magnitude
            if dist <= range then
                table.insert(nitties, nitty)
            end
        end
    end
    return nitties
end

-- Update ESP
local function updateNittyESP()
    for _, highlight in pairs(espHighlights) do
        pcall(function() highlight:Destroy() end)
    end
    espHighlights = {}
    
    if not espActive then return end
    
    local nitties = findNittiesInRange()
    for _, nitty in pairs(nitties) do
        if nitty:FindFirstChild("HumanoidRootPart") then
            local highlight = Instance.new("Highlight")
            highlight.FillColor = Color3.fromRGB(255, 0, 0)
            highlight.OutlineColor = Color3.fromRGB(255, 255, 255)
            highlight.FillTransparency = 0.3
            highlight.Adornee = nitty
            highlight.Parent = gui
            table.insert(espHighlights, highlight)
        end
    end
    
    statusText.Text = "👁️ FOUND " .. #nitties .. " NITTIES WITHIN " .. currentRange .. " studs"
end

-- Update nitty list
local function updateNittyList()
    for _, child in pairs(nittyListFrame:GetChildren()) do
        if child:IsA("TextButton") then
            child:Destroy()
        end
    end
    
    allNitties = findAllNitties()
    local char = player.Character
    if not char or not char:FindFirstChild("HumanoidRootPart") then return end
    
    local myPos = char.HumanoidRootPart.Position
    
    -- Sort by distance
    table.sort(allNitties, function(a, b)
        local distA = (a.HumanoidRootPart.Position - myPos).Magnitude
        local distB = (b.HumanoidRootPart.Position - myPos).Magnitude
        return distA < distB
    end)
    
    -- Create buttons for each nitty
    for i, nitty in ipairs(allNitties) do
        if i <= 10 then -- Show top 10 closest
            local dist = (nitty.HumanoidRootPart.Position - myPos).Magnitude
            local btn = Instance.new("TextButton")
            btn.Size = UDim2.new(1, -5, 0, 25)
            btn.Text = "📍 " .. nitty.Name .. " (" .. math.floor(dist) .. " studs)"
            btn.BackgroundColor3 = Color3.fromRGB(40, 40, 50)
            btn.TextColor3 = Color3.fromRGB(255, 255, 255)
            btn.Font = Enum.Font.Gotham
            btn.TextSize = 12
            btn.Parent = nittyListFrame
            
            btn.MouseButton1Click:Connect(function()
                teleportToNitty(nitty)
            end)
        end
    end
end

-- Range toggle
espRange.MouseButton1Click:Connect(function()
    if currentRange == 100 then
        currentRange = 200
    elseif currentRange == 200 then
        currentRange = 500
    else
        currentRange = 100
    end
    espRange.Text = "📏 ESP RANGE: " .. currentRange
    if espActive then
        updateNittyESP()
    end
    updateNittyList()
end)

nittyEspBtn.MouseButton1Click:Connect(function()
    espActive = not espActive
    if espActive then
        nittyEspBtn.BackgroundColor3 = Color3.fromRGB(0, 150, 0)
        nittyEspBtn.Text = "👁️  NITTY ESP [ON]"
        updateNittyESP()
    else
        nittyEspBtn.BackgroundColor3 = Color3.fromRGB(40, 40, 55)
        nittyEspBtn.Text = "👁️  NITTY ESP [OFF]"
        for _, highlight in pairs(espHighlights) do
            pcall(function() highlight:Destroy() end)
        end
        espHighlights = {}
        statusText.Text = "👁️ ESP OFF"
    end
end)

refreshBtn.MouseButton1Click:Connect(function()
    if espActive then
        updateNittyESP()
    end
    updateNittyList()
    local count = #findAllNitties()
    statusText.Text = "👁️ " .. count .. " TOTAL NITTIES IN GAME"
end)

-- TP to nearest nitty (uses universal bypass)
tpNearestBtn.MouseButton1Click:Connect(function()
    local nitties = findAllNitties()
    if #nitties == 0 then
        statusText.Text = "❌ NO NITTIES FOUND"
        return
    end
    
    local nearest = nil
    local nearestDist = math.huge
    local char = player.Character
    if not char or not char:FindFirstChild("HumanoidRootPart") then return end
    
    local myPos = char.HumanoidRootPart.Position
    
    for _, nitty in pairs(nitties) do
        if nitty:FindFirstChild("HumanoidRootPart") then
            local dist = (nitty.HumanoidRootPart.Position - myPos).Magnitude
            if dist < nearestDist then
                nearestDist = dist
                nearest = nitty
            end
        end
    end
    
    if nearest then
        teleportToNitty(nearest)
    end
end)

-- TP to ANY nitty
tpAnyBtn.MouseButton1Click:Connect(function()
    updateNittyList()
    statusText.Text = "🌍 CLICK A NITTY FROM THE LIST"
end)

-- ================ MONEY PAGE ================
local moneyY = 5

-- Money display
local wallet = player:FindFirstChild("Stats") and player.Stats:FindFirstChild("Wallet")
if wallet then
    local moneyDisplay = Instance.new("TextLabel")
    moneyDisplay.Size = UDim2.new(0.9, 0, 0, 40)
    moneyDisplay.Position = UDim2.new(0.05, 0, 0, moneyY)
    moneyDisplay.Text = "💰 CURRENT: $" .. wallet.Value
    moneyDisplay.TextColor3 = Color3.fromRGB(255, 200, 0)
    moneyDisplay.BackgroundColor3 = Color3.fromRGB(20, 20, 30)
    moneyDisplay.Font = Enum.Font.GothamBold
    moneyDisplay.TextSize = 16
    moneyDisplay.Parent = pages[3]
    
    local displayCorner = Instance.new("UICorner")
    displayCorner.CornerRadius = UDim.new(0, 10)
    displayCorner.Parent = moneyDisplay
    
    moneyY = moneyY + 50
end

-- Method 1: Direct wallet
local directBtn = createButton(pages[3], "DIRECT WALLET (VISUAL)", moneyY, Color3.fromRGB(60, 60, 80), "💰")
moneyY = moneyY + 50

-- Method 2: Remote scan
local scanBtn = createButton(pages[3], "SCAN FOR MONEY REMOTES", moneyY, Color3.fromRGB(60, 60, 80), "🔍")
moneyY = moneyY + 50

-- Method 3: Auto loop
local autoBtn = createButton(pages[3], "AUTO MONEY LOOP", moneyY, Color3.fromRGB(60, 60, 80), "🔄")
moneyY = moneyY + 50

-- Method 4: Duo attack
local duoBtn = createButton(pages[3], "DUO ATTACK (WALLET+PURCHASED)", moneyY, Color3.fromRGB(60, 60, 80), "⚔️")
moneyY = moneyY + 50

-- Money state
local autoMoneyActive = false
local moneyLoop = nil

directBtn.MouseButton1Click:Connect(function()
    if wallet then
        wallet.Value = 999999999
        statusText.Text = "💰 VISUAL CHANGE - SERVER WILL REVERT"
        if moneyDisplay then
            moneyDisplay.Text = "💰 CURRENT: $" .. wallet.Value
        end
    end
end)

scanBtn.MouseButton1Click:Connect(function()
    statusText.Text = "🔍 SCANNING FOR MONEY REMOTES..."
    local found = 0
    for _, obj in pairs(replicatedStorage:GetDescendants()) do
        if obj:IsA("RemoteEvent") then
            local name = obj.Name:lower()
            if name:find("money") or name:find("cash") or name:find("wallet") or 
               name:find("purchase") or name:find("buy") or name:find("earn") then
                found = found + 1
                pcall(function()
                    obj:FireServer(1000000)
                    obj:FireServer("add", 1000000)
                    obj:FireServer(player, 1000000)
                end)
            end
        end
    end
    statusText.Text = "✅ FIRED " .. found .. " MONEY REMOTES"
end)

autoBtn.MouseButton1Click:Connect(function()
    autoMoneyActive = not autoMoneyActive
    if autoMoneyActive then
        autoBtn.BackgroundColor3 = Color3.fromRGB(0, 150, 0)
        autoBtn.Text = "🔄  AUTO MONEY LOOP [ON]"
        statusText.Text = "🔄 AUTO MONEY ACTIVE"
        
        if moneyLoop then moneyLoop:Disconnect() end
        moneyLoop = runService.Heartbeat:Connect(function()
            if wallet then
                wallet.Value = wallet.Value + 100000
                if moneyDisplay then
                    moneyDisplay.Text = "💰 CURRENT: $" .. wallet.Value
                end
            end
        end)
    else
        autoBtn.BackgroundColor3 = Color3.fromRGB(60, 60, 80)
        autoBtn.Text = "🔄  AUTO MONEY LOOP [OFF]"
        statusText.Text = "🔄 AUTO MONEY STOPPED"
        if moneyLoop then
            moneyLoop:Disconnect()
            moneyLoop = nil
        end
    end
end)

duoBtn.MouseButton1Click:Connect(function()
    local purchased = player:FindFirstChild("Stats") and player.Stats:FindFirstChild("PurchasedMoney")
    if wallet and purchased then
        wallet.Value = 999999999
        purchased.Value = 999999999
        statusText.Text = "⚔️ DUO ATTACK COMPLETE"
        if moneyDisplay then
            moneyDisplay.Text = "💰 CURRENT: $" .. wallet.Value
        end
    end
end)

-- ================ FARM PAGE ================
local farmY = 5

-- Farm positions
local farmSpots = {
    {name = "CARCASS", pos = Vector3.new(-371, 5, -487)},
    {name = "CHOP MEAT", pos = Vector3.new(-356.14, 4.2, -497.93)},
    {name = "SELL MEAT", pos = Vector3.new(-342.1, 4.5, -509.72)}
}

-- Manual teleport buttons
local farmBtns = {}
for i, spot in ipairs(farmSpots) do
    local btn = createButton(pages[4], "TP TO " .. spot.name, farmY, Color3.fromRGB(40, 40, 55), "📍")
    farmY = farmY + 50
    table.insert(farmBtns, {btn = btn, pos = spot.pos, name = spot.name})
end

for _, data in ipairs(farmBtns) do
    data.btn.MouseButton1Click:Connect(function()
        local char = player.Character
        if char and char:FindFirstChild("HumanoidRootPart") then
            char.HumanoidRootPart.CFrame = CFrame.new(data.pos)
            statusText.Text = "📍 TP TO " .. data.name
        end
    end)
end

-- Auto farm
local autoFarmActive = false
local autoFarmLoop = nil

local autoFarmBtn = createButton(pages[4], "▶️ AUTO FARM (AFK)", farmY, Color3.fromRGB(0, 100, 200), "⚡")
farmY = farmY + 50

local function holdE()
    local held = false
    for _, obj in pairs(workspace:GetDescendants()) do
        if obj:IsA("ProximityPrompt") then
            local part = obj.Parent
            if part and part:IsA("BasePart") then
                local dist = (part.Position - player.Character.HumanoidRootPart.Position).Magnitude
                if dist < 25 then
                    fireproximityprompt(obj, 0)
                    held = true
                end
            end
        end
    end
    if not held then
        pcall(function()
            virtualInput:SendKeyEvent(true, Enum.KeyCode.E, false, game)
            wait(0.1)
            virtualInput:SendKeyEvent(false, Enum.KeyCode.E, false, game)
        end)
    end
    return held
end

autoFarmBtn.MouseButton1Click:Connect(function()
    autoFarmActive = not autoFarmActive
    if autoFarmActive then
        autoFarmBtn
