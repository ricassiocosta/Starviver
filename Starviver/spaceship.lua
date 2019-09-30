local joystick = require("joystick");
local physics = require("physics")
local scene = require("scene")
local bullets = require("bullets")
local enemy = require("enemies")

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

local debug_speedText;
local debug_currentSpeed;
local debug_bulletNum;
local debug_spaceshipX, debug_spaceshipY;

function spaceship.new(_x, _y, _acceleration)
	local newSpaceship = {
		speed = 0;
	}
	speed = 0;
	currentSpeed = 0;
	maxSpeed = 50;
	accelerationRate = _acceleration;
	shootCooldown = 0;
	bulletNum = 0;
	bulletCount = 1;

	lastAngle = 0;
	lastMagnitude = 0;
	width = 170;
	lenght = 220;

	player = display.newRect( _x, _y, width, lenght )
	player.fill = spaceshipSprite;
	player:scale( 0.5, 0.5 )
	player.name = "Player";
	player.health = 100;
	player.maxHealth = 100;

	healthBar = display.newRect(_x, _y - 100, 150, 20);
	healthBar:setFillColor(100/255, 255/255, 60/255);
	healthMissing = display.newRect(_x, _y - 100, 150, 20);
	healthMissing:setFillColor(255/255, 100/255, 60/255);

	bullets.new(player);

	debug_speedText = display.newText("", 1200, 300, "Arial", 72)
	debug_currentSpeed = display.newText("", 500, 300, "Arial", 72)
	debug_spaceshipX = display.newText("", 1400, 500, "Arial", 72)
	debug_spaceshipY = display.newText("", 1400, 600, "Arial", 72)
	debug_bulletNum = display.newText("", 500, 900, "Arial", 72)

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

function spaceship:init(  )
	bullets:init();
	scene:addObjectToScene(player, 0);
	scene:addObjectToScene(healthMissing, 0);
	scene:addObjectToScene(healthBar, 0);
	scene:addFocusTrack(player);
	healthBar.x = player.x - ((healthMissing.width - healthBar.width)/2);
end

function spaceship:translate( _x, _y, _angle )
	player.x = player.x + _x;
	player.y = player.y + _y;
	turnRateAngleDiff = (player.rotation - _angle + 180) % 360 - 180;

	if (turnRateAngleDiff > speed/2) then
		player.rotation = player.rotation - speed/4
	elseif (turnRateAngleDiff < -speed/2) then
		player.rotation = player.rotation + speed/4
	else
		player.rotation = _angle;
	end
end

function spaceship:debug(  )
	debug_speedText.text = speed;
	debug_spaceshipX.text = player.x;
	debug_spaceshipY.text = player.y;
	debug_currentSpeed.text = currentSpeed;
end

function spaceship:run( )

	healthBar.width = (player.health/player.maxHealth) * healthMissing.width;

	healthBar.y = player.y - 100 - currentSpeed * math.cos(math.rad(lastAngle));
	healthBar.x = player.x - ((healthMissing.width - healthBar.width)/2) + currentSpeed * math.sin(math.rad(lastAngle));
	healthMissing.y = player.y - 100 - currentSpeed * math.cos(math.rad(lastAngle));
	healthMissing.x = player.x + currentSpeed * math.sin(math.rad(lastAngle));
	
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
		bullets:shoot();
		shootCooldown = 0
	end
	bullets:removeBullets();
end

return spaceship;