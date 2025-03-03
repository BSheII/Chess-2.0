local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Signal = require(ReplicatedStorage.Packages.Signal)

return {
	hookClickDetectors = Signal.new(),
	attemptPlacement = Signal.new(),

	selectedMinion = nil,

	gridPartsLookup = {},
	clientGrid = {},
	playersInGame = {},
}
