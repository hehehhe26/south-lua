-- ================ UNIVERSAL ANTI-TP BYPASS (ANY DISTANCE) ================
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
        -- Method: Rapid chunk teleport with variable speeds
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
        -- Method: Smooth chunk movement with variable speed
        humanoid.WalkSpeed = 300
        local chunks = math.ceil(distance / 300)
        
        for i = 1, chunks do
            if not char or not char:FindFirstChild("HumanoidRootPart") then break end
            
            local progress = i / chunks
            local currentPos = startPos:Lerp(targetPos, progress)
            root.CFrame = CFrame.new(currentPos)
            
            -- Random delay between 0.05 and 0.2
            wait(0.05 + math.random() * 0.15)
        end
    end
    
    -- STAGE 3: Far (500-1000 studs)
    elseif distance > 500 then
        -- Method: Fast movement with occasional pauses
        humanoid.WalkSpeed = 200
        root.Velocity = (targetPos - startPos).Unit * 200
        
        local steps = math.ceil(distance / 100)
        for i = 1, steps do
            if not char or not char:FindFirstChild("HumanoidRootPart") then break end
            
            local progress = i / steps
            local currentPos = startPos:Lerp(targetPos, progress)
            root.CFrame = CFrame.new(currentPos)
            
            -- Variable delay
            wait(0.03 + math.random() * 0.1)
        end
    end
    
    -- STAGE 4: Medium (100-500 studs)
    elseif distance > 100 then
        -- Method: Super speed with jump arcs
        humanoid.WalkSpeed = 150
        humanoid.JumpPower = 100
        
        -- Jump in arcs to look natural
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
        -- Method: Instant with disguise
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

-- ================ UPDATED TP BUTTONS ================

-- TP to nearest nitty (any distance)
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
        teleportToNitty(nearest) -- Universal teleport for ANY distance
    end
end)

-- TP to ANY nitty from list
tpAnyBtn.MouseButton1Click:Connect(function()
    updateNittyList()
    statusText.Text = "🌍 CLICK A NITTY FROM THE LIST"
end)

-- Update the list buttons
-- In updateNittyList, replace the button click with:
btn.MouseButton1Click:Connect(function()
    teleportToNitty(nitty) -- Universal teleport for ANY distance
end)
