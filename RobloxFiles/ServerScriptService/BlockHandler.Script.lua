local HttpService = game:GetService("HttpService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Workspace = game:GetService("Workspace")

local BlockStateManager = require(ReplicatedStorage:WaitForChild("BlockStateManager"))
local currentBlocks = require(ReplicatedStorage:WaitForChild("CurrentBlocks"))

local modelsFolder = ReplicatedStorage:WaitForChild("models")
local blockSize = 3
local updateInterval = 60 / 300 --300 requests per minute

-- Biome color table
local biomeColors = {
	PLAINS = Color3.fromRGB(145, 189, 89)
}

local function getChunkBlocks(chunkX, chunkY)
	local url = "http://localhost:4567/blocks?chunkX=" .. chunkX .. "&chunkZ=" .. chunkY
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
	if currentBlocks[key] then
		return currentBlocks[key]
	end

	
	local blockType = blockData.type
	local modelTemplate = modelsFolder:FindFirstChild(blockType)

	if modelTemplate then
		local modelClone = modelTemplate:Clone()
		modelClone:SetPrimaryPartCFrame(CFrame.new(blockData.x * blockSize, blockData.y * blockSize, blockData.z * blockSize))
		modelClone.Parent = Workspace

		BlockStateManager.applyState(modelClone, blockData)

		-- Biome color stuff
		if blockData.biome then
			local biome = blockData.biome
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

		return modelClone
	else
		warn("Model for block type " .. blockType .. " not found in ReplicatedStorage.models")
	end
end

local function updateBlocks(newBlocks)
	local newBlockKeys = {}
	for _, blockData in ipairs(newBlocks) do
		local key = string.format("%d,%d,%d", blockData.x, blockData.y, blockData.z)
		newBlockKeys[key] = blockData
	end

	-- Update existing blocks
	for key, block in pairs(currentBlocks) do
		local blockData = newBlockKeys[key]
		if blockData then

			BlockStateManager.applyState(block, blockData)

			if blockData.biome then
				local biome = blockData.biome
				local color = biomeColors[biome]
				if color then
					for _, descendant in ipairs(block:GetDescendants()) do
						if blockData.type == "GRASS_BLOCK" then
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

			-- Remove updated block from newBlockKeys to track remaining new blocks
			newBlockKeys[key] = nil
		else
			-- Block no longer exists, destroy it
			block:Destroy()
			currentBlocks[key] = nil
		end
	end

	-- Create new blocks in batches of 200
	local batchSize = 200
	local blockCount = #newBlocks
	for i = 1, blockCount, batchSize do
		local batchEnd = math.min(i + batchSize - 1, blockCount)
		local batch = {}
		for j = i, batchEnd do
			table.insert(batch, newBlocks[j])
		end
		for _, blockData in ipairs(batch) do
			currentBlocks[string.format("%d,%d,%d", blockData.x, blockData.y, blockData.z)] = placeBlock(blockData)
		end
		wait()
	end
end

local function loadChunks(centerChunkX, centerChunkY, chunkGridSize)
	local halfGridSize = math.floor(chunkGridSize / 2)
	local allBlocks = {}

	for offsetX = -halfGridSize, halfGridSize do
		for offsetY = -halfGridSize, halfGridSize do
			local chunkX = centerChunkX + offsetX
			local chunkY = centerChunkY + offsetY
			local blocks = getChunkBlocks(chunkX, chunkY)

			for _, blockData in ipairs(blocks) do
				table.insert(allBlocks, blockData)
			end
		end
	end

	updateBlocks(allBlocks)
end

local function startUpdatingChunks(centerChunkX, centerChunkY, chunkGridSize)
	while true do
		loadChunks(centerChunkX, centerChunkY, chunkGridSize)
		task.wait(updateInterval)
	end
end

-- First two values are the center chunk. The third one is the chunk radius. Works only for odd numbers. Eg. 3 is going to be a 3x3 grid, 5 is going to be a 5x5 grid.
startUpdatingChunks(0, 0, 5)
