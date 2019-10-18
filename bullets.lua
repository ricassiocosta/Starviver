--------------------------------------------------------------------------------
--
-- Contains all logic for bullets and their interaction with other entities
--
-- bullets.lua
--

local physics = require("physics");
local scene = require("scene");
local class = require("classy")

local bullets = {};
bullets.newInstance = class("BulletClass")


function bullets.newInstance:__init(_object,
                                    _image,
                                    _width,
                                    _height,
                                    _speed)

  self.baseObject = _object; -- the object that the bullets originate from, e.g. the spaceship.

  if(_image ~= nil) then
    self.imagePath = _image;
  end
  self.width = _width or self.baseObject.width/8;
  self.height = _height or self.baseObject.height/3;
  self.speed = _speed or 5000;

  self.bulletNum = 0;
  self.bullet = {};
  self.numberOfBulletsToRemove = 0;
end

function bullets.newInstance:getTable()
  return self.bullet;
end

function bullets:getX( _index )
  if (table.getn(self.bullet) >= 1) then
    return self.bullet[_index].x;
  else 
    return -99999
  end
end

function bullets.newInstance:getY( _index )
  if (table.getn(self.bullet) >= 1) then
    return self.bullet[_index].y;
  else
    return -99999
  end
end

function onBulletCollision( self, event )
  -- runs when the bullet hits something
  if (event.phase == "began") then
    self:removeSelf();
    if (event.other.name == "Player") then
      event.other.damage(80);
    else
      event.other.healthBar.health = event.other.healthBar.health - 20 + event.other.healthBar.armour;
      event.other.isShaking = true;
      event.other.healthBar.isVisible = true; event.other.healthMissing.isVisible = true;
    end
  end
end

function bullets.newInstance:shoot(_maskBits, _angleOffset)
  _angleOffset = _angleOffset or 0;
  self.bulletNum = table.getn(self.bullet) + 1;
  self.bullet[self.bulletNum] = display.newRect(self.baseObject.x, self.baseObject.y, self.width, self.height);
  if(self.imagePath ~= nil) then
    self.bullet[self.bulletNum].fill = {type = "image", filename = self.imagePath};
  else
    self.bullet[self.bulletNum]:setFillColor(0.3, 0.6, 0.9);
  end  
  self.bullet[self.bulletNum].rotation = self.baseObject.rotation + _angleOffset;
  self.bullet[self.bulletNum].name = "Bullet";
  self.bullet[self.bulletNum].baseObject = self.baseObject;
  self.bullet[self.bulletNum].enemyType = self.baseObject.enemyType; --non-enemy
 
  scene:addObjectToScene(self.bullet[self.bulletNum], 1);

  physics.addBody(self.bullet[self.bulletNum], "dynamic", {filter = {categoryBits = 2, maskBits = _maskBits}});
  self.bullet[self.bulletNum].isBullet = true;
  self.bullet[self.bulletNum]:setLinearVelocity(math.sin(math.rad(self.bullet[self.bulletNum].rotation + _angleOffset)) * self.speed, 
                                                -math.cos(math.rad(self.bullet[self.bulletNum].rotation + _angleOffset)) * self.speed);
  physics.start();
  physics.setGravity(0, 0);
  self.bullet[self.bulletNum].collision = onBulletCollision;
  self.bullet[self.bulletNum]:addEventListener("collision", self.bullet[self.bulletNum])
end

function bullets.newInstance:removeBullets()
  for i = 0, table.getn(self.bullet) do
    if (self.bullet[i] == nil) then break
    elseif(self.bullet[i].x > (self.baseObject.x + 2000)
    or self.bullet[i].x < (self.baseObject.x - 2000) 
    or self.bullet[i].y > (self.baseObject.y + 1000) 
    or self.bullet[i].y < (self.baseObject.y - 1000)) then
      self.bullet[i]:removeSelf();
      table.remove(self.bullet, i);
    end
  end
end

return bullets;