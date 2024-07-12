-- This is an implementation from our old code.

local BlockStateManager = {}

function BlockStateManager.applyState(blockType, blockData)
	local material = blockData.t
	local state = blockData.s


	if string.match(material, "_LOG$") or string.match(material, "_STEM$") or material == "BASALT" or material == "POLISHED_BASALT" or material == "BLACKSTONE" or material == "BAMBOO_BLOCK" then
		local axis = state:match("axis=([xyz])")
		if axis == "x" then
			blockType:SetPrimaryPartCFrame(CFrame.new(blockType.PrimaryPart.Position) * CFrame.Angles(0, 0, math.rad(90)))
		elseif axis == "z" then
			blockType:SetPrimaryPartCFrame(CFrame.new(blockType.PrimaryPart.Position) * CFrame.Angles(math.rad(90), 0, 0))
		end
	end

	if string.match(material, "_SLAB$") then
		local typetype = state:match("type=([^,%]]+)")
		if typetype == "top" then
			blockType:SetPrimaryPartCFrame(CFrame.new(blockType.PrimaryPart.Position) * CFrame.Angles(0, 0, math.rad(-180)))
		elseif typetype == "bottom" then
			blockType:SetPrimaryPartCFrame(CFrame.new(blockType.PrimaryPart.Position) * CFrame.Angles(0, 0, 0))
		elseif typetype == "double" then
			blockType.PrimaryPart.Part.Size = Vector3.new(3, 3, 3)
			blockType.PrimaryPart.Part.Position = Vector3.new(blockType.PrimaryPart.Position.X, blockType.PrimaryPart.Position.Y, blockType.PrimaryPart.Position.Z)
		end
	end

	if material == "LANTERN" then
		local hanging = state:match("hanging=([^,%]]+)")
		if hanging == "true" then

			for _, child in ipairs(blockType.PrimaryPart:GetChildren()) do
				if child:IsA("BasePart") then
					child.Position = child.Position + Vector3.new(0, 0.2, 0)
				end
			end

			for _, child in ipairs(blockType.PrimaryPart.WhenHanged:GetChildren()) do
				if child:IsA("BasePart") then
					child.Position = child.Position + Vector3.new(0, 0.2, 0)
				end
			end

			blockType.PrimaryPart.WhenHanged.Middle.Transparency = 0.99
			for _, texture in ipairs(blockType.PrimaryPart.WhenHanged.Middle:GetChildren()) do
				texture.Transparency = 0
			end
			blockType.PrimaryPart.WhenHanged.Top.Transparency = 0.99
			for _, texture in ipairs(blockType.PrimaryPart.WhenHanged.Top:GetChildren()) do
				texture.Transparency = 0
			end
			blockType.PrimaryPart.OnFloor.Transparency = 1
			for _, texture in ipairs(blockType.PrimaryPart.OnFloor:GetChildren()) do
				texture.Transparency = 1
			end
		end
	end

	if string.match(material, "_STAIRS$") then
		local facing = state:match("facing=([^,%]]+)")
		local half = state:match("half=([^,%]]+)")
		local shape = state:match("shape=([^,%]]+)")
		if facing == "north" then
			if half == "top" then
				blockType:SetPrimaryPartCFrame(CFrame.new(blockType.PrimaryPart.Position) * CFrame.Angles(0, 0, math.rad(180)))
				if shape == "straight" then
					blockType.PrimaryPart.Shape1.Transparency = 1
					blockType.PrimaryPart.Shape2.Transparency = 0
					blockType.PrimaryPart.Shape3.Transparency = 0
					blockType.PrimaryPart.Shape4.Transparency = 1

					for _, texture in ipairs(blockType.PrimaryPart.Shape1:GetChildren()) do
						texture.Transparency = 1
					end
					for _, texture in ipairs(blockType.PrimaryPart.Shape2:GetChildren()) do
						texture.Transparency = 0
					end
					for _, texture in ipairs(blockType.PrimaryPart.Shape3:GetChildren()) do
						texture.Transparency = 0
					end
					for _, texture in ipairs(blockType.PrimaryPart.Shape4:GetChildren()) do
						texture.Transparency = 1
					end
				end
				if shape == "outer_right" then
					blockType.PrimaryPart.Shape1.Transparency = 1
					for _, texture in ipairs(blockType.PrimaryPart.Shape1:GetChildren()) do
						texture.Transparency = 1
					end

					blockType.PrimaryPart.Shape2.Transparency = 1
					for _, texture in ipairs(blockType.PrimaryPart.Shape2:GetChildren()) do
						texture.Transparency = 1
					end

					blockType.PrimaryPart.Shape3.Transparency = 0
					for _, texture in ipairs(blockType.PrimaryPart.Shape3:GetChildren()) do
						texture.Transparency = 0
					end

					blockType.PrimaryPart.Shape4.Transparency = 1
					for _, texture in ipairs(blockType.PrimaryPart.Shape4:GetChildren()) do
						texture.Transparency = 1
					end
				end
				if shape == "outer_left" then
					blockType.PrimaryPart.Shape1.Transparency = 1
					for _, texture in ipairs(blockType.PrimaryPart.Shape1:GetChildren()) do
						texture.Transparency = 1
					end
					blockType.PrimaryPart.Shape2.Transparency = 0
					for _, texture in ipairs(blockType.PrimaryPart.Shape2:GetChildren()) do
						texture.Transparency = 0
					end
					blockType.PrimaryPart.Shape3.Transparency = 1
					for _, texture in ipairs(blockType.PrimaryPart.Shape3:GetChildren()) do
						texture.Transparency = 1
					end
					blockType.PrimaryPart.Shape4.Transparency = 1
					for _, texture in ipairs(blockType.PrimaryPart.Shape4:GetChildren()) do
						texture.Transparency = 1
					end
				end
				if shape == "inner_right" then
					blockType.PrimaryPart.Shape1.Transparency = 1
					for _, texture in ipairs(blockType.PrimaryPart.Shape1:GetChildren()) do
						texture.Transparency = 1
					end

					blockType.PrimaryPart.Shape2.Transparency = 0
					for _, texture in ipairs(blockType.PrimaryPart.Shape2:GetChildren()) do
						texture.Transparency = 0
					end

					blockType.PrimaryPart.Shape3.Transparency = 0
					for _, texture in ipairs(blockType.PrimaryPart.Shape3:GetChildren()) do
						texture.Transparency = 0
					end

					blockType.PrimaryPart.Shape4.Transparency = 0
					for _, texture in ipairs(blockType.PrimaryPart.Shape4:GetChildren()) do
						texture.Transparency = 0
					end
				end
				if shape == "inner_left" then
					blockType.PrimaryPart.Shape1.Transparency = 0
					for _, texture in ipairs(blockType.PrimaryPart.Shape1:GetChildren()) do
						texture.Transparency = 0
					end
					blockType.PrimaryPart.Shape2.Transparency = 0
					for _, texture in ipairs(blockType.PrimaryPart.Shape2:GetChildren()) do
						texture.Transparency = 0
					end
					blockType.PrimaryPart.Shape3.Transparency = 0
					for _, texture in ipairs(blockType.PrimaryPart.Shape3:GetChildren()) do
						texture.Transparency = 0
					end
					blockType.PrimaryPart.Shape4.Transparency = 1
					for _, texture in ipairs(blockType.PrimaryPart.Shape4:GetChildren()) do
						texture.Transparency = 1
					end
				end
			elseif half == "bottom" then
				if shape == "straight" then
					blockType.PrimaryPart.Shape1.Transparency = 1
					blockType.PrimaryPart.Shape2.Transparency = 0
					blockType.PrimaryPart.Shape3.Transparency = 0
					blockType.PrimaryPart.Shape4.Transparency = 1

					for _, texture in ipairs(blockType.PrimaryPart.Shape1:GetChildren()) do
						texture.Transparency = 1
					end
					for _, texture in ipairs(blockType.PrimaryPart.Shape2:GetChildren()) do
						texture.Transparency = 0
					end
					for _, texture in ipairs(blockType.PrimaryPart.Shape3:GetChildren()) do
						texture.Transparency = 0
					end
					for _, texture in ipairs(blockType.PrimaryPart.Shape4:GetChildren()) do
						texture.Transparency = 1
					end
				end
				if shape == "outer_right" then
					blockType.PrimaryPart.Shape1.Transparency = 1
					for _, texture in ipairs(blockType.PrimaryPart.Shape1:GetChildren()) do
						texture.Transparency = 1
					end

					blockType.PrimaryPart.Shape2.Transparency = 0
					for _, texture in ipairs(blockType.PrimaryPart.Shape2:GetChildren()) do
						texture.Transparency = 0
					end

					blockType.PrimaryPart.Shape3.Transparency = 1
					for _, texture in ipairs(blockType.PrimaryPart.Shape3:GetChildren()) do
						texture.Transparency = 1
					end

					blockType.PrimaryPart.Shape4.Transparency = 1
					for _, texture in ipairs(blockType.PrimaryPart.Shape4:GetChildren()) do
						texture.Transparency = 1
					end
				end
				if shape == "outer_left" then
					blockType.PrimaryPart.Shape1.Transparency = 1
					for _, texture in ipairs(blockType.PrimaryPart.Shape1:GetChildren()) do
						texture.Transparency = 1
					end
					blockType.PrimaryPart.Shape2.Transparency = 1
					for _, texture in ipairs(blockType.PrimaryPart.Shape2:GetChildren()) do
						texture.Transparency = 1
					end
					blockType.PrimaryPart.Shape3.Transparency = 0
					for _, texture in ipairs(blockType.PrimaryPart.Shape3:GetChildren()) do
						texture.Transparency = 0
					end
					blockType.PrimaryPart.Shape4.Transparency = 1
					for _, texture in ipairs(blockType.PrimaryPart.Shape4:GetChildren()) do
						texture.Transparency = 1
					end
				end
				if shape == "inner_right" then
					blockType.PrimaryPart.Shape1.Transparency = 0
					for _, texture in ipairs(blockType.PrimaryPart.Shape1:GetChildren()) do
						texture.Transparency = 0
					end

					blockType.PrimaryPart.Shape2.Transparency = 0
					for _, texture in ipairs(blockType.PrimaryPart.Shape2:GetChildren()) do
						texture.Transparency = 0
					end

					blockType.PrimaryPart.Shape3.Transparency = 0
					for _, texture in ipairs(blockType.PrimaryPart.Shape3:GetChildren()) do
						texture.Transparency = 0
					end

					blockType.PrimaryPart.Shape4.Transparency = 1
					for _, texture in ipairs(blockType.PrimaryPart.Shape4:GetChildren()) do
						texture.Transparency = 1
					end
				end
				if shape == "inner_left" then
					blockType.PrimaryPart.Shape1.Transparency = 1
					for _, texture in ipairs(blockType.PrimaryPart.Shape1:GetChildren()) do
						texture.Transparency = 1
					end
					blockType.PrimaryPart.Shape2.Transparency = 0
					for _, texture in ipairs(blockType.PrimaryPart.Shape2:GetChildren()) do
						texture.Transparency = 0
					end
					blockType.PrimaryPart.Shape3.Transparency = 0
					for _, texture in ipairs(blockType.PrimaryPart.Shape3:GetChildren()) do
						texture.Transparency = 0
					end
					blockType.PrimaryPart.Shape4.Transparency = 0
					for _, texture in ipairs(blockType.PrimaryPart.Shape4:GetChildren()) do
						texture.Transparency = 0
					end
				end
			end
		elseif facing == "east" then
			if half == "top" then
				blockType:SetPrimaryPartCFrame(CFrame.new(blockType.PrimaryPart.Position) * CFrame.Angles(0, 0, math.rad(180)))
				if shape == "straight" then
					blockType.PrimaryPart.Shape1.Transparency = 1
					blockType.PrimaryPart.Shape2.Transparency = 1
					blockType.PrimaryPart.Shape3.Transparency = 0
					blockType.PrimaryPart.Shape4.Transparency = 0

					for _, texture in ipairs(blockType.PrimaryPart.Shape1:GetChildren()) do
						texture.Transparency = 1
					end
					for _, texture in ipairs(blockType.PrimaryPart.Shape2:GetChildren()) do
						texture.Transparency = 1
					end
					for _, texture in ipairs(blockType.PrimaryPart.Shape3:GetChildren()) do
						texture.Transparency = 0
					end
					for _, texture in ipairs(blockType.PrimaryPart.Shape4:GetChildren()) do
						texture.Transparency = 0
					end
				end
				if shape == "outer_right" then
					blockType.PrimaryPart.Shape1.Transparency = 1
					for _, texture in ipairs(blockType.PrimaryPart.Shape1:GetChildren()) do
						texture.Transparency = 1
					end

					blockType.PrimaryPart.Shape2.Transparency = 0
					for _, texture in ipairs(blockType.PrimaryPart.Shape2:GetChildren()) do
						texture.Transparency = 0
					end

					blockType.PrimaryPart.Shape3.Transparency = 1
					for _, texture in ipairs(blockType.PrimaryPart.Shape3:GetChildren()) do
						texture.Transparency = 1
					end

					blockType.PrimaryPart.Shape4.Transparency = 1
					for _, texture in ipairs(blockType.PrimaryPart.Shape4:GetChildren()) do
						texture.Transparency = 1
					end
				end
				if shape == "outer_left" then
					blockType.PrimaryPart.Shape1.Transparency = 0
					for _, texture in ipairs(blockType.PrimaryPart.Shape1:GetChildren()) do
						texture.Transparency = 0
					end
					blockType.PrimaryPart.Shape2.Transparency = 1
					for _, texture in ipairs(blockType.PrimaryPart.Shape2:GetChildren()) do
						texture.Transparency = 1
					end
					blockType.PrimaryPart.Shape3.Transparency = 1
					for _, texture in ipairs(blockType.PrimaryPart.Shape3:GetChildren()) do
						texture.Transparency = 1
					end
					blockType.PrimaryPart.Shape4.Transparency = 1
					for _, texture in ipairs(blockType.PrimaryPart.Shape4:GetChildren()) do
						texture.Transparency = 1
					end
				end
				if shape == "inner_right" then
					blockType.PrimaryPart.Shape1.Transparency = 0
					for _, texture in ipairs(blockType.PrimaryPart.Shape1:GetChildren()) do
						texture.Transparency = 0
					end

					blockType.PrimaryPart.Shape2.Transparency = 1
					for _, texture in ipairs(blockType.PrimaryPart.Shape2:GetChildren()) do
						texture.Transparency = 1
					end

					blockType.PrimaryPart.Shape3.Transparency = 0
					for _, texture in ipairs(blockType.PrimaryPart.Shape3:GetChildren()) do
						texture.Transparency = 0
					end

					blockType.PrimaryPart.Shape4.Transparency = 0
					for _, texture in ipairs(blockType.PrimaryPart.Shape4:GetChildren()) do
						texture.Transparency = 0
					end
				end
				if shape == "inner_left" then
					blockType.PrimaryPart.Shape1.Transparency = 1
					for _, texture in ipairs(blockType.PrimaryPart.Shape1:GetChildren()) do
						texture.Transparency = 1
					end
					blockType.PrimaryPart.Shape2.Transparency = 0
					for _, texture in ipairs(blockType.PrimaryPart.Shape2:GetChildren()) do
						texture.Transparency = 0
					end
					blockType.PrimaryPart.Shape3.Transparency = 0
					for _, texture in ipairs(blockType.PrimaryPart.Shape3:GetChildren()) do
						texture.Transparency = 0
					end
					blockType.PrimaryPart.Shape4.Transparency = 0
					for _, texture in ipairs(blockType.PrimaryPart.Shape4:GetChildren()) do
						texture.Transparency = 0
					end
				end
			elseif half == "bottom" then
				if shape == "straight" then
					blockType.PrimaryPart.Shape3.Transparency = 1
					blockType.PrimaryPart.Shape4.Transparency = 1

					for _, texture in ipairs(blockType.PrimaryPart.Shape1:GetChildren()) do
						texture.Transparency = 0
					end
					for _, texture in ipairs(blockType.PrimaryPart.Shape2:GetChildren()) do
						texture.Transparency = 0
					end
					for _, texture in ipairs(blockType.PrimaryPart.Shape3:GetChildren()) do
						texture.Transparency = 1
					end
					for _, texture in ipairs(blockType.PrimaryPart.Shape4:GetChildren()) do
						texture.Transparency = 1
					end
				end
				if shape == "outer_right" then
					blockType.PrimaryPart.Shape1.Transparency = 0
					for _, texture in ipairs(blockType.PrimaryPart.Shape1:GetChildren()) do
						texture.Transparency = 0
					end

					blockType.PrimaryPart.Shape2.Transparency = 1
					for _, texture in ipairs(blockType.PrimaryPart.Shape2:GetChildren()) do
						texture.Transparency = 1
					end

					blockType.PrimaryPart.Shape3.Transparency = 1
					for _, texture in ipairs(blockType.PrimaryPart.Shape3:GetChildren()) do
						texture.Transparency = 1
					end

					blockType.PrimaryPart.Shape4.Transparency = 1
					for _, texture in ipairs(blockType.PrimaryPart.Shape4:GetChildren()) do
						texture.Transparency = 1
					end
				end
				if shape == "outer_left" then
					blockType.PrimaryPart.Shape1.Transparency = 1
					for _, texture in ipairs(blockType.PrimaryPart.Shape1:GetChildren()) do
						texture.Transparency = 1
					end
					blockType.PrimaryPart.Shape2.Transparency = 0
					for _, texture in ipairs(blockType.PrimaryPart.Shape2:GetChildren()) do
						texture.Transparency = 0
					end
					blockType.PrimaryPart.Shape3.Transparency = 1
					for _, texture in ipairs(blockType.PrimaryPart.Shape3:GetChildren()) do
						texture.Transparency = 1
					end
					blockType.PrimaryPart.Shape4.Transparency = 1
					for _, texture in ipairs(blockType.PrimaryPart.Shape4:GetChildren()) do
						texture.Transparency = 1
					end
				end
				if shape == "inner_right" then
					blockType.PrimaryPart.Shape1.Transparency = 0
					for _, texture in ipairs(blockType.PrimaryPart.Shape1:GetChildren()) do
						texture.Transparency = 0
					end

					blockType.PrimaryPart.Shape2.Transparency = 0
					for _, texture in ipairs(blockType.PrimaryPart.Shape2:GetChildren()) do
						texture.Transparency = 0
					end

					blockType.PrimaryPart.Shape3.Transparency = 1
					for _, texture in ipairs(blockType.PrimaryPart.Shape3:GetChildren()) do
						texture.Transparency = 1
					end

					blockType.PrimaryPart.Shape4.Transparency = 0
					for _, texture in ipairs(blockType.PrimaryPart.Shape4:GetChildren()) do
						texture.Transparency = 0
					end
				end
				if shape == "inner_left" then
					blockType.PrimaryPart.Shape1.Transparency = 0
					for _, texture in ipairs(blockType.PrimaryPart.Shape1:GetChildren()) do
						texture.Transparency = 0
					end
					blockType.PrimaryPart.Shape2.Transparency = 0
					for _, texture in ipairs(blockType.PrimaryPart.Shape2:GetChildren()) do
						texture.Transparency = 0
					end
					blockType.PrimaryPart.Shape3.Transparency = 0
					for _, texture in ipairs(blockType.PrimaryPart.Shape3:GetChildren()) do
						texture.Transparency = 0
					end
					blockType.PrimaryPart.Shape4.Transparency = 1
					for _, texture in ipairs(blockType.PrimaryPart.Shape4:GetChildren()) do
						texture.Transparency = 1
					end
				end
			end
		elseif facing == "south" then
			if half == "top" then
				blockType:SetPrimaryPartCFrame(CFrame.new(blockType.PrimaryPart.Position) * CFrame.Angles(0, 0, math.rad(180)))
				if shape == "straight" then
					blockType.PrimaryPart.Shape1.Transparency = 0
					blockType.PrimaryPart.Shape2.Transparency = 1
					blockType.PrimaryPart.Shape3.Transparency = 1
					blockType.PrimaryPart.Shape4.Transparency = 0

					for _, texture in ipairs(blockType.PrimaryPart.Shape1:GetChildren()) do
						texture.Transparency = 0
					end
					for _, texture in ipairs(blockType.PrimaryPart.Shape2:GetChildren()) do
						texture.Transparency = 1
					end
					for _, texture in ipairs(blockType.PrimaryPart.Shape3:GetChildren()) do
						texture.Transparency = 1
					end
					for _, texture in ipairs(blockType.PrimaryPart.Shape4:GetChildren()) do
						texture.Transparency = 0
					end
				end
				if shape == "outer_right" then
					blockType.PrimaryPart.Shape1.Transparency = 0
					for _, texture in ipairs(blockType.PrimaryPart.Shape1:GetChildren()) do
						texture.Transparency = 0
					end

					blockType.PrimaryPart.Shape2.Transparency = 1
					for _, texture in ipairs(blockType.PrimaryPart.Shape2:GetChildren()) do
						texture.Transparency = 1
					end

					blockType.PrimaryPart.Shape3.Transparency = 1
					for _, texture in ipairs(blockType.PrimaryPart.Shape3:GetChildren()) do
						texture.Transparency = 1
					end

					blockType.PrimaryPart.Shape4.Transparency = 1
					for _, texture in ipairs(blockType.PrimaryPart.Shape4:GetChildren()) do
						texture.Transparency = 1
					end
				end
				if shape == "outer_left" then
					blockType.PrimaryPart.Shape1.Transparency = 1
					for _, texture in ipairs(blockType.PrimaryPart.Shape1:GetChildren()) do
						texture.Transparency = 1
					end
					blockType.PrimaryPart.Shape2.Transparency = 1
					for _, texture in ipairs(blockType.PrimaryPart.Shape2:GetChildren()) do
						texture.Transparency = 1
					end
					blockType.PrimaryPart.Shape3.Transparency = 1
					for _, texture in ipairs(blockType.PrimaryPart.Shape3:GetChildren()) do
						texture.Transparency = 1
					end
					blockType.PrimaryPart.Shape4.Transparency = 0
					for _, texture in ipairs(blockType.PrimaryPart.Shape4:GetChildren()) do
						texture.Transparency = 0
					end
				end
				if shape == "inner_right" then
					blockType.PrimaryPart.Shape1.Transparency = 0
					for _, texture in ipairs(blockType.PrimaryPart.Shape1:GetChildren()) do
						texture.Transparency = 0
					end

					blockType.PrimaryPart.Shape2.Transparency = 0
					for _, texture in ipairs(blockType.PrimaryPart.Shape2:GetChildren()) do
						texture.Transparency = 0
					end

					blockType.PrimaryPart.Shape3.Transparency = 1
					for _, texture in ipairs(blockType.PrimaryPart.Shape3:GetChildren()) do
						texture.Transparency = 1
					end

					blockType.PrimaryPart.Shape4.Transparency = 0
					for _, texture in ipairs(blockType.PrimaryPart.Shape4:GetChildren()) do
						texture.Transparency = 0
					end
				end
				if shape == "inner_left" then
					blockType.PrimaryPart.Shape1.Transparency = 0
					for _, texture in ipairs(blockType.PrimaryPart.Shape1:GetChildren()) do
						texture.Transparency = 0
					end
					blockType.PrimaryPart.Shape2.Transparency = 1
					for _, texture in ipairs(blockType.PrimaryPart.Shape2:GetChildren()) do
						texture.Transparency = 1
					end
					blockType.PrimaryPart.Shape3.Transparency = 0
					for _, texture in ipairs(blockType.PrimaryPart.Shape3:GetChildren()) do
						texture.Transparency = 0
					end
					blockType.PrimaryPart.Shape4.Transparency = 0
					for _, texture in ipairs(blockType.PrimaryPart.Shape4:GetChildren()) do
						texture.Transparency = 0
					end
				end
			elseif half == "bottom" then
				if shape == "straight" then
					blockType.PrimaryPart.Shape1.Transparency = 0
					blockType.PrimaryPart.Shape2.Transparency = 1
					blockType.PrimaryPart.Shape3.Transparency = 1
					blockType.PrimaryPart.Shape4.Transparency = 0

					for _, texture in ipairs(blockType.PrimaryPart.Shape1:GetChildren()) do
						texture.Transparency = 0
					end
					for _, texture in ipairs(blockType.PrimaryPart.Shape2:GetChildren()) do
						texture.Transparency = 1
					end
					for _, texture in ipairs(blockType.PrimaryPart.Shape3:GetChildren()) do
						texture.Transparency = 1
					end
					for _, texture in ipairs(blockType.PrimaryPart.Shape4:GetChildren()) do
						texture.Transparency = 0
					end
				end
				if shape == "outer_right" then
					blockType.PrimaryPart.Shape1.Transparency = 1
					for _, texture in ipairs(blockType.PrimaryPart.Shape1:GetChildren()) do
						texture.Transparency = 1
					end

					blockType.PrimaryPart.Shape2.Transparency = 1
					for _, texture in ipairs(blockType.PrimaryPart.Shape2:GetChildren()) do
						texture.Transparency = 1
					end

					blockType.PrimaryPart.Shape3.Transparency = 1
					for _, texture in ipairs(blockType.PrimaryPart.Shape3:GetChildren()) do
						texture.Transparency = 1
					end

					blockType.PrimaryPart.Shape4.Transparency = 0
					for _, texture in ipairs(blockType.PrimaryPart.Shape4:GetChildren()) do
						texture.Transparency = 0
					end
				end
				if shape == "outer_left" then
					blockType.PrimaryPart.Shape1.Transparency = 0
					for _, texture in ipairs(blockType.PrimaryPart.Shape1:GetChildren()) do
						texture.Transparency = 0
					end
					blockType.PrimaryPart.Shape2.Transparency = 1
					for _, texture in ipairs(blockType.PrimaryPart.Shape2:GetChildren()) do
						texture.Transparency = 1
					end
					blockType.PrimaryPart.Shape3.Transparency = 1
					for _, texture in ipairs(blockType.PrimaryPart.Shape3:GetChildren()) do
						texture.Transparency = 1
					end
					blockType.PrimaryPart.Shape4.Transparency = 1
					for _, texture in ipairs(blockType.PrimaryPart.Shape4:GetChildren()) do
						texture.Transparency = 1
					end
				end
				if shape == "inner_right" then
					blockType.PrimaryPart.Shape1.Transparency = 0
					for _, texture in ipairs(blockType.PrimaryPart.Shape1:GetChildren()) do
						texture.Transparency = 0
					end

					blockType.PrimaryPart.Shape2.Transparency = 1
					for _, texture in ipairs(blockType.PrimaryPart.Shape2:GetChildren()) do
						texture.Transparency = 1
					end

					blockType.PrimaryPart.Shape3.Transparency = 0
					for _, texture in ipairs(blockType.PrimaryPart.Shape3:GetChildren()) do
						texture.Transparency = 0
					end

					blockType.PrimaryPart.Shape4.Transparency = 0
					for _, texture in ipairs(blockType.PrimaryPart.Shape4:GetChildren()) do
						texture.Transparency = 0
					end
				end
				if shape == "inner_left" then
					blockType.PrimaryPart.Shape1.Transparency = 0
					for _, texture in ipairs(blockType.PrimaryPart.Shape1:GetChildren()) do
						texture.Transparency = 0
					end
					blockType.PrimaryPart.Shape2.Transparency = 0
					for _, texture in ipairs(blockType.PrimaryPart.Shape2:GetChildren()) do
						texture.Transparency = 0
					end
					blockType.PrimaryPart.Shape3.Transparency = 0
					for _, texture in ipairs(blockType.PrimaryPart.Shape3:GetChildren()) do
						texture.Transparency = 0
					end
					blockType.PrimaryPart.Shape4.Transparency = 1
					for _, texture in ipairs(blockType.PrimaryPart.Shape4:GetChildren()) do
						texture.Transparency = 1
					end
				end
			end
		elseif facing == "west" then
			if half == "top" then
				blockType:SetPrimaryPartCFrame(CFrame.new(blockType.PrimaryPart.Position) * CFrame.Angles(0, 0, math.rad(180)))
				if shape == "straight" then
					blockType.PrimaryPart.Shape1.Transparency = 0
					blockType.PrimaryPart.Shape2.Transparency = 0
					blockType.PrimaryPart.Shape3.Transparency = 1
					blockType.PrimaryPart.Shape4.Transparency = 1

					for _, texture in ipairs(blockType.PrimaryPart.Shape1:GetChildren()) do
						texture.Transparency = 0
					end
					for _, texture in ipairs(blockType.PrimaryPart.Shape2:GetChildren()) do
						texture.Transparency = 0
					end
					for _, texture in ipairs(blockType.PrimaryPart.Shape3:GetChildren()) do
						texture.Transparency = 1
					end
					for _, texture in ipairs(blockType.PrimaryPart.Shape4:GetChildren()) do
						texture.Transparency = 1
					end
				end
				if shape == "outer_right" then
					blockType.PrimaryPart.Shape1.Transparency = 1
					for _, texture in ipairs(blockType.PrimaryPart.Shape1:GetChildren()) do
						texture.Transparency = 1
					end

					blockType.PrimaryPart.Shape2.Transparency = 0
					for _, texture in ipairs(blockType.PrimaryPart.Shape2:GetChildren()) do
						texture.Transparency = 0
					end

					blockType.PrimaryPart.Shape3.Transparency = 1
					for _, texture in ipairs(blockType.PrimaryPart.Shape3:GetChildren()) do
						texture.Transparency = 1
					end

					blockType.PrimaryPart.Shape4.Transparency = 1
					for _, texture in ipairs(blockType.PrimaryPart.Shape4:GetChildren()) do
						texture.Transparency = 1
					end
				end
				if shape == "outer_left" then
					blockType.PrimaryPart.Shape1.Transparency = 0
					for _, texture in ipairs(blockType.PrimaryPart.Shape1:GetChildren()) do
						texture.Transparency = 0
					end
					blockType.PrimaryPart.Shape2.Transparency = 1
					for _, texture in ipairs(blockType.PrimaryPart.Shape2:GetChildren()) do
						texture.Transparency = 1
					end
					blockType.PrimaryPart.Shape3.Transparency = 1
					for _, texture in ipairs(blockType.PrimaryPart.Shape3:GetChildren()) do
						texture.Transparency = 1
					end
					blockType.PrimaryPart.Shape4.Transparency = 1
					for _, texture in ipairs(blockType.PrimaryPart.Shape4:GetChildren()) do
						texture.Transparency = 1
					end
				end
				if shape == "inner_right" then
					blockType.PrimaryPart.Shape1.Transparency = 0
					for _, texture in ipairs(blockType.PrimaryPart.Shape1:GetChildren()) do
						texture.Transparency = 0
					end

					blockType.PrimaryPart.Shape2.Transparency = 0
					for _, texture in ipairs(blockType.PrimaryPart.Shape2:GetChildren()) do
						texture.Transparency = 0
					end

					blockType.PrimaryPart.Shape3.Transparency = 0
					for _, texture in ipairs(blockType.PrimaryPart.Shape3:GetChildren()) do
						texture.Transparency = 0
					end

					blockType.PrimaryPart.Shape4.Transparency = 1
					for _, texture in ipairs(blockType.PrimaryPart.Shape4:GetChildren()) do
						texture.Transparency = 1
					end
				end
				if shape == "inner_left" then
					blockType.PrimaryPart.Shape1.Transparency = 0
					for _, texture in ipairs(blockType.PrimaryPart.Shape1:GetChildren()) do
						texture.Transparency = 0
					end
					blockType.PrimaryPart.Shape2.Transparency = 0
					for _, texture in ipairs(blockType.PrimaryPart.Shape2:GetChildren()) do
						texture.Transparency = 0
					end
					blockType.PrimaryPart.Shape3.Transparency = 1
					for _, texture in ipairs(blockType.PrimaryPart.Shape3:GetChildren()) do
						texture.Transparency = 1
					end
					blockType.PrimaryPart.Shape4.Transparency = 0
					for _, texture in ipairs(blockType.PrimaryPart.Shape4:GetChildren()) do
						texture.Transparency = 0
					end
				end
			elseif half == "bottom" then
				if shape == "straight" then
					blockType.PrimaryPart.Shape1.Transparency = 1
					blockType.PrimaryPart.Shape2.Transparency = 1
					blockType.PrimaryPart.Shape3.Transparency = 0
					blockType.PrimaryPart.Shape4.Transparency = 0

					for _, texture in ipairs(blockType.PrimaryPart.Shape1:GetChildren()) do
						texture.Transparency = 1
					end
					for _, texture in ipairs(blockType.PrimaryPart.Shape2:GetChildren()) do
						texture.Transparency = 1
					end
					for _, texture in ipairs(blockType.PrimaryPart.Shape3:GetChildren()) do
						texture.Transparency = 0
					end
					for _, texture in ipairs(blockType.PrimaryPart.Shape4:GetChildren()) do
						texture.Transparency = 0
					end
				end
				if shape == "outer_right" then
					blockType.PrimaryPart.Shape1.Transparency = 1
					for _, texture in ipairs(blockType.PrimaryPart.Shape1:GetChildren()) do
						texture.Transparency = 1
					end

					blockType.PrimaryPart.Shape2.Transparency = 1
					for _, texture in ipairs(blockType.PrimaryPart.Shape2:GetChildren()) do
						texture.Transparency = 1
					end

					blockType.PrimaryPart.Shape3.Transparency = 0
					for _, texture in ipairs(blockType.PrimaryPart.Shape3:GetChildren()) do
						texture.Transparency = 0
					end

					blockType.PrimaryPart.Shape4.Transparency = 1
					for _, texture in ipairs(blockType.PrimaryPart.Shape4:GetChildren()) do
						texture.Transparency = 1
					end
				end
				if shape == "outer_left" then
					blockType.PrimaryPart.Shape1.Transparency = 1
					for _, texture in ipairs(blockType.PrimaryPart.Shape1:GetChildren()) do
						texture.Transparency = 1
					end
					blockType.PrimaryPart.Shape2.Transparency = 1
					for _, texture in ipairs(blockType.PrimaryPart.Shape2:GetChildren()) do
						texture.Transparency = 1
					end
					blockType.PrimaryPart.Shape3.Transparency = 1
					for _, texture in ipairs(blockType.PrimaryPart.Shape3:GetChildren()) do
						texture.Transparency = 1
					end
					blockType.PrimaryPart.Shape4.Transparency = 0
					for _, texture in ipairs(blockType.PrimaryPart.Shape4:GetChildren()) do
						texture.Transparency = 0
					end
				end
				if shape == "inner_right" then
					blockType.PrimaryPart.Shape1.Transparency = 1
					for _, texture in ipairs(blockType.PrimaryPart.Shape1:GetChildren()) do
						texture.Transparency = 1
					end

					blockType.PrimaryPart.Shape2.Transparency = 0
					for _, texture in ipairs(blockType.PrimaryPart.Shape2:GetChildren()) do
						texture.Transparency = 0
					end

					blockType.PrimaryPart.Shape3.Transparency = 0
					for _, texture in ipairs(blockType.PrimaryPart.Shape3:GetChildren()) do
						texture.Transparency = 0
					end

					blockType.PrimaryPart.Shape4.Transparency = 0
					for _, texture in ipairs(blockType.PrimaryPart.Shape4:GetChildren()) do
						texture.Transparency = 0
					end
				end
				if shape == "inner_left" then
					blockType.PrimaryPart.Shape1.Transparency = 0
					for _, texture in ipairs(blockType.PrimaryPart.Shape1:GetChildren()) do
						texture.Transparency = 0
					end
					blockType.PrimaryPart.Shape2.Transparency = 1
					for _, texture in ipairs(blockType.PrimaryPart.Shape2:GetChildren()) do
						texture.Transparency = 1
					end
					blockType.PrimaryPart.Shape3.Transparency = 0
					for _, texture in ipairs(blockType.PrimaryPart.Shape3:GetChildren()) do
						texture.Transparency = 0
					end
					blockType.PrimaryPart.Shape4.Transparency = 0
					for _, texture in ipairs(blockType.PrimaryPart.Shape4:GetChildren()) do
						texture.Transparency = 0
					end
				end
			end
		end
	end

	if string.match(material, "_FENCE$") then
		local north = state:match("north=([^,%]]+)")
		local south = state:match("south=([^,%]]+)")
		local east = state:match("east=([^,%]]+)")
		local west = state:match("west=([^,%]]+)")
		if west == "true" then
			blockType.PrimaryPart.north.North1.Transparency = 0
			blockType.PrimaryPart.north.North2.Transparency = 0
			blockType.PrimaryPart.north.North1.CanCollide = true
			blockType.PrimaryPart.north.North2.CanCollide = true
			for _, texture in ipairs(blockType.PrimaryPart.north.North1:GetChildren()) do
				texture.Transparency = 0
			end
			for _, texture in ipairs(blockType.PrimaryPart.north.North2:GetChildren()) do
				texture.Transparency = 0
			end
		elseif west == "false" then
			blockType.PrimaryPart.north.North1.Transparency = 1
			blockType.PrimaryPart.north.North2.Transparency = 1
			blockType.PrimaryPart.north.North1.CanCollide = false
			blockType.PrimaryPart.north.North2.CanCollide = false
			for _, texture in ipairs(blockType.PrimaryPart.north.North1:GetChildren()) do
				texture.Transparency = 1
			end
			for _, texture in ipairs(blockType.PrimaryPart.north.North2:GetChildren()) do
				texture.Transparency = 1
			end
		end
		if north == "true" then
			blockType.PrimaryPart.east.East1.Transparency = 0
			blockType.PrimaryPart.east.East2.Transparency = 0
			blockType.PrimaryPart.east.East1.CanCollide = true
			blockType.PrimaryPart.east.East2.CanCollide = true
			for _, texture in ipairs(blockType.PrimaryPart.east.East1:GetChildren()) do
				texture.Transparency = 0
			end
			for _, texture in ipairs(blockType.PrimaryPart.east.East2:GetChildren()) do
				texture.Transparency = 0
			end
		elseif north == "false" then
			blockType.PrimaryPart.east.East1.Transparency = 1
			blockType.PrimaryPart.east.East2.Transparency = 1
			blockType.PrimaryPart.east.East1.CanCollide = false
			blockType.PrimaryPart.east.East2.CanCollide = false
			for _, texture in ipairs(blockType.PrimaryPart.east.East1:GetChildren()) do
				texture.Transparency = 1
			end
			for _, texture in ipairs(blockType.PrimaryPart.east.East2:GetChildren()) do
				texture.Transparency = 1
			end
		end
		if east == "true" then
			blockType.PrimaryPart.south.South1.Transparency = 0
			blockType.PrimaryPart.south.South2.Transparency = 0
			blockType.PrimaryPart.south.South1.CanCollide = true
			blockType.PrimaryPart.south.South2.CanCollide = true
			for _, texture in ipairs(blockType.PrimaryPart.south.South1:GetChildren()) do
				texture.Transparency = 0
			end
			for _, texture in ipairs(blockType.PrimaryPart.south.South2:GetChildren()) do
				texture.Transparency = 0
			end
		elseif east == "false" then
			blockType.PrimaryPart.south.South1.Transparency = 1
			blockType.PrimaryPart.south.South2.Transparency = 1
			blockType.PrimaryPart.south.South1.CanCollide = false
			blockType.PrimaryPart.south.South2.CanCollide = false
			for _, texture in ipairs(blockType.PrimaryPart.south.South1:GetChildren()) do
				texture.Transparency = 1
			end
			for _, texture in ipairs(blockType.PrimaryPart.south.South2:GetChildren()) do
				texture.Transparency = 1
			end
		end
		if south == "true" then
			blockType.PrimaryPart.west.West1.Transparency = 0
			blockType.PrimaryPart.west.West2.Transparency = 0
			blockType.PrimaryPart.west.West1.CanCollide = true
			blockType.PrimaryPart.west.West2.CanCollide = true
			for _, texture in ipairs(blockType.PrimaryPart.west.West1:GetChildren()) do
				texture.Transparency = 0
			end
			for _, texture in ipairs(blockType.PrimaryPart.west.West2:GetChildren()) do
				texture.Transparency = 0
			end
		elseif south == "false" then
			blockType.PrimaryPart.west.West1.Transparency = 1
			blockType.PrimaryPart.west.West2.Transparency = 1
			blockType.PrimaryPart.west.West1.CanCollide = false
			blockType.PrimaryPart.west.West2.CanCollide = false
			for _, texture in ipairs(blockType.PrimaryPart.west.West1:GetChildren()) do
				texture.Transparency = 1
			end
			for _, texture in ipairs(blockType.PrimaryPart.west.West2:GetChildren()) do
				texture.Transparency = 1
			end
		end
	end

	if material == "IRON_BARS" then
		local north = state:match("north=([^,%]]+)")
		local south = state:match("south=([^,%]]+)")
		local east = state:match("east=([^,%]]+)")
		local west = state:match("west=([^,%]]+)")
		if west == "true" then
			blockType.PrimaryPart.Bar1.CanCollide = true
			for _, texture in ipairs(blockType.PrimaryPart.Bar1:GetChildren()) do
				texture.Transparency = 0
			end
		elseif west == "false" then
			blockType.PrimaryPart.Bar1.CanCollide = false
			for _, texture in ipairs(blockType.PrimaryPart.Bar1:GetChildren()) do
				texture.Transparency = 1
			end
		end

		if north == "true" then
			blockType.PrimaryPart.Bar4.CanCollide = true
			for _, texture in ipairs(blockType.PrimaryPart.Bar4:GetChildren()) do
				texture.Transparency = 0
			end
		elseif north == "false" then
			blockType.PrimaryPart.Bar4.CanCollide = false
			for _, texture in ipairs(blockType.PrimaryPart.Bar4:GetChildren()) do
				texture.Transparency = 1
			end
		end

		if east == "true" then
			blockType.PrimaryPart.Bar2.CanCollide = true
			for _, texture in ipairs(blockType.PrimaryPart.Bar2:GetChildren()) do
				texture.Transparency = 0
			end
		elseif east == "false" then
			for _, texture in ipairs(blockType.PrimaryPart.Bar2:GetChildren()) do
				blockType.PrimaryPart.Bar2.CanCollide = false
				texture.Transparency = 1
			end
		end

		if south == "true" then
			blockType.PrimaryPart.Bar3.CanCollide = true
			for _, texture in ipairs(blockType.PrimaryPart.Bar3:GetChildren()) do
				texture.Transparency = 0
			end
		elseif south == "false" then
			blockType.PrimaryPart.Bar3.CanCollide = false
			for _, texture in ipairs(blockType.PrimaryPart.Bar3:GetChildren()) do
				texture.Transparency = 1
			end
		end
	end

	if material == "RAIL" then
		local shape = state:match("shape=([^,%]]+)")
		if shape == "north_south" then
			blockType:SetPrimaryPartCFrame(CFrame.new(blockType.PrimaryPart.Position) * CFrame.Angles(0, 0, 0))
		elseif shape == "east_west" then
			blockType:SetPrimaryPartCFrame(CFrame.new(blockType.PrimaryPart.Position) * CFrame.Angles(0, math.rad(90), 0))
		elseif shape == "south_east" then
			blockType:SetPrimaryPartCFrame(CFrame.new(blockType.PrimaryPart.Position) * CFrame.Angles(0, math.rad(180), 0))
			for _, texture in ipairs(blockType.PrimaryPart.Rail:GetChildren()) do
				if texture.Name == "Straight" then
					texture.Transparency = 1
				end
			end
			for _, texture in ipairs(blockType.PrimaryPart.Rail:GetChildren()) do
				if texture.Name == "Turn" then
					texture.Transparency = 0
				end
			end
		elseif shape == "south_west" then
			blockType:SetPrimaryPartCFrame(CFrame.new(blockType.PrimaryPart.Position) * CFrame.Angles(0, math.rad(90), 0))
			for _, texture in ipairs(blockType.PrimaryPart.Rail:GetChildren()) do
				if texture.Name == "Straight" then
					texture.Transparency = 1
				end
			end
			for _, texture in ipairs(blockType.PrimaryPart.Rail:GetChildren()) do
				if texture.Name == "Turn" then
					texture.Transparency = 0
				end
			end
		elseif shape == "north_east" then
			blockType:SetPrimaryPartCFrame(CFrame.new(blockType.PrimaryPart.Position) * CFrame.Angles(0, math.rad(270), 0))
			for _, texture in ipairs(blockType.PrimaryPart.Rail:GetChildren()) do
				if texture.Name == "Straight" then
					texture.Transparency = 1
				end
			end
			for _, texture in ipairs(blockType.PrimaryPart.Rail:GetChildren()) do
				if texture.Name == "Turn" then
					texture.Transparency = 0
				end
			end
		elseif shape == "north_west" then
			blockType:SetPrimaryPartCFrame(CFrame.new(blockType.PrimaryPart.Position) * CFrame.Angles(0, 0, 0))
			for _, texture in ipairs(blockType.PrimaryPart.Rail:GetChildren()) do
				if texture.Name == "Straight" then
					texture.Transparency = 1
				end
				if texture.Name == "Turn" then
					texture.Transparency = 0
				end
			end

		elseif shape == "ascending_north" then
			blockType.PrimaryPart.Rail.CanCollide = false -- migth not need but just to make sure. :P
			blockType.PrimaryPart.Slainted.CanCollide = true -- so roblox people float on the part

			for _, texture in ipairs(blockType.PrimaryPart.Rail:GetChildren()) do
				if texture.Name == "Straight" then
					texture.Transparency = 1
				end
			end

			for _, texture in ipairs(blockType.PrimaryPart.Slainted:GetChildren()) do
				if texture.Name == "Straight" then
					texture.Transparency = 0
				end
			end
		elseif shape == "ascending_south" then
			blockType:SetPrimaryPartCFrame(CFrame.new(blockType.PrimaryPart.Position) * CFrame.Angles(0, math.rad(180), 0))
			blockType.PrimaryPart.Rail.CanCollide = false -- migth not need but just to make sure. :P
			blockType.PrimaryPart.Slainted.CanCollide = true -- so roblox people float on the part

			for _, texture in ipairs(blockType.PrimaryPart.Rail:GetChildren()) do
				if texture.Name == "Straight" then
					texture.Transparency = 1
				end
			end

			for _, texture in ipairs(blockType.PrimaryPart.Slainted:GetChildren()) do
				if texture.Name == "Straight" then
					texture.Transparency = 0
				end
			end
		elseif shape == "ascending_west" then
			blockType:SetPrimaryPartCFrame(CFrame.new(blockType.PrimaryPart.Position) * CFrame.Angles(0, math.rad(90), 0))
			blockType.PrimaryPart.Rail.CanCollide = false -- migth not need but just to make sure. :P
			blockType.PrimaryPart.Slainted.CanCollide = true -- so roblox people float on the part

			for _, texture in ipairs(blockType.PrimaryPart.Rail:GetChildren()) do
				if texture.Name == "Straight" then
					texture.Transparency = 1
				end
			end

			for _, texture in ipairs(blockType.PrimaryPart.Slainted:GetChildren()) do
				if texture.Name == "Straight" then
					texture.Transparency = 0
				end
			end
		elseif shape == "ascending_east" then
			blockType:SetPrimaryPartCFrame(CFrame.new(blockType.PrimaryPart.Position) * CFrame.Angles(0, math.rad(-90), 0))
			blockType.PrimaryPart.Rail.CanCollide = false
			blockType.PrimaryPart.Slainted.CanCollide = true

			for _, texture in ipairs(blockType.PrimaryPart.Rail:GetChildren()) do
				if texture.Name == "Straight" then
					texture.Transparency = 1
				end
			end

			for _, texture in ipairs(blockType.PrimaryPart.Slainted:GetChildren()) do
				if texture.Name == "Straight" then
					texture.Transparency = 0
				end
			end
		end
	end

	if material == "LEVER" then
		local facing = state:match("facing=([^,%]]+)")
		local face = state:match("face=([^,%]]+)")
		local powered = state:match("powered=([^,%]]+)")

		if facing == "south" then
			if face == "floor" then
				blockType:SetPrimaryPartCFrame(CFrame.new(blockType.PrimaryPart.Position) * CFrame.Angles(0, 0, 0))
				if powered == "true" then
					blockType.PrimaryPart.Switch1.Transparency = 1
					blockType.PrimaryPart.Switch2.Transparency = 0

					for _, texture in ipairs(blockType.PrimaryPart.Switch1:GetChildren()) do
						texture.Transparency = 1
					end
					for _, texture in ipairs(blockType.PrimaryPart.Switch2:GetChildren()) do
						texture.Transparency = 0
					end
				else
					blockType.PrimaryPart.Switch1.Transparency = 0
					blockType.PrimaryPart.Switch2.Transparency = 1

					for _, texture in ipairs(blockType.PrimaryPart.Switch1:GetChildren()) do
						texture.Transparency = 0
					end
					for _, texture in ipairs(blockType.PrimaryPart.Switch2:GetChildren()) do
						texture.Transparency = 1
					end
				end
			elseif face == "wall" then
				blockType:SetPrimaryPartCFrame(CFrame.new(blockType.PrimaryPart.Position) * CFrame.Angles(math.rad(90), 0, 0))
				if powered == "true" then
					blockType.PrimaryPart.Switch1.Transparency = 1
					blockType.PrimaryPart.Switch2.Transparency = 0

					for _, texture in ipairs(blockType.PrimaryPart.Switch1:GetChildren()) do
						texture.Transparency = 1
					end
					for _, texture in ipairs(blockType.PrimaryPart.Switch2:GetChildren()) do
						texture.Transparency = 0
					end
				else
					blockType.PrimaryPart.Switch1.Transparency = 0
					blockType.PrimaryPart.Switch2.Transparency = 1

					for _, texture in ipairs(blockType.PrimaryPart.Switch1:GetChildren()) do
						texture.Transparency = 0
					end
					for _, texture in ipairs(blockType.PrimaryPart.Switch2:GetChildren()) do
						texture.Transparency = 1
					end
				end
			elseif face == "ceiling" then
				blockType:SetPrimaryPartCFrame(CFrame.new(blockType.PrimaryPart.Position) * CFrame.Angles(math.rad(180), math.rad(180), 0))
				if powered == "true" then
					blockType.PrimaryPart.Switch1.Transparency = 1
					blockType.PrimaryPart.Switch2.Transparency = 0

					for _, texture in ipairs(blockType.PrimaryPart.Switch1:GetChildren()) do
						texture.Transparency = 1
					end
					for _, texture in ipairs(blockType.PrimaryPart.Switch2:GetChildren()) do
						texture.Transparency = 0
					end
				else
					blockType.PrimaryPart.Switch1.Transparency = 0
					blockType.PrimaryPart.Switch2.Transparency = 1

					for _, texture in ipairs(blockType.PrimaryPart.Switch1:GetChildren()) do
						texture.Transparency = 0
					end
					for _, texture in ipairs(blockType.PrimaryPart.Switch2:GetChildren()) do
						texture.Transparency = 1
					end
				end
			end

		elseif facing == "north" then
			if face == "floor" then
				blockType:SetPrimaryPartCFrame(CFrame.new(blockType.PrimaryPart.Position) * CFrame.Angles(0, math.rad(180), 0))
				if powered == "true" then
					blockType.PrimaryPart.Switch1.Transparency = 1
					blockType.PrimaryPart.Switch2.Transparency = 0

					for _, texture in ipairs(blockType.PrimaryPart.Switch1:GetChildren()) do
						texture.Transparency = 1
					end
					for _, texture in ipairs(blockType.PrimaryPart.Switch2:GetChildren()) do
						texture.Transparency = 0
					end
				else
					blockType.PrimaryPart.Switch1.Transparency = 0
					blockType.PrimaryPart.Switch2.Transparency = 1

					for _, texture in ipairs(blockType.PrimaryPart.Switch1:GetChildren()) do
						texture.Transparency = 0
					end
					for _, texture in ipairs(blockType.PrimaryPart.Switch2:GetChildren()) do
						texture.Transparency = 1
					end
				end
			elseif face == "wall" then
				blockType:SetPrimaryPartCFrame(CFrame.new(blockType.PrimaryPart.Position) * CFrame.Angles(math.rad(-90), math.rad(-180), 0))
				if powered == "true" then
					blockType.PrimaryPart.Switch1.Transparency = 1
					blockType.PrimaryPart.Switch2.Transparency = 0

					for _, texture in ipairs(blockType.PrimaryPart.Switch1:GetChildren()) do
						texture.Transparency = 1
					end
					for _, texture in ipairs(blockType.PrimaryPart.Switch2:GetChildren()) do
						texture.Transparency = 0
					end
				else
					blockType.PrimaryPart.Switch1.Transparency = 0
					blockType.PrimaryPart.Switch2.Transparency = 1

					for _, texture in ipairs(blockType.PrimaryPart.Switch1:GetChildren()) do
						texture.Transparency = 0
					end
					for _, texture in ipairs(blockType.PrimaryPart.Switch2:GetChildren()) do
						texture.Transparency = 1
					end
				end
			elseif face == "ceiling" then
				blockType:SetPrimaryPartCFrame(CFrame.new(blockType.PrimaryPart.Position) * CFrame.Angles(math.rad(180), 0, 0))
				if powered == "true" then
					blockType.PrimaryPart.Switch1.Transparency = 1
					blockType.PrimaryPart.Switch2.Transparency = 0

					for _, texture in ipairs(blockType.PrimaryPart.Switch1:GetChildren()) do
						texture.Transparency = 1
					end
					for _, texture in ipairs(blockType.PrimaryPart.Switch2:GetChildren()) do
						texture.Transparency = 0
					end
				else
					blockType.PrimaryPart.Switch1.Transparency = 0
					blockType.PrimaryPart.Switch2.Transparency = 1

					for _, texture in ipairs(blockType.PrimaryPart.Switch1:GetChildren()) do
						texture.Transparency = 0
					end
					for _, texture in ipairs(blockType.PrimaryPart.Switch2:GetChildren()) do
						texture.Transparency = 1
					end
				end
			end
		elseif facing == "east" then
			if face == "floor" then
				blockType:SetPrimaryPartCFrame(CFrame.new(blockType.PrimaryPart.Position) * CFrame.Angles(0, math.rad(90), 0))
				if powered == "true" then
					blockType.PrimaryPart.Switch1.Transparency = 1
					blockType.PrimaryPart.Switch2.Transparency = 0

					for _, texture in ipairs(blockType.PrimaryPart.Switch1:GetChildren()) do
						texture.Transparency = 1
					end
					for _, texture in ipairs(blockType.PrimaryPart.Switch2:GetChildren()) do
						texture.Transparency = 0
					end
				else
					blockType.PrimaryPart.Switch1.Transparency = 0
					blockType.PrimaryPart.Switch2.Transparency = 1

					for _, texture in ipairs(blockType.PrimaryPart.Switch1:GetChildren()) do
						texture.Transparency = 0
					end
					for _, texture in ipairs(blockType.PrimaryPart.Switch2:GetChildren()) do
						texture.Transparency = 1
					end
				end
			elseif face == "wall" then
				blockType:SetPrimaryPartCFrame(CFrame.new(blockType.PrimaryPart.Position) * CFrame.Angles(math.rad(-90), math.rad(-180), math.rad(90)))
				if powered == "true" then
					blockType.PrimaryPart.Switch1.Transparency = 1
					blockType.PrimaryPart.Switch2.Transparency = 0

					for _, texture in ipairs(blockType.PrimaryPart.Switch1:GetChildren()) do
						texture.Transparency = 1
					end
					for _, texture in ipairs(blockType.PrimaryPart.Switch2:GetChildren()) do
						texture.Transparency = 0
					end
				else
					blockType.PrimaryPart.Switch1.Transparency = 0
					blockType.PrimaryPart.Switch2.Transparency = 1

					for _, texture in ipairs(blockType.PrimaryPart.Switch1:GetChildren()) do
						texture.Transparency = 0
					end
					for _, texture in ipairs(blockType.PrimaryPart.Switch2:GetChildren()) do
						texture.Transparency = 1
					end
				end
			elseif face == "ceiling" then
				blockType:SetPrimaryPartCFrame(CFrame.new(blockType.PrimaryPart.Position) * CFrame.Angles(math.rad(180), math.rad(90), 0))
				if powered == "true" then
					blockType.PrimaryPart.Switch1.Transparency = 1
					blockType.PrimaryPart.Switch2.Transparency = 0

					for _, texture in ipairs(blockType.PrimaryPart.Switch1:GetChildren()) do
						texture.Transparency = 1
					end
					for _, texture in ipairs(blockType.PrimaryPart.Switch2:GetChildren()) do
						texture.Transparency = 0
					end
				else
					blockType.PrimaryPart.Switch1.Transparency = 0
					blockType.PrimaryPart.Switch2.Transparency = 1

					for _, texture in ipairs(blockType.PrimaryPart.Switch1:GetChildren()) do
						texture.Transparency = 0
					end
					for _, texture in ipairs(blockType.PrimaryPart.Switch2:GetChildren()) do
						texture.Transparency = 1
					end
				end
			end

		elseif facing == "west" then
			if face == "floor" then
				blockType:SetPrimaryPartCFrame(CFrame.new(blockType.PrimaryPart.Position) * CFrame.Angles(0, math.rad(-90), 0))
				if powered == "true" then
					blockType.PrimaryPart.Switch1.Transparency = 1
					blockType.PrimaryPart.Switch2.Transparency = 0

					for _, texture in ipairs(blockType.PrimaryPart.Switch1:GetChildren()) do
						texture.Transparency = 1
					end
					for _, texture in ipairs(blockType.PrimaryPart.Switch2:GetChildren()) do
						texture.Transparency = 0
					end
				else
					blockType.PrimaryPart.Switch1.Transparency = 0
					blockType.PrimaryPart.Switch2.Transparency = 1

					for _, texture in ipairs(blockType.PrimaryPart.Switch1:GetChildren()) do
						texture.Transparency = 0
					end
					for _, texture in ipairs(blockType.PrimaryPart.Switch2:GetChildren()) do
						texture.Transparency = 1
					end
				end
			elseif face == "wall" then
				blockType:SetPrimaryPartCFrame(CFrame.new(blockType.PrimaryPart.Position) * CFrame.Angles(math.rad(-90), math.rad(-180), math.rad(-90)))
				if powered == "true" then
					blockType.PrimaryPart.Switch1.Transparency = 1
					blockType.PrimaryPart.Switch2.Transparency = 0

					for _, texture in ipairs(blockType.PrimaryPart.Switch1:GetChildren()) do
						texture.Transparency = 1
					end
					for _, texture in ipairs(blockType.PrimaryPart.Switch2:GetChildren()) do
						texture.Transparency = 0
					end
				else
					blockType.PrimaryPart.Switch1.Transparency = 0
					blockType.PrimaryPart.Switch2.Transparency = 1

					for _, texture in ipairs(blockType.PrimaryPart.Switch1:GetChildren()) do
						texture.Transparency = 0
					end
					for _, texture in ipairs(blockType.PrimaryPart.Switch2:GetChildren()) do
						texture.Transparency = 1
					end
				end
			elseif face == "ceiling" then
				blockType:SetPrimaryPartCFrame(CFrame.new(blockType.PrimaryPart.Position) * CFrame.Angles(math.rad(180), math.rad(-90), 0))
				if powered == "true" then
					blockType.PrimaryPart.Switch1.Transparency = 1
					blockType.PrimaryPart.Switch2.Transparency = 0

					for _, texture in ipairs(blockType.PrimaryPart.Switch1:GetChildren()) do
						texture.Transparency = 1
					end
					for _, texture in ipairs(blockType.PrimaryPart.Switch2:GetChildren()) do
						texture.Transparency = 0
					end
				else
					blockType.PrimaryPart.Switch1.Transparency = 0
					blockType.PrimaryPart.Switch2.Transparency = 1

					for _, texture in ipairs(blockType.PrimaryPart.Switch1:GetChildren()) do
						texture.Transparency = 0
					end
					for _, texture in ipairs(blockType.PrimaryPart.Switch2:GetChildren()) do
						texture.Transparency = 1
					end
				end
			end
		end
	end

	if string.match(material, "_BUTTON$") then
		local face = state:match("face=([^,%]]+)")
		local facing = state:match("facing=([^,%]]+)")
		local powered = state:match("powered=([^,%]]+)")

		if facing == "south" then
			if face == "floor" then
				blockType:SetPrimaryPartCFrame(CFrame.new(blockType.PrimaryPart.Position) * CFrame.Angles(0, math.rad(-180), 0))
			elseif face == "wall" then
				blockType:SetPrimaryPartCFrame(CFrame.new(blockType.PrimaryPart.Position) * CFrame.Angles(math.rad(90), 0, 0))
			elseif face == "ceiling" then
				blockType:SetPrimaryPartCFrame(CFrame.new(blockType.PrimaryPart.Position) * CFrame.Angles(0, 0, math.rad(180)))
			end

			if powered == "true" then
				blockType.PrimaryPart.PoweredOff.CanCollide = false
				blockType.PrimaryPart.PoweredOff.Transparency = 1
				for _, texture in ipairs(blockType.PrimaryPart.PoweredOff:GetChildren()) do
					texture.Transparency = 1
				end
				blockType.PrimaryPart.PoweredOn.CanCollide = true
				blockType.PrimaryPart.PoweredOn.Transparency = 0
				for _, texture in ipairs(blockType.PrimaryPart.PoweredOn:GetChildren()) do
					texture.Transparency = 0
				end
			else
				blockType.PrimaryPart.PoweredOff.CanCollide = true
				blockType.PrimaryPart.PoweredOff.Transparency = 0
				for _, texture in ipairs(blockType.PrimaryPart.PoweredOff:GetChildren()) do
					texture.Transparency = 0
				end
				blockType.PrimaryPart.PoweredOn.CanCollide = false
				blockType.PrimaryPart.PoweredOn.Transparency = 1
				for _, texture in ipairs(blockType.PrimaryPart.PoweredOn:GetChildren()) do
					texture.Transparency = 1
				end
			end
		elseif facing == "west" then
			if face == "floor" then
				blockType:SetPrimaryPartCFrame(CFrame.new(blockType.PrimaryPart.Position) * CFrame.Angles(0, math.rad(90), 0))
			elseif face == "wall" then
				blockType:SetPrimaryPartCFrame(CFrame.new(blockType.PrimaryPart.Position) * CFrame.Angles(math.rad(90), 0, math.rad(90)))
			elseif face == "ceiling" then
				blockType:SetPrimaryPartCFrame(CFrame.new(blockType.PrimaryPart.Position) * CFrame.Angles(0, math.rad(90), math.rad(180)))
			end

			if powered == "true" then
				blockType.PrimaryPart.PoweredOff.CanCollide = false
				blockType.PrimaryPart.PoweredOff.Transparency = 1
				for _, texture in ipairs(blockType.PrimaryPart.PoweredOff:GetChildren()) do
					texture.Transparency = 1
				end
				blockType.PrimaryPart.PoweredOn.CanCollide = true
				blockType.PrimaryPart.PoweredOn.Transparency = 0
				for _, texture in ipairs(blockType.PrimaryPart.PoweredOn:GetChildren()) do
					texture.Transparency = 0
				end
			else
				blockType.PrimaryPart.PoweredOff.CanCollide = true
				blockType.PrimaryPart.PoweredOff.Transparency = 0
				for _, texture in ipairs(blockType.PrimaryPart.PoweredOff:GetChildren()) do
					texture.Transparency = 0
				end
				blockType.PrimaryPart.PoweredOn.CanCollide = false
				blockType.PrimaryPart.PoweredOn.Transparency = 1
				for _, texture in ipairs(blockType.PrimaryPart.PoweredOn:GetChildren()) do
					texture.Transparency = 1
				end
			end
		elseif facing == "north" then
			if face == "floor" then
				blockType:SetPrimaryPartCFrame(CFrame.new(blockType.PrimaryPart.Position) * CFrame.Angles(0, math.rad(-180), 0))
			elseif face == "wall" then
				blockType:SetPrimaryPartCFrame(CFrame.new(blockType.PrimaryPart.Position) * CFrame.Angles(math.rad(-90), math.rad(-180), 0))
			elseif face == "ceiling" then
				blockType:SetPrimaryPartCFrame(CFrame.new(blockType.PrimaryPart.Position) * CFrame.Angles(0, math.rad(-180), math.rad(180)))
			end

			if powered == "true" then
				blockType.PrimaryPart.PoweredOff.CanCollide = false
				blockType.PrimaryPart.PoweredOff.Transparency = 1
				for _, texture in ipairs(blockType.PrimaryPart.PoweredOff:GetChildren()) do
					texture.Transparency = 1
				end
				blockType.PrimaryPart.PoweredOn.CanCollide = true
				blockType.PrimaryPart.PoweredOn.Transparency = 0
				for _, texture in ipairs(blockType.PrimaryPart.PoweredOn:GetChildren()) do
					texture.Transparency = 0
				end
			else
				blockType.PrimaryPart.PoweredOff.CanCollide = true
				blockType.PrimaryPart.PoweredOff.Transparency = 0
				for _, texture in ipairs(blockType.PrimaryPart.PoweredOff:GetChildren()) do
					texture.Transparency = 0
				end
				blockType.PrimaryPart.PoweredOn.CanCollide = false
				blockType.PrimaryPart.PoweredOn.Transparency = 1
				for _, texture in ipairs(blockType.PrimaryPart.PoweredOn:GetChildren()) do
					texture.Transparency = 1
				end
			end
		elseif facing == "east" then
			if face == "floor" then
				blockType:SetPrimaryPartCFrame(CFrame.new(blockType.PrimaryPart.Position) * CFrame.Angles(0, math.rad(-90), 0))
			elseif face == "wall" then
				blockType:SetPrimaryPartCFrame(CFrame.new(blockType.PrimaryPart.Position) * CFrame.Angles(math.rad(90), 0, math.rad(-90)))
			elseif face == "ceiling" then
				blockType:SetPrimaryPartCFrame(CFrame.new(blockType.PrimaryPart.Position) * CFrame.Angles(0, math.rad(-90), math.rad(180)))
			end

			if powered == "true" then
				blockType.PrimaryPart.PoweredOff.CanCollide = false
				blockType.PrimaryPart.PoweredOff.Transparency = 1
				for _, texture in ipairs(blockType.PrimaryPart.PoweredOff:GetChildren()) do
					texture.Transparency = 1
				end
				blockType.PrimaryPart.PoweredOn.CanCollide = true
				blockType.PrimaryPart.PoweredOn.Transparency = 0
				for _, texture in ipairs(blockType.PrimaryPart.PoweredOn:GetChildren()) do
					texture.Transparency = 0
				end
			else
				blockType.PrimaryPart.PoweredOff.CanCollide = true
				blockType.PrimaryPart.PoweredOff.Transparency = 0
				for _, texture in ipairs(blockType.PrimaryPart.PoweredOff:GetChildren()) do
					texture.Transparency = 0
				end
				blockType.PrimaryPart.PoweredOn.CanCollide = false
				blockType.PrimaryPart.PoweredOn.Transparency = 1
				for _, texture in ipairs(blockType.PrimaryPart.PoweredOn:GetChildren()) do
					texture.Transparency = 1
				end
			end
		end
	end

	if material == "WATER" then
		local level = tonumber(state:match("level=([^,%]]+)"))
		if level then
			local waterHeight = 2.625
			local newHeight = waterHeight - (level * 0.3)
			blockType.PrimaryPart.WaterPart.Size = Vector3.new(3, newHeight, 3)
			local blockSize = blockType.PrimaryPart.Size
			local waterPartSize = blockType.PrimaryPart.WaterPart.Size
			local newPosition = Vector3.new(
				blockType.PrimaryPart.Position.X,
				blockType.PrimaryPart.Position.Y - (blockSize.Y / 2) + (waterPartSize.Y / 2),
				blockType.PrimaryPart.Position.Z
			)
			blockType.PrimaryPart.WaterPart.Position = newPosition

			local materialUnderWater = workspace:FindPartOnRayWithIgnoreList(
				Ray.new(newPosition, Vector3.new(0, -1, 0)),
				{blockType}
			)

			local materialAboveWater = workspace:FindPartOnRayWithIgnoreList(
				Ray.new(newPosition + Vector3.new(0, 2, 0), Vector3.new(0, 1, 0)),
				{blockType}
			)

			if (materialUnderWater and materialUnderWater.Material.Name == "Neon") or
				(materialAboveWater and materialAboveWater.Material.Name == "Neon") then
				blockType.PrimaryPart.WaterPart.Size = Vector3.new(3, 3, 3)
				blockType.PrimaryPart.WaterPart.Position = newPosition + Vector3.new(0, (3 - newHeight) / 2, 0)
			end
		end
	end

	if material == "LADDER" then
		local facing = state:match("facing=([^,%]]+)")
		if facing == "north" then
			blockType:SetPrimaryPartCFrame(CFrame.new(blockType.PrimaryPart.Position) * CFrame.Angles(0, math.rad(-90), 0))
		elseif facing == "east" then
			blockType:SetPrimaryPartCFrame(CFrame.new(blockType.PrimaryPart.Position) * CFrame.Angles(0, math.rad(-180), 0))
		elseif facing == "south" then
			blockType:SetPrimaryPartCFrame(CFrame.new(blockType.PrimaryPart.Position) * CFrame.Angles(0, math.rad(90), 0))
		elseif facing == "west" then
			blockType:SetPrimaryPartCFrame(CFrame.new(blockType.PrimaryPart.Position) * CFrame.Angles(0, 0, 0))
		end
	end

	if material == "NETHER_PORTAL" then
		local axis = state:match("axis=([^,%]]+)")
		if axis == "z" then
			blockType:SetPrimaryPartCFrame(CFrame.new(blockType.PrimaryPart.Position) * CFrame.Angles(0, math.rad(90), 0))
		else
			blockType:SetPrimaryPartCFrame(CFrame.new(blockType.PrimaryPart.Position) * CFrame.Angles(0, 0, 0))
		end
	end

	if string.match(material, "_SIGN$") and not string.match(material, "_WALL_SIGN$") then
		local rotation = tonumber(state:match("rotation=([^,%]]+)")) or 0
		local angle = rotation * (360 / 16)
		blockType:SetPrimaryPartCFrame(CFrame.new(blockType.PrimaryPart.Position) * CFrame.Angles(0, math.rad(-angle), 0))
	end


	if string.match(material, "_WALL_SIGN$") then
		local facing = state:match("facing=([^,%]]+)")
		if facing == "north" then
			blockType:SetPrimaryPartCFrame(CFrame.new(blockType.PrimaryPart.Position) * CFrame.Angles(0, math.rad(-90), 0))
		elseif facing == "east" then
			blockType:SetPrimaryPartCFrame(CFrame.new(blockType.PrimaryPart.Position) * CFrame.Angles(0, math.rad(-180), 0))
		elseif facing == "south" then
			blockType:SetPrimaryPartCFrame(CFrame.new(blockType.PrimaryPart.Position) * CFrame.Angles(0, math.rad(90), 0))
		elseif facing == "west" then
			blockType:SetPrimaryPartCFrame(CFrame.new(blockType.PrimaryPart.Position) * CFrame.Angles(0, 0, 0))
		end
	end

	if material == "REDSTONE_WIRE" then
		-- no support for redstone going up or down
		local north = state:match("north=([^,%]]+)")
		local south = state:match("south=([^,%]]+)")
		local east = state:match("east=([^,%]]+)")
		local west = state:match("west=([^,%]]+)")
		local power = tonumber(state:match("power=([^,%]]+)"))

		local function setTextureProperties(textureName, transparency, color)
			for _, texture in ipairs(blockType.PrimaryPart.Wire:GetChildren()) do
				if texture.Name == textureName then
					texture.Transparency = transparency
					if color then
						texture.Color3 = color
					end
				end
			end
		end

		local function interpolateColor(power)
			local minColor = Color3.new(100/255, 100/255, 100/255)
			local maxColor = Color3.new(1, 1, 1)

			local ratio = power / 15
			local r = minColor.R + (maxColor.R - minColor.R) * ratio
			local g = minColor.G + (maxColor.G - minColor.G) * ratio
			local b = minColor.B + (maxColor.B - minColor.B) * ratio

			return Color3.new(r, g, b)
		end

		-- for crosses
		if north == "side" and south == "side" and east == "side" and west == "side" then
			setTextureProperties("cross", 0, interpolateColor(power))
			setTextureProperties("dot", 1)
			setTextureProperties("line", 1)
			setTextureProperties("corner", 1)
			setTextureProperties("tturn", 1)
		end
		-- for dots
		if north == "none" and south == "none" and east == "none" and west == "none" then
			setTextureProperties("cross", 1)
			setTextureProperties("dot", 0, interpolateColor(power))
			setTextureProperties("line", 1)
			setTextureProperties("corner", 1)
			setTextureProperties("tturn", 1)
		end
		-- for straight lines
		if ((north == "none" and south == "none") or (east == "none" and west == "none")) and not (north == "none" and south == "none" and east == "none" and west == "none") then
			setTextureProperties("cross", 1)
			setTextureProperties("dot", 1)
			setTextureProperties("line", 0, interpolateColor(power))
			setTextureProperties("corner", 1)
			setTextureProperties("tturn", 1)
			if west == "none" and east == "none" then
				blockType:SetPrimaryPartCFrame(CFrame.new(blockType.PrimaryPart.Position) * CFrame.Angles(0, math.rad(90), 0))
			end
		end
		-- for corners
		if ((north == "none" and west == "none") or (north == "none" and east == "none") or (south == "none" and west == "none") or (south == "none" and east == "none")) and not (north == "none" and south == "none" and east == "none" and west == "none") then
			setTextureProperties("cross", 1)
			setTextureProperties("dot", 1)
			setTextureProperties("line", 1)
			setTextureProperties("corner", 0, interpolateColor(power))
			setTextureProperties("tturn", 1)

			local rotationAngle = 0
			if north == "none" and west == "none" then
				rotationAngle = math.rad(-90)
			elseif north == "none" and east == "none" then
				rotationAngle = math.rad(180)
			elseif south == "none" and west == "none" then
				rotationAngle = math.rad(0)
			elseif south == "none" and east == "none" then
				rotationAngle = math.rad(90)
			end
			blockType:SetPrimaryPartCFrame(CFrame.new(blockType.PrimaryPart.Position) * CFrame.Angles(0, rotationAngle, 0))
		end
		-- for t-turns
		if ((north == "side" and west == "side" and east == "side") or 
			(north == "side" and south == "side" and west == "side") or 
			(north == "side" and south == "side" and east == "side") or 
			(south == "side" and west == "side" and east == "side")) and 
			not (north == "side" and south == "side" and east == "side" and west == "side") then
			setTextureProperties("cross", 1)
			setTextureProperties("dot", 1)
			setTextureProperties("line", 1)
			setTextureProperties("corner", 1)
			setTextureProperties("tturn", 0, interpolateColor(power))

			local rotationAngle = 0
			if north == "side" and west == "side" and east == "side" then
				rotationAngle = math.rad(0)
			elseif north == "side" and south == "side" and west == "side" then
				rotationAngle = math.rad(90)
			elseif north == "side" and south == "side" and east == "side" then
				rotationAngle = math.rad(-90)
			elseif south == "side" and west == "side" and east == "side" then
				rotationAngle = math.rad(180)
			end
			blockType:SetPrimaryPartCFrame(CFrame.new(blockType.PrimaryPart.Position) * CFrame.Angles(0, rotationAngle, 0))
		end
	end

	if material == "REDSTONE_LAMP" then
		local lit = state:match("lit=([^,%]]+)")
		if lit == "true" then
			for _, child in ipairs(blockType.PrimaryPart:GetChildren()) do
				if child:IsA("PointLight") then
					child.Brightness = 1
				end
			end

			for _, texture in ipairs(blockType.PrimaryPart:GetChildren()) do
				if texture.Name == "on" then
					texture.Transparency = 0
				end
			end
			for _, texture in ipairs(blockType.PrimaryPart:GetChildren()) do
				if texture.Name == "off" then
					texture.Transparency = 1
				end
			end
		elseif lit == "false" then
			for _, child in ipairs(blockType.PrimaryPart:GetChildren()) do
				if child:IsA("PointLight") then
					child.Brightness = 0
				end
			end
			for _, texture in ipairs(blockType.PrimaryPart:GetChildren()) do
				if texture.Name == "on" then
					texture.Transparency = 1
				end
			end
			for _, texture in ipairs(blockType.PrimaryPart:GetChildren()) do
				if texture.Name == "off" then
					texture.Transparency = 0
				end
			end
		end

	end

	if string.match(material, "_WALL$") then
		local north = state:match("north=([^,%]]+)")
		local south = state:match("south=([^,%]]+)")
		local east = state:match("east=([^,%]]+)")
		local west = state:match("west=([^,%]]+)")
		local up = state:match("up=([^,%]]+)")


		if up == "false" then
			blockType.PrimaryPart.Core.Transparency = 1
			blockType.PrimaryPart.Core.CanCollide = false
			for _, texture in ipairs(blockType.PrimaryPart.Core:GetChildren()) do
				texture.Transparency = 1
			end
		elseif up == "true" then
			blockType.PrimaryPart.Core.Transparency = 0
			blockType.PrimaryPart.Core.CanCollide = true
			for _, texture in ipairs(blockType.PrimaryPart.Core:GetChildren()) do
				texture.Transparency = 0
			end
		end

		-- Handling the north direction
		if north == "low" then
			blockType.PrimaryPart.Wall1.Transparency = 0
			blockType.PrimaryPart.Wall1.CanCollide = true
			for _, texture in ipairs(blockType.PrimaryPart.Wall1:GetChildren()) do
				texture.Transparency = 0
			end
		elseif north == "none" then
			blockType.PrimaryPart.Wall1.Transparency = 1
			blockType.PrimaryPart.Wall1.CanCollide = false
			blockType.PrimaryPart.WallTall1.Transparency = 1
			blockType.PrimaryPart.WallTall1.CanCollide = false
			for _, texture in ipairs(blockType.PrimaryPart.Wall1:GetChildren()) do
				texture.Transparency = 1
			end
			for _, texture in ipairs(blockType.PrimaryPart.WallTall1:GetChildren()) do
				texture.Transparency = 1
			end
		elseif north == "tall" then
			blockType.PrimaryPart.WallTall1.Transparency = 0
			blockType.PrimaryPart.WallTall1.CanCollide = true
			for _, texture in ipairs(blockType.PrimaryPart.WallTall1:GetChildren()) do
				texture.Transparency = 0
			end
		end

		-- Handling the south direction
		if south == "low" then
			blockType.PrimaryPart.Wall2.Transparency = 0
			blockType.PrimaryPart.Wall2.CanCollide = true
			for _, texture in ipairs(blockType.PrimaryPart.Wall2:GetChildren()) do
				texture.Transparency = 0
			end
		elseif south == "none" then
			blockType.PrimaryPart.Wall2.Transparency = 1
			blockType.PrimaryPart.Wall2.CanCollide = false
			blockType.PrimaryPart.WallTall2.Transparency = 1
			blockType.PrimaryPart.WallTall2.CanCollide = false
			for _, texture in ipairs(blockType.PrimaryPart.Wall2:GetChildren()) do
				texture.Transparency = 1
			end
			for _, texture in ipairs(blockType.PrimaryPart.WallTall2:GetChildren()) do
				texture.Transparency = 1
			end
		elseif south == "tall" then
			blockType.PrimaryPart.WallTall2.Transparency = 0
			blockType.PrimaryPart.WallTall2.CanCollide = true
			for _, texture in ipairs(blockType.PrimaryPart.WallTall2:GetChildren()) do
				texture.Transparency = 0
			end
		end

		-- Handling the east direction
		if east == "low" then
			blockType.PrimaryPart.Wall3.Transparency = 0
			blockType.PrimaryPart.Wall3.CanCollide = true
			for _, texture in ipairs(blockType.PrimaryPart.Wall3:GetChildren()) do
				texture.Transparency = 0
			end
		elseif east == "none" then
			blockType.PrimaryPart.Wall3.Transparency = 1
			blockType.PrimaryPart.Wall3.CanCollide = false
			blockType.PrimaryPart.WallTall3.Transparency = 1
			blockType.PrimaryPart.WallTall3.CanCollide = false
			for _, texture in ipairs(blockType.PrimaryPart.Wall3:GetChildren()) do
				texture.Transparency = 1
			end
			for _, texture in ipairs(blockType.PrimaryPart.WallTall3:GetChildren()) do
				texture.Transparency = 1
			end
		elseif east == "tall" then
			blockType.PrimaryPart.WallTall3.Transparency = 0
			blockType.PrimaryPart.WallTall3.CanCollide = true
			for _, texture in ipairs(blockType.PrimaryPart.WallTall3:GetChildren()) do
				texture.Transparency = 0
			end
		end

		-- Handling the west direction
		if west == "low" then
			blockType.PrimaryPart.Wall4.Transparency = 0
			blockType.PrimaryPart.Wall4.CanCollide = true
			for _, texture in ipairs(blockType.PrimaryPart.Wall4:GetChildren()) do
				texture.Transparency = 0
			end
		elseif west == "none" then
			blockType.PrimaryPart.Wall4.Transparency = 1
			blockType.PrimaryPart.Wall4.CanCollide = false
			blockType.PrimaryPart.WallTall4.Transparency = 1
			blockType.PrimaryPart.WallTall4.CanCollide = false
			for _, texture in ipairs(blockType.PrimaryPart.Wall4:GetChildren()) do
				texture.Transparency = 1
			end
			for _, texture in ipairs(blockType.PrimaryPart.WallTall4:GetChildren()) do
				texture.Transparency = 1
			end
		elseif west == "tall" then
			blockType.PrimaryPart.WallTall4.Transparency = 0
			blockType.PrimaryPart.WallTall4.CanCollide = true
			for _, texture in ipairs(blockType.PrimaryPart.WallTall4:GetChildren()) do
				texture.Transparency = 0
			end
		end
	end
end

return BlockStateManager
