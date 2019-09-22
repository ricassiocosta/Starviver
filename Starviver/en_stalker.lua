--------------------------------------------------------------------------------
--
-- Controls the basic, common logic of enemies
--
-- en_stalker.lua
--
------------------------------- Private Fields ---------------------------------
local scene = require("scene")

stalker = {};
stalker.__index = stalker;
------------------------------ Public Functions --------------------------------

function stalker.new( _x, _y)
  local instance = {
  }

  instance.x = _x or math.random(-1000, 1000);
  instance.y = _y or math.random(-1000, 1000);
  instance.layer = _layer or 1;
  instance.index = index;

  instance.width = 160
  instance.height = 200
  instance.sprite = display.newRect(instance.x, instance.y, instance.width, instance.height);
  instance.speed = 0;

  instance.properties = {
    enemyType = 1, --stalker
    canShoot = true,
    maxSpeed = 45,
    acceleration = 1,
    health = 30,
    name = "Perseguidores",
    description = "Rápidos e leves, os Perseguidores são caçadores perigosos que estão sempre dispostos a adicionar uma nova estrela no universo"
  }

  return setmetatable(instance, stalker);
end

function stalker:getSpeed()
  return self.speed;
end

function stalker:getX()
  return self.x;
end

function stalker:getY()
  return self.y;
end

function stalker:getDisplayObject()
  return self.sprite;
end

function stalker:getDiscription(  )
  return self.properties.description;
end

function stalker:init()
  self.sprite.fill = {type = "image", filename = "imgs/stalker.png"}
  scene:addObjectToScene(self.sprite, self.layer);
end

function stalker:run()
  self.x = self.sprite.x;
  self.y = self.sprite.y;
  self.width = self.sprite.width;
  self.height = self.sprite.height;
end

return stalker;