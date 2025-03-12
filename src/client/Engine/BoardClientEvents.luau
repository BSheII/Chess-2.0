local ReplicatedStorage = game:GetService("ReplicatedStorage")

local BoardClientVisualizer = require(ReplicatedStorage.Modules.Engine.BoardClientVisualizer)
local EngineClientInterface = require(ReplicatedStorage.Modules.Engine.EngineClientInterface)
local Utils = require(ReplicatedStorage.Shared.Utils)

local function createBoard(grid)
	Utils.debug("Creating board")
	EngineClientInterface.board = BoardClientVisualizer.createBoard(grid)

	local sizeX, sizeY = #grid, #grid[1]

	for x = 1, sizeX do
		EngineClientInterface.grid[x] = {}
		for y = 1, sizeY do
			EngineClientInterface.grid[x][y] = 0
		end
	end

	for _, cell in EngineClientInterface.board:GetDescendants() do
		if not cell:IsA("BasePart") then continue end

		local x, y = tonumber(cell.Parent.Name), tonumber(cell.Name)
		local cellCoordinates = Vector2.new(x, y)

		EngineClientInterface.cellsLookup[cell] = cellCoordinates
	end
end

EngineClientInterface.updateBoardRE.OnClientEvent:Connect(function(grid, ownedCells)
	local board = EngineClientInterface.board

	if not board then createBoard(grid) end

	Utils.debug(`Updating board with grid:`)
	Utils.debug(grid)

	BoardClientVisualizer.updateBoard(grid)
	EngineClientInterface.grid = grid
	EngineClientInterface.ownedCells = ownedCells
end)

return 0
