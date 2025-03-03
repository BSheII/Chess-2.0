local module = {}
local data = {}

function module.PlayerHas(player, token)
	if not table.find(data[player], token) then return false end

	return true
end

function module.AddToken(player, token)
	table.insert(data[player], token)
end

function module.RemoveToken(player, token)
	local foundToken = table.find(data[player], token)

	if not foundToken then return end

	table.remove(data[player], foundToken)
end

function module.InitializePlayer(player, deck)
	data[player] = deck
end

function module.ClearPlayer(player)
	data[player] = {}
end

return module
