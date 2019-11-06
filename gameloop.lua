-- The game logic and loop
local spaceship = require("spaceship")
local physics = require("physics")
local scene = require("scene")
local enemies = require("enemies")
local powerup = require("powerup_manager")
local radarClass = require("radar")
local score = require("score")
local gui = require("gui");
local progressRing = require("progressRing")

------------------------------- Private Fields ---------------------------------

local gameloop = {};
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
	--native.setProperty("androidSystemVisibility", "immersiveSticky");
	--display.setStatusBar(display.HiddenStatusBar);
  	--physics.setDrawMode("hybrid");
 	display.setDefault("background", 0/255, 32/255, 50/255);
	isFirstRun = true;
	--creates instances of classes
	enemy = enemies.new();
	player = spaceship.new(0, 0, 0.75)
	powerups = powerup:class();
	
	--initializes instances
	scene:init(1)
	player:init();

  	--initializes the hud
	hud = gui.class({player = player:getDisplayObject()});
	--adds misc. objects that belong in the HUD/GUI
	hud:insert(player:getHealthGroup(), 1) --player healthbar
	for i = 1, table.getn(powerups:getTimerObject()) do
	  	hud:insert(powerups:getTimerObject(i), 1) --all powerup timers
	end
end

--Runs continously. Different code for each different game state
function gameloop:run()
	if(hud:getState() == 1) then  --MAIN MENU--
		hud:getSelf().menuGroup.isVisible = true;
		hud:getSelf().controlGroup.isVisible = false;
		player:wander();
		local menuBackgroundMusic = audio.loadSound( "audio/music/mainmenu.mp3" )
		audio.play( menuBackgroundMusic, { channel=1, loops=-1} )
	elseif(hud:getState() == 2) then  --GAMEPLAY--
		scene:setCameraDamping(5)
		if(isFirstRun == true) then
			actualScore = display.newText("0", 1200, 300, "Arial", 72);
		end
		actualScore.text = score:get();
		audio.stop({channel = 1})
		audio.stop({channel = 3})
		local gameplayBackgroundMusic = audio.loadSound( "audio/music/gameplay.mp3" )
		audio.play( gameplayBackgroundMusic, { channel=2, loops=-1} )
		hud:getSelf().menuGroup.isVisible = false;
		hud:getSelf().controlGroup.isVisible = true;

		enemy:randomSpawn(player:getX(), player:getY(), {radar = hud:get(4, 1)}) --spawns enemies randomly
		powerups:randomSpawn(player:getX(), player:getY()) --spawns powerups randomly
		player:run(hud:get(4, 1), hud:get(2, 1)); --runs player controls, passes in joystick and fire button
		enemy:run({radar = hud:get(3, 1)}); --runs enemy logic
		powerups:run(); --runs misc. powerup animations and event listeners
		hud:run(); --runs HUD and GUI elements
		isFirstRun = false;
	elseif(hud:getState() == 4) then --GAME OVER--
		if(score:isHighscore(score:get())) then
			score:setHighscore(score:get())
		end
		--display.remove(actualScore)
		--finalScore = display.newText(score:get(), 1500, 600, "Arial", 72);
		transition.to(actualScore, {time = 100, x = 1500, y = 600});
		isFirstRun = true;
		audio.stop({channel = 2})
		local overBackgroundMusic = audio.loadSound( "audio/music/gameover.mp3" )
		audio.play( overBackgroundMusic, { channel=3, loops=-1} )
		hud:showEndscreen();
	elseif(hud:getState() == 5) then --RESETTING
		enemy:clear(hud:get(3, 1));
		powerups:clear();
		player:reset();
		hud:setState(2);
		score:set(0);
		display.remove(actualScore)
	elseif(hud:getState() == 6) then --PREPARING FOR MENU
		enemy:clear(hud:get(3, 1));
		powerups:clear();
		player:reset();
		hud:setState(1);
		audio.stop({channel = 3})
		display.remove(actualScore)
	end
  
	if(player:getIsDead() and hud:getState() == 2) then
	  	hud:setState(4);
	end
end

return gameloop;