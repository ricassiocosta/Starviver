--------------------------------------------------------------------------------
--
-- Stalker enemy
-- Inherited from enemy.lua
--
-- en_stalker.lua
--
------------------------------- Private Fields ---------------------------------
require ("enemy")

stalker = {};
stalker_mt = {stalker.__index};

local x,y
local width, height;
local maxSpeed;
local acceleration;
local sprite;

local speed;

------------------------------ Public Functions --------------------------------

function stalker.new(_x, _y,)
  local newStalker = {
  }

  x = _x or math.random(-1000, 1000);
  y = _y or math.random(-1000, 1000);
  width = 160;
  height = 200;
  maxSpeed = 50;
  acceleration = 0.75;

  sprite = display.newRect(x, y, width, height);

  speed = 0;

  setmetatable(newStalker, stalker_mt);
  return newStalker;
end

function stalker:getSpeed(  )
  return speed;
end

function stalker:getX(  )
  return x;
end

function stalker:getY(  )
  return y;
end

function stalker:getDisplayObject(  )
  return sprite;
end

function stalker:init( _filepath )
  sprite.fill = {type = "image", filename = _filepath}
end

function stalker:run(  )
  x = sprite.x;
  y = sprite.y;
  width = sprite.width;
  height = sprite.height;
end

return stalker;