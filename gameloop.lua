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
local radarClearTimer;
local scoutEnemyCount; 

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
	radarClearTimer = 0;
	scoutEnemyCount = 101;
end

--Runs continously. Different code for each different game state
function gameloop:run()
	scene:run(player:getX(), player:getY());
	if(hud:getState() == 1) then  --MAIN MENU--
		hud:getSelf().menuGroup.isVisible = true;
		hud:getSelf().controlGroup.isVisible = false;
		player:wander();
		local menuBackgroundMusic = audio.loadSound( "audio/music/mainmenu.mp3" )
		audio.play( menuBackgroundMusic, { channel=1, loops=-1} )
		--score:clearHighscore();
	elseif(hud:getState() == 2) then  --GAMEPLAY--(KAMIKAZE)
		scene:setCameraDamping(5)
		if(isFirstRun == true) then
			scoreBoxGroup = display.newGroup();
			scoreBox = display.newRect(display.contentWidth - ((display.contentWidth) * 0.06), display.contentHeight/2 - display.contentHeight/3.5, display.contentWidth/6, display.contentHeight/12)
			scoreBox:setFillColor(0.2, 0.4, 0.85)
			scoreBoxGroup:insert(scoreBox);
			scoreBoxText = display.newText("SCORE", display.contentWidth - ((display.contentWidth) * 0.097), display.contentHeight/2 - display.contentHeight/3.6, "font/league-spartan-bold.otf", 45);
			scoreBoxGroup:insert(scoreBoxText);
			actualScore = display.newText("0", display.contentWidth - ((display.contentWidth) * 0.03), display.contentHeight/2 - display.contentHeight/3.6, "font/league-spartan-bold.otf", 45);
			scoreBoxGroup:insert(actualScore);
		end
		actualScore.text = score:get();

		audio.stop({channel = 1})
		audio.stop({channel = 3})
		local kamikazeBackgroundMusic = audio.loadSound( "audio/music/gameplay.mp3" )
		audio.play( kamikazeBackgroundMusic, { channel=2, loops=-1} )
		hud:getSelf().menuGroup.isVisible = false;
		hud:getSelf().controlGroup.isVisible = true;

		enemy:randomSpawn(player:getX(), player:getY(), {radar = hud:get(4, 1)}) --spawns enemies randomly
		powerups:randomSpawn(player:getX(), player:getY()) --spawns powerups randomly
		player:run(hud:get(4, 1), hud:get(2, 1)); --runs player controls, passes in joystick and fire button
		enemy:run({radar = hud:get(3, 1), x = player:getX(), y = player:getY()}); --runs enemy logic
		powerups:run(); --runs misc. powerup animations and event listeners
		hud:run(enemy:getAmount()); --runs HUD and GUI elements
		isFirstRun = false;
		--print(score:getHighscore());

	elseif(hud:getState() == 3) then--GAMEPLAY--(BATEDOR)
		audio.stop({channel = 1})
		audio.stop({channel = 3})
		local batedorBackgroundMusic = audio.loadSound( "audio/music/gameplay.mp3" )
		audio.play( batedorBackgroundMusic, { channel=2, loops=-1} )
		radarClearTimer = radarClearTimer + 1;
		if(radarClearTimer == 240) then
		  hud:get(3, 1):clear();
		  radarClearTimer = 0;
		end
		--player:debug();
		hud:getSelf().menuGroup.isVisible = false;
		hud:getSelf().controlGroup.isVisible = true;
		hud:getEnemyCounterGroup().isVisible = true;
	
		local enemySpawned = enemy:getAmount();
		powerups:randomSpawn(player:getX(), player:getY()) --spawns powerups randomly
		player:run(hud:get(4, 1), hud:get(2, 1)); --runs player controls, passes in joystick and fire button
		enemy:run({radar = hud:get(3, 1), x = player:getX(), y = player:getY()}); --runs enemy logic
		powerups:run(); --runs misc. powerup animations and event listeners
		hud:run(enemy:getAmount()); --runs HUD and GUI elements
	
		if (enemySpawned - enemy:getAmount() >= 1) then
		  local enemyDiff = (enemySpawned - enemy:getAmount())
		  if (scoutEnemyCount > 20) then
			enemy:batchSpawn((enemySpawned - enemy:getAmount()), {radar = hud:get(3, 1), x = player.getX(), y = player.getY()});
		  end
		  scoutEnemyCount = scoutEnemyCount - enemyDiff;
		end
		hud:setEnemyCounter(scoutEnemyCount);
	
		if(scoutEnemyCount <= 0) then
		  hud:setState(9);
		end
	elseif(hud:getState() == 4) then --GAME OVER--
		if(score:isHighscore(score:get())) then
			score:setHighscore(score:get())
		end
		display.remove(scoreBoxGroup);
		gui.class:showHighscore();
		isFirstRun = true;
		audio.stop({channel = 2})
		local overBackgroundMusic = audio.loadSound( "audio/music/gameover.mp3" )
		audio.play( overBackgroundMusic, { channel=3, loops=-1} )
		hud:showEndscreen();
		hud:getEnemyCounterGroup().isVisible = false;
	elseif(hud:getState() == 5) then --RESETTING FOR KAMIKAZE
		enemy:clear(hud:get(3, 1));
		powerups:clear();
		player:reset();
		hud:setState(2);
		hud:getEnemyCounterGroup().isVisible = false;
		score:set(0);
	elseif(hud:getState() == 6) then --PREPARING FOR MENU
		enemy:clear(hud:get(3, 1));
		powerups:clear();
		player:reset();
		hud:setState(1);
		hud:getEnemyCounterGroup().isVisible = false;
		audio.stop({channel = 3})
	elseif(hud:getState() == 7) then --RESETTING FOR BATEDOR
		enemy:clear(hud:get(3, 1));
		powerups:clear();
		player:reset();
		enemy:batchSpawn(20, {radar = hud:get(3, 1)});
		scoutEnemyCount = 100;
		if scoutEnemyCount > 20 then
			enemy:batchSpawn(20, {radar = hud:get(3, 1)});
		else
			enemy:batchSpawn(5, {radar = hud:get(3, 1)});
		  end
		hud:getEnemyCounterGroup().isVisible = true;
		hud:setState(3);
	elseif(hud:getState() == 8) then --GAME OVER AFTER BRAWL--
		hud:showFailedMissionScreen();
		audio.stop({channel = 2})
		hud:getEnemyCounterGroup().isVisible = false;
		local overBackgroundMusic = audio.loadSound( "audio/music/gameover.mp3" )
		audio.play( overBackgroundMusic, { channel=3, loops=-1} )
	elseif(hud:getState() == 9) then --Victory AFTER BRAWL--
		hud:showVictoryScreen();
		audio.stop({channel = 2})
		hud:getEnemyCounterGroup().isVisible = false;
		local overBackgroundMusic = audio.loadSound( "audio/music/gameover.mp3" )
		audio.play( overBackgroundMusic, { channel=3, loops=-1} )
	end
  
	if(player:getIsDead()) then
		if(hud:getState() == 2) then 
			hud:setState(4);
		elseif(hud:getState() == 3) then 
			hud:setState(8); 
		end
	end
end

return gameloop;