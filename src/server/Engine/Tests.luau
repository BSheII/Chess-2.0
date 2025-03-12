local BoardInterface = require(script.Parent.BoardServerInterface)

task.spawn(function()
	task.wait(3)

	BoardInterface.initializeGameSignal:Fire(Vector2.new(10, 8), { game.Players.Vesp_Ithon })
end)

return 0
