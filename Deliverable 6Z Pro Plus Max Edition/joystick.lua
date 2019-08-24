-- Joystick code, used for moving the player

local joystick = {};
local joystick_mt = {__index = joystick};

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

local angle;
local magnitude;
local xMag;
local yMag;
local background;
local stick;
local deltaRadius;
local x, y;

local angleText;
local magText;

function joystick.new( _x, _y )
	local newJoystick = {
		x = _x;
		y = _y;

		angle = 0;
		magnitude = 0;
		background = nil;
		stick = nil;
	}

	angle = 0;

	background = display.newCircle(_x, _y, display.contentWidth/8 );
	background:setFillColor( 0.4, 1, 0.32, 0.5);
	stick = display.newCircle(_x, _y, display.contentWidth/20);
	stick:setFillColor( 0.4, 1, 0.6, 1 );
	deltaRadius = (3 * display.contentWidth)/40;

	angleText = display.newText("", 500, 300, "Arial", 72);
	magText = display.newText("", 500, 500, "Arial", 72);

	return setmetatable( newJoystick, joystick_mt )
end

local function onStickHold( event )
	if (isStickFocused == true) then	
		stick.x = event.x;
		stick.y = event.y;
		xMag = 0;
		yMag = 0;
		if(event.phase == "ended" or event.phase == "canceled") then
			display.getCurrentStage():setFocus( self, nil );
			isStickFocused = false;
			stick.x = background.x;
			stick.y = background.y;
			stick:removeEventListener( "touch", onStickHold )
		end
	end
end

local function snapStick( event )
	if (event.phase == "began") then
		stick.x = event.x;
		stick.y = event.y;
		stick:addEventListener("touch", onStickHold);
		display.getCurrentStage( ):setFocus( stick , event.id )
		isStickFocused = true;
	end
end

--[[
  joystick.new
    - runs once to create a joystick object
  run
    - Runs in the game loop
    - gets user input, and returns angle and magnitude values
  getAngle
    -returns the angle of the joystick
    - Measured in degrees. 0 is up
  getMagnitude
    -returns the magnitude of the joystick
    -ranges from 0 - 1
    -calculated using center of the joystick
  init
    - runs once to initiate the joystick
    - adds the event listener that allows the joystick to move around
   run
    - Runs in the game loop
    - gets user input, and returns angle and magnitude values
]]--


function joystick:getAngle(  )
	if(stick.x - background.x < 0) then
		angle = math.deg(math.atan((stick.y - background.y)/(stick.x - background.x))) + 270;
	elseif (stick.x - background.x > 0) then
		angle = math.deg(math.atan((stick.y - background.y)/(stick.x - background.x))) + 90;
	elseif (stick.x - background.x == 0) then
		if(stick.y - background.y > 0) then
			angle = 180;
		else
			angle = 0;
		end
	end
	return angle;
end

function joystick:getMagnitude(  )
	magnitude = math.sqrt(math.pow((stick.x-background.x),2) + math.pow((stick.y-background.y),2)) / (background.width/2)
	if(magnitude > 1) then
		return 1
	else
		return magnitude;
	end
end

function joystick:getStickX ()
	return stick.x;
end

function joystick:getStickY(  )
	return stick.y;
end

function joystick:init()
	background:addEventListener( "touch", snapStick );
end 

function joystick:isInUse(  )
	if(joystick:getMagnitude() == 0) then
		return false;
	else 
		return true;
	end
end

function joystick:debug(  )
	angleText.text = joystick:getAngle();
	magText.text = joystick:getMagnitude();
end

return joystick;