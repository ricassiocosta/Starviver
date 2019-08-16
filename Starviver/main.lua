local gameloop = require("gameloop")
gameloop.new();
gameloop:init();

local function gameLoop()
    gameloop:run()
end

Runtime:addEventListener("enterFrame", gameLoop)