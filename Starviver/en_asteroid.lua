--------------------------------------------------------------------------------
--
-- Controls the basic, common logic of enemies
--
-- en_asteroid.lua
--
------------------------------- Private Fields ---------------------------------
local scene = require("scene")

asteroid = {};
asteroid.__index = asteroid;
------------------------------ Public Functions --------------------------------

function asteroid.new(_x, _y, _index, _layer)
  local instance = {
  }

  instance.x = _x or math.random(-1000, 1000);
  instance.y = _y or math.random(-1000, 1000);
  instance.index = index;
  instance.layer = _layer or 1;

  instance.width = math.random(100, 500);
  instance.height = math.random(100, 500);
  instance.sprite = display.newRect(instance.x, instance.y, instance.width, instance.height);
  instance.speed = 0;

  instance.properties = {
    enemyType = 2, --asteroid
    canShoot = false,
    maxSpeed = 20,
    acceleration = 0.6,
    health = 60,
    name = "Asteroides",
    description = "Cuidado! Você não vai querer ser atingido por eles! "
  }

  return setmetatable(instance, asteroid);
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
  scene:addObjectToScene(self.sprite, self.layer);
end

function asteroid:run()
  self.x = self.sprite.x;
  self.y = self.sprite.y;
  self.width = self.sprite.width;
  self.height = self.sprite.height;
end

return asteroid;