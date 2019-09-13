--------------------------------------------------------------------------------
--
-- Controls the basic, common logic of enemies
--
-- enemy.lua
--
------------------------------- Private Fields ---------------------------------
enemy = {};
enemy_mt = {__index = enemy}; --metatable

local x,y
local width, height;
local maxSpeed;
local acceleration;
local sprite;

local speed;

------------------------------ Public Functions --------------------------------

function enemy.new(
                  _x, _y,
                  _width, _height,
                  _maxSpeed,
                  _acceleration
                  )
  local newEnemy = {
  }

  x = _x or 0;
  y = _y or 0;
  width = _width or 256;
  height = _height or 256;
  maxSpeed = _maxSpeed or 50;
  acceleration = _acceleration or 0.75;

  sprite = display.newRect(x, y, width, height);

  speed = 0;

  return setmetatable(newEnemy, enemy_mt);
end

function enemy:getSpeed()
  return speed;
end

function enemy:getX()
  return x;
end

function enemy:getY()
  return y;
end


function enemy:init()
end

function enemy:run()
  x = sprite.x;
  y = sprite.y;
  width = sprite.width;
  height = sprite.height;
end

return enemy;