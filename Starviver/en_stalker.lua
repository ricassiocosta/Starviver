--------------------------------------------------------------------------------
--
-- Stalker enemy
-- Inherited from enemy.lua
--
-- en_stalker.lua
--
------------------------------- Private Fields ---------------------------------
require ("enemy")

local stalker = {};
stalker.__index = stalker;

local x,y
local width, height;
local maxSpeed;
local acceleration;
local sprite;

local speed;

------------------------------ Public Functions --------------------------------

function stalker.new(_x, _y,
                      _width, _height,
                      _maxSpeed,
                      _acceleration)
  local newStalker = {
    x = _x or 0;
    y = _y or 0;
    width = _width or 256;
    height = _height or 256;
    maxSpeed = _maxSpeed or 50;
    acceleration = _acceleration or 0.75;

    speed = 0;
  }

  setmetatable(newStalker, stalker);
  return newStalker;
end
setmetatable(stalker, {__index = enemy})

return stalker;