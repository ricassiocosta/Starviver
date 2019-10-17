--------------------------------------------------------------------------------
--
-- Contains all logic for bullets and their interaction with other entities
--
-- bullets.lua
--

local physics = require("physics");
local scene = require("scene");

local bullets = {};
local bullets_mt = {__index = bullets}; --metatable

local bulletNum;
local bullet = {};
local numberOfBulletsToRemove;
local baseObject;


function bullets.new(_object)
  local newBullets = {
  }

  baseObject = _object; -- the object that the bullets originate from, e.g. the spaceship.

  bulletNum = 0;
  bullet = {};
  numberOfBulletsToRemove = 0;

  return setmetatable(newBullets, bullets_mt);
end

function bullets:init(  )
  physics.start();
  physics.setGravity(0, 0);
end

function bullets:getTable()
  return bullet;
end

function bullets:getX( _index )
  if (table.getn(bullet) >= 1) then
    return bullet[_index].x;
  else 
    return -99999
  end
end

function bullets:getY( _index )
  if (table.getn(bullet) >= 1) then
    return bullet[_index].y;
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

function bullets:shoot()
  bulletNum = table.getn(bullet) + 1;
  bullet[bulletNum] = display.newRect(baseObject.x, baseObject.y, baseObject.width/12, baseObject.height/3);
  bullet[bulletNum]:setFillColor(0.3, 0.6, 0.9);
  bullet[bulletNum].rotation = baseObject.rotation;
  bullet[bulletNum].name = "Bullet";
  bullet[bulletNum].enemyType = -1; --non enemy
  scene:addObjectToScene(bullet[bulletNum], 1);

  physics.addBody(bullet[bulletNum], "dynamic", {filter = {categoryBits=2, maskBits=4 }});
  bullet[bulletNum].isBullet = true;
  bullet[bulletNum]:setLinearVelocity(math.sin(math.rad(bullet[bulletNum].rotation))*50000, -math.cos(math.rad(bullet[bulletNum].rotation))*50000);
  bullet[bulletNum].collision = onBulletCollision;
  bullet[bulletNum]:addEventListener("collision", bullet[bulletNum])
end

function bullets:removeBullets()
  for i = 0, table.getn(bullet) do
    if (bullet[i] == nil) then break
    elseif(bullet[i].x > (baseObject.x + 2000)
    or bullet[i].x < (baseObject.x - 2000) 
    or bullet[i].y > (baseObject.y + 1000) 
    or bullet[i].y < (baseObject.y - 1000)) then
      bullet[i]:removeSelf();
      table.remove(bullet, i);
    end
  end
end

return bullets;