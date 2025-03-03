local ReplicatedStorage = game:GetService("ReplicatedStorage")

local BoardInterface = require(ReplicatedStorage.Modules.Engine.BoardInterface)
local BoardVisualizer = require(ReplicatedStorage.Modules.Engine.BoardVisualizer)
local Net = require(ReplicatedStorage.Packages.Net)

local function hookClickDetectors(board)
	local clickDetectors = {}

	for _, clickDetector in board:GetDescendants() do
		if not clickDetector:IsA("ClickDetector") then continue end

		table.insert(clickDetectors, clickDetector)
	end

	BoardInterface.hookClickDetectors:Fire(clickDetectors)
end

Net:Connect("InitializeGame", function(grid, players)
	BoardInterface.clientGrid = grid
	BoardInterface.playersInGame = players

	local newBoard = BoardVisualizer.Visualize(grid)

	local sizeX, sizeY = #grid, #grid[1]

	for x = 1, sizeX do
		local folder = newBoard[x]

		for y = 1, sizeY do
			BoardInterface.gridPartsLookup[folder[y]] = Vector2.new(x, y)
		end
	end

	hookClickDetectors(newBoard)

	BoardInterface.selectedMinion = "King"
	BoardVisualizer.HoverToken(BoardInterface.selectedMinion)
end)

Net:Connect("EndGame", function()
	BoardInterface.clientGrid = {}
	BoardInterface.playersInGame = {}
end)

BoardInterface.attemptPlacement:Connect(function(coordinates)
	if BoardInterface.selectedMinion == nil then return end

	-- TODO: Tell server to try it instead of doing it here and not changing selected minion until sure it worked

	BoardInterface.clientGrid[coordinates.X][coordinates.Y] = BoardInterface.selectedMinion

	BoardVisualizer.PlaceToken(BoardInterface.selectedMinion, coordinates)
	BoardInterface.selectedMinion = nil
end)

return 0
