local joystick = require("joystick");

local spaceship = {};
local spaceship_mt = {};

local spaceshipSprite = {
	type = "image",
	filename = "imgs/starviver.png"
}

local x;
local y;
local speed;
local accelerationRate;
local isShooting;
local speedText;
local lastAngle;
local lastMagnitude;

function spaceship.new(_x, _y, _acceleration)
	local newSpaceship = {
		x = _x;
		y = _y;
		speed = _speed;
	}
	x = _x;
	y = _y;
	speed = 0;
	accelerationRate = _acceleration;
	lastAngle = 0;
	lastMagnitude = 0;

	player = display.newRect( _x, _y, 300, 400 )
	player.fill = spaceshipSprite;
	player:scale( 0.7, 0.7 )

	speedText = display.newText("0", 1200, 300, "Arial", 72)

	return setmetatable( newSpaceship, spaceship_mt )
end

function spaceship:getX()
	return x;
end

function spaceship:getY(  )
	return y;
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

function spaceship:setSpeed( _speed )
	speed = _speed;
end

function spaceship:setAcceleration( _acceleration )
	accelerationRate = _acceleration;
end

function spaceship:translate( _x, _y, _angle )
	player.x = player.x + _x;
	player.y = player.y + _y;
	player.rotation = _angle
end

function spaceship:run( )
	if(joystick:isInUse() == false and (speed) > 0) then
		speed = speed - accelerationRate;
		spaceship:translate( lastMagnitude * math.sin(math.rad(lastAngle)) * speed, 
							-lastMagnitude * math.cos(math.rad(lastAngle)) * speed,
							 lastAngle);
	elseif(joystick:isInUse() == true) then
		if(speed < 100) then
			speed = speed + accelerationRate;
		end
		spaceship:translate( joystick:getMagnitude() * math.sin(math.rad(joystick:getAngle())) * speed,
							-joystick:getMagnitude() * math.cos(math.rad(joystick:getAngle())) * speed, 
							 joystick:getAngle());
		lastAngle = joystick:getAngle();
		lastMagnitude = joystick:getMagnitude();
	end

	speedText.text = speed;
end

return spaceship;