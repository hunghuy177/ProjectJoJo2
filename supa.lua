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

-- Function to create/update dropdown for items
local function createItemDropdown()
    -- Create a dropdown with current items
    local items = updateItems()

    -- Clear existing dropdown items if any
    if TeleportTab:GetDropdown("ItemDropdown") then
        TeleportTab:GetDropdown("ItemDropdown"):ClearItems()
    end

    local dropdown = TeleportTab:CreateDropdown({
        Name = "Select Item",
        Options = table.keys(items), -- Get the names of the items
        Callback = function(itemName)
            local item = items[itemName]
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

-- Button to refresh and update the item dropdown
TeleportTab:CreateButton({
    Name = "Refresh Items",
    Callback = createItemDropdown,
})

-- Initial call to create the dropdown
createItemDropdown()

-- Helper function to get table keys
function table.keys(t)
    local keys = {}
    for k in pairs(t) do
        table.insert(keys, k)
    end
    return keys
end
