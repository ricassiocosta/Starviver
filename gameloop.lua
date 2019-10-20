-- The game logic and loop
local spaceship = require("spaceship")
local joystick = require("joystick")
local button = require("button")
local physics = require("physics")
local scene = require("scene")
local enemies = require("enemies")
local bullets = require("bullets")
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

------------------------------ Public Functions --------------------------------

-- Runs once to initialize the game
-- Runs everytime the game state changes
function gameloop:init()
	--math.randomseed(os.time()); math.random( ); math.random( );
	system.activate("multitouch")
	native.setProperty("androidSystemVisibility", "immersiveSticky");
  --physics.setDrawMode("hybrid");

	--sets gamestate
	gameState = 2;

	--creates instances of classes
	enemy = enemies.new();
	player = spaceship.new(0, 0, 0.75)
	
	--initializes instances
	scene:init(1)
  player:init();
  player:initHUD();
end

--Runs continously. Different code for each different game state
function gameloop:run()	
	actualScore.text = score:get();

  player:run(); --runs player controls
  enemy:randomSpawn(player:getX(), player:getY()) --spawns enemies randomly
  enemy:run(); --runs enemy logic
end

return gameloop;