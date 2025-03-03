local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")

local BoardInterface = require(script.Parent.BoardInterface)
local Assets = ReplicatedStorage.Assets

local module = {}
local localPlayer = Players.LocalPlayer
local mouse = localPlayer:GetMouse()

local targetConnection
local hoverHighlight
local tokenTweenInfo = TweenInfo.new(0.07, Enum.EasingStyle.Linear)
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

local function deleteHoverToken()
	if targetConnection then targetConnection:Disconnect() end
	if hoverHighlight then hoverHighlight:Destroy() end
	local hoverToken = workspace.Debris:FindFirstChild("HoverToken")
	if hoverToken then hoverToken:Destroy() end
end

local function moveObjectTo(object, targetCFrame)
	local tween = TweenService:Create(object, tokenTweenInfo, { CFrame = targetCFrame })
	tween:Play()
	tween.Completed:Once(function()
		tween:Destroy()
	end)
end

local function moveHighlightTo(highlight, newTarget)
	local fadeOut = TweenService:Create(highlight, highlightTweenInfo, { FillTransparency = 1 })
	local fadeIn = TweenService:Create(highlight, highlightTweenInfo, { FillTransparency = 0.5 })

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

local function updateHoverPosition(token, highlight)
	local newTarget = mouse.Target
	if not newTarget or not newTarget:IsDescendantOf(workspace.Board) then return end

	moveObjectTo(token, newTarget.CFrame * CFrame.new(0, 3, 0) * CFrame.Angles(0, 0, math.rad(90)))
	moveHighlightTo(highlight, newTarget)
end

function module.Visualize(grid)
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

function module.Unvisualize()
	local board = workspace:FindFirstChild("Board")

	if board then board:Destroy() end
end

function module.HoverToken(tokenName)
	deleteHoverToken()

	local tokenTemplate = Assets.Tokens:FindFirstChild(tokenName)

	if not tokenTemplate then return end

	local hoverToken = tokenTemplate:Clone()
	hoverToken.Name = "HoverToken"
	hoverToken.Parent = workspace.Debris

	hoverHighlight = Assets.HoverHighlight:Clone()

	local initialTarget = if mouse.Target and mouse.Target:IsDescendantOf(workspace.Board) then mouse.Target else workspace.Board["1"]["1"]

	hoverToken.CFrame = initialTarget.CFrame * CFrame.new(0, 3, 0) * CFrame.Angles(0, 0, math.rad(90))
	hoverHighlight.Parent = initialTarget

	targetConnection = RunService.RenderStepped:Connect(function()
		updateHoverPosition(hoverToken, hoverHighlight)
	end)
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

	deleteHoverToken()

	local newToken = tokenTemplate:Clone()
	newToken.CFrame = cell.CFrame * CFrame.new(0, 0.5, 0) * CFrame.Angles(0, 0, math.rad(90))
	newToken.Parent = workspace.Tokens
end

return module
