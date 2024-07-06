local HttpService = game:GetService("HttpService")
local replicatedStorage = game:GetService("ReplicatedStorage")

local updateInterval = 60 / 100 -- 100 requests per minute

local lastPositions = {}

local function sendData(player, disconnect)
	local url = "http://" .. replicatedStorage.IP.Value .. ":4567/npc"
	local postData

	if disconnect then
		postData = HttpService:JSONEncode({ user = tostring(player.DisplayName), disconnect = true })
	else
		local humanoidRootPart = player.Character and player.Character:FindFirstChild("HumanoidRootPart")
		if not humanoidRootPart then return end

		local adjustedX = humanoidRootPart.Position.X / 3
		local adjustedY = (humanoidRootPart.Position.Y - 4.3) / 3
		local adjustedZ = humanoidRootPart.Position.Z / 3
		local yaw = (humanoidRootPart.Orientation.Y * -1) + 180
		local pitch = 0 -- placeholder

		local lastPosition = lastPositions[player]
		if lastPosition and lastPosition.x == adjustedX and lastPosition.y == adjustedY and lastPosition.z == adjustedZ and lastPosition.ya == yaw and lastPosition.pi == pitch then
			return
		end

		postData = HttpService:JSONEncode({
			user = tostring(player.DisplayName),
			x = adjustedX,
			y = adjustedY,
			z = adjustedZ,
			yaw = yaw,
			pitch = pitch
		})

		lastPositions[player] = {
			x = adjustedX,
			y = adjustedY,
			z = adjustedZ,
			ya = yaw,
			pi = pitch
		}
	end

	local success, response = pcall(function()
		return HttpService:PostAsync(url, postData, Enum.HttpContentType.ApplicationJson, false)
	end)

	if success == false then
		warn("Failed to send data:", response)
	end
end

game.Players.PlayerAdded:Connect(function(player)
	player.CharacterAdded:Connect(function(character)
		character:WaitForChild("HumanoidRootPart")
		spawn(function()
			while true do
				local humanoidRootPart = character:FindFirstChild("HumanoidRootPart")
				if humanoidRootPart then
					sendData(player, false)
				end
				task.wait(updateInterval)
			end
		end)
	end)
end)

game.Players.PlayerRemoving:Connect(function(player)
	sendData(player, true)
	lastPositions[player] = nil
end)