local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")

local Board = require(ReplicatedStorage.Shared.Board)
local BoardInterface = require(script.Parent.BoardInterface)
local TokenIdentifiers = require(ReplicatedStorage.Shared.TokenIdentifiers)
local Tokens = require(ReplicatedStorage.Shared.Tokens)

local Assets = ReplicatedStorage.Assets

local module = {}
local localPlayer = Players.LocalPlayer
local mouse = localPlayer:GetMouse()

local targetConnection
local hoverHighlight
local tokenTweenInfo = TweenInfo.new(0.07, Enum.EasingStyle.Linear)
local tokenPlacementTweenInfo = TweenInfo.new(0.12, Enum.EasingStyle.Linear)
local highlightTweenInfo = TweenInfo.new(0.08, Enum.EasingStyle.Linear)

local function constrainBoard(board, gridSize)
	for x = 1, 10 do
		for y = 1, 8 do
			if gridSize.Y >= y then continue end

			board[x][y]:Destroy()
		end

		if gridSize.X >= x then continue end

		board[x]:Destroy()
	end
end

local function deleteHoverConnections()
	if targetConnection then targetConnection:Disconnect() end
	if hoverHighlight then hoverHighlight:Destroy() end
end

local function deleteHoverToken()
	local hoverToken = workspace.Debris:FindFirstChild("HoverToken")

	if hoverToken then hoverToken:Destroy() end

	for _, highlight in BoardInterface.highlightsCache do
		highlight:Destroy()
	end
end

local function createMovementHighlights(coordinates)
	for _, currentCoordinates in coordinates do
		local part

		for gridPart, coords in BoardInterface.gridPartsLookup do
			if coords ~= currentCoordinates then continue end

			part = gridPart
			break
		end

		local movementHighlight = Assets.HoverHighlight:Clone()
		movementHighlight.FillColor = Board.canPlaceColor
		table.insert(BoardInterface.highlightsCache, movementHighlight)
		movementHighlight.Parent = part
	end
end

local function updateObject(object, targetCFrame, tweenInfo)
	local tween = TweenService:Create(object, tweenInfo, { CFrame = targetCFrame })
	tween:Play()
	tween.Completed:Once(function()
		tween:Destroy()
	end)
end

local function updateHighlight(highlight, newTarget, canPlaceHere)
	local fillColor = if canPlaceHere then Board.canPlaceColor else Board.noPlaceColor

	local fadeOut = TweenService:Create(highlight, highlightTweenInfo, { FillTransparency = 1 })
	local fadeIn = TweenService:Create(highlight, highlightTweenInfo, { FillTransparency = 0.5, FillColor = fillColor })

	fadeOut:Play()

	fadeOut.Completed:Once(function()
		if not highlight.Parent then return end

		highlight.Parent = newTarget

		fadeIn:Play()
		fadeOut:Destroy()
	end)

	fadeIn.Completed:Once(function()
		fadeIn:Destroy()
	end)
end

function module.VisualizeBoard(grid)
	local existingBoard = workspace:FindFirstChild("Board")

	if existingBoard then
		existingBoard:Destroy()
		warn("Deleted previous board - Creating new one")
	end

	local newBoard = Assets.Board:Clone()

	newBoard:PivotTo(CFrame.new(0, 10, 0))
	constrainBoard(newBoard, Vector2.new(#grid, #grid[1]))

	newBoard.Parent = workspace
	return newBoard
end

function module.UnvisualizeBoard()
	local board = workspace:FindFirstChild("Board")

	if board then board:Destroy() end
end

function module.PlaceToken(tokenName, coordinates)
	local tokenTemplate = Assets.Tokens:FindFirstChild(tokenName)
	if not tokenTemplate then return end

	local cell

	for part, partCoordinates in BoardInterface.gridPartsLookup do
		if coordinates ~= partCoordinates then continue end

		cell = part
		break
	end

	if not cell then return end

	local token = workspace.Debris:FindFirstChild("HoverToken")

	deleteHoverConnections()

	if token then updateObject(token, cell.CFrame * CFrame.new(0, 0.5, 0) * CFrame.Angles(0, 0, math.rad(90)), tokenPlacementTweenInfo) end

	task.wait(tokenPlacementTweenInfo.Time)

	deleteHoverToken()

	local newToken = tokenTemplate:Clone()
	newToken.CFrame = cell.CFrame * CFrame.new(0, 0.5, 0) * CFrame.Angles(0, 0, math.rad(90))
	newToken.Parent = workspace.Tokens

	return newToken
end

local function updateHoverPosition(token, highlight, allowedPositions)
	local newTarget = mouse.Target
	if not newTarget or not newTarget:IsDescendantOf(workspace.Board) then return end
	local canPlaceHere = table.find(allowedPositions, BoardInterface.gridPartsLookup[newTarget])
	updateObject(token, newTarget.CFrame * CFrame.new(0, 3, 0) * CFrame.Angles(0, 0, math.rad(90)), tokenTweenInfo)
	updateHighlight(highlight, newTarget, canPlaceHere)
end

local function hoverToken(token, allowedPositions)
	hoverHighlight = Assets.HoverHighlight:Clone()
	local initialTarget = if mouse.Target and mouse.Target:IsDescendantOf(workspace.Board) then mouse.Target else workspace.Board["1"]["1"]
	token.CFrame = initialTarget.CFrame * CFrame.new(0, 3, 0) * CFrame.Angles(0, 0, math.rad(90))
	hoverHighlight.Parent = initialTarget
	targetConnection = RunService.RenderStepped:Connect(function()
		updateHoverPosition(token, hoverHighlight, allowedPositions)
	end)
end

function module.HoverToken(tokenName)
	deleteHoverConnections()
	deleteHoverToken()
	local tokenTemplate = Assets.Tokens:FindFirstChild(tokenName)
	if not tokenTemplate then return end
	local token = tokenTemplate:Clone()
	token.Name = "HoverToken"
	token.Parent = workspace.Debris
	hoverToken(token, BoardInterface.localSide)
end

function module.HoverExistingToken(token)
	deleteHoverConnections()
	deleteHoverToken()

	local allowedMovements = {}

	local tokenCoordinates = BoardInterface.tokensLookup[token]

	for _, move in Tokens[token.Name:lower()].movementPattern do
		local coordinates = tokenCoordinates + move

		if BoardInterface.clientGrid[coordinates.X][coordinates.Y] ~= TokenIdentifiers.empty then
			local occupyingToken

			for _token, coords in BoardInterface.tokensLookup do
				if coords ~= coordinates then continue end

				occupyingToken = _token
				break
			end

			if occupyingToken:GetAttribute("Owner") == localPlayer then continue end
		end

		table.insert(allowedMovements, coordinates)
	end

	createMovementHighlights(allowedMovements)

	hoverToken(token, allowedMovements)
end

return module
