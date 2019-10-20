local joystick = require("joystick");
local physics = require("physics")
local scene = require("scene")
local bullet = require("bullets")

local spaceship = {};
local spaceship_mt = {__index = spaceship};

local spaceshipSprite = {
	type = "image",
	filename = "imgs/starviver.png"
}

local speed, maxSpeed, currentSpeed;
local width, lenght;
local accelerationRate;
local isShooting;
local shootCooldown;
local turnRateAngleDiff;
local lastAngle;
local lastMagnitude;

local bullets;
local collisionID;

function spaceship.new(_x, _y, _acceleration)
	local newSpaceship = {
		speed = 0;
	}
	speed = 0;
	currentSpeed = 0;
	maxSpeed = 30;
	accelerationRate = _acceleration;
	shootCooldown = 0;
	bulletNum = 0;
	bulletCount = 1;

	lastAngle = 0;
	lastMagnitude = 0;
	width = 100;
	lenght = 130;

	player = display.newRect( _x, _y, width, lenght )

	player.healthBar = display.newRect(_x, _y - 100, 150, 20);
  	player.healthBar:setFillColor(50/255, 100/255, 255/255);
  	player.healthMissing = display.newRect(_x, _y - 100, 150, 20);
  	player.healthMissing:setFillColor(255/255, 100/255, 60/255);

	player.fill = spaceshipSprite;
	player.name = "Player";
	player.healthBar.health = 1000;
	player.healthBar.armour = 0;
	player.maxHealth = 1000;
	player.damage = nil;
	player.damageTimeout = 0;

	collisionID = 1;

	physics.addBody(player, "kinematic", {filter = {categoryBits = collisionID, maskBits = 7}});

	bullets = bullet.newInstance(player, "imgs/bullet_3.png", player.width / 3, player.height/1.25);

	return setmetatable( newSpaceship, spaceship_mt )
end

function spaceship:getDisplayObject(  )
	return player;
end

function spaceship:getX()
	return player.x;
end

function spaceship:getY(  )
	return player.y;
end

function spaceship:getSpeed(  )
	return speed;
end

function spaceship:setX( _x )
	x = _x;
end

function spaceship:setY( _y )
	y = _y;
end

function spaceship:setIsShooting( _flag )
	isShooting = _flag;
end

function spaceship:setSpeed( _speed )
	speed = _speed;
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

function spaceship:init(  )
	player.damage = spaceship.damage;
	scene:addObjectToScene(player, 0);
	scene:addObjectToScene(player.healthMissing, 0);
	scene:addObjectToScene(player.healthBar, 0);
	scene:addFocusTrack(player);
	player.healthBar.x = player.x - ((player.healthMissing.width - player.healthBar.width)/2);
end

function spaceship:translate( _x, _y, _angle )
	player.x = player.x + _x;
	player.y = player.y + _y;
	turnRateAngleDiff = (player.rotation - _angle + 180) % 360 - 180;

	if (turnRateAngleDiff > speed/4) then
		player.rotation = player.rotation - speed/4
	elseif (turnRateAngleDiff < -speed/4) then
		player.rotation = player.rotation + speed/4
	else
		player.rotation = _angle;
	end
end

function spaceship:run( ) --Runs every fram

	player.healthBar.width = (player.healthBar.health/player.maxHealth) * player.healthMissing.width;

	--Moves the healthbar with player
	player.healthBar.y = player.y - 100 - speed * lastMagnitude * math.cos(math.rad(lastAngle));
	player.healthBar.x = player.x - ((player.healthMissing.width - player.healthBar.width)/2) + speed * lastMagnitude * math.sin(math.rad(lastAngle));
	player.healthMissing.y = player.y - 100 - speed * lastMagnitude * math.cos(math.rad(lastAngle));
	player.healthMissing.x = player.x + speed * lastMagnitude * math.sin(math.rad(lastAngle));
	
	if(joystick:isInUse() == false and (speed) > 0) then
		speed = speed - accelerationRate;
		currentSpeed = speed;
		spaceship:translate( lastMagnitude * math.sin(math.rad(lastAngle)) * speed, 
							-lastMagnitude * math.cos(math.rad(lastAngle)) * speed,
							 lastAngle);
	elseif(joystick:isInUse() == true) then
		if(speed < maxSpeed) then
			speed = speed + (accelerationRate * joystick:getMagnitude());
		end
		currentSpeed = joystick:getMagnitude() * speed;
		spaceship:translate( joystick:getMagnitude() * math.sin(math.rad(joystick:getAngle())) * speed,
							-joystick:getMagnitude() * math.cos(math.rad(joystick:getAngle())) * speed, 
							 joystick:getAngle());
		lastAngle = joystick:getAngle();
		lastMagnitude = joystick:getMagnitude();
	end

	shootCooldown = shootCooldown + 1;

	if(isShooting == true and shootCooldown > (8)) then
		bullets:shoot(4);
		bullets:shoot(4, 15 - (speed/3));
		bullets:shoot(4, -15 + (speed/3));
		shootCooldown = 0
	end
	bullets:removeBullets();

	print("PLAYER:" .. table.maxn(bullets:getTable()))

	if(player.damageTimeout <= 295) then
		player.isVisible = true;
	else
		player.isVisible = not player.isVisible;
	end

	player.damageTimeout = player.damageTimeout - 1;
	if(player.damageTimeout <= 0 and player.healthBar.health < player.maxHealth) then
		player.healthBar.health = player.healthBar.health + 1;
	end
end

return spaceship;