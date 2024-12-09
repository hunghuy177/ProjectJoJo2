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

-- Create/update dropdown for items
local function createItemDropdown()
    local items = updateItems()

    -- Create dropdown options from item names
    local options = {}
    for itemName in pairs(items) do
        table.insert(options, itemName)
    end

    -- Create or update the dropdown menu
    local dropdown = TeleportTab:CreateDropdown({
        Name = "Select Item",
        Options = options,
        CurrentOption = {options[1]}, -- Set initial selection
        MultipleOptions = false,
        Flag = "ItemDropdown",
        Callback = function(selectedItemNames)
            local selectedItemName = selectedItemNames[1]
            local selectedItem = items[selectedItemName]

            if selectedItem and humanoidRootPart and selectedItem:IsA("BasePart") then
                humanoidRootPart.CFrame = selectedItem.CFrame -- Teleport
                wait(1)
                grabitem(selectedItem.Parent or selectedItem) -- Grab the item
            else
                Rayfield:Notify({
                    Title = "Item Not Found",
                    Content = "Could not find or interact with " .. selectedItemName,
                    Duration = 2,
                })
            end
        end,
    })
end

-- Button to refresh and update the item dropdown
TeleportTab:CreateButton({
    Name = "Refresh Items",
    Callback = createItemDropdown,
})

-- Initial call to create the dropdown
createItemDropdown()
