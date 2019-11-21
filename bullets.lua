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
  self.width = _width or self.baseObject.width/4;
  self.height = _height or self.baseObject.height/1.5;
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

--gets distance, in pixel widths, to given point
function bullets.newInstance:getDistanceTo(_bulletIndex, _x, _y)
  local distance = math.sqrt(((self.bullet[_bulletIndex].x - _x) * (self.bullet[_bulletIndex].x - _x)) + ((self.bullet[_bulletIndex].y - _y) * (self.bullet[_bulletIndex].y - _y)));
  return distance or 0;
end

function onBulletCollision( self, event )
  -- runs when the bullet hits something
  if (event.phase == "began") then
    self.isDead = true;
    if (event.other.name == "Player") then
      event.other.damage(self.baseObject.damage);
    else
      event.other.healthBar.health = event.other.healthBar.health - (self.baseObject.bulletDamage * (1 - event.other.healthBar.armour));
      if(event.other.healthBar.health > event.other.healthBar.maxHealth) then event.other.healthBar.health = event.other.healthBar.maxHealth end
      event.other.isShaking = true;
      event.other.shakeMax = 24;
      event.other.healthBar.isVisible = true; event.other.healthMissing.isVisible = true;
      event.other.damaged = true;
      local soundEffect = audio.loadSound( "audio/sfx/hit1.wav" )
			audio.play( soundEffect )
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
  self.bullet[self.bulletNum].index = self.bulletNum;
  self.bullet[self.bulletNum].bulletList = self.bullet;
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

function bullets.newInstance:removeBullets(_baseObj)
  _baseObj = _baseObj or self.baseObject;
  for i = 1, table.getn(self.bullet) do
    if (self.bullet[i] == nil) then break
    elseif (self:getDistanceTo(i, _baseObj.x, _baseObj.y) > 5000 or (self.bullet[i].isDead == true or _baseObj.isDead == true)) then
      self.bullet[i]:removeSelf();
      table.remove(self.bullet, i);
    end
  end
end

return bullets;