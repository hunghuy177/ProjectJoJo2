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

-- Function to update items dynamically
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

-- Dropdown to show all items
local Dropdown = TeleportTab:CreateDropdown({
    Name = "Items Dropdown",
    Options = {},  -- Start with an empty list
    CurrentOption = {},
    MultipleOptions = true,
    Flag = "ItemsDropdown",
    Callback = function(Options)
        -- Teleport to selected item when chosen
        local selectedItemName = Options[1]
        local selectedItem = items[selectedItemName]
        
        if selectedItem then
            humanoidRootPart.CFrame = selectedItem.CFrame -- Teleport to item
            wait(1)
            grabitem(selectedItem)  -- Interact with the item
        else
            Rayfield:Notify({
                Title = "Item Not Found",
                Content = "The item you selected is not available.",
                Duration = 2,
            })
        end
    end,
})

-- Function to grab item
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

-- Button to refresh the dropdown options
TeleportTab:CreateButton({
    Name = "Refresh Items",
    Callback = function()
        updateItems()  -- Refresh the item list
        local options = {}
        
        -- Update the dropdown options with current items
        for itemName, _ in pairs(items) do
            table.insert(options, itemName)
        end
        
        -- Update the dropdown with new options
        Dropdown:Set(options)
    end,
})

-- Initial population of dropdown with items
updateItems()
local initialOptions = {}
for itemName, _ in pairs(items) do
    table.insert(initialOptions, itemName)
end
Dropdown:Set(initialOptions)
