local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Utils = require(ReplicatedStorage.Shared.Utils)

return {
	attackPattern = { Utils.aliases.up, Utils.aliases.topLeft, Utils.aliases.topRight },
	movementPattern = { Utils.aliases.allSidesNoDiagonals },
}
