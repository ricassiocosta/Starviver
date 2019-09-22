-- The game logic and loop
local spaceship = require("spaceship")
local joystick = require("joystick")
local button = require("button")
local physics = require("physics")
local scene = require("scene")
local enemies = require("enemies")
local bullets = require("bullets")

local kek;


local gameloop = {};
local gameloop_mt = {};
local gameState;
local player;
local stick;
local fireBtn;
local testEn;
local enemy;
local kek;

--[[  GameStates
	0 = not initialized
	1 = main menu
	2 = gameplay
	3 = pause menu
]] 


-- Runs once to initialize the game
-- Runs everytime the game state changes
function gameloop:init()
	math.randomseed(os.time());
	system.activate("multitouch")
	native.setProperty("androidSystemVisibility", "immersiveSticky");

	--sets gamestate
	gameState = 2;

	--creates instances of classes
	enemy = enemies.new();
	player = spaceship.new(0, 0, 0.75)
	
	--initializes instances
	scene:init(1)
	player:init();

	--initializes scene; add objects
	scene:addObjectToScene(player:getDisplayObject(), 0);
	scene:addFocusTrack(player:getDisplayObject());

	--Spawns in enemies
	enemy:spawn(1, 0, -500)

	kek = display.newText(enemy:get(1, 1).health, 200, 200, "Arial", 48)

	-- Spawns in HUD and Controls
	stick = joystick.new(1.125 * display.contentWidth / 8, 6 * display.contentHeight / 8);
	fireBtn = button.new(1.7 * (display.contentWidth / 2), 1.5 * (display.contentHeight / 2), display.contentWidth/17, display.contentWidth/17, 255, 45, 65);

	fireBtn:init();
	stick:init();
end

-- Runs continously, but with different code for each different game state
function gameloop:run()
	player:run();
	--player:debug()

	kek.text = enemy:get(1, 1).health

	for i = 1, table.getn(enemy:get()) do
	    for j = 1, table.getn(enemy:get(i)) do
	      enemy:get(i,j):run();
	    end
  	end

	if(fireBtn:isPressed() == true) then
		player:setIsShooting(true);
	else
		player:setIsShooting(false);
	end
end

return gameloop;