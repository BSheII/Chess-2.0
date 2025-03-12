local HttpService = game:GetService("HttpService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ServerStorage = game:GetService("ServerStorage")

local BoardData = require(ServerStorage.Modules.Engine.BoardServerData)
local BoardInterface = require(ServerStorage.Modules.Engine.BoardServerInterface)
local PieceIdentifiers = require(ReplicatedStorage.Shared.PieceIdentifiers)
local Utils = require(ReplicatedStorage.Shared.Utils)

BoardInterface.initializeGameSignal:Connect(function(gridSize: Vector2, players: { Player }): nil
	local match = {}

	match.grid = {}
	match.players = players
	match.decks = {}
	match.ownedCells = {}

	if gridSize.X > 10 or gridSize.Y > 8 then return end
	--if #players < 2 then return end

	for x = 1, gridSize.X do
		match.grid[x] = {}

		for y = 1, gridSize.Y do
			match.grid[x][y] = PieceIdentifiers.empty
		end
	end

	match.grid[1][4] = "k"

	for _, player in players do
		match.ownedCells[player] = {}
		match.decks[player] = { "king", "knight" }

		BoardInterface.updateBoardRE:FireClient(player, match.grid, match.ownedCells[player])
	end

	BoardData[HttpService:GenerateGUID()] = match

	return
end)

BoardInterface.endGameSignal:Connect(function() end)

BoardInterface.placePieceRE.OnServerEvent:Connect(function(player: Player, pieceName: string, coordinates: Vector2): nil
	local match = Utils.getMatchFromPlayer(BoardData, player)

	if not match then return end

	match.grid[coordinates.X][coordinates.Y] = PieceIdentifiers[pieceName]

	return
end)

return 0
