local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ServerStorage = game:GetService("ServerStorage")

local BoardsData = require(ServerStorage.Modules.Engine.BoardsData)
local Net = require(ReplicatedStorage.Packages.Net)
local PlayerDeckData = require(ServerStorage.Modules.Engine.PlayerDeckData)
local TokenIdentifiers = require(ReplicatedStorage.Shared.TokenIdentifiers)
local Utils = require(ReplicatedStorage.Shared.Utils)

type grid = { [number]: { [number]: number } }

local module = {}

local initializeGameRE = Net:RemoteEvent("InitializeGame")
local _endGameRE = Net:RemoteEvent("EndGame")
local placeTokenRE = Net:RemoteEvent("PlaceToken")

function module.InitializeGame(gridSize: Vector2, players: { Player }): grid?
	local grid = {}

	if gridSize.X > 10 or gridSize.Y > 8 then return end

	for x = 1, gridSize.X do
		grid[x] = {}

		for y = 1, gridSize.Y do
			grid[x][y] = TokenIdentifiers.empty
		end
	end

	for player, side in Utils.playersToSides(players) do
		BoardsData.playersSides[player] = side
	end

	for _, player in players do
		PlayerDeckData.InitializePlayer(player, { "King", "Knight" }) -- temp deck tbh

		initializeGameRE:FireClient(player, grid, players)
	end

	return grid
end

placeTokenRE.OnServerEvent:Connect(function(player, minion, coordinates)
	if not PlayerDeckData.PlayerHas(player, minion) then return end
	if not table.find(BoardsData.playersSides[player], coordinates) then return end

	PlayerDeckData.RemoveToken(player, minion)

	placeTokenRE:FireClient(player, minion, coordinates)
end)

return module
