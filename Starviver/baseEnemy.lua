--------------------------------------------------------------------------------
--
-- Base Enemy class
--
-- baseEnemy.lua
--
------------------------------- Private Fields ---------------------------------
local scene = require("scene");
local class = require("classy");
local score = require("score");

local M = {}

M.BaseEnemy =  class("BaseEnemy")

function M.BaseEnemy:__init(_enemyType, _x, _y, _width, _height, _rotation, _spriteImg, _name, _description, _pointsPerKill, _layer)
  self.x = _x or math.random(-1000, 1000);
  self.y = _y or math.random(-1000, 1000);
  self.sprite = display.newRect(self.x, self.y, _width, _height);
  if (_spriteImg ~= nil) then
    self.sprite.fill = {type = "image", filename = _spriteImg};
  end
  self.sprite.enemyType = _enemyType; --base class

  self.sprite.rotation = _rotation or 0;
  self.sprite.name = _name or "BaseEnemy";
  self.sprite.description = _description or "Base Description";
  self.layer = _layer or 1;

  self.sprite.speed = 10;
  self.sprite.shakeMax = 15;
  self.sprite.shakeAmount = 0;
  self.sprite.isShaking = false;
  self.sprite.pointsPerKill = _pointsPerKill;

  self.sprite.healthBar = display.newRect(self.x, self.y - (self.sprite.height/2) - 50, 150, 20)
  self.sprite.healthBar:setFillColor(100/255, 255/255, 60/255);
  self.sprite.healthMissing = display.newRect(self.x, self.y - (self.sprite.height/2) - 50, 150, 20);
  self.sprite.healthMissing:setFillColor(255/255, 100/255, 60/255);
  self.sprite.healthBar.isVisible = false;  self.sprite.healthMissing.isVisible = false;

  scene:addObjectToScene(self.sprite, self.layer);
  scene:addObjectToScene(self.sprite.healthMissing, self.layer);
  scene:addObjectToScene(self.sprite.healthBar, self.layer);
end

function M.BaseEnemy:shake()
  if(self.sprite.isShaking == true) then
    if(self.sprite.shakeMax <= 1) then
      self.sprite.shakeMax = 15;
      self.sprite.isShaking = false;
    else
      self.sprite.shakeAmount = math.random(self.sprite.shakeMax);
      self.sprite.x = self.x + math.random(-self.sprite.shakeAmount, self.sprite.shakeAmount);
      self.sprite.y = self.y + math.random(-self.sprite.shakeAmount, self.sprite.shakeAmount);
      self.sprite.shakeMax = self.sprite.shakeMax - 0.85;
    end
  end
end

function M.BaseEnemy:kill()
  score:increase(self.sprite.pointsPerKill);
  self.sprite:removeSelf();
  self.sprite.healthBar:removeSelf();
  self.sprite.healthMissing:removeSelf();
end

function M.BaseEnemy:isDead()
  if(self.sprite ~= nil) then
    return false;
  else
    return true;
  end
end

function M.BaseEnemy:getDistanceTo( _x, _y )
  local distance = math.sqrt(((self.x - _x) * (self.x - _x)) + ((self.y - _y) * (self.y - _y)));
  return distance;
end

function M.BaseEnemy:getDirectionTo(_x, _y)
  local direction = math.deg(math.atan2((_y - self.y), (_x - self.x))) + 90;
  if (direction < 0) then
    direction = 360 + direction;
  end
  return direction;
end

function M.BaseEnemy:hasCollided( obj2 )
  local obj1 = self.sprite;
  if(obj2 == nil) then --make sure that other object exists
    return false
  end

local left = obj1.contentBounds.xMin <= obj2.contentBounds.xMin and obj1.contentBounds.xMax >= obj2.contentBounds.xMin
  local right = obj1.contentBounds.xMin >= obj2.contentBounds.xMin and obj1.contentBounds.xMin <= obj2.contentBounds.xMax
  local up = obj1.contentBounds.yMin <= obj2.contentBounds.yMin and obj1.contentBounds.yMax >= obj2.contentBounds.yMin
  local down = obj1.contentBounds.yMin >= obj2.contentBounds.yMin and obj1.contentBounds.yMin <= obj2.contentBounds.yMax
  return (left or right) and (up or down)
end

function M.BaseEnemy:init(  )
  -- body
end

function M.BaseEnemy:run( )
  if(self.sprite.healthBar.health <= 0) then
    self.isDead = true;
  else
    self:shake();
    if(self.sprite.isShaking == false) then
      self.sprite.x = self.x;
      self.sprite.y = self.y;
    end

    --sets health bar size, and makes sure it follows the enemy's movement
    self.sprite.healthBar.width = (self.sprite.healthBar.health / self.sprite.healthBar.maxHealth) * self.sprite.healthMissing.width;
    self.sprite.healthBar.y = self.sprite.y - (self.sprite.height/2) - 50;
    self.sprite.healthBar.x = self.sprite.x;
    self.sprite.healthMissing.y = self.sprite.healthBar.y
    self.sprite.healthMissing.x = self.sprite.x;
  end
end

return M;