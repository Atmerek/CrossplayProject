local MessageEvent = game:GetService('ReplicatedStorage').Chat

local player = game:GetService('Players').LocalPlayer

MessageEvent.OnClientEvent:Connect(function(message,sender)
	local TextChatService = game:GetService("TextChatService")
	local TextChannels = TextChatService:WaitForChild("TextChannels")
	
	MessageEvent:FireServer(message, sender)
	
	TextChannels.RBXSystem:DisplaySystemMessage("<font color = \"rgb(170, 170, 170)\">[MC] </font>".."<font color = \"rgb(255, 255, 255)\">"..sender..": "..message.."</font>")
end)