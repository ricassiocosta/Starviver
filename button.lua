--  button.lua
--
------------------------------- Private Fields ---------------------------------
local class = require ("classy");

local button = {};
button.newInstance = class("Button");

--[[
_x,
_y,
_width,
_height,
_toggleable,
_r,
_g,
_b,
_a,
_tag
]]

--Constructor
function button.newInstance:__init(params)

	self.x = params.x;
	self.y = params.y;
	self.width = params.width;
	self.height = params.height;
  
	self.btnCircle = display.newCircle(self.x, self.y, self.width, self.height);
  
	self.btnCircle.tag = params.tag or "button";
	self.btnCircle.isToggleable = params.isToggleable or false;
	self.btnCircle.isPressed = false;
	self.btnCircle.r = params.r or 1;
	self.btnCircle.g = params.g or 1;
	self.btnCircle.b = params.b or 1;
	self.btnCircle.a = params.a or 1;
  
	self.btnCircle.originalWidth = params.width;
	self.btnCircle.originalHeight = params.height;
	self.btnCircle.originalX = params.x;
	self.btnCircle.originalY = params.y;
	self.btnCircle:setFillColor(self.btnCircle.r, self.btnCircle.g, self.btnCircle.b, self.btnCircle.a);
  
	--initializes the touch input
	self.btnCircle.touch = self.run;
	self.btnCircle:addEventListener("touch", self.btnCircle);
  end

------------------------------ Public Functions --------------------------------

function button.newInstance:run(event)
	if(event.phase == "began") then
		if(event.target.isPressed == false) then
			display.getCurrentStage():setFocus(event.target)
			event.target.width = event.target.width / 1.5
			event.target.height = event.target.height / 1.5
			event.target.isPressed = true;
		end
	elseif(event.phase == "ended" or event.phase == "canceled") then
		if(event.target.isPressed == true) then
			event.target.width = event.target.width * 1.5
			event.target.height = event.target.height * 1.5
			event.target.isPressed = false;
			display.getCurrentStage():setFocus(nil)
		end
	end
end
  
function button.newInstance:getDisplayObject()
	return self.btnCircle;
end

function button.newInstance:isPressed()
	return self.btnCircle.isPressed;
end

function button.newInstance:setCoordinates(_x, _y)
	self.btnCircle.x = _x;
	self.btnCircle.y = _y;
end

return button;