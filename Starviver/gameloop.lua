-- The game logic and loop
local spaceship = require("spaceship")
local joystick = require("joystick")


local gameloop = {};
local gameloop_mt = {};
local gameState;
local player;
local stick;

--[[  GameStates
	0 = not initialized
	1 = main menu
	2 = gameplay
	3 = pause menu
]] 

function gameloop.new()
	local newGameloop = {
		gameState = 0;
		player = nil;
		stick = nil;
	}
	return setmetatable( newGameloop, gameloop_mt );
end



-- Runs once to initialize the game
-- Runs everytime the game state changes
function gameloop:init()
	gameState = 2;
	player = spaceship.new(3 * display.contentWidth / 4, 5 * display.contentHeight / 6, 20);
	stick = joystick.new(1.125 * display.contentWidth / 8, 6 * display.contentHeight / 8);
end

-- Runs continously, but with different code for each different game state
function gameloop:run(event)
	joystick:run();
end

return gameloop;