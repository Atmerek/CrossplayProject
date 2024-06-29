local BlockStateManager = {}

function BlockStateManager.applyState(blockType, blockData)
	local material = blockData.type
	local state = blockData.state

	if string.match(material, "_LOG$") then
		local axis = state:match("axis=([xyz])")
		if axis == "x" then
			blockType:SetPrimaryPartCFrame(CFrame.new(blockType.PrimaryPart.Position) * CFrame.Angles(0, 0, math.rad(90)))
		elseif axis == "z" then
			blockType:SetPrimaryPartCFrame(CFrame.new(blockType.PrimaryPart.Position) * CFrame.Angles(math.rad(90), 0, 0))
		end
	end
	-- Add more as you wish.
end

return BlockStateManager
