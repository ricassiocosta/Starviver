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

  scene.new();

  return setmetatable(newBullets, bullets_mt);
end

function bullets:init(  )
  physics.start();
  physics.setGravity(0, 0);
end

function bullets:getTable()
  return bullet;
end

function bullets:shoot()
  bulletNum = table.getn(bullets) + 1;
  bullet[bulletNum] = display.newRect(baseObject.x, baseObject.y, baseObject.width/12, baseObject.height/3);
  bullet[bulletNum]:setFillColor(0.3, 0.6, 0.9);
  bullet[bulletNum].rotation = baseObject.rotation;
  scene:addObjectToScene(bullet[bulletNum], 2)

  physics.addBody(bullet[bulletNum], "kinematic");
  bullet[bulletNum]:setLinearVelocity(math.sin(math.rad(bullet[bulletNum].rotation))*50000, -math.cos(math.rad(bullet[bulletNum].rotation))*50000);

end

function bullets:removeBullets()
  numberOfBulletsToRemove = 0;
  for i = 1, table.getn(bullet) do
    if (bullet[i].x > (baseObject.x + 2000) 
    or bullet[i].x < (baseObject.x - 2000) 
    or bullet[i].y > (baseObject.y + 1000) 
    or bullet[i].y < (baseObject.y - 1000)) then
      numberOfBulletsToRemove = numberOfBulletsToRemove + 1;
    end
  end

  if numberOfBulletsToRemove > 0 then
    for j = 1, numberOfBulletsToRemove do
      bullet[j]:removeSelf();
      table.remove(bullet, j);
    end
  end
end

return bullets;