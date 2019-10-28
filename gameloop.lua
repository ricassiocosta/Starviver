-- The game logic and loop
local spaceship = require("spaceship")
local physics = require("physics")
local scene = require("scene")
local enemies = require("enemies")
local powerup = require("powerup_manager")
local score = require("score")

------------------------------- Private Fields ---------------------------------

local gameloop = {};
local gameloop_mt = {};
local gameState = 0;
--[[  GameStates
	0 = not initialized
	1 = main menu
	2 = gameplay
	3 = pause menu
]] 

local player;
local stick;
local fireBtn;
local testEn;
local enemy;
local powerups;

------------------------------ Public Functions --------------------------------

-- Runs once to initialize the game
-- Runs everytime the game state changes
function gameloop:init()
	--math.randomseed(os.time()); math.random( ); math.random( );
	system.activate("multitouch")
	native.setProperty("androidSystemVisibility", "immersiveSticky");
  	physics.setDrawMode("hybrid");
 	display.setDefault("background", 0/255, 32/255, 50/255);

	--sets gamestate
	gameState = 2;

	--creates instances of classes
	enemy = enemies.new();
	player = spaceship.new(0, 0, 0.75)
	powerups = powerup:class();
	
	--initializes instances
	scene:init(1)
	player:init();
	player:initHUD();

	enemy:spawn(3, 100, 100);

	powerups:spawn(1);
	powerups:spawn(1);
	powerups:spawn(2);
	powerups:spawn(2);
	powerups:spawn(1);
end

--Runs continously. Different code for each different game state
function gameloop:run()	
	actualScore.text = score:get();

	player:run(); --runs player controls
	enemy:randomSpawn(player:getX(), player:getY()) --spawns enemies randomly
	enemy:run(); --runs enemy logic

	powerups:randomSpawn(player:getX(), player:getY()) --spawns enemies randomly
	powerups:run();
end

return gameloop;