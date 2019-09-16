-- The game logic and loop
local spaceship = require("spaceship")
local joystick = require("joystick")
local button = require("button")
local physics = require("physics")
local scene = require("scene")
local enemies = require("enemies")
local stalker = require("en_stalker")


local gameloop = {};
local gameloop_mt = {};
local gameState;
local player;
local stick;
local fireBtn;
local gameScene;
local testEn;
local enemy;
local newStalker;

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
	math.randomseed(os.time());
	system.activate("multitouch")
	native.setProperty("androidSystemVisibility", "immersiveSticky");

	gameState = 2;

	--creates instances of classes
	enemy = enemies.new();
	gameScene = scene.new();
	player = spaceship.new(0, 0, 0.75)
	
	stick = joystick.new(1.125 * display.contentWidth / 8, 6 * display.contentHeight / 8);
	fireBtn = button.new(1.7 * (display.contentWidth / 2), 1.5 * (display.contentHeight / 2), display.contentWidth/17, display.contentWidth/17, 255, 45, 65);
	
	--initializes instances
	local newStalker = enemy:spawn(1, 300, 25);
	local newStalkerSec = enemy:spawn(1, 400, -200);
	player:init();
	newStalker:init("imgs/stalker.png");
	newStalkerSec:init("imgs/stalker.png");
	stick:init();
	fireBtn:init();

	--initializes scene; add objects
	gameScene:init(1);
	gameScene:addObjectToScene(player:getDisplayObject(), 1);
	gameScene:addObjectToScene(newStalker:getDisplayObject(), 3);
	gameScene:addObjectToScene(newStalkerSec:getDisplayObject(), 3);
	gameScene:addFocusTrack(player:getDisplayObject());
end

-- Runs continously, but with different code for each different game state
function gameloop:run(event)
	player:run();
	player:debug()

	if(fireBtn:isPressed() == true) then
		player:setIsShooting(true);
	else
		player:setIsShooting(false);
	end
end

return gameloop;