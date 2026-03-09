local char = string.char
local byte = string.byte
local sub = string.sub
local bit = bit32 or bit
local bxor = bit.bxor
local concat = table.concat
local insert = table.insert

-- Game services
local player = game.Players.LocalPlayer
local tweenService = game:GetService("TweenService")
local players = game:GetService("Players")
local userInputService = game:GetService("UserInputService")

-- ERROR CATCHING
print("🔍 Script started - checking for errors...")

local success, err = pcall(function()
    -- E Key Fix
    local guiService = game:GetService("GuiService")
    local contextActionService = game:GetService("ContextActionService")
    
    print("✅ Services loaded")
    
    userInputService.InputBegan:Connect(function(input, gameProcessed)
        if gameProcessed then return end
        if input.UserInputType == Enum.UserInputType.Keyboard then
            pcall(function() guiService.SelectedCore = nil end)
        end
    end)
    
    print("✅ E key fix applied")
    
    -- Auto-prompt for proximity prompts
    for _, descendant in next, workspace:GetDescendants() do
        if descendant:IsA("ProximityPrompt") then
            descendant.PromptButtonHoldBegan:Connect(function()
                if (descendant.HoldDuration <= 0) then return end
                fireproximityprompt(descendant, 0)
            end)
        end
    end
    print("✅ Proximity prompts connected")
    
    -- Character references
    local character = player.Character or player.CharacterAdded:Wait()
    local humanoid = character:WaitForChild("Humanoid")
    print("✅ Character found: " .. character.Name)
    
    -- Main GUI
    local mainGui = Instance.new("ScreenGui")
    mainGui.Name = "ProfessionalDashboard"
    mainGui.ResetOnSpawn = false
    mainGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    mainGui.Parent = player:WaitForChild("PlayerGui")
    print("✅ GUI created")
    
    -- Test frame
    local testFrame = Instance.new("Frame")
    testFrame.Size = UDim2.new(0, 100, 0, 100)
    testFrame.Position = UDim2.new(0, 0, 0, 0)
    testFrame.BackgroundColor3 = Color3.fromRGB(0, 255, 0)
    testFrame.Parent = mainGui
    print("✅ Test frame added")
    
    -- Billboard Holder
    local billboardHolder = Instance.new("Folder")
    billboardHolder.Name = "BillboardHolder"
    billboardHolder.Parent = mainGui
    
    local gothamFont = Enum.Font.Gotham
    local gothamBoldFont = Enum.Font.GothamBold
    
    -- Draggable function
    local function makeDraggable(frame)
        local dragging = false
        local dragInput, dragStart, startPos
        
        frame.InputBegan:Connect(function(input)
            if (input.UserInputType == Enum.UserInputType.MouseButton1) then
                dragging = true
                dragStart = input.Position
                startPos = frame.Position
                
                input.Changed:Connect(function()
                    if (input.UserInputState == Enum.UserInputState.End) then
                        dragging = false
                    end
                end)
            end
        end)
        
        frame.InputChanged:Connect(function(input)
            if (input.UserInputType == Enum.UserInputType.MouseMovement) then
                dragInput = input
            end
        end)
        
        userInputService.InputChanged:Connect(function(input)
            if ((input == dragInput) and dragging) then
                local delta = input.Position - dragStart
                frame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
            end
        end)
    end
    
    -- Main Window
    local mainWindow = Instance.new("Frame")
    mainWindow.Name = "MainWindow"
    mainWindow.Size = UDim2.new(0, 340, 0, 320)
    mainWindow.Position = UDim2.new(0, 20, 0, 20)
    mainWindow.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
    mainWindow.BorderSizePixel = 0
    mainWindow.Parent = mainGui
    makeDraggable(mainWindow)
    print("✅ Main window created")
    
    local mainCorner = Instance.new("UICorner")
    mainCorner.CornerRadius = UDim.new(0, 6)
    mainCorner.Parent = mainWindow
    
    local mainStroke = Instance.new("UIStroke")
    mainStroke.Thickness = 1
    mainStroke.Color = Color3.fromRGB(45, 48, 55)
    mainStroke.Transparency = 0.5
    mainStroke.Parent = mainWindow
    
    local header = Instance.new("ImageLabel")
    header.Name = "Header"
    header.Size = UDim2.new(1, 30, 0, 30)
    header.Position = UDim2.new(0, -15, 0, -15)
    header.BackgroundTransparency = 1
    header.Image = "rbxasset://textures/ui/GuiImagePlaceholder.png"
    header.ImageColor3 = Color3.fromRGB(255, 255, 255)
    header.ImageTransparency = 0.9
    header.ScaleType = Enum.ScaleType.Slice
    header.SliceCenter = Rect.new(10, 10, 28, 28)
    header.Parent = mainWindow
    
    local gradient = Instance.new("UIGradient")
    gradient.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, Color3.fromRGB(22, 25, 32)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(12, 14, 18))
    })
    gradient.Rotation = 90
    gradient.Parent = mainWindow
    
    local statusBar = Instance.new("Frame")
    statusBar.Size = UDim2.new(1, -20, 0, 3)
    statusBar.Position = UDim2.new(0, 10, 0, 30)
    statusBar.BackgroundColor3 = Color3.fromRGB(220, 130, 90)
    statusBar.BorderSizePixel = 0
    statusBar.Parent = mainWindow
    
    local statusCorner = Instance.new("UICorner")
    statusCorner.CornerRadius = UDim.new(0, 3)
    statusCorner.Parent = statusBar
    
    local content = Instance.new("Frame")
    content.Size = UDim2.new(1, -30, 0, 60)
    content.Position = UDim2.new(0, 15, 0, 0)
    content.BackgroundTransparency = 1
    content.Parent = mainWindow
    
    local titleSection = Instance.new("ImageLabel")
    titleSection.Size = UDim2.new(0, 32, 0, 32)
    titleSection.Position = UDim2.new(0, 0, 0, -16)
    titleSection.BackgroundTransparency = 1
    titleSection.Image = "rbxasset://textures/ui/GuiImagePlaceholder.png"
    titleSection.ImageColor3 = Color3.fromRGB(130, 130, 130)
    titleSection.Parent = content
    
    local title = Instance.new("TextLabel")
    title.Size = UDim2.new(1, -40, 1, 0)
    title.Position = UDim2.new(0, 40, 0, 0)
    title.BackgroundTransparency = 1
    title.Text = "BUTCHER BOT"
    title.TextColor3 = Color3.fromRGB(250, 250, 250)
    title.Font = gothamBoldFont
    title.TextSize = 20
    title.TextXAlignment = Enum.TextXAlignment.Left
    title.Parent = content
    
    local subtitle = Instance.new("TextLabel")
    subtitle.Size = UDim2.new(1, -40, 0, 15)
    subtitle.Position = UDim2.new(0, 40, 0, 25)
    subtitle.BackgroundTransparency = 1
    subtitle.Text = "Professional Auto-Farming System"
    subtitle.TextColor3 = Color3.fromRGB(150, 150, 150)
    subtitle.Font = gothamFont
    subtitle.TextSize = 12
    subtitle.TextXAlignment = Enum.TextXAlignment.Left
    subtitle.Parent = content
    
    -- Farm Button
    local farmButton = Instance.new("Frame")
    farmButton.Size = UDim2.new(1, -30, 0, 50)
    farmButton.Position = UDim2.new(0, 15, 0, 60)
    farmButton.BackgroundColor3 = Color3.fromRGB(22, 25, 32)
    farmButton.BorderSizePixel = 0
    farmButton.Parent = mainWindow
    
    local farmButtonCorner = Instance.new("UICorner")
    farmButtonCorner.CornerRadius = UDim.new(0, 12)
    farmButtonCorner.Parent = farmButton
    
    local farmIcon = Instance.new("Frame")
    farmIcon.Size = UDim2.new(0, 8, 0, 8)
    farmIcon.Position = UDim2.new(0, 15, 0.5, -4)
    farmIcon.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    farmIcon.BorderSizePixel = 0
    farmIcon.Parent = farmButton
    
    local farmIconCorner = Instance.new("UICorner")
    farmIconCorner.CornerRadius = UDim.new(1, 0)
    farmIconCorner.Parent = farmIcon
    
    local farmText = Instance.new("TextLabel")
    farmText.Size = UDim2.new(0.7, -25, 1, 0)
    farmText.Position = UDim2.new(0, 45, 0, 0)
    farmText.BackgroundTransparency = 1
    farmText.Text = "START FARMING"
    farmText.TextColor3 = Color3.fromRGB(220, 220, 220)
    farmText.Font = gothamBoldFont
    farmText.TextSize = 14
    farmText.TextXAlignment = Enum.TextXAlignment.Left
    farmText.Parent = farmButton
    
    local farmRate = Instance.new("TextLabel")
    farmRate.Size = UDim2.new(0.3, -10, 1, 0)
    farmRate.Position = UDim2.new(0.7, -10, 0, 0)
    farmRate.BackgroundTransparency = 1
    farmRate.Text = "£5k/hr"
    farmRate.TextColor3 = Color3.fromRGB(150, 150, 150)
    farmRate.Font = gothamBoldFont
    farmRate.TextSize = 14
    farmRate.TextXAlignment = Enum.TextXAlignment.Right
    farmRate.Parent = farmButton
    
    local farmClickButton = Instance.new("TextButton")
    farmClickButton.Size = UDim2.new(1, 0, 1, 0)
    farmClickButton.BackgroundTransparency = 1
    farmClickButton.Text = ""
    farmClickButton.Parent = farmButton
    
    -- Status Panel
    local statusPanel = Instance.new("Frame")
    statusPanel.Size = UDim2.new(1, -30, 0, 50)
    statusPanel.Position = UDim2.new(0, 15, 0, 115)
    statusPanel.BackgroundColor3 = Color3.fromRGB(45, 110, 65)
    statusPanel.BorderSizePixel = 0
    statusPanel.Text = ""
    statusPanel.Parent = mainWindow
    
    local statusPanelCorner = Instance.new("UICorner")
    statusPanelCorner.CornerRadius = UDim.new(0, 12)
    statusPanelCorner.Parent = statusPanel
    
    local statusGradient = Instance.new("UIGradient")
    statusGradient.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, Color3.fromRGB(55, 130, 75)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(35, 90, 55))
    })
    statusGradient.Rotation = 90
    statusGradient.Parent = statusPanel
    
    local statusText = Instance.new("TextLabel")
    statusText.Size = UDim2.new(1, 0, 1, 0)
    statusText.BackgroundTransparency = 1
    statusText.Text = "STATUS: IDLE"
    statusText.TextColor3 = Color3.fromRGB(255, 255, 255)
    statusText.Font = gothamBoldFont
    statusText.TextSize = 16
    statusText.Parent = statusPanel
    
    -- Bottom Section
    local bottomSection = Instance.new("Frame")
    bottomSection.Size = UDim2.new(1, -30, 0, 30)
    bottomSection.Position = UDim2.new(0, 15, 0, 170)
    bottomSection.BackgroundTransparency = 1
    bottomSection.Parent = mainWindow
    
    -- Stats Boxes
    local playersOnline = Instance.new("Frame")
    playersOnline.Size = UDim2.new(0.3, -4, 1, -4)
    playersOnline.Position = UDim2.new(0, 0, 0, 2)
    playersOnline.BackgroundColor3 = Color3.fromRGB(55, 60, 70)
    playersOnline.BorderSizePixel = 0
    playersOnline.Parent = bottomSection
    
    local playersOnlineCorner = Instance.new("UICorner")
    playersOnlineCorner.CornerRadius = UDim.new(0, 6)
    playersOnlineCorner.Parent = playersOnline
    
    local playersOnlineText = Instance.new("TextLabel")
    playersOnlineText.Size = UDim2.new(1, 0, 1, 0)
    playersOnlineText.BackgroundTransparency = 1
    playersOnlineText.Text = tostring(#players:GetPlayers())
    playersOnlineText.TextColor3 = Color3.fromRGB(180, 180, 195)
    playersOnlineText.Font = gothamBoldFont
    playersOnlineText.TextSize = 11
    playersOnlineText.Parent = playersOnline
    
    local uptime = Instance.new("Frame")
    uptime.Size = UDim2.new(0.3, -4, 1, -4)
    uptime.Position = UDim2.new(0.35, 0, 0, 2)
    uptime.BackgroundColor3 = Color3.fromRGB(55, 60, 70)
    uptime.BorderSizePixel = 0
    uptime.Parent = bottomSection
    
    local uptimeCorner = Instance.new("UICorner")
    uptimeCorner.CornerRadius = UDim.new(0, 6)
    uptimeCorner.Parent = uptime
    
    local uptimeText = Instance.new("TextLabel")
    uptimeText.Size = UDim2.new(1, 0, 1, 0)
    uptimeText.BackgroundTransparency = 1
    uptimeText.Text = "0s"
    uptimeText.TextColor3 = Color3.fromRGB(180, 180, 195)
    uptimeText.Font = gothamBoldFont
    uptimeText.TextSize = 11
    uptimeText.Parent = uptime
    
    local earnings = Instance.new("Frame")
    earnings.Size = UDim2.new(0.3, -4, 1, -4)
    earnings.Position = UDim2.new(0.7, 0, 0, 2)
    earnings.BackgroundColor3 = Color3.fromRGB(55, 60, 70)
    earnings.BorderSizePixel = 0
    earnings.Parent = bottomSection
    
    local earningsCorner = Instance.new("UICorner")
    earningsCorner.CornerRadius = UDim.new(0, 6)
    earningsCorner.Parent = earnings
    
    local earningsText = Instance.new("TextLabel")
    earningsText.Size = UDim2.new(1, 0, 1, 0)
    earningsText.BackgroundTransparency = 1
    earningsText.Text = "£0"
    earningsText.TextColor3 = Color3.fromRGB(180, 180, 195)
    earningsText.Font = gothamBoldFont
    earningsText.TextSize = 11
    earningsText.Parent = earnings
    
    -- Butcher Panel
    local butcherPanel = Instance.new("Frame")
    butcherPanel.Name = "ButcherPanel"
    butcherPanel.Size = UDim2.new(0, 280, 0, 180)
    butcherPanel.Position = UDim2.new(0, 380, 0, 20)
    butcherPanel.BackgroundColor3 = Color3.fromRGB(15, 17, 22)
    butcherPanel.BorderSizePixel = 0
    butcherPanel.Parent = mainGui
    makeDraggable(butcherPanel)
    
    local butcherCorner = Instance.new("UICorner")
    butcherCorner.CornerRadius = UDim.new(0, 6)
    butcherCorner.Parent = butcherPanel
    
    local butcherStroke = Instance.new("UIStroke")
    butcherStroke.Thickness = 1
    butcherStroke.Color = Color3.fromRGB(45, 48, 55)
    butcherStroke.Transparency = 0.5
    butcherStroke.Parent = butcherPanel
    
    local butcherGradient = Instance.new("UIGradient")
    butcherGradient.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, Color3.fromRGB(22, 25, 32)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(12, 14, 18))
    })
    butcherGradient.Rotation = 90
    butcherGradient.Parent = butcherPanel
    
    local butcherTitle = Instance.new("TextLabel")
    butcherTitle.Size = UDim2.new(1, -30, 0, 50)
    butcherTitle.Position = UDim2.new(0, 15, 0, 10)
    butcherTitle.BackgroundTransparency = 1
    butcherTitle.Text = "BUTCHER JOB"
    butcherTitle.TextColor3 = Color3.fromRGB(250, 250, 250)
    butcherTitle.Font = gothamBoldFont
    butcherTitle.TextSize = 20
    butcherTitle.TextXAlignment = Enum.TextXAlignment.Left
    butcherTitle.Parent = butcherPanel
    
    -- Step 1
    local step1Frame = Instance.new("Frame")
    step1Frame.Size = UDim2.new(1, -30, 0, 45)
    step1Frame.Position = UDim2.new(0, 15, 0, 60)
    step1Frame.BackgroundColor3 = Color3.fromRGB(22, 25, 32)
    step1Frame.BorderSizePixel = 0
    step1Frame.Parent = butcherPanel
    
    local step1Corner = Instance.new("UICorner")
    step1Corner.CornerRadius = UDim.new(0, 10)
    step1Corner.Parent = step1Frame
    
    local step1Icon = Instance.new("TextLabel")
    step1Icon.Size = UDim2.new(0, 30, 1, 0)
    step1Icon.BackgroundTransparency = 1
    step1Icon.Text = "👁"
    step1Icon.TextColor3 = Color3.fromRGB(150, 220, 150)
    step1Icon.Font = gothamFont
    step1Icon.TextSize = 18
    step1Icon.Parent = step1Frame
    
    local step1Text = Instance.new("TextLabel")
    step1Text.Size = UDim2.new(0.5, -20, 1, 0)
    step1Text.Position = UDim2.new(0, 30, 0, 0)
    step1Text.BackgroundTransparency = 1
    step1Text.Text = "Step 1: Get Meat"
    step1Text.TextColor3 = Color3.fromRGB(220, 220, 255)
    step1Text.Font = gothamFont
    step1Text.TextSize = 14
    step1Text.TextXAlignment = Enum.TextXAlignment.Left
    step1Text.Parent = step1Frame
    
    local step1Button = Instance.new("TextButton")
    step1Button.Size = UDim2.new(0, 60, 0, 28)
    step1Button.Position = UDim2.new(1, -100, 0.5, -14)
    step1Button.BackgroundColor3 = Color3.fromRGB(45, 110, 65)
    step1Button.BorderSizePixel = 0
    step1Button.Text = "TP"
    step1Button.TextColor3 = Color3.fromRGB(255, 255, 255)
    step1Button.Font = gothamBoldFont
    step1Button.TextSize = 12
    step1Button.Parent = step1Frame
    
    local step1ButtonCorner = Instance.new("UICorner")
    step1ButtonCorner.CornerRadius = UDim.new(0, 8)
    step1ButtonCorner.Parent = step1Button
    
    -- Step 2
    local step2Frame = Instance.new("Frame")
    step2Frame.Size = UDim2.new(1, -30, 0, 45)
    step2Frame.Position = UDim2.new(0, 15, 0, 110)
    step2Frame.BackgroundColor3 = Color3.fromRGB(22, 25, 32)
    step2Frame.BorderSizePixel = 0
    step2Frame.Parent = butcherPanel
    
    local step2Corner = Instance.new("UICorner")
    step2Corner.CornerRadius = UDim.new(0, 10)
    step2Corner.Parent = step2Frame
    
    local step2Icon = Instance.new("TextLabel")
    step2Icon.Size = UDim2.new(0, 30, 1, 0)
    step2Icon.BackgroundTransparency = 1
    step2Icon.Text = "🔪"
    step2Icon.TextColor3 = Color3.fromRGB(220, 220, 150)
    step2Icon.Font = gothamFont
    step2Icon.TextSize = 18
    step2Icon.Parent = step2Frame
    
    local step2Text = Instance.new("TextLabel")
    step2Text.Size = UDim2.new(0.5, -20, 1, 0)
    step2Text.Position = UDim2.new(0, 30, 0, 0)
    step2Text.BackgroundTransparency = 1
    step2Text.Text = "Step 2: Chop Meat"
    step2Text.TextColor3 = Color3.fromRGB(220, 220, 255)
    step2Text.Font = gothamFont
    step2Text.TextSize = 14
    step2Text.TextXAlignment = Enum.TextXAlignment.Left
    step2Text.Parent = step2Frame
    
    local step2Button = Instance.new("TextButton")
    step2Button.Size = UDim2.new(0, 60, 0, 28)
    step2Button.Position = UDim2.new(1, -100, 0.5, -14)
    step2Button.BackgroundColor3 = Color3.fromRGB(45, 110, 65)
    step2Button.BorderSizePixel = 0
    step2Button.Text = "TP"
    step2Button.TextColor3 = Color3.fromRGB(255, 255, 255)
    step2Button.Font = gothamBoldFont
    step2Button.TextSize = 12
    step2Button.Parent = step2Frame
    
    local step2ButtonCorner = Instance.new("UICorner")
    step2ButtonCorner.CornerRadius = UDim.new(0, 8)
    step2ButtonCorner.Parent = step2Button
    
    -- Step 3
    local step3Frame = Instance.new("Frame")
    step3Frame.Size = UDim2.new(1, -30, 0, 45)
    step3Frame.Position = UDim2.new(0, 15, 0, 160)
    step3Frame.BackgroundColor3 = Color3.fromRGB(22, 25, 32)
    step3Frame.BorderSizePixel = 0
    step3Frame.Parent = butcherPanel
    
    local step3Corner = Instance.new("UICorner")
    step3Corner.CornerRadius = UDim.new(0, 10)
    step3Corner.Parent = step3Frame
    
    local step3Icon = Instance.new("TextLabel")
    step3Icon.Size = UDim2.new(0, 30, 1, 0)
    step3Icon.BackgroundTransparency = 1
    step3Icon.Text = "💰"
    step3Icon.TextColor3 = Color3.fromRGB(255, 215, 0)
    step3Icon.Font = gothamFont
    step3Icon.TextSize = 18
    step3Icon.Parent = step3Frame
    
    local step3Text = Instance.new("TextLabel")
    step3Text.Size = UDim2.new(0.5, -20, 1, 0)
    step3Text.Position = UDim2.new(0, 30, 0, 0)
    step3Text.BackgroundTransparency = 1
    step3Text.Text = "Step 3: Sell Meat"
    step3Text.TextColor3 = Color3.fromRGB(220, 220, 255)
    step3Text.Font = gothamFont
    step3Text.TextSize = 14
    step3Text.TextXAlignment = Enum.TextXAlignment.Left
    step3Text.Parent = step3Frame
    
    local step3Button = Instance.new("TextButton")
    step3Button.Size = UDim2.new(0, 60, 0, 28)
    step3Button.Position = UDim2.new(1, -100, 0.5, -14)
    step3Button.BackgroundColor3 = Color3.fromRGB(45, 110, 65)
    step3Button.BorderSizePixel = 0
    step3Button.Text = "TP"
    step3Button.TextColor3 = Color3.fromRGB(255, 255, 255)
    step3Button.Font = gothamBoldFont
    step3Button.TextSize = 12
    step3Button.Parent = step3Frame
    
    local step3ButtonCorner = Instance.new("UICorner")
    step3ButtonCorner.CornerRadius = UDim.new(0, 8)
    step3ButtonCorner.Parent = step3Button
    
    -- Panel 3
    local panel3 = Instance.new("Frame")
    panel3.Name = "Panel3"
    panel3.Size = UDim2.new(0, 340, 0, 360)
    panel3.Position = UDim2.new(1, -360, 0, 20)
    panel3.BackgroundColor3 = Color3.fromRGB(15, 17, 22)
    panel3.BorderSizePixel = 0
    panel3.Parent = mainGui
    makeDraggable(panel3)
    print("✅ Panel 3 created")
    
    local panel3Corner = Instance.new("UICorner")
    panel3Corner.CornerRadius = UDim.new(0, 18)
    panel3Corner.Parent = panel3
    
    local panel3Stroke = Instance.new("UIStroke")
    panel3Stroke.Thickness = 1
    panel3Stroke.Color = Color3.fromRGB(45, 48, 55)
    panel3Stroke.Transparency = 0.5
    panel3Stroke.Parent = panel3
    
    local panel3Gradient = Instance.new("UIGradient")
    panel3Gradient.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, Color3.fromRGB(22, 25, 32)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(12, 14, 18))
    })
    panel3Gradient.Rotation = 90
    panel3Gradient.Parent = panel3
    
    local panel3Header = Instance.new("Frame")
    panel3Header.Size = UDim2.new(1, -30, 0, 50)
    panel3Header.Position = UDim2.new(0, 15, 0, 10)
    panel3Header.BackgroundTransparency = 1
    panel3Header.Parent = panel3
    
    local panel3Icon = Instance.new("TextLabel")
    panel3Icon.Size = UDim2.new(0, 30, 1, 0)
    panel3Icon.BackgroundTransparency = 1
    panel3Icon.Text = "👥"
    panel3Icon.TextColor3 = Color3.fromRGB(230, 230, 230)
    panel3Icon.Font = gothamFont
    panel3Icon.TextSize = 22
    panel3Icon.Parent = panel3Header
    
    local panel3Title = Instance.new("TextLabel")
    panel3Title.Size = UDim2.new(1, -30, 1, 0)
    panel3Title.Position = UDim2.new(0, 35, 0, 0)
    panel3Title.BackgroundTransparency = 1
    panel3Title.Text = "PLAYERS NEARBY"
    panel3Title.TextColor3 = Color3.fromRGB(250, 250, 250)
    panel3Title.Font = gothamBoldFont
    panel3Title.TextSize = 20
    panel3Title.TextXAlignment = Enum.TextXAlignment.Left
    panel3Title.Parent = panel3Header
    
    local contentArea = Instance.new("Frame")
    contentArea.Size = UDim2.new(1, -30, 0, 35)
    contentArea.Position = UDim2.new(0, 15, 0, 70)
    contentArea.BackgroundColor3 = Color3.fromRGB(22, 25, 32)
    contentArea.BorderSizePixel = 0
    contentArea.Parent = panel3
    
    local contentAreaCorner = Instance.new("UICorner")
    contentAreaCorner.CornerRadius = UDim.new(0, 10)
    contentAreaCorner.Parent = contentArea
    
    local contentText = Instance.new("TextLabel")
    contentText.Size = UDim2.new(1, -20, 1, 0)
    contentText.Position = UDim2.new(0, 15, 0, 0)
    contentText.BackgroundTransparency = 1
    contentText.Text = "No players nearby"
    contentText.TextColor3 = Color3.fromRGB(200, 200, 215)
    contentText.Font = gothamBoldFont
    contentText.TextSize = 14
    contentText.TextXAlignment = Enum.TextXAlignment.Left
    contentText.Parent = contentArea
    
    local scrollingFrame = Instance.new("ScrollingFrame")
    scrollingFrame.Size = UDim2.new(1, -30, 1, -145)
    scrollingFrame.Position = UDim2.new(0, 15, 0, 115)
    scrollingFrame.BackgroundColor3 = Color3.fromRGB(18, 20, 26)
    scrollingFrame.BorderSizePixel = 0
    scrollingFrame.ScrollBarThickness = 4
    scrollingFrame.ScrollBarImageColor3 = Color3.fromRGB(100, 105, 115)
    scrollingFrame.CanvasSize = UDim2.new(0, 0, 0, 0)
    scrollingFrame.AutomaticCanvasSize = Enum.AutomaticSize.Y
    scrollingFrame.Parent = panel3
    
    local scrollingCorner = Instance.new("UICorner")
    scrollingCorner.CornerRadius = UDim.new(0, 12)
    scrollingCorner.Parent = scrollingFrame
    
    local closeButton = Instance.new("TextButton")
    closeButton.Size = UDim2.new(0, 100, 0, 35)
    closeButton.Position = UDim2.new(1, -120, 1, -45)
    closeButton.BackgroundColor3 = Color3.fromRGB(40, 45, 55)
    closeButton.BorderSizePixel = 0
    closeButton.Text = "CLOSE"
    closeButton.TextColor3 = Color3.fromRGB(220, 220, 235)
    closeButton.Font = gothamBoldFont
    closeButton.TextSize = 13
    closeButton.Parent = mainGui
    
    local closeButtonCorner = Instance.new("UICorner")
    closeButtonCorner.CornerRadius = UDim.new(0, 8)
    closeButtonCorner.Parent = closeButton
    
    closeButton.MouseButton1Click:Connect(function()
        mainGui:Destroy()
    end)
    
    -- Farm positions
    local farmPositions = {
        {
            position = Vector3.new(-681.16, 3.36, -497.09),
            name = "Carcass",
            waitTime = 0.8
        },
        {
            position = Vector3.new(-356.14, 3.36, -497.93),
            name = "Chop",
            waitTime = 0.8
        },
        {
            position = Vector3.new(-342.1, 3.36, -509.72),
            name = "Sell",
            waitTime = 0.1
        }
    }
    
    print("✅ Farm positions loaded")
    
    -- Teleport function
    local function teleportTo(position)
        if tween then tween:Cancel() end
        tween = tweenService:Create(humanoid, TweenInfo.new(0.1, Enum.EasingStyle.Linear), {
            CFrame = CFrame.new(position)
        })
        tween:Play()
    end
    
    -- Step button functions
    step1Button.MouseButton1Click:Connect(function()
        teleportTo(farmPositions[1].position)
        statusText.Text = "➜ " .. farmPositions[1].name
    end)
    
    step2Button.MouseButton1Click:Connect(function()
        teleportTo(farmPositions[2].position)
        statusText.Text = "➜ " .. farmPositions[2].name
    end)
    
    step3Button.MouseButton1Click:Connect(function()
        teleportTo(farmPositions[3].position)
        statusText.Text = "➜ " .. farmPositions[3].name
    end)
    
    print("✅ Step buttons connected")
    
    -- Farming state
    local isFarming = false
    
    farmClickButton.MouseButton1Click:Connect(function()
        isFarming = not isFarming
        if isFarming then
            farmText.Text = "STOP FARMING"
            statusText.Text = "STATUS: FARMING"
            spawn(function()
                local step = 1
                while isFarming do
                    teleportTo(farmPositions[step].position)
                    statusText.Text = "➜ " .. farmPositions[step].name
                    wait(farmPositions[step].waitTime)
                    step = step + 1
                    if step > #farmPositions then step = 1 end
                end
            end)
        else
            farmText.Text = "START FARMING"
            statusText.Text = "STATUS: IDLE"
        end
    end)
    
    print("✅ Farm toggle connected")
    print("🎉 SCRIPT FULLY LOADED!")
    
    -- Update player count
    spawn(function()
        while true do
            playersOnlineText.Text = tostring(#players:GetPlayers())
            wait(1)
        end
    end)
    
end)

if not success then
    warn("❌ SCRIPT ERROR:", err)
    print("Error details: " .. tostring(err))
    
    local errorGui = Instance.new("ScreenGui")
    errorGui.Parent = player:WaitForChild("PlayerGui")
    
    local errorFrame = Instance.new("Frame")
    errorFrame.Size = UDim2.new(0, 400, 0, 200)
    errorFrame.Position = UDim2.new(0.5, -200, 0.5, -100)
    errorFrame.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
    errorFrame.Parent = errorGui
    
    local errorText = Instance.new("TextLabel")
    errorText.Size = UDim2.new(1, -20, 1, -20)
    errorText.Position = UDim2.new(0, 10, 0, 10)
    errorText.Text = "ERROR:\n" .. tostring(err)
    errorText.TextColor3 = Color3.fromRGB(255, 255, 255)
    errorText.TextWrapped = true
    errorText.BackgroundTransparency = 1
    errorText.Parent = errorFrame
end
