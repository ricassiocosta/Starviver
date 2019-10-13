--------------------------------------------------------------------------------
--
-- ENEMY: Attack Galleon
--
-- en_galleon.lua
--
------------------------------- Private Fields ---------------------------------
local enemyBase = require("baseEnemy");
local class = require("classy");
local player = require("spaceship");
local physics = require("physics");
physics.start();

local M = {};

M.class = class("Attack_Galleon", enemyBase.BaseEnemy);
M.description = "Não há barganhas com os Galeões de Ataque, eles só tem uma missão: Impedir a sua."

function M.class:__init(_x, _y)
  self.x = _x;
  self.y = _y;
  enemyBase.BaseEnemy.__init( self, 
                              3, 
                              self.x, 
                              self.y, 
                              250, 
                              180, 
                              math.random(0, 359), 
                              "imgs/attack_galleon.png", 
                              "Galeão de Ataque", 
                              description,
                              20, 
                              1);

  self.sprite.maxSpeed = 800;
  self.sprite.acceleration = 0.5;
  self.sprite.healthBar.maxHealth = 25;
  self.sprite.healthBar.health = 25;
  self.sprite.healthBar.armour = math.random(12, 17);

  self.chaseTimeout = 0;
  self.sprite.damageTimeout = 0;
  self.turnRateAngleDiff = 0;

  physics.addBody(self.sprite, "dynamic");
  self.sprite.collision = self.onCollision;
  self.sprite:addEventListener("collision", self.sprite)
end

function M.class:runCoroutine()
  
  if(self:getDistanceTo(player:getX(), player:getY()) < 1000) then
    self.chaseTimeout = 15;
  elseif(self.chaseTimeout > 0) then
    self.chaseTimeout = self.chaseTimeout - 1;
  end

  if (self.chaseTimeout > 0) then
    self.turnRateAngleDiff = (self.sprite.rotation - self:getDirectionTo(player:getX(), player:getY()) + 180) % 360 - 180;

    if (self.turnRateAngleDiff > 10) then
      self.sprite.rotation = self.sprite.rotation - 3;
    elseif (self.turnRateAngleDiff < -10) then
      self.sprite.rotation = self.sprite.rotation + 3;
    else
      self.sprite.rotation = self:getDirectionTo(player:getX(), player:getY());
    end

    self.sprite:setLinearVelocity(self.sprite.maxSpeed * math.sin(math.rad(self.sprite.rotation)), self.sprite.maxSpeed * -math.cos(math.rad(self.sprite.rotation)));

    if(self.sprite.damageTimeout > 0) then
      self.sprite.damageTimeout = self.sprite.damageTimeout - 1;
    end
  end

  --print(self.chaseTimeout);

end

return M;