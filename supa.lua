local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))() 
local Window = Rayfield:CreateWindow({
    Name = "Item Teleporter",
    LoadingTitle = "Teleport and Grab Items",
    LoadingSubtitle = "Teleport and interact with items dynamically.",
    ConfigurationSaving = { Enabled = false },
})

local TeleportTab = Window:CreateTab("Teleport", nil)
local player = game.Players.LocalPlayer

-- Function to get the player's HumanoidRootPart
local function getHumanoidRootPart()
    local character = player.Character or player.CharacterAdded:Wait()
    return character:FindFirstChild("HumanoidRootPart")
end

-- Function to interact with the item
local function grabitem(item)
    local clickBox = item:FindFirstChild("ClickBox") or item:FindFirstChild("Handle")
    if clickBox then
        local clickDetector = clickBox:FindFirstChild("ClickDetector")
        if clickDetector then
            fireclickdetector(clickDetector)
        else
            Rayfield:Notify({
                Title = "Interaction Failed",
                Content = "No ClickDetector found for this item.",
                Duration = 2,
            })
        end
    else
        Rayfield:Notify({
            Title = "Interaction Failed",
            Content = "Cannot interact with the item.",
            Duration = 2,
        })
    end
end

-- List of items and their exact names in the workspace
local items = {
    ["Requiem Arrow"] = workspace.Items:FindFirstChild("Requiem Arrow"),
    ["Hamon Breather"] = workspace.Items:FindFirstChild("Hamon Breather"),
    ["Rokakaka Fruit"] = workspace.Items:FindFirstChild("Rokakaka"),
    ["Stone Rokakaka"] = workspace.Items:FindFirstChild("Stone Rokakaka"),
    ["New Rokakaka"] = workspace.Items:FindFirstChild("New Rokakaka"),
    ["Corpse Part"] = workspace.Items:FindFirstChild("Corpse Part"),
    ["Sinner Soul"] = workspace.Items:FindFirstChild("Sinner Soul"),
    ["Steel Ball"] = workspace.Items:FindFirstChild("Steel Ball"),
    ["Dio Diary"] = workspace.Items:FindFirstChild("Dio Diary"),
    ["Aja Mask"] = workspace.Items:FindFirstChild("Aja Mask"),
    ["Vampire Mask"] = workspace.Items:FindFirstChild("Vampire Mask"),
    ["Dio Bone"] = workspace.Items:FindFirstChild("Dio Bone"),
    ["Stand Arrow"] = workspace.Items:FindFirstChild("Stand Arrow"),
    ["Cash Sack"] = workspace.Items:FindFirstChild("Cash Sack"),
}

-- Create buttons for each item
for itemName, item in pairs(items) do
    if item then -- Only create button if item exists
        TeleportTab:CreateButton({
            Name = itemName,
            Callback = function()
                local humanoidRootPart = getHumanoidRootPart()
                if humanoidRootPart and item and item:IsA("BasePart") then
                    humanoidRootPart.CFrame = item.CFrame -- Teleport
                    wait(1)
                    grabitem(item) -- Grab the item
                else
                    Rayfield:Notify({
                        Title = "Item Not Found",
                        Content = "Could not find or interact with " .. itemName,
                        Duration = 2,
                    })
                end
            end,
        })
    else
        Rayfield:Notify({
            Title = "Item Not Found",
            Content = itemName .. " not found in the workspace.",
            Duration = 2,
        })
    end
end
