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

M.BaseEnemy = class("BaseEnemy");

function M.BaseEnemy:__init(_enemyType, 
                            _x, 
                            _y, 
                            _width, 
                            _height, 
                            _rotation, 
                            _spriteImg, 
                            _name, 
                            _description, 
                            _pointsPerKill, 
                            _layer,
                            newIndex,
                            params)

  self.x = _x or math.random(-10000, 10000);
  self.y = _y or math.random(-10000, 10000);
  self.width = _width or 100;
  self.height = _height or 100;
  self.rotation = _rotation;
  self.sprite = display.newRect(self.x, self.y, _width, _height);
  if (_spriteImg ~= nil) then
    self.sprite.fill = {type = "image", filename = _spriteImg};
  end
  self.sprite.enemyType = _enemyType; --base class

  self.sprite.rotation = self.rotation or 0;
  self.sprite.name = _name or "BaseEnemy";
  self.sprite.description = _description or "Base Description";
  self.layer = _layer or 1;
  self.radar = params.radar or nil;

  self.sprite.speed = 10;
  self.sprite.shakeMax = 24;
  self.sprite.shakeAmount = 0;
  self.sprite.isShaking = false;
  self.sprite.wayPointX = 0;
  self.sprite.wayPointY = 0;
  --self.autokill = true; --when true, will despawn enemies that are too far from player
  self.sprite.damage = 2;
  self.sprite.index = newIndex;
  self.sprite.radarColour = {1, 1, 1}
  self.oppositeAngle = 180;

  self.sprite.chaseTimeout = -1;
  self.sprite.damageTimeout = 0;
  self.turnRateAngleDiff = 0;
  self.collisionID = 4;
  self.maskBits = _maskBits or 7;
  self.sprite.isChasingPlayer = false;
  self.sprite.isStuck = false;
  self.sprite.pointsPerKill = _pointsPerKill;

  self.sprite.healthBar = display.newRect(self.x, self.y - (self.sprite.height/2) - 50, 150, 20);
  self.sprite.healthBar:setFillColor(100/255, 255/255, 60/255);
  self.sprite.healthMissing = display.newRect(self.x, self.y - (self.sprite.height/2) - 50, 150, 20);
  self.sprite.healthMissing:setFillColor(255/255, 100/255, 60/255);
  self.sprite.healthBar.isVisible = false;  self.sprite.healthMissing.isVisible = false;

  self.sprite.maxSpeed = 1200;
  self.sprite.acceleration = 1;
  self.sprite.isPassive = false;
  self.sprite.healthBar.maxHealth = 30;
  self.sprite.healthBar.health = 30;
  self.sprite.healthBar.armour = 0.5; --armour is damage resistance. from 0-1. higher number means more resistance
  self.turnRate = 3;

  scene:addObjectToScene(self.sprite, self.layer);
  scene:addObjectToScene(self.sprite.healthMissing, self.layer);
  scene:addObjectToScene(self.sprite.healthBar, self.layer);

  physics.addBody(self.sprite, "dynamic", {filter = { categoryBits = self.collisionID, maskBits=self.maskBits }});

  self.sprite.collision = self.onCollision;
  self.sprite:addEventListener("collision", self.sprite);

end

function M.BaseEnemy:shake()
  if(self.sprite.isShaking == true) then
    if(self.sprite.shakeMax <= 1) then
      self.sprite.shakeMax = 24;
      self.sprite.isShaking = false;
      self.sprite:setFillColor(1,1,1);
    else
      self.sprite:setFillColor(0.8, (24-self.sprite.shakeMax)/24, (24-self.sprite.shakeMax)/24);
      self.sprite.shakeAmount = math.random(self.sprite.shakeMax);
      self.sprite.x = self.sprite.x + math.random(-self.sprite.shakeAmount, self.sprite.shakeAmount);
      self.sprite.y = self.sprite.y + math.random(-self.sprite.shakeAmount, self.sprite.shakeAmount);
      self.sprite.shakeMax = self.sprite.shakeMax - 1;
    end
  end
end

function M.BaseEnemy:updateHealthBar()
  --sets healthbar size, and makes sure it follows the enemy's movement
  self.sprite.healthBar.width = (self.sprite.healthBar.health / self.sprite.healthBar.maxHealth) * self.sprite.healthMissing.width;
  self.sprite.healthBar.y = self.sprite.y - (self.sprite.height/2) - 50;
  self.sprite.healthBar.x = self.sprite.x - ((self.sprite.healthMissing.width - self.sprite.healthBar.width)/2);
  self.sprite.healthMissing.y = self.sprite.y - (self.sprite.height/2) - 50;
  self.sprite.healthMissing.x = self.sprite.x;
end

function M.BaseEnemy:removeHealthBar()
  --sets healthbar size, and makes sure it follows the enemy's movement
  self.sprite.healthBar.width = 0;
  self.sprite.healthMissing.width = 0;
end

--Kills the enemy (does NOT remove from list of enemies)
function M.BaseEnemy:kill(radar, reason)
  reason = reason or ""
  score:increase(self, self.sprite.pointsPerKill);
  if(radar) then 
    radar:kill(self.sprite.enemyType, self.sprite.index) 
  end
  self.sprite.healthBar:removeSelf();
  self.sprite.healthMissing:removeSelf();
  transition.to(self.sprite, {time = 400, transition = easing.inCirc, alpha = 0, rotation = 720, width = 1, height = 1, onComplete = function() self.sprite:removeSelf(); end})  
  if (reason == "isDead") then
    local soundEffect = audio.loadSound( "audio/sfx/success.wav" )
    audio.play( soundEffect )
  end
end

--Returns whether the enemy is dead or not
function M.BaseEnemy:isDead()
  if(self.sprite ~= nil) then
    return false;
  else
    return true;
  end
end

--Gets distance, in pixel widths, to a given point
function M.BaseEnemy:getDistanceTo(_x, _y)
  local distance = math.sqrt(((self.x - _x) * (self.x - _x)) + ((self.y - _y) * (self.y - _y)));
  return distance;
end

--Given coordinates, returns angle from sprite to that point
function M.BaseEnemy:getDirectionTo(_x, _y)
  local direction = math.deg(math.atan2((_y - self.y), (_x - self.x))) + 90;
  if (direction < 0) then
    direction = 360 + direction;
  end
  return direction;
end

function M.BaseEnemy:getWaypoint(force)
  force = force or false;
  if(self:getDistanceTo(self.sprite.wayPointX, self.sprite.wayPointY) < 200 or force == true) then
    self.sprite.wayPointX = math.random(self.sprite.x - 5000, self.sprite.x + 5000);
    self.sprite.wayPointY = math.random(self.sprite.y - 5000, self.sprite.y + 5000);
  end
  return self.sprite.wayPointX, self.sprite.wayPointY;
end

function M.BaseEnemy:setOppositeAngle()
  -- Used to turn 180 degrees around and go the other way
  -- Helps prevent massive pileups
  self.oppositeAngle = self.sprite.rotation - 180;
  if (self.oppositeAngle < 0) then
    self.oppositeAngle = 360 + self.oppositeAngle;
  end
  return self.oppositeAngle;
end

function M.BaseEnemy:turnAround()
  self.turnRateAngleDiff = (self.sprite.rotation - self.oppositeAngle + 180) % 360 - 180;
  if (self.turnRateAngleDiff > self.turnRate*4) then
    self.sprite.rotation = self.sprite.rotation - 2*self.turnRate;
  elseif (self.turnRateAngleDiff < -self.turnRate*4) then
    self.sprite.rotation = self.sprite.rotation + 2*self.turnRate;
  else
    self.sprite.rotation = self.oppositeAngle;
    self.sprite.isStuck = false;
    self:lockOnTarget(self:getWaypoint(true));
  end
end

function M.BaseEnemy:lockOnTarget(_x, _y)
  self.turnRateAngleDiff = (self.sprite.rotation - self:getDirectionTo(_x, _y) + 180) % 360 - 180;

  if (self.turnRateAngleDiff > self.turnRate*2) then
    self.sprite.rotation = self.sprite.rotation - self.turnRate;
  elseif (self.turnRateAngleDiff < -self.turnRate*2) then
    self.sprite.rotation = self.sprite.rotation + self.turnRate;
  else
    self.sprite.rotation = self:getDirectionTo(_x, _y);
  end

  self.sprite:setLinearVelocity(self.sprite.maxSpeed * math.sin(math.rad(self.sprite.rotation)), self.sprite.maxSpeed * -math.cos(math.rad(self.sprite.rotation)));
end

--
function M.BaseEnemy:chase(isPassive)
  if(isPassive == false and (self:getDistanceTo(player:getX(), player:getY()) < 5500)) then
    if(self.sprite.chaseTimeout <= 0) then
      self:lockOnTarget(self:getWaypoint(true));
      self.sprite.chaseTimeout = 120;
      self.sprite.isChasingPlayer = false;
    else
      self.sprite.speed = self.sprite.speed * 2;
      self:lockOnTarget(player:getX(), player:getY())
      self.sprite.isChasingPlayer = true;
      self.sprite.chaseTimeout = self.sprite.chaseTimeout - 1;
    end
  else
    self.sprite.isChasingPlayer = false;
    self:lockOnTarget(self:getWaypoint());
  end
end

function M.BaseEnemy:brake()
  self.sprite:setLinearVelocity(0, 0);
  self.sprite.x = self.sprite.x;
  self.sprite.y = self.sprite.y;
end

function M.BaseEnemy:onCollision(event)
  if(event.other.name ~= "Bullet") then
    if(event.other.name == "Player") then
      event.other.damage(self.damage);
    else
      self.isStuck = true;
    end
  end
end

function M.BaseEnemy:drawOnRadar(radar)
  if(radar) then
    if(self:getDistanceTo(player:getX(), player:getY()) < 5500)then
      radar:draw((self.sprite.x - player:getX())/25,
                (self.sprite.y - player:getY())/25,
                self.sprite.enemyType,
                self.sprite.index,
                self.sprite.radarColour);
    else
      radar:kill(self.sprite.enemyType, self.sprite.index)
    end
  end
end

function M.BaseEnemy:run(radar)
  --Checks if enemy is dead
  if (self.sprite.healthBar.health <= 0 or self:getDistanceTo(player:getX(), player:getY()) > 100000) then
    self.sprite.isDead = true;
    self.sprite.bodyType = "kinematic";
    self:removeHealthBar();
  else
    self:updateHealthBar();
    self:drawOnRadar(radar);
    --runs shake routine
    self:shake();

    if(self.sprite.isShaking == false) then
      self.x = self.sprite.x;
      self.y = self.sprite.y;
    end

    if(self.sprite.isStuck == false) then
      self:setOppositeAngle();
      self:chase(self.sprite.isPassive);
    else
      self:turnAround();
    end
  end
end

function M.BaseEnemy:getAutoKill()
  return M.BaseEnemy.autokill
end

return M;