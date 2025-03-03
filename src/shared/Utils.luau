local module = {}

module.aliases = {
	left = Vector2.new(-1, 0),
	right = Vector2.new(1, 0),
	down = Vector2.new(0, -1),
	up = Vector2.new(0, 1),
	topLeft = Vector2.new(-1, 1),
	topRight = Vector2.new(1, 1),
	bottomLeft = Vector2.new(-1, -1),
	bottomRight = Vector2.new(1, -1),
	center = Vector2.new(0, 0),
}

module.aliases.allSides = {
	module.aliases.left,
	module.aliases.right,
	module.aliases.down,
	module.aliases.up,
	module.aliases.topLeft,
	module.aliases.topRight,
	module.aliases.bottomLeft,
	module.aliases.bottomRight,
}

module.aliases.allSidesNoDiagonals = {
	module.aliases.left,
	module.aliases.right,
	module.aliases.down,
	module.aliases.up,
}

module.sides = {}

module.sides.blue = {
	Vector2.new(1, 1),
	Vector2.new(1, 2),
	Vector2.new(1, 3),
	Vector2.new(1, 4),
	Vector2.new(1, 5),
	Vector2.new(1, 6),
	Vector2.new(1, 7),
	Vector2.new(1, 8),
	Vector2.new(2, 1),
	Vector2.new(2, 2),
	Vector2.new(2, 3),
	Vector2.new(2, 4),
	Vector2.new(2, 5),
	Vector2.new(2, 6),
	Vector2.new(2, 7),
	Vector2.new(2, 8),
}

module.sides.red = {
	Vector2.new(9, 1),
	Vector2.new(9, 2),
	Vector2.new(9, 3),
	Vector2.new(9, 4),
	Vector2.new(9, 5),
	Vector2.new(9, 6),
	Vector2.new(9, 7),
	Vector2.new(9, 8),
	Vector2.new(10, 1),
	Vector2.new(10, 2),
	Vector2.new(10, 3),
	Vector2.new(10, 4),
	Vector2.new(10, 5),
	Vector2.new(10, 6),
	Vector2.new(10, 7),
	Vector2.new(10, 8),
}

function module.playersToSides(players)
	local sides = {}

	if players[1] then sides[players[1]] = module.sides.red end
	if players[2] then sides[players[2]] = module.sides.blue end

	return sides
end

return module
