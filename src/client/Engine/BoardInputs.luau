local ReplicatedStorage = game:GetService("ReplicatedStorage")

local BoardInterface = require(ReplicatedStorage.Modules.Engine.BoardInterface)
local TokenIdentifiers = require(ReplicatedStorage.Shared.TokenIdentifiers)

BoardInterface.hookClickDetectors:Connect(function(clickDetectors)
	for _, clickDetector: ClickDetector in clickDetectors do
		local detectedPart = clickDetector.Parent
		local coordinates = BoardInterface.gridPartsLookup[detectedPart]

		clickDetector.MouseClick:Connect(function()
			local cell = BoardInterface.clientGrid[coordinates.X][coordinates.Y]

			if cell == TokenIdentifiers.empty then
				-- Attempt to place a minion on the cell or no interaction
				print(`Attempting to place a minion	on cell: {tostring(coordinates)}`)
				BoardInterface.attemptPlacement:Fire(coordinates)
			else
				-- Attempt to interact with the cell
				print(`Attempting to interact with cell: {tostring(coordinates)}`)

				BoardInterface.attemptReallocation:Fire(coordinates)
			end
		end)
	end
end)

return 0
