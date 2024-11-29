local HttpService = game:GetService("HttpService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
local Workspace = game:GetService("Workspace")
local TweenService = game:GetService("TweenService")
local ChatService = game:GetService("Chat")

local playerModelTemplate = ReplicatedStorage.Player
local players = {}
local playerModels = {}
local usernameToUUID = {}

local updateInterval = 60 / 100 -- 100 requests per minute

local dataUrl = "http://" .. ReplicatedStorage.IP.Value .. "/players"
local crossplayApiUrl = "https://crossplayproject.xyz/api/uuid/"

local function getUsername(uuid)
	local url = crossplayApiUrl .. uuid
	local response = HttpService:GetAsync(url)
	local jsonData = HttpService:JSONDecode(response)
	return jsonData.username
end

local function handleRequest()
	local success, pdata = pcall(function()
		return HttpService:GetAsync(dataUrl)
	end)

	if success then
		local playerData = HttpService:JSONDecode(pdata)
		local currentPlayers = {}

		for _, data in ipairs(playerData) do
			local uuid = data["uuid"]
			currentPlayers[uuid] = true

			if not players[uuid] then
				-- Player joined the game
				local newPlayerModel = playerModelTemplate:Clone()
				newPlayerModel.Name = uuid
				newPlayerModel.Parent = Workspace.Players

				local username = getUsername(uuid)
				usernameToUUID[username] = uuid
				local nameLabel = Instance.new("BillboardGui")
				nameLabel.Name = "PlayerNameLabel"
				nameLabel.Size = UDim2.new(0, 100, 0, 20)
				nameLabel.StudsOffset = Vector3.new(0, 1.2, 0) -- Offset above head
				nameLabel.Adornee = newPlayerModel:FindFirstChild("Head")
				nameLabel.AlwaysOnTop = false
				nameLabel.MaxDistance = 50

				local nameText = Instance.new("TextLabel")
				nameText.Parent = nameLabel
				nameText.Size = UDim2.new(1, 0, 1, 0)
				nameText.Text = username
				nameText.TextColor3 = Color3.new(1, 1, 1)
				nameText.BackgroundTransparency = 0.6
				nameText.BackgroundColor3 = Color3.fromRGB(128, 128, 128)
				nameText.BorderSizePixel = 0
				nameText.FontFace = Font.fromId(12187371840)
				nameText.TextScaled = true

				nameLabel.Parent = newPlayerModel

				game.ReplicatedStorage.loadPlayerSkin:FireAllClients(uuid, username, newPlayerModel)

				players[uuid] = true
				playerModels[uuid] = newPlayerModel
			end

			local playerModel = playerModels[uuid]
			local position = Vector3.new((data.x * 3) - 1.5, (data.y * 3) + 0.3, (data.z * 3) - 1.5)
			local currentCFrame = playerModel:GetPrimaryPartCFrame()
			local newCFrame = CFrame.new(position)

			local tweenInfo = TweenInfo.new(0.5, Enum.EasingStyle.Linear, Enum.EasingDirection.Out)
			local tween = TweenService:Create(playerModel.PrimaryPart, tweenInfo, {CFrame = newCFrame})
			tween:Play()

			local pitch = data.pitch
			local yaw = data.yaw + 180

			local headPosition = position + Vector3.new(0, 2, 0)
			local headLoc = CFrame.new(headPosition)
			headLoc = headLoc * CFrame.Angles(0, math.rad(-yaw), 0)
			headLoc = headLoc * CFrame.Angles(math.rad(-pitch), 0, 0)

			local headPart = playerModel:FindFirstChild("Head")
			local neckPart = headPart and headPart:FindFirstChild("Neck")

			if headPart and neckPart then
				local headTween = TweenService:Create(headPart, tweenInfo, {CFrame = headLoc})
				local neckTween = TweenService:Create(neckPart, tweenInfo, {CFrame = headLoc})
				headTween:Play()
				neckTween:Play()
			end

			local torsoPosition = position + Vector3.new(0, 1, 0)
			local torsoLoc = CFrame.new(torsoPosition)
			torsoLoc = torsoLoc * CFrame.Angles(0, math.rad(-yaw), 0)

			local torsoPart = playerModel:FindFirstChild("Torso")

			if torsoPart then
				local torsoTween = TweenService:Create(torsoPart, tweenInfo, {CFrame = torsoLoc})
				torsoTween:Play()
			end
		end

		-- Remove players who are no longer present
		for uuid, _ in pairs(players) do
			if not currentPlayers[uuid] then
				local playerModel = playerModels[uuid]
				if playerModel then
					playerModel:Destroy()
					playerModels[uuid] = nil
				end
				players[uuid] = nil

				local username = getUsername(uuid)
				usernameToUUID[username] = nil
			end
		end
	else
		warn("Failed to fetch player data:", pdata)
	end
end

local function CreateChatBubble(instance, message)
	ChatService:Chat(instance, message, Enum.ChatColor.White)
end

game.ReplicatedStorage.Chat.OnServerEvent:Connect(function(player, message, sender)
	local uuid = usernameToUUID[sender]
	if uuid then
		local playerModel = playerModels[uuid]
		if playerModel then
			CreateChatBubble(playerModel.Head, message)
		else
			warn("Player model not found for chat message:", sender)
		end
	else
		warn("UUID not found for username:", sender)
	end
end)

while true do
	handleRequest()
	task.wait(updateInterval)
end
