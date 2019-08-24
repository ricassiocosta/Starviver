local button = {};
local button_mt = {__index = button};

local r, g, b;
local width, height;
local x, y;
local isPressed;
local isToggleable;
local tag;

local btnCircle;

function button.new( _x, _y, _width, _height, _toggleable, _r, _g, _b, _tag )
	local newButton = {
		x = _x;
		y = _y;
		width = _width;
		height = _height;
		tag = _tag;
		color = {_r/255, _g/255, _b/255};
		isToggleable = _toggleable;
	}

	x = _x;
	y = _y;
	width = _width;
	height = _height;
	tag = _tag or "button";
	isToggleable = _toggleable or false;
	isPressed = false;
	r = _r or 1;
	g = _g or 1;
	b = _b or 1;

	btnCircle = display.newCircle(x, y, width, height);
	btnCircle:setFillColor(r, g, b)
	return setmetatable(newButton, button_mt);
end

local function run( event )
	if(event.phase == "began") then
		if(isToggleable == false) then
			btnCircle.width = btnCircle.width / 1.5
			btnCircle.height = btnCircle.height / 1.5
			isPressed = true;
		else
			isPressed = not isPressed;
			if(isPressed) then
				btnCircle.width = btnCircle.width / 1.5
				btnCircle.height = btnCircle.height / 1.5
			else
				btnCircle.width = btnCircle.width * 1.5
				btnCircle.height = btnCircle.height * 1.5
			end
		end
	elseif(event.phase == "ended" or event.phase == "canceled") then
		if(isToggleable == false) then
			btnCircle.width = btnCircle.width * 1.5
			btnCircle.height = btnCircle.height * 1.5
			isPressed = false;
		end
	end
end

function button:init(  )
	btnCircle:addEventListener("touch", run);
end

function button:isPressed(  )
	return isPressed;
end

function button:setCoordinates( _x, _y )
	x = _x;
	y = _y;
end

return button;