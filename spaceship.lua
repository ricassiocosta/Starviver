--------------------------------------------------------------------------------
--
-- Controls the player and their spaceship
--
-- spaceship.lua
--
------------------------------- Private Fields ---------------------------------
local physics = require("physics")
local scene = require("scene")
local bullet = require("bullets")

local spaceship = {};
local spaceship_mt = {__index = spaceship};

local spaceshipSprite = {
	type = "image",
	filename = "imgs/starviver.png"
}

local speed, currentSpeed;
local width, lenght;
local accelerationRate;
local isShooting;
local shootCooldown;
local turnRateAngleDiff;
local lastAngle;
local lastMagnitude;

local bullets;
local collisionID;

--Constructor
function spaceship.new(_x, _y, _acceleration)
	local newSpaceship = {
	}

	currentSpeed = 0;
	accelerationRate = _acceleration;
	shootCooldown = 0;
	bulletNum = 0;
	bulletCount = 1;

	lastAngle = 0;
	lastMagnitude = 0;
	width = 100;
	lenght = 130;

	player = display.newRect( _x, _y, width, lenght )
	player.rotation = 50;

	player.healthMissing = display.newRect(display.contentWidth, 75, display.actualContentWidth-550, 100);
	player.healthMissing:setFillColor(0.3, 0.3, 0.3);
	player.healthMissing.anchorX = 1;
	player.healthMissing.anchorY = 0;
	player.healthMissing.path.x1 = -75;

	player.healthBar = display.newRect(player.healthMissing.x+75, player.healthMissing.y, player.healthMissing.width, player.healthMissing.height);
	player.healthBar:setFillColor(0.2, 0.85, 0.4);
	player.healthBar.anchorX = 1;
	player.healthBar.anchorY = 0;
	player.healthBar.path.x1 = -75;
	player.healthBar.path.x4 = -75;

	player.healthGroup = display.newGroup();
	player.healthGroup:insert(player.healthMissing);
	player.healthGroup:insert(player.healthBar);


	player.fill = spaceshipSprite;
	player.name = "Player";
	player.healthBar.health = 1000;
	player.healthBar.armour = 0;
	player.healthBar.maxHealth = 1000;
	player.damage = nil;
	player.bulletDamage = 4;
	player.damageTimeout = 0;
	player.maxSpeed = 35;
	player.speed = 0;
	player.isDead = false;

	--stores the cooldowns on the buffs gained by most powerups
	--counts down; 0 means cooldown is done
	--[[
		[1] --> speedBoost
		[2] --> double Damage
	]]
	player.powerupBuffs = {
		-1,
		-1
	}

	collisionID = 1;

	physics.addBody(player, "kinematic", {filter = {categoryBits = collisionID, maskBits = 23}});
	player.isFixedRotation = true;
	player.gravityScale = 0;

	bullets = bullet.newInstance(player, "imgs/bullet_3.png", player.width/6);

	return setmetatable( newSpaceship, spaceship_mt )
end

------------------------------ Public Functions --------------------------------
function spaceship:getX()
	return player.x;
end

function spaceship:getY()
	return player.y;
end

function spaceship:getIsDead()
	return player.isDead;
end

function spaceship:setIsShooting( _flag )
	isShooting = _flag;
end

function spaceship:setSpeed( _speed )
	player.speed = _speed;
end

function spaceship:setAcceleration( _acceleration )
	accelerationRate = _acceleration;
end

function spaceship:getHealthGroup()
	return player.healthGroup;
end

function spaceship.damage( _damage )
	if(player.damageTimeout <= 0) then
		player.damageTimeout = 300;
		player.healthBar.health = player.healthBar.health - _damage;
	elseif(player.damageTimeout <= 285) then
		player.healthBar.health = player.healthBar.health - _damage;
	end
end

function spaceship:getDisplayObject()
	return player;
end

function spaceship:updateBuffs()
	for k = 1, table.getn(player.powerupBuffs) do
		player.powerupBuffs[k] = player.powerupBuffs[k] - 1;
		if(player.powerupBuffs[k] == 0) then
		if(k == 1) then
			player.maxSpeed = 35;
			player.speed = 35;
		elseif(k == 2) then
			player:setFillColor(1, 1, 1)
			player.bulletDamage = player.bulletDamage / 2;
		end
		end
	end
end

function spaceship:translate( _x, _y, _angle )
	player.x = player.x + _x;
	player.y = player.y + _y;
	turnRateAngleDiff = (player.rotation - _angle + 180) % 360 - 180;

	if (turnRateAngleDiff > player.speed/4) then
		player.rotation = player.rotation - player.speed/4
	elseif (turnRateAngleDiff < -player.speed/4) then
		player.rotation = player.rotation + player.speed/4
	else
		player.rotation = _angle;
	end
end

function spaceship:init()
	player.damage = spaceship.damage;
	scene:addObjectToScene(player, 0);
	scene:addFocusTrack(player);
end

function spaceship:reset()
	player.isDead = false;
	player.isFixedRotation = true;
	player.bodyType = "kinematic";
	player.healthBar.health = player.healthBar.maxHealth;
	player.healthBar.width = player.healthMissing.width;
	player.x = 0; player.y = 0;
	player.rotation = 25;
	player:setLinearVelocity(0, 0);
end

function spaceship:run(joystick, fireButton) --Runs every frame
	if(player.healthBar.health <= 0) then
	  player.isDead = true;
	  player.isFixedRotation = false;
	  player.bodyType = "dynamic";
	  player.healthBar.width = 0;
	  for i = 1, table.getn(player.powerupBuffs) do
		player.powerupBuffs[i] = 0;
	  end
	  self:updateBuffs();
	else
	  if (joystick:isInUse() == true) then
		if (player.speed < player.maxSpeed) then
		  player.speed = player.speed + (accelerationRate * joystick:getMagnitude());
		end
		currentSpeed = joystick:getMagnitude() * player.speed;
		spaceship:translate(currentSpeed * math.sin(math.rad(joystick:getAngle())),
					  -currentSpeed * math.cos(math.rad(joystick:getAngle())),
					  joystick:getAngle());
		lastAngle = joystick:getAngle();
		lastMagnitude = joystick:getMagnitude();
	  elseif (player.speed > 0) then
  
	  player.speed = player.speed - accelerationRate;
	  currentSpeed = player.speed;
  
	  spaceship:translate(lastMagnitude * math.sin(math.rad(lastAngle)) * player.speed,
					-lastMagnitude * math.cos(math.rad(lastAngle)) * player.speed,
					lastAngle);
  
	  end
  
	  if (fireButton:isPressed() == true) then
		isShooting = true;
	  else
		isShooting = false;
	  end
  
	  shootCooldown = shootCooldown + 1;
	  if(isShooting == true and shootCooldown > (8)) then
		bullets:shoot(4);
		bullets:shoot(4, 2 - (currentSpeed/36.5));
		bullets:shoot(4, -2 + (currentSpeed/36.5));
		shootCooldown = 0;
	  end
  
	  player.damageTimeout = player.damageTimeout - 1;
	  if(player.damageTimeout <= 299) then
		player.isVisible = true;
	  else
		player.isVisible = not player.isVisible;
	  end
	  spaceship:updateBuffs();
	end
  
	--Updates the healthbar
	player.healthBar.healthPercent = (player.healthBar.health/player.healthBar.maxHealth)
	player.healthBar.width = player.healthBar.healthPercent*player.healthMissing.width;
  
	if(player.healthBar.healthPercent < 0.5) then
	  player.healthBar.g = player.healthBar.healthPercent + 0.3;
	  player.healthBar.r = 0.8;
	else
	  player.healthBar.g = 0.8;
	  player.healthBar.r = -player.healthBar.healthPercent + 1.3;
	end
	player.healthBar:setFillColor(player.healthBar.r,
								  player.healthBar.g,
								  0.4);
  
	bullets:removeBullets();
  
	player.x = player.x;
	player.y = player.y;
end

return spaceship;