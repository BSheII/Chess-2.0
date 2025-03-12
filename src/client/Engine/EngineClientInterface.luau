local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Net = require(ReplicatedStorage.Packages.Net)
local Signal = require(ReplicatedStorage.Packages.Signal)

return {
	placePieceRE = Net:RemoteEvent("PlacePiece"),
	updateBoardRE = Net:RemoteEvent("UpdateBoard"),

	onPlacedSignal = Signal.new(),

	grabPieceSignal = Signal.new(),
	placePieceSignal = Signal.new(),

	hookInputSignal = Signal.new(),
	unhookInputSignal = Signal.new(),

	board = nil,
	holdingPiece = nil,

	grid = {},
	cellsLookup = {},
	tokensLookup = {},
	ownedCells = {},
}
