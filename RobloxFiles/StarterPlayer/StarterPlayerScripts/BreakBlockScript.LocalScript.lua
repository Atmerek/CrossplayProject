local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local UserInputService = game:GetService("UserInputService")

local player = Players.LocalPlayer
local remoteEvent = ReplicatedStorage:WaitForChild("BlockBrokenEvent")

local modifyModeGui = player:WaitForChild("PlayerGui"):WaitForChild("ModifyMode")
local breakButton = modifyModeGui:WaitForChild("Frame"):WaitForChild("Break")

local isBreakingEnabled = false

breakButton.MouseButton1Click:Connect(function()
	isBreakingEnabled = not isBreakingEnabled
	breakButton.Text = isBreakingEnabled and "Breaking Enabled" or "Breaking Disabled"
end)

UserInputService.InputBegan:Connect(function(input, gameProcessed)
	if gameProcessed then return end
	if input.UserInputType == Enum.UserInputType.MouseButton1 and isBreakingEnabled then
		local mouse = player:GetMouse()
		local target = mouse.Target

		if target and target.Parent and target.Parent:IsA("Model") then
			local block = target.Parent
			local blockPosition = block.PrimaryPart.Position

			remoteEvent:FireServer(blockPosition)
		end
	end
end)
