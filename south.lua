-- ================ ESP PAGE (with Long-Range TP) ================
local espY = 5
local nittyEspBtn = createButton(pages[2], "NITTY ESP", espY, Color3.fromRGB(40, 40, 55), "👁️")
espY = espY + 50
local refreshBtn = createButton(pages[2], "REFRESH NITTIES", espY, Color3.fromRGB(40, 40, 55), "🔄")
espY = espY + 50
local tpNearestBtn = createButton(pages[2], "📍 TP TO NEAREST NITTY", espY, Color3.fromRGB(0, 100, 200), "📍")
espY = espY + 50

-- NEW: Long-range teleport button
local tpAnyBtn = createButton(pages[2], "🌍 TP TO ANY NITTY (FAR AWAY)", espY, Color3.fromRGB(150, 0, 150), "🚀")
espY = espY + 50

local espRange = createButton(pages[2], "📏 ESP RANGE: 100", espY, Color3.fromRGB(40, 40, 55), "📏")
espY = espY + 50

-- Nitty list display
local nittyListFrame = Instance.new("ScrollingFrame")
nittyListFrame.Size = UDim2.new(0.9, 0, 0, 120)
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
                smoothTeleportToNitty(nitty)
            end)
        end
    end
end

-- Smooth teleport function (bypasses anti-cheat)
local function smoothTeleportToNitty(nitty)
    local char = player.Character
    if not char or not char:FindFirstChild("HumanoidRootPart") or not nitty:FindFirstChild("HumanoidRootPart") then
        statusText.Text = "❌ CAN'T TP"
        return
    end
    
    local targetPos = nitty.HumanoidRootPart.Position + Vector3.new(0, 3, 0)
    local myPos = char.HumanoidRootPart.Position
    local distance = (targetPos - myPos).Magnitude
    local humanoid = char:FindFirstChild("Humanoid")
    
    statusText.Text = "🚀 TP TO " .. nitty.Name .. " (" .. math.floor(distance) .. " studs)"
    
    -- Anti-TP bypass: smooth movement
    local originalSpeed = humanoid.WalkSpeed
    humanoid.WalkSpeed = 100 -- Super fast but not instant
    
    -- If very far, do it in chunks
    if distance > 500 then
        local chunks = math.ceil(distance / 100)
        for i = 1, chunks do
            if not char or not char:FindFirstChild("HumanoidRootPart") then break end
            local progress = i / chunks
            local currentPos = myPos:Lerp(targetPos, progress)
            char.HumanoidRootPart.CFrame = CFrame.new(currentPos)
            wait(0.1)
        end
    else
        -- Smooth movement
        local direction = (targetPos - myPos).Unit
        local steps = math.ceil(distance / 10)
        for i = 1, steps do
            if not char or not char:FindFirstChild("HumanoidRootPart") then break end
            local progress = i / steps
            local currentPos = myPos:Lerp(targetPos, progress)
            char.HumanoidRootPart.CFrame = CFrame.new(currentPos)
            wait(0.05)
        end
    end
    
    -- Final position
    char.HumanoidRootPart.CFrame = CFrame.new(targetPos)
    humanoid.WalkSpeed = originalSpeed
    statusText.Text = "📍 ARRIVED AT " .. nitty.Name
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

-- TP to nearest
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
        smoothTeleportToNitty(nearest)
    end
end)

-- TP to ANY nitty (opens list)
tpAnyBtn.MouseButton1Click:Connect(function()
    updateNittyList()
    statusText.Text = "🌍 CLICK A NITTY FROM THE LIST"
end)
