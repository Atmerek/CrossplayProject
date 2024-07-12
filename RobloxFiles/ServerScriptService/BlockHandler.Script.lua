local HttpService = game:GetService("HttpService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Workspace = game:GetService("Workspace")

local BlockStateManager = require(ReplicatedStorage:WaitForChild("BlockStateManager"))
local currentBlocks = require(ReplicatedStorage:WaitForChild("CurrentBlocks"))

local modelsFolder = ReplicatedStorage:WaitForChild("models")
local blockSize = 3
local updateInterval = 60 / 100 -- 100 requests per minute

-- Biome color table
local biomeColors = {
	PLAINS = Color3.fromRGB(145, 189, 89)
}

local function getChunkBlocks(minChunkX, maxChunkX, minChunkZ, maxChunkZ)
	local url = string.format("http://%s:4567/blocks?chunkX=%d,%d&chunkZ=%d,%d", ReplicatedStorage.IP.Value, minChunkX, maxChunkX, minChunkZ, maxChunkZ)
	local success, response = pcall(function() return HttpService:GetAsync(url) end)
	if success then
		return HttpService:JSONDecode(response)
	else
		warn("Failed to fetch world info:", response)
		return nil
	end
end

local function placeBlock(blockData)
	local key = string.format("%d,%d,%d", blockData.x, blockData.y, blockData.z)
	local existingBlock = currentBlocks[key]

	if existingBlock then
		if existingBlock.Name ~= blockData.t then
			existingBlock:Destroy()
			currentBlocks[key] = nil
		else
			BlockStateManager.applyState(existingBlock, blockData)
			return existingBlock
		end
	end

	local blockType = blockData.t
	local modelTemplate = modelsFolder:FindFirstChild(blockType)

	if modelTemplate then
		local modelClone = modelTemplate:Clone()
		modelClone:SetPrimaryPartCFrame(CFrame.new(blockData.x * blockSize, blockData.y * blockSize, blockData.z * blockSize))
		modelClone.Parent = Workspace.Blocks

		BlockStateManager.applyState(modelClone, blockData)

		if blockData.b then
			local biome = blockData.b
			local color = biomeColors[biome]
			if color then
				for _, descendant in ipairs(modelClone:GetDescendants()) do
					if blockType == "GRASS_BLOCK" then
						if descendant:IsA("Texture") or descendant:IsA("Decal") then
							if string.match(descendant.Name, "_Overlay$") then
								descendant.Color3 = color
							end
						end
					else
						if descendant:IsA("BasePart") then
							descendant.Color = color
						elseif descendant:IsA("Texture") or descendant:IsA("Decal") then
							descendant.Color3 = color
						end
					end
				end
			end
		end

		currentBlocks[key] = modelClone
		return modelClone
	else
		warn("Model for block type " .. blockType .. " not found in ReplicatedStorage.models")
		return nil
	end
end

local function updateBlocks(chunkData)
	local newBlocks = {}

	for _, blockData in ipairs(chunkData) do
		local key = string.format("%d,%d,%d", blockData.x, blockData.y, blockData.z)
		newBlocks[key] = placeBlock(blockData)
	end

	for key, block in pairs(currentBlocks) do
		if not newBlocks[key] then
			block:Destroy()
			currentBlocks[key] = nil
		end
	end
end

local function loadChunks(centerChunkX, centerChunkY, chunkGridSize)
	local halfGridSize = math.floor(chunkGridSize / 2)
	local minChunkX = centerChunkX - halfGridSize
	local maxChunkX = centerChunkX + halfGridSize
	local minChunkZ = centerChunkY - halfGridSize
	local maxChunkZ = centerChunkY + halfGridSize

	local chunkData = getChunkBlocks(minChunkX, maxChunkX, minChunkZ, maxChunkZ)
	if chunkData then
		updateBlocks(chunkData)
	end
end

local function startUpdatingChunks(centerChunkX, centerChunkY, chunkGridSize)
	while true do
		loadChunks(centerChunkX, centerChunkY, chunkGridSize)
		task.wait(updateInterval)
	end
end

-- First two values are the center chunk. The third one is the chunk radius. Works only for odd numbers. Eg. 3 is going to be a 3x3 grid, 5 is going to be a 5x5 grid.
startUpdatingChunks(0, 0, 5)
