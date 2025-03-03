local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Utils = require(ReplicatedStorage.Shared.Utils)

local config = {
	king = {
		attackPattern = { Utils.aliases.allSides },
	},
	knight = {
		attackPattern = { Utils.aliases.up, Utils.aliases.topLeft, Utils.aliases.topRight },
	},
}

local kingMovementPattern = { unpack(Utils.aliases.allSides) }
table.insert(kingMovementPattern, Utils.aliases.center)

config.king.movementPattern = kingMovementPattern

local knightMovementPattern = { unpack(Utils.aliases.allSidesNoDiagonals) }
table.insert(knightMovementPattern, Utils.aliases.center)

config.knight.movementPattern = knightMovementPattern

return config
