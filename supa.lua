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

-- Function to grab the item
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

-- Create Dropdown for items
local Dropdown = TeleportTab:CreateDropdown({
    Name = "Items List",
    Options = {},
    MultipleOptions = false,
    CurrentOption = {"Stand Arrow"},
    Callback = function(Options)
        local selectedItemName = Options[1]
        local selectedItem = items[selectedItemName]

        if selectedItem then
            if selectedItem:IsA("BasePart") then
                humanoidRootPart.CFrame = selectedItem.CFrame
            elseif selectedItem:IsA("Tool") and selectedItem:FindFirstChild("Handle") then
                humanoidRootPart.CFrame = selectedItem.Handle.CFrame
            end
            wait(1)
            grabitem(selectedItem)
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
