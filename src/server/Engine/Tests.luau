local BoardLogic = require(script.Parent.BoardServerLogic)

task.wait(3)

BoardLogic.InitializeGame(Vector2.new(10, 8), { game.Players.Vesp_Ithon })

return 0
