local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local UserInputService = game:GetService("UserInputService")
local HttpService = game:GetService("HttpService")
local RunService = game:GetService("RunService")

local player = Players.LocalPlayer
local remoteEvent = ReplicatedStorage:WaitForChild("BlockPlaceEvent")

local modelsFolder = ReplicatedStorage:WaitForChild("models")
local modifyModeGui = player:WaitForChild("PlayerGui"):WaitForChild("ModifyMode")
local placeButton = modifyModeGui:WaitForChild("Frame"):WaitForChild("Place")

local isPlacingEnabled = false
local selectedMaterial = "STONE"
local buildGuide

local screenGui = Instance.new("ScreenGui")
screenGui.Name = "BlockSelectionGui"
screenGui.Parent = player:WaitForChild("PlayerGui")

local blockListFrame = Instance.new("ScrollingFrame")
blockListFrame.Size = UDim2.new(0, 200, 0, 300)
blockListFrame.Position = UDim2.new(0.5, -100, 0.5, -150)
blockListFrame.BackgroundColor3 = Color3.new(1, 1, 1)
blockListFrame.BorderSizePixel = 1
blockListFrame.Visible = false
blockListFrame.CanvasSize = UDim2.new(0, 0, 0, #modelsFolder:GetChildren() * 30)
blockListFrame.ScrollBarThickness = 10
blockListFrame.Parent = screenGui

local blockList = {}

for _, model in pairs(modelsFolder:GetChildren()) do
	table.insert(blockList, model.Name)
end

table.sort(blockList)

for i, blockName in ipairs(blockList) do
	local button = Instance.new("TextButton")
	button.Size = UDim2.new(1, -10, 0, 30)
	button.Position = UDim2.new(0, 0, 0, (i - 1) * 30)
	button.Text = blockName
	button.BackgroundColor3 = Color3.new(0.8, 0.8, 0.8)
	button.TextColor3 = Color3.new(0, 0, 0)
	button.Parent = blockListFrame

	button.MouseButton1Click:Connect(function()
		selectedMaterial = blockName
		blockListFrame.Visible = false
	end)
end

placeButton.MouseButton1Click:Connect(function()
	isPlacingEnabled = not isPlacingEnabled
	placeButton.Text = isPlacingEnabled and "Placing Enabled" or "Placing Disabled"

	if isPlacingEnabled then
		if not buildGuide then
			buildGuide = Instance.new("Part")
			buildGuide.Anchored = true
			buildGuide.CanCollide = false
			buildGuide.Transparency = 0.5
			buildGuide.CanQuery = false
			buildGuide.Size = Vector3.new(3, 3, 3)
			buildGuide.Parent = workspace
		end
	else
		if buildGuide then
			buildGuide:Destroy()
			buildGuide = nil
		end
	end
end)

UserInputService.InputBegan:Connect(function(input, gameProcessed)
	if gameProcessed then return end
	if input.KeyCode == Enum.KeyCode.E then
		blockListFrame.Visible = not blockListFrame.Visible
	end
	if input.UserInputType == Enum.UserInputType.MouseButton2 and isPlacingEnabled then
		local mouse = player:GetMouse()
		local target = mouse.Target
		if target and target ~= buildGuide and not target:IsA("Terrain") then
			local targetPos = mouse.Hit.p
			local x = math.floor((targetPos.X + 1.5) / 3)
			local y = math.floor((targetPos.Y + 1.5) / 3)
			local z = math.floor((targetPos.Z + 1.5) / 3)

			local blockData = {
				x = x,
				y = y,
				z = z,
				material = selectedMaterial,
				direction = "NORTH"
			}

			remoteEvent:FireServer(blockData)
		end
	end
end)

RunService.RenderStepped:Connect(function()
	if isPlacingEnabled and buildGuide then
		local mouse = player:GetMouse()
		local targetPos = mouse.Hit.p
		buildGuide.Position = Vector3.new(math.floor((targetPos.X + 1.5) / 3) * 3, math.floor((targetPos.Y + 1.5) / 3) * 3, math.floor((targetPos.Z + 1.5) / 3) * 3)
	end
end)
