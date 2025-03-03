local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Signal = require(ReplicatedStorage.Packages.Signal)

return {
	hookClickDetectors = Signal.new(),
	attemptPlacement = Signal.new(),
	attemptReallocation = Signal.new(),

	selectedMinion = nil,
	highlightsCache = {},
	localSide = nil,

	gridPartsLookup = {},
	tokensLookup = {},

	clientGrid = {},
	playersInGame = {},
}
