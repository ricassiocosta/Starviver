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

	player.healthBar = display.newRect(_x, _y - 100, 150, 20);
  	player.healthBar:setFillColor(50/255, 100/255, 255/255);
  	player.healthMissing = display.newRect(_x, _y - 100, 150, 20);
  	player.healthMissing:setFillColor(255/255, 100/255, 60/255);

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
	scene:addObjectToScene(player.healthMissing, 0);
	scene:addObjectToScene(player.healthBar, 0);
	scene:addFocusTrack(player);
	player.healthBar.x = player.x - ((player.healthMissing.width - player.healthBar.width)/2);
end

function spaceship:run(joystick, fireButton ) --Runs every frame
	if(player.healthBar.health <= 0) then
		player.isDead = true;
		player.isFixedRotation = true;
		player.bodyType = "dynamic";
		player.density = 3.0;
		player:applyAngularImpulse(math.random(1200));
	else
		spaceship:updateBuffs();
		player.healthBar.width = (player.healthBar.health/player.healthBar.maxHealth) * player.healthMissing.width;

		--Moves the healthbar with player
		player.healthBar.y = player.y - 100 - player.speed * lastMagnitude * math.cos(math.rad(lastAngle));
		player.healthBar.x = player.x - ((player.healthMissing.width - player.healthBar.width)/2) + player.speed * lastMagnitude * math.sin(math.rad(lastAngle));
		player.healthMissing.y = player.y - 100 - player.speed * lastMagnitude * math.cos(math.rad(lastAngle));
		player.healthMissing.x = player.x + player.speed * lastMagnitude * math.sin(math.rad(lastAngle));
		
		if (fireButton:isPressed() == true) then 
			isShooting = true;
		else
			isShooting = false;
		end

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

		bullets:removeBullets();
		shootCooldown = shootCooldown + 1;

		if(isShooting == true and shootCooldown > (8)) then
			bullets:shoot(4);
			bullets:shoot(4, 2 - (currentSpeed/36.5));
			bullets:shoot(4, -2 + (currentSpeed/36.5));
			shootCooldown = 0
		end

		if(player.damageTimeout <= 299) then
			player.isVisible = true;
		else
			player.isVisible = not player.isVisible;
		end

		player.damageTimeout = player.damageTimeout - 1;
		if(player.damageTimeout <= 0 and player.healthBar.health < player.healthBar.maxHealth) then
			player.healthBar.health = player.healthBar.health + 1;
		end

		player.x = player.x;
		player.y = player.y;
	end
end

return spaceship;