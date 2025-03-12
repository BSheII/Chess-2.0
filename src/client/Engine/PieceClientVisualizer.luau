local ReplicatedStorage = game:GetService("ReplicatedStorage")

local EngineClientInterface = require(ReplicatedStorage.Modules.Engine.EngineClientInterface)
local PieceIdentifiers = require(ReplicatedStorage.Shared.PieceIdentifiers)
local Tokens = require(ReplicatedStorage.Shared.Tokens)

local module = {}

function module.grabToken(coordinates)
	local token
	local tokenName

	for tokenInstance, tokenCoordinates in EngineClientInterface.tokensLookup do
		if coordinates ~= tokenCoordinates then continue end

		token = tokenInstance
		break
	end

	for identifierName, identifier in PieceIdentifiers do
		if EngineClientInterface.grid[coordinates.X][coordinates.Y] ~= identifier then continue end

		tokenName = identifierName
		break
	end

	local validMoves = {}
	local tokenMovementPattern = Tokens[tokenName].movementPattern

	local currentVector2 = Vector2.new(coordinates.X, coordinates.Y)

	for _, move in tokenMovementPattern do
		local newVector2 = currentVector2 + move

		if table.find(EngineClientInterface.ownedCells, newVector2) then continue end

		table.insert(validMoves, newVector2)
	end

	print(validMoves, token)
end

return module
