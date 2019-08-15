-- The game logic and loop

local gameloop = {};
local gameloop_mt = {};
local gameState;
local player;

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
	}
	return setmetatable( newGameloop, gameloop_mt );
end



-- Runs once to initialize the game
-- Runs everytime the game state changes
function gameloop:init()
	gameState = 2;
	player = ship.new(display.contentWidth / 2, 5 * display.contentHeight / 6);
end

-- Runs continously, but with different code for each different game state
function gameloop:run()
	
end

return gameloop;