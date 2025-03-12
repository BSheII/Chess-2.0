local ReplicatedStorage = game:GetService("ReplicatedStorage")

local EngineClientInterface = require(ReplicatedStorage.Modules.Engine.EngineClientInterface)
local PieceIdentifiers = require(ReplicatedStorage.Shared.PieceIdentifiers)

local hookConnections = {}

local function hookClickDetector(cell, clickDetector)
	hookConnections[clickDetector] = clickDetector.MouseClick:Connect(function()
		--[[
            if (dragging piece) then 
                stop

            if (clicked on piece X) then
                (engage in piece X placement)

            if (clicked on empty space Y) then
                if (piece X in placement mode) then
                    (place piece X on empty space Y)
        ]]

		local cellCoordinates = EngineClientInterface.cellsLookup[cell]
		local cellIdentifier = EngineClientInterface.grid[cellCoordinates.X][cellCoordinates.Y]

		if cellIdentifier ~= PieceIdentifiers.empty then
			if EngineClientInterface.holdingPiece ~= nil then return end

			-- check if cellIdentifier is the player's or not and if not then attack or sum

			EngineClientInterface.grabPieceSignal:Fire(cellCoordinates)
		else
			if EngineClientInterface.holdingPiece == nil then return end

			EngineClientInterface.placePieceSignal:Fire(cellCoordinates)
		end
	end)
end

EngineClientInterface.hookInputSignal:Connect(function(cells)
	for _, cell in cells do
		local clickDetector = cell:FindFirstChild("ClickDetector")

		if not clickDetector then continue end

		hookClickDetector(clickDetector)
	end
end)

EngineClientInterface.unhookInputSignal:Connect(function()
	for clickDetector, connection in hookConnections do
		connection:Disconnect()
		hookConnections[clickDetector] = nil
	end
end)

return 0
