local joystick = require("joystick");

local spaceship = {};
local spaceship_mt = {};

local x;
local y;
local speed;
local isShooting;

function spaceship.new(_x, _y, _speed)
	local newSpaceship = {
		x = _x;
		y = _y;
		speed = _speed
	}
	x = _x;
	y = _y;
	speed = _speed
	player = display.newRect( _x, _y, 300, 400 )

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

function spaceship:translate( _x, _y, _angle )
	player.x = player.x + _x;
	player.y = player.y + _y;
	player.rotation = _angle
end

function spaceship:run( )
	spaceship:translate(joystick:getMagnitude() * math.sin(math.rad(joystick:getAngle())) * spaceship:getSpeed(), 
						-joystick:getMagnitude() * math.cos(math.rad(joystick:getAngle())) * spaceship:getSpeed(), 
						joystick:getAngle());
end

return spaceship;