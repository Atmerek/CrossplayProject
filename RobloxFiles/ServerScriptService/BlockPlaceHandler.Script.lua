local ReplicatedStorage = game:GetService("ReplicatedStorage")
local HttpService = game:GetService("HttpService")

local currentBlocks = require(ReplicatedStorage:WaitForChild("CurrentBlocks"))

local remoteEvent = Instance.new("RemoteEvent")
remoteEvent.Name = "BlockPlaceEvent"
remoteEvent.Parent = ReplicatedStorage

local function onBlockPlace(player, blockData)
	local key = string.format("%d,%d,%d", blockData.x, blockData.y, blockData.z)

	if currentBlocks[key] then
		warn("Block already exists at location: " .. key)
		return
	end

	local data = {
		x = blockData.x,
		y = blockData.y,
		z = blockData.z,
		material = blockData.material,
		direction = blockData.direction,
		action = "BUILD"
	}

	local url = "http://" .. ReplicatedStorage.IP.Value .. "/post"
	local success, response = pcall(function()
		return HttpService:PostAsync(url, HttpService:JSONEncode(data), Enum.HttpContentType.ApplicationJson)
	end)

	if success then
		local modelTemplate = ReplicatedStorage:FindFirstChild("models"):FindFirstChild(blockData.material)
		if modelTemplate then
			local modelClone = modelTemplate:Clone()
			modelClone:SetPrimaryPartCFrame(CFrame.new(blockData.x * 3, blockData.y * 3, blockData.z * 3))
			modelClone.Parent = workspace
			currentBlocks[key] = modelClone
		else
			warn("Model for block type " .. blockData.material .. " not found in ReplicatedStorage.models")
		end
	else
		warn("Failed to send block place data: " .. tostring(response))
	end
end

remoteEvent.OnServerEvent:Connect(onBlockPlace)
