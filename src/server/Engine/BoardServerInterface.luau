local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Net = require(ReplicatedStorage.Packages.Net)
local Signal = require(ReplicatedStorage.Packages.Signal)

return {
	initializeGameSignal = Signal.new(),
	endGameSignal = Signal.new(),

	placePieceRE = Net:RemoteEvent("PlacePiece"),
	updateBoardRE = Net:RemoteEvent("UpdateBoard"),
}
