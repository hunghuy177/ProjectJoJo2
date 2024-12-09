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

-- Function to update the items table
local function updateItems()
    items = {}  -- Clear existing items

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

-- Continuously check for new items
game:GetService("RunService").Heartbeat:Connect(function()
    updateItems() -- Keep items updated
end)

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

-- Function to teleport and grab the item
local function tpspeitem(item)
    if item and humanoidRootPart and item:IsA("BasePart") then
        humanoidRootPart.CFrame = item.CFrame -- Teleport
        wait(1)
        grabitem(item) -- Grab the item
    else
        Rayfield:Notify({
            Title = "Item Not Found",
            Content = "The item hasn't spawned yet!",
            Duration = 2,
        })
    end
end

-- Create buttons for each item dynamically
local items = {
    "Requiem Arrow", "Hamon Breather", "Rokakaka Fruit", "Stone Rokakaka", "New Rokakaka",
    "Corpse Part", "Sinner Soul", "Steel Ball", "Dio Diary", "Aja Mask", "Vampire Mask",
    "Dio Bone", "Stand Arrow", "Cash Sack"
}

for _, itemName in pairs(items) do
    local item = itemsFolder:FindFirstChild(itemName) -- Get the item from the folder
    if item then
        TeleportTab:CreateButton({
            Name = itemName,
            Callback = function()
                tpspeitem(item)
            end
        })
    end
end
