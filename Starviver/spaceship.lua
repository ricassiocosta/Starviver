local spaceship = {};
local spaceship_mt = {};

local x = 0;
local y = 0;
local isShooting = false;

function spaceship.new(_x, _y)
	local newSpaceship = {
		x = _x;
		y = _y;
	}

	display.newRect( _x, _y, 300, 300 )

	return setmetatable( newSpaceship, spaceship_mt )
end

function spaceship:getX()
	return x;
end

function spaceship:getY(  )
	return y;
end

function spaceship:setX( _x )
	x = _x;
end

function spaceship:setY( _y )
	y = _y;
end

function spaceship:translate( _x, _y )
	x = x + _x;
	y = y + _y;
end

return spaceship;