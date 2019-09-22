--------------------------------------------------------------------------------
--
-- Controls the basic, common logic of enemies
--
-- en_asteroid.lua
--
------------------------------- Private Fields ---------------------------------
asteroid = {};
asteroid.__index = asteroid;
------------------------------ Public Functions --------------------------------

function asteroid.new(_x, _y, _index)
  local newAsteroid = {
  }

  newAsteroid.x = _x or math.random(-1000, 1000);
  newAsteroid.y = _y or math.random(-1000, 1000);
  newAsteroid.width = math.random(100, 500);
  newAsteroid.height = math.random(100, 500);
  newAsteroid.maxSpeed = 50
  newAsteroid.acceleration = 0.75;
  newAsteroid.sprite = display.newRect(newAsteroid.x, newAsteroid.y, newAsteroid.width, newAsteroid.height);
  newAsteroid.speed = 0;

  newAsteroid.index = _index;
  newAsteroid.enemyType = 1; --asteroid

  return setmetatable(newAsteroid, asteroid);
end

function asteroid:getSpeed()
  return self.speed;
end

function asteroid:getX()
  return self.x;
end

function asteroid:getY()
  return self.y;
end

function asteroid:getDisplayObject()
  return self.sprite;
end

function asteroid:init()
  self.sprite.fill = {type = "image", filename = "imgs/asteroid.png"}
end

function asteroid:run()
  self.x = self.sprite.x;
  self.y = self.sprite.y;
  self.width = self.sprite.width;
  self.height = self.sprite.height;
end

return asteroid;