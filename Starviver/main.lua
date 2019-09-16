local gameloop = require("gameloop")

gameloop:init();

local function gameLoop()
    gameloop:run()
end

Runtime:addEventListener("enterFrame", gameLoop)