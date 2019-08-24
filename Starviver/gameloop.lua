-- The game logic and loop
local spaceship = require("spaceship")
local joystick = require("joystick")
local button = require("button")


local gameloop = {};
local gameloop_mt = {};
local gameState;
local player;
local stick;
local fireBtn;
local debaq;

--[[  GameStates
	0 = not initialized
	1 = main menu
	2 = gameplay
	3 = pause menu
]] 

function gameloop.new()
	local newGameloop = {
		gameState = 0;
	}
	return setmetatable( newGameloop, gameloop_mt );
end



-- Runs once to initialize the game
-- Runs everytime the game state changes
function gameloop:init()
	gameState = 2;
	debaq = display.newText("123", 333, 444, "Arial", 60)
	player = spaceship.new(display.contentWidth / 2, display.contentHeight / 2, 0.5);
	stick = joystick.new(1.125 * display.contentWidth / 8, 6 * display.contentHeight / 8);
	fireBtn = button.new(1.7 * (display.contentWidth / 2), 1.5 * (display.contentHeight / 2), display.contentWidth/17, display.contentWidth/17, true, 255, 45, 65, "fire");
	stick:init();
	fireBtn:init();
end

-- Runs continously, but with different code for each different game state
function gameloop:run(event)
	stick:debug();
	player:run();
	if(fireBtn:isPressed() == true) then
		debaq.text = "asda"
	else
		debaq.text = "1012"
	end
end

return gameloop;