local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local BoardInterface = require(ReplicatedStorage.Modules.Engine.BoardInterface)
local BoardVisualizer = require(ReplicatedStorage.Modules.Engine.BoardVisualizer)
local Net = require(ReplicatedStorage.Packages.Net)
local TokenIdentifiers = require(ReplicatedStorage.Shared.TokenIdentifiers)
local Utils = require(ReplicatedStorage.Shared.Utils)

local placeTokenRE = Net:RemoteEvent("PlaceToken")

local localPlayer = Players.LocalPlayer

local function grabToken(token)
	local tokenIsString = typeof(token) == "string"

	BoardInterface.selectedMinion = if tokenIsString then token else token.Name

	if tokenIsString then
		BoardVisualizer.HoverToken(token)
	else
		BoardVisualizer.HoverExistingToken(token)
	end
end

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

	local newBoard = BoardVisualizer.VisualizeBoard(grid)

	local sizeX, sizeY = #grid, #grid[1]

	for x = 1, sizeX do
		local folder = newBoard[x]

		for y = 1, sizeY do
			BoardInterface.gridPartsLookup[folder[y]] = Vector2.new(x, y)
		end
	end

	hookClickDetectors(newBoard)

	BoardInterface.localSide = Utils.playersToSides(players)[localPlayer]

	grabToken("King")

	task.delay(4, function()
		grabToken("Knight")
	end)
end)

Net:Connect("EndGame", function()
	BoardInterface.clientGrid = {}
	BoardInterface.playersInGame = {}
end)

BoardInterface.attemptPlacement:Connect(function(coordinates)
	if BoardInterface.selectedMinion == nil then return end

	placeTokenRE:FireServer(BoardInterface.selectedMinion, coordinates)
end)

BoardInterface.attemptReallocation:Connect(function(coordinates)
	local token

	for currentToken, tokenCoordinates in BoardInterface.tokensLookup do
		if tokenCoordinates ~= coordinates then continue end

		token = currentToken
		break
	end

	BoardInterface.clientGrid[coordinates.X][coordinates.Y] = TokenIdentifiers.empty

	grabToken(token)
end)

Net:Connect("PlaceToken", function(minion, coordinates)
	if BoardInterface.selectedMinion ~= minion then
		warn(`oopsie doopsie I did a fucky wucky in the client-server sync`)
		return
	end

	BoardInterface.clientGrid[coordinates.X][coordinates.Y] = TokenIdentifiers[BoardInterface.selectedMinion:lower()]

	local token = BoardVisualizer.PlaceToken(BoardInterface.selectedMinion, coordinates)

	token:SetAttribute("Owner", localPlayer)

	BoardInterface.tokensLookup[token] = coordinates
	BoardInterface.selectedMinion = nil
end)

return 0
