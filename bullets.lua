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


function bullets.newInstance:__init(_object)
  local newBullets = {
  }

  self.baseObject = _object; -- the object that the bullets originate from, e.g. the spaceship.

  self.bulletNum = 0;
  self.bullet = {};
  self.numberOfBulletsToRemove = 0;
end

function bullets.newInstance:init(  )
  physics.start();
  physics.setGravity(0, 0);
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
  if (event.phase == "began" and event.other.name ~= "Player") then
    self:removeSelf();
    if (event.other.name ~= "Bullet") then
      event.other.healthBar.health = event.other.healthBar.health - 20 + event.other.healthBar.armour;
      event.other.isShaking = true;
      event.other.healthBar.isVisible = true; event.other.healthMissing.isVisible = true;
    end
  end
end

function bullets.newInstance:shoot()
  self.bulletNum = table.getn(self.bullet) + 1;
  self.bullet[self.bulletNum] = display.newRect(self.baseObject.x, self.baseObject.y, self.baseObject.width/12, self.baseObject.height/3);
  self.bullet[self.bulletNum]:setFillColor(0.3, 0.6, 0.9);
  self.bullet[self.bulletNum].rotation = self.baseObject.rotation;
  self.bullet[self.bulletNum].name = "Bullet";
  self.bullet[self.bulletNum].enemyType = -1; --non enemy
  scene:addObjectToScene(self.bullet[self.bulletNum], 1);

  physics.addBody(self.bullet[self.bulletNum], "dynamic", {filter = {categoryBits=2, maskBits=4 }});
  self.bullet[self.bulletNum].isBullet = true;
  self.bullet[self.bulletNum]:setLinearVelocity(math.sin(math.rad(self.bullet[self.bulletNum].rotation))*50000, -math.cos(math.rad(self.bullet[self.bulletNum].rotation))*50000);
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