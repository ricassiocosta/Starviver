local gameloop = require("gameloop")
local backgroundSprite = {
	type = "image",
	filename = "imgs/space.jpg"
}

background = display.newRect(display.contentCenterX, display.contentCenterY, display.actualContentWidth, display.actualContentHeight )
background.fill = backgroundSprite

gameloop.new();
gameloop:init();

local function gameLoop()
    gameloop:run()
end

Runtime:addEventListener("enterFrame", gameLoop)