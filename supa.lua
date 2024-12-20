local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()
local Window = Rayfield:CreateWindow({
    Name = "Item Teleporter",
    LoadingTitle = "Teleport and Grab Items",
    LoadingSubtitle = "Teleport and interact with items dynamically.",
    ConfigurationSaving = { Enabled = false },
})

local TeleportTab = Window:CreateTab("Teleport", nil)
local player = game.Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local humanoidRootPart = character:WaitForChild("HumanoidRootPart")

local itemsFolder = workspace:FindFirstChild("Items")
local items = {}

-- Function to update the items list
local function updateItems()
    items = {}
    if itemsFolder then
        for _, item in pairs(itemsFolder:GetChildren()) do
            if item:IsA("Tool") then
                items[item.Name] = item:FindFirstChild("Handle") -- Handle for tools
            elseif item:IsA("BasePart") then
                items[item.Name] = item -- Non-tool items
            end
        end
    end
end

-- Function to teleport and grab the item
local function teleportAndGrab(item)
    if item and item:FindFirstChild("ClickBox") then
        local clickBox = item.ClickBox
        -- Calculate 5m distance below the item
        local targetPosition = item.Position - Vector3.new(0, 5, 0)
        
        humanoidRootPart.CFrame = CFrame.new(targetPosition)
        
        wait(0.5)
        
        -- Fire the click detector to grab the item
        local clickDetector = clickBox:FindFirstChild("ClickDetector")
        if clickDetector then
            fireclickdetector(clickDetector)
        end    
    end
end

-- Create Dropdown for items
local Dropdown = TeleportTab:CreateDropdown({
    Name = "Items List",
    Options = {},  -- Start with empty options
    MultipleOptions = false,
    Callback = function(Options)
        local selectedItemName = Options[1]  -- Use the first option as the selected item
        local selectedItem = items[selectedItemName]

        if selectedItem then
            -- Teleport the player to the selected item
            if selectedItem:IsA("BasePart") then
                humanoidRootPart.CFrame = selectedItem.CFrame
            elseif selectedItem:IsA("Tool") and selectedItem:FindFirstChild("Handle") then
                humanoidRootPart.CFrame = selectedItem.Handle.CFrame
            end
            wait(1)
            teleportAndGrab(selectedItem)  -- Try to interact with the item (grab it)
        else
            Rayfield:Notify({
                Title = "Item Not Found",
                Content = "The item you selected is not available.",
                Duration = 2,
            })
        end
    end,
})

-- Continuously update the items in the dropdown
game:GetService("RunService").Heartbeat:Connect(function()
    updateItems()
    local itemNames = {}
    for name in pairs(items) do
        table.insert(itemNames, name)
    end
    Dropdown:Set(itemNames)  -- Update the dropdown options dynamically
end)
