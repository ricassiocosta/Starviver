--------------------------------------------------------------------------------
--
-- ENEMY: stalker
--
-- en_stalker.lua
--
------------------------------- Private Fields ---------------------------------
local scene = require("scene");
local physics = require("physics");

stalker = {};
stalker.__index = stalker;
------------------------------ Public Functions --------------------------------

function stalker.new( _x, _y, index, _layer)
  local instance = {
  }

  instance.x = _x or math.random(-1000, 1000);
  instance.y = _y or math.random(-1000, 1000);
  instance.layer = _layer or 1;
  instance.index = index;

  instance.width = 160;
  instance.height = 200;
  instance.sprite = display.newRect(instance.x, instance.y, instance.width, instance.height);
  instance.speed = 0;

  --Used for shaking the object when hit
  instance.shakeMax = 15;
  instance.shakeAmount = 0;
  instance.isShaking = false;

  instance.enemyType = 1; --stalker
  instance.canShoot = true;
  instance.maxSpeed = 42;
  instance.acceleration = 1;
  instance.health = 30;
  instance.Armour = 1;
  instance.name = "Perseguidores";
  instance.description = "Rápidos e leves, os Perseguidores são caçadores perigosos que estão sempre dispostos a adicionar uma nova estrela no universo.";

  return setmetatable(instance, stalker);
end

function stalker:shake()
  if(self.isShaking == true) then
    if(self.shakeMax <= 1) then
      self.shakeMax = 15;
      self.isShaking = false;
    else
      self.shakeAmount = math.random(self.shakeMax);
      self.x = self.x + math.random(-self.shakeAmount, self.shakeAmount);
      self.y = self.y + math.random(-self.shakeAmount, self.shakeAmount);
      self.shakeMax = self.shakeMax - 0.85;
    end
  end
end

function stalker:init()
  self.sprite.fill = {type = "image", filename = "imgs/stalker.png"};
  physics.addBody(self.sprite, "kinematic")
  scene:addObjectToScene(self.sprite, self.layer);
end

function stalker:run()
  if (self.health <= 0) then
    self.sprite:removeSelf();
  else
    self:shake();
    self.sprite.x = self.x;
    self.sprite.y = self.y;
  end
end

return stalker;