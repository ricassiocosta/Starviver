--------------------------------------------------------------------------------
--
-- Controls the basic, common logic of enemies
--
-- en_asteroid.lua
--
------------------------------- Private Fields ---------------------------------
local scene = require("scene")
local physics = require("physics")

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

  instance.enemyType = 2; --asteroid
  instance.canShoot = false;
  instance.maxSpeed = 20;
  instance.acceleration = 0.6;
  instance.health = 60;
  instance.Armour = 0;
  instance.name = "Asteroides";
  instance.description = "Cuidado! Você não vai querer ser atingido por eles!";

  return setmetatable(instance, asteroid);
end

function asteroid:init()
  self.sprite.fill = {type = "image", filename = "imgs/asteroid.png"}
  physics.addBody(self.sprite, "kinematic")
  scene:addObjectToScene(self.sprite, self.layer);
end

function asteroid:run()
  self.x = self.sprite.x;
  self.y = self.sprite.y;
  self.width = self.sprite.width;
  self.height = self.sprite.height;
end

return asteroid;