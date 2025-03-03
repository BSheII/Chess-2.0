local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Net = require(ReplicatedStorage.Packages.Net)
local TokenIdentifiers = require(ReplicatedStorage.Shared.TokenIdentifiers)

type grid = { [number]: { [number]: number } }

local module = {}

local initializeGameRE = Net:RemoteEvent("InitializeGame")
local _endGameRE = Net:RemoteEvent("EndGame")

function module.InitializeGame(gridSize: Vector2, players: { Player }): grid?
	local grid = {}

	if gridSize.X > 10 or gridSize.Y > 8 then return end

	for x = 1, gridSize.X do
		grid[x] = {}

		for y = 1, gridSize.Y do
			grid[x][y] = TokenIdentifiers.empty
		end
	end

	for _, player in players do
		initializeGameRE:FireClient(player, grid, players)
	end

	return grid
end

return module
