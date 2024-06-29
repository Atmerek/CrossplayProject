local ReplicatedStorage = game:GetService("ReplicatedStorage")
local HttpService = game:GetService("HttpService")

local currentBlocks = require(ReplicatedStorage:WaitForChild("CurrentBlocks"))

local remoteEvent = Instance.new("RemoteEvent")
remoteEvent.Name = "BlockBrokenEvent"
remoteEvent.Parent = ReplicatedStorage

local function onBlockInteraction(player, blockPosition)
	local key = string.format("%d,%d,%d", blockPosition.X / 3, blockPosition.Y / 3, blockPosition.Z / 3)
	local block = currentBlocks[key]

	if block then
		block:Destroy()
		--currentBlocks[key] = nil

		local data = {
			x = blockPosition.X / 3,
			y = blockPosition.Y / 3,
			z = blockPosition.Z / 3,
			action = "BREAK"
		}

		spawn(function()
			local url = "http://localhost:4567/post"
			local success, response = pcall(function()
				return HttpService:PostAsync(url, HttpService:JSONEncode(data), Enum.HttpContentType.ApplicationJson)
			end)

			if not success then
				warn("Failed to send block break data: " .. tostring(response))
			end
		end)
	end
end

remoteEvent.OnServerEvent:Connect(onBlockInteraction)
