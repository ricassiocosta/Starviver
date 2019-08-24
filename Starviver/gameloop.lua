-- The game logic and loop
local spaceship = require("spaceship")
local joystick = require("joystick")
local button = require("button")
local physics = require("physics")
local perspective = require("perspective")


local gameloop = {};
local gameloop_mt = {};
local gameState;
local player;
local stick;
local fireBtn;
local camera;
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
	physics.addBody(player, "kinematic")
	stick = joystick.new(1.125 * display.contentWidth / 8, 6 * display.contentHeight / 8);
	fireBtn = button.new(1.7 * (display.contentWidth / 2), 1.5 * (display.contentHeight / 2), display.contentWidth/17, display.contentWidth/17, true, 255, 45, 65, "fire");
	player:init();
	stick:init();
	fireBtn:init();

	-- Used to allow the camera to follow the player
	camera = perspective.createView();
	camera:add(player:getDisplayObject(), 1) -- Add plyer to layer 1 of the camera


	local scene = {}
	for i = 1, 100 do
		scene[i] = display.newCircle(0, 0, 10)
		scene[i].x = math.random(display.screenOriginX, display.contentWidth * 3)
		scene[i].y = math.random(display.screenOriginY, display.contentHeight)
		scene[i]:setFillColor(math.random(100) * 0.01, math.random(100) * 0.01, math.random(100) * 0.01)
		camera:add(scene[i], math.random(0, camera:layerCount()))
	end

	camera:setParallax(1, 0.9, 0.8, 0.7, 0.6, 0.5, 0.4, 0.3) -- Here we set parallax for each layer in desceding order

	camera.damping = 10;
	camera:setFocus(player);
	camera:track(); --Begin auto-tracking
end

-- Runs continously, but with different code for each different game state
function gameloop:run(event)
	stick:debug();
	player:run();
	camera:snap();
	if(fireBtn:isPressed() == true) then
		player:setIsShooting(true);
		debaq.text = isShooting;
	else
		player:setIsShooting(false);
		debaq.text = isShooting;
	end
end

return gameloop;