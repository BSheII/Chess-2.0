local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Utils = require(ReplicatedStorage.Shared.Utils)

return {
	attackPattern = { Utils.aliases.allSides },
	movementPattern = { Utils.aliases.allSides },
}
