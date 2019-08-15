-- Joystick code, used for moving the player

local joystick = {};
local joystick_mt = {};

--[[
  angle
    - Angle of the joystick_mt
    - Range = { 0 - 359 }
    - Up is 0 degrees
  magnitude
    - How far from the center the joystick has moved.
    - Higher magnitude == higher speed
    - Range = {0 - 1}
  x, y
    - Stores coordinates of joystick *center*
  background
    - Display object for back of joystick
  stick
    - Display object for movable joystick
]]--

local MAX_RANGE_OF_MOTION_PX = 144;
local angle;
local magnitude;
local background;
local stick;
local x, y;

--[[
  joystick.new
    - runs once to create a joystick object
  run
    - Runs in the game loop
    - gets user input, and returns angle and magnitude values
]]--

function joystick.new( _x, _y )
	local newJoystick = {
		x = _x;
		y = _y;

		angle = 0;
		magnitude = 0;
		background = nil;
		stick = nil;
	}

	background = display.newCircle(_x, _y, display.contentWidth/8 );
	background:setFillColor( 0.324, 0.434, 0.112, 0.3 );
	stick = display.newCircle(_x, _y, display.contentWidth/20);
	stick:setFillColor( 0.123, 0.233, 0.540 );

	return setmetatable( newJoystick, joystick_mt );
end

local function onStickHold( event )
	if(event.phase == "moved") then
		stick.x = event.x;
		stick.y = event.y;
	elseif(event.phase == "ended") then
		stick.x = background.x;
		stick.y = background.y;
	end
end

function joystick:run(  )
	stick:addEventListener( "touch", onStickHold );
end

function joystick:getAngle(  )
	return angle;
end

function joystick:getMagnitude(  )
	return magnitude;
end

return joystick;