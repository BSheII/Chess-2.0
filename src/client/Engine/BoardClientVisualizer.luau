local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Assets = ReplicatedStorage.Assets

local EngineClientInterface = require(ReplicatedStorage.Modules.Engine.EngineClientInterface)
local PieceIdentifiers = require(ReplicatedStorage.Shared.PieceIdentifiers)
local Utils = require(ReplicatedStorage.Shared.Utils)

local module = {}

local function placeToken(coordinates, identifier) -- TODO: Find a way to move this
	local token

	for pieceName, pieceIdentifier in PieceIdentifiers do
		if pieceIdentifier ~= identifier then continue end

		token = Assets.Tokens[pieceName]:Clone()
	end

	token.CFrame = Utils.correctTokenPosition(EngineClientInterface.board[coordinates.X][coordinates.Y].CFrame, true)
	token.Parent = workspace.Tokens

	EngineClientInterface.onPlacedSignal:Fire(token, coordinates)
end

local function resetCell(coordinates)
	local cellToken

	for token, tokenCoordinates in EngineClientInterface.tokensLookup do
		if tokenCoordinates ~= coordinates then continue end

		cellToken = token
		break
	end

	if not cellToken then return end

	cellToken:Destroy()
end

function module.createBoard(grid)
	local board = Assets.Board:Clone()

	for _, cell in board:GetDescendants() do
		if not cell:IsA("BasePart") then continue end

		local x, y = tonumber(cell.Parent.Name), tonumber(cell.Name)
		local cellCoordinates = Vector2.new(x, y)

		if grid[cellCoordinates.X][cellCoordinates.Y] then continue end

		Utils.debug(`Destroying cell {tostring(cellCoordinates)} due to grid size constraints`)

		cell:Destroy()
	end

	board.Parent = workspace

	return board
end

function module.updateBoard(grid)
	local gridSizeX, gridSizeY = #grid, #grid[1]

	for x = 1, gridSizeX do
		for y = 1, gridSizeY do
			local clientIdentifier = EngineClientInterface.grid[x][y]
			local serverIdentifier = grid[x][y]
			local coordinates = Vector2.new(x, y)

			if clientIdentifier == serverIdentifier then continue end

			resetCell(coordinates)

			if serverIdentifier ~= PieceIdentifiers.empty then placeToken(coordinates, serverIdentifier) end
		end
	end
end

return module
