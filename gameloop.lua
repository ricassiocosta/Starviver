-- The game logic and loop
local spaceship = require("spaceship")
local physics = require("physics")
local scene = require("scene")
local enemies = require("enemies")
local powerup = require("powerup_manager")
local radarClass = require("radar")
local score = require("score")
local gui = require("gui");

------------------------------- Private Fields ---------------------------------

local gameloop = {};
local gameloop_mt = {};
local gameState = 0;

--[[  GameStates
	0 = not initialized
	1 = main menu
	2 = gameplay
	3 = pause menu
	4 = gameover
]] 

local player;
local testEn;
local enemy;
local powerups;
local hud;

------------------------------ Public Functions --------------------------------

-- Runs once to initialize the game
-- Runs everytime the game state changes
function gameloop:init()
	--math.randomseed(os.time()); math.random( ); math.random( );
	system.activate("multitouch")
	native.setProperty("androidSystemVisibility", "immersiveSticky");
	display.setStatusBar(display.HiddenStatusBar);
  	--physics.setDrawMode("hybrid");
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

  	--initializes the hud
  	hud = gui.class();
end

--Runs continously. Different code for each different game state
function gameloop:run()
	if(false) then
	  gameState = 4;
	end
  
	if(gameState == 2) then
  
	  player:run(); --runs player controls
  
	  --enemy:randomSpawn(player:getX(), player:getY()) --spawns enemies randomly
	  enemy:run({}); --runs enemy logic
  
	  --powerups:randomSpawn(player:getX(), player:getY()) --spawns powerups randomly
	  powerups:run();
	  hud:run();
	elseif(gameState == 4) then
	  --if player.getGameOverBG().alpha <= 0.9 then
	  --  player.getGameOverBG().alpha = player.getGameOverBG().alpha + 0.01
	  --else
	  --  gameOverText.text = "gaem is ded"
	  --end
	end
  end

return gameloop;