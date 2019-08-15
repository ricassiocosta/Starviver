local spaceship = {};
local spaceship_mt {};

local x = 0;
local y = 0;

function ship.new(_x, _y)
	local newSpaceship = {
		x = _x;
		y = _y;
	}

	display.newRect( _x, _y, 300, 300 )

	return setmetatable( newSpaceship, spaceship_mt )
end

function ship:getX()
	return x;
end

function ship:getY(  )
	return y;
end

function ship:setX( _x )
	x = _x;
end

function ship:setY( _y )
	y = _y;
end

function ship:translate( _x, _y )
	x = x + _x;
	y = y + _y;
end

return spaceship;