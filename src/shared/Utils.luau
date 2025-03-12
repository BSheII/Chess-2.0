local module = {}

local DEBUG_MODE = true

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

function module.getMatchFromPlayer(matchesList, player)
	for _, match in matchesList do
		if not table.find(match.players, player) then continue end

		return match
	end

	return
end

function module.stringToVector2(string)
	local x, y = string:match("<Vector2>%s*%((%-?%d+%.?%d*),%s*(%-?%d+%.?%d*)%)")

	if x and y then return Vector2.new(tonumber(x), tonumber(y)) end

	return nil
end

function module.vector2ToString(vector)
	return string.format("<Vector2> (%.0f, %.0f)", vector.X, vector.Y)
end

function module.DesGrid(grid)
	local desGrid = {}

	for serVector2, pieceIdentifier in grid do
		local vector2 = module.stringToVector2(serVector2)

		desGrid[vector2] = pieceIdentifier
	end

	return desGrid
end

function module.debug(message)
	if DEBUG_MODE == true then warn(message) end
end

function module.correctTokenPosition(cframe, reverse)
	local extraCFrame = if reverse then CFrame.Angles(0, math.rad(180), math.rad(90)) else CFrame.Angles(0, 0, math.rad(90))

	return cframe * extraCFrame * CFrame.new(0.5, 0, 0)
end

return module
