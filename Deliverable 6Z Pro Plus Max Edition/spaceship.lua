local joystick = require("joystick");
local physics = require("physics")
local scene = require("scene")

local spaceship = {};
local spaceship_mt = {__index = spaceship};

local spaceshipSprite = {
	type = "image",
	filename = "imgs/starviver.png"
}

local speed;
local maxSpeed;
local accelerationRate;
local isShooting;
local shootCooldown;
local lastAngle;
local lastMagnitude;
local bulletNum;
local bullets = {};

local debug_speedText;
local debug_spaceshipX, debug_spaceshipY;

function spaceship.new(_x, _y, _acceleration)
	local newSpaceship = {
		speed = 0;
	}
	speed = 0;
	maxSpeed = 45;
	accelerationRate = _acceleration;
	shootCooldown = 0;
	bulletNum = 0;

	lastAngle = 0;
	lastMagnitude = 0;

	player = display.newRect( _x, _y, 300, 400 )
	player.fill = spaceshipSprite;
	player:scale( 0.7, 0.7 )

	debug_speedText = display.newText("0", 1200, 300, "Arial", 72)
	debug_spaceshipX = display.newText("", 1400, 500, "Arial", 72)
	debug_spaceshipY = display.newText("0", 1400, 600, "Arial", 72)

	return setmetatable( newSpaceship, spaceship_mt )
end

function spaceship:getDisplayObject(  )
	return player;
end

function spaceship:getX()
	return player;
end

function spaceship:getY(  )
	return player;
end

function spaceship:getSpeed(  )
	return speed;
end

function spaceship:getBullets(  )
	return bullets;
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
	physics.start()
	physics.setGravity(0, 0)
end

function spaceship:translate( _x, _y, _angle )
	player.x = player.x + _x;
	player.y = player.y + _y;
	player.rotation = _angle
end

function spaceship:debug(  )
	debug_speedText.text = speed;
	debug_spaceshipX.text = player.x;
	debug_spaceshipY.text = player.y;
end

function spaceship:run( )
	
	if(joystick:isInUse() == false and (speed) > 0) then
		speed = speed - accelerationRate;
		spaceship:translate( lastMagnitude * math.sin(math.rad(lastAngle)) * speed, 
							-lastMagnitude * math.cos(math.rad(lastAngle)) * speed,
							 lastAngle);
	elseif(joystick:isInUse() == true) then
		if(speed < maxSpeed) then
			speed = speed + accelerationRate;
		end
		spaceship:translate( joystick:getMagnitude() * math.sin(math.rad(joystick:getAngle())) * speed,
							-joystick:getMagnitude() * math.cos(math.rad(joystick:getAngle())) * speed, 
							 joystick:getAngle());
		lastAngle = joystick:getAngle();
		lastMagnitude = joystick:getMagnitude();
	end

	shootCooldown = shootCooldown + 1;

	if(isShooting == true and shootCooldown > 12) then
		spaceship:shoot();
	end

end

function spaceship:shoot(  )
	bulletNum = bulletNum + 1;
	bullets[bulletNum] = display.newRect(player.x, player.y, 25, 200);
	bullets[bulletNum]:setFillColor( 0.3, 0.6, 0.9 );
	bullets[bulletNum].rotation = player.rotation;
	scene:addObjectToScene(bullets[bulletNum], 2)


	physics.addBody( bullets[bulletNum], "kinematic" );
	bullets[bulletNum]:setLinearVelocity(math.sin(math.rad(bullets[bulletNum].rotation)) * 50000, 
										-math.cos(math.rad(bullets[bulletNum].rotation)) * 50000)
	shootCooldown = 0;
end

return spaceship;