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
local player = require("spaceship");
local physics = require("physics");

local M = {}

M.BaseEnemy =  class("BaseEnemy")

function M.BaseEnemy:__init(_enemyType, _x, _y, _width, _height, _rotation, _spriteImg, _name, _description, _pointsPerKill, _layer)
  self.x = _x or math.random(-10000, 10000);
  self.y = _y or math.random(-10000, 10000);
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
  self.sprite.wayPointX = 0;
  self.sprite.wayPointY = 0;
  self.autoKill = true; --when true, will despawn enemies that are too far from player

  self.sprite.chaseTimeout = 0;
  self.sprite.damageTimeout = 0;
  self.turnRateAngleDiff = 0;
  self.sprite.pointsPerKill = _pointsPerKill;

  self.sprite.healthBar = display.newRect(self.x, self.y - (self.sprite.height/2) - 50, 150, 20)
  self.sprite.healthBar:setFillColor(100/255, 255/255, 60/255);
  self.sprite.healthMissing = display.newRect(self.x, self.y - (self.sprite.height/2) - 50, 150, 20);
  self.sprite.healthMissing:setFillColor(255/255, 100/255, 60/255);
  self.sprite.healthBar.isVisible = false;  self.sprite.healthMissing.isVisible = false;

  scene:addObjectToScene(self.sprite, self.layer);
  scene:addObjectToScene(self.sprite.healthMissing, self.layer);
  scene:addObjectToScene(self.sprite.healthBar, self.layer);

  physics.addBody(self.sprite, "dynamic", {filter = {categoryBits=4, maskBits=7}});

  self.sprite.collision = self.onCollision;
  self.sprite:addEventListener("collision", self.sprite);
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

function M.BaseEnemy:getWayPoint(force)
  force = force or false;
  if(self:getDistanceTo(self.sprite.wayPointX, self.sprite.wayPointY) < 200 or force == true) then
    self.sprite.wayPointX = math.random(self.sprite.x - 5000, self.sprite.x + 5000)
    self.sprite.wayPointY = math.random(self.sprite.y - 5000, self.sprite.y + 5000)
  end
  return self.sprite.wayPointX, self.sprite.wayPointY;
end

function M.BaseEnemy:lockOnTarget(_x, _y)
  self.turnRateAngleDiff = (self.sprite.rotation - self:getDirectionTo(_x, _y) + 180) % 360 - 180;

  if(self.turnRateAngleDiff > 10) then
    self.sprite.rotation = self.sprite.rotation - 3;
  elseif(self.turnRateAngleDiff < -10) then
    self.sprite.rotation = self.sprite.rotation + 3;
  else
    self.sprite.rotation = self:getDirectionTo(_x, _y);
  end
  self.sprite:setLinearVelocity(self.sprite.maxSpeed * math.sin(math.rad(self.sprite.rotation)), self.sprite.maxSpeed * -math.cos(math.rad(self.sprite.rotation)));
end

function M.BaseEnemy:brake()
  self.sprite:setLinearVelocity(0, 0);
  self.sprite.x = self.sprite.x;
  self.sprite.y = self.sprite.y;
end

function M.BaseEnemy:onCollision( event )
  if(event.other.name ~= "Bullet") then
    if(event.other.name == "Player") then
      event.other.damage(2);
    elseif(self.chaseTimeout <= 0) then
      self.wayPointX = math.random(self.x - 5000, self.x + 5000);
      self.wayPointY = math.random(self.y - 5000, self.y + 5000);
    end
  end
end

function M.BaseEnemy:run( )
  if(self.sprite.healthBar.health <= 0 or self:getDistanceTo(player:getX(), player:getY()) > 10000) then
    self.isDead = true;
  else
    self:shake();
    if(self.sprite.isShaking == false) then
      self.x = self.sprite.x;
      self.y = self.sprite.y;
    end

    --sets health bar size, and makes sure it follows the enemy's movement
    self.sprite.healthBar.width = (self.sprite.healthBar.health / self.sprite.healthBar.maxHealth) * self.sprite.healthMissing.width;
    self.sprite.healthBar.y = self.sprite.y - (self.sprite.height/2) - 50;
    self.sprite.healthBar.x = self.sprite.x;
    self.sprite.healthMissing.y = self.sprite.healthBar.y
    self.sprite.healthMissing.x = self.sprite.x;

    if(self:getDistanceTo(player:getX(), player:getY()) < 400) then
      if(self.sprite.chaseTimeout <= 0) then
        self:lockOnTarget(self:getWayPoint(true));
        self.sprite.chaseTimeout = 120;
      else
        self:lockOnTarget(player:getX(), player:getY())
        self.sprite.chaseTimeout = self.sprite.chaseTimeout - 1;
      end
    else
      self:lockOnTarget(self:getWayPoint());
    end
  end
end

return M;