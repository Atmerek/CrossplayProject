-- An example on how to convert minecraft time into the roblox format and apply it.

local HttpService = game:GetService("HttpService")
local Lighting = game:GetService("Lighting")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local endpointURL = "http://localhost:4567/world"

local function generateTimeConversionTable()
	local conversionTable, nightStart, nightEnd, dayStart, dayEnd = {}, 18000, 24000, 0, 18000
	for i = 0, 24000 do
		if i >= nightStart and i < nightEnd then
			conversionTable[i] = string.format("%02d:%02d", ((i - nightStart) / 1000), (i - nightStart) / 100 % 10 * 6)
		elseif i >= dayStart and i < dayEnd then
			conversionTable[i] = string.format("%02d:%02d", ((i - dayStart) / 1000 + 6) % 24, (i - dayStart) / 100 % 10 * 6)
		end
	end
	return conversionTable
end

local timeConversion = generateTimeConversionTable()

local function fetchWorldInfo()
	local success, result = pcall(function() return HttpService:GetAsync(endpointURL) end)
	if success then
		return result
	else
		warn("Failed to fetch world info:", result)
		return nil
	end
end

local function applyWorldInfo(info)
	if info then
		local worldInfo = HttpService:JSONDecode(info)
		local convertedTime = timeConversion[worldInfo.time]
		if convertedTime then
			local hour, minute = convertedTime:match("(%d+):(%d+)")
			Lighting:SetMinutesAfterMidnight(tonumber(hour) * 60 + tonumber(minute))
			--print(hour .. ":" .. minute)
		else
			warn("Invalid time received from server.")
		end
	end
end

local function updateWorldInfo()
	local info = fetchWorldInfo()
	applyWorldInfo(info)
end

updateWorldInfo()

while true do
	wait(2)
	updateWorldInfo()
end