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

-- Function to dynamically fetch items from workspace.Items
local function updateItems()
    local itemsFolder = workspace:FindFirstChild("Items")
    local items = {}

    if itemsFolder then
        for _, item in pairs(itemsFolder:GetChildren()) do
            if item:IsA("Tool") then
                items[item.Name] = item:FindFirstChild("Handle") -- Handle for tools
            elseif item:IsA("BasePart") then
                items[item.Name] = item -- Non-tool items
            end
        end
    end
    return items
end

-- Function to interact with the item
local function grabitem(item)
    local clickBox = item:FindFirstChild("ClickBox") or item:FindFirstChild("Handle")
    if clickBox then
        local clickDetector = clickBox:FindFirstChild("ClickDetector")
        if clickDetector then
            fireclickdetector(clickDetector)
        end
    else
        Rayfield:Notify({
            Title = "Interaction Failed",
            Content = "Cannot interact with the item.",
            Duration = 2,
        })
    end
end

-- Keep track of the previously created items to check for changes
local lastItems = {}

-- Update items regularly and create buttons if items change
game:GetService("RunService").Heartbeat:Connect(function()
    local items = updateItems() -- Get updated list of items

    -- Check if items have changed (add new or removed items)
    local itemsChanged = false
    for itemName, item in pairs(items) do
        if not lastItems[itemName] then
            itemsChanged = true
            break
        end
    end

    if itemsChanged then
        TeleportTab:ClearButtons()  -- Clear previous buttons

        -- Create new buttons
        for itemName, item in pairs(items) do
            TeleportTab:CreateButton({
                Name = itemName,
                Callback = function()
                    if item and humanoidRootPart and item:IsA("BasePart") then
                        humanoidRootPart.CFrame = item.CFrame -- Teleport
                        wait(1)
                        grabitem(item.Parent or item) -- Grab the item
                    else
                        Rayfield:Notify({
                            Title = "Item Not Found",
                            Content = "Could not find or interact with " .. itemName,
                            Duration = 2,
                        })
                    end
                end,
            })
        end
    end

    -- Update the lastItems table
    lastItems = items
end)
