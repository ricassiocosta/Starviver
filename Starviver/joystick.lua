-- Joystick code, used for moving the player

local spaceship = require("spaceship");

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
local angleText = display.newText("0", 500, 300 , "Arial" , 72 );


local function onStickHold( event )
	if(event.phase == "began") then
		display.getCurrentStage( ):setFocus( self, event.id );
		isStickFocused = true;
	elseif (isStickFocused == true) then	
		if(event.phase == "moved") then
			if ((event.x < (background.x + 100)) or (event.x > (background.x - 100))) then
				stick.x = event.x;
			end
			if ((event.y < (background.y + 100)) or (event.y > (background.y - 100))) then
				stick.y = event.y;
			end

		elseif(event.phase == "ended" or event.phase == "cancelled") then
			display.getCurrentStage( ):setFocus( self, nil);
			isStickFocused = false;
			stick.x = background.x;
			stick.y = background.y;
		end
	end
	angleText.text = joystick:getAngle();
end

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
	background:setFillColor( 0.7, 0.7, 0.7);
	stick = display.newCircle(_x, _y, display.contentWidth/20);
	stick:setFillColor( 0.4, 1, 0.6 );

	return setmetatable( newJoystick, joystick_mt )
end

function joystick:getAngle(  )
	if(stick.x - background.x < 0) then
		angle = ((math.atan((stick.y - background.y)/(stick.x - background.x)))*(180/math.pi)+270);
	else 
		angle = ((math.atan((stick.y - background.y)/(stick.x - background.x)))*(180/math.pi)+90)
	end
	return angle;
end

function joystick:getMagnitude(  )
	return magnitude;
end

function joystick:run(  )
	stick:addEventListener( "touch", onStickHold );
end

return joystick;