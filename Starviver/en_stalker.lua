--------------------------------------------------------------------------------
--
-- Stalker enemy
-- Inherited from enemy.lua
--
-- en_stalker.lua
--
------------------------------- Private Fields ---------------------------------

stalker = {};
stalker.__index = stalker;

------------------------------ Public Functions --------------------------------

function stalker.new(_x, _y)
  local newStalker = {
  }

  newStalker.x = _x or math.random(-1000, 1000);
  newStalker.y = _y or math.random(-1000, 1000);
  newStalker.width = 160
  newStalker.height = 200
  newStalker.maxSpeed = 50
  newStalker.acceleration = 0.75;

  newStalker.sprite = display.newRect(newStalker.x, newStalker.y, newStalker.width, newStalker.height);

  newStalker.speed = 0;

  setmetatable(newStalker, stalker);
end

function stalker:getSpeed(  )
  return self.speed;
end

function stalker:getX(  )
  return self.x;
end

function stalker:getY(  )
  return self.y;
end

function stalker:getDisplayObject(  )
  return self.sprite;
end

function stalker:init( _filepath )
  self.sprite.fill = {type = "image", filename = _filepath}
end

function stalker:run(  )
  self.x = self.sprite.x;
  self.y = self.sprite.y;
  self.width = self.sprite.width;
  self.height = self.sprite.height;
end

return stalker;