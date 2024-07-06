local HttpService = game:GetService("HttpService")

local serverUrl = "http://" .. game.ReplicatedStorage.IP.Value .. ":4567/chat"
local updateInterval = 60 / 100 -- 100 requests per minute

local NAME_COLORS = {
	Color3.new(253/255, 41/255, 67/255), -- Bright red
	Color3.new(1/255, 162/255, 255/255), -- Bright blue
	Color3.new(2/255, 184/255, 87/255), -- Earth green
	Color3.new(107/255, 50/255, 124/255), -- Bright violet
	Color3.new(218/255, 133/255, 65/255), -- Bright orange
	Color3.new(245/255, 205/255, 48/255), -- Bright yellow
	Color3.new(232/255, 186/255, 200/255), -- Light reddish violet
	Color3.new(215/255, 197/255, 154/255) -- Brick yellow
}

local function GetNameValue(pName)
	local value = 0
	for index = 1, #pName do
		local cValue = string.byte(string.sub(pName, index, index))
		local reverseIndex = #pName - index + 1
		if #pName % 2 == 1 then
			reverseIndex = reverseIndex - 1
		end
		if reverseIndex % 4 >= 2 then
			cValue = -cValue
		end
		value = value + cValue
	end
	return value
end

local function ComputeNameColor(pName)
	local color_offset = 0
	return NAME_COLORS[((GetNameValue(pName) + color_offset) % #NAME_COLORS) + 1]
end

local function onChat(speaker, speakerusername, message)
	local nameColor = ComputeNameColor(speakerusername)

	local hexColor = "#" .. string.format("%02X%02X%02X", math.floor(nameColor.R * 255), math.floor(nameColor.G * 255), math.floor(nameColor.B * 255))

	local data = HttpService:JSONEncode({
		player = speaker,
		color = hexColor,
		message = message 
	})

	HttpService:PostAsync(serverUrl, data, Enum.HttpContentType.ApplicationJson, false)
end

local function fetchMessages()
	local success, response = pcall(function()
		return HttpService:GetAsync(serverUrl)
	end)

	if success then
		return response
	else
		warn("Failed to fetch messages:", response)
		return nil
	end
end

local function displayMessages(messages)
	if messages then
		local decoded = HttpService:JSONDecode(messages)
		if decoded then
			for _, message in ipairs(decoded) do
				game.ReplicatedStorage:WaitForChild("Chat"):FireAllClients(message.message, message.sender)
			end
		else
			warn("Decoding JSON failed:", messages)
		end
	else
		warn("No messages received.")
	end
end

local function mainLoop()
	while true do
		local messages = fetchMessages()
		displayMessages(messages)
		wait(updateInterval)
	end
end

game.Players.PlayerAdded:Connect(function(player)
	player.Chatted:Connect(function(message)
		onChat(player.DisplayName, player.Name, message)
	end)
end)

mainLoop()
