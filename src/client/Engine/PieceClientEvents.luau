local ReplicatedStorage = game:GetService("ReplicatedStorage")

local EngineClientInterface = require(ReplicatedStorage.Modules.Engine.EngineClientInterface)
local PieceClientVisualizer = require(ReplicatedStorage.Modules.Engine.PieceClientVisualizer)
local Utils = require(ReplicatedStorage.Shared.Utils)

EngineClientInterface.grabPieceSignal:Connect(function(coordinates)
	if not table.find(EngineClientInterface.ownedCells, coordinates) then return end

	local holdingToken = PieceClientVisualizer.grabToken(coordinates)

	EngineClientInterface.holdingPiece = holdingToken
end)

EngineClientInterface.placePieceSignal:Connect(function(coordinates)
	-- local cellIdentifier = EngineClientInterface.grid[coordinates.X][coordinates.Y]

	--[[
		if (can move here) then
			if (empty) then
				(place here)
			else
				(take here)
	]]
end)

EngineClientInterface.onPlacedSignal:Connect(function(token, coordinates)
	Utils.debug(`Placed piece {token} at {tostring(coordinates)}`)

	EngineClientInterface.tokensLookup[token] = coordinates
end)

return 0
