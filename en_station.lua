--------------------------------------------------------------------------------
--
-- ENEMY: Combat Station
--
-- en_station.lua
--
------------------------------- Private Fields ---------------------------------
local enemyBase = require("baseEnemy");
local class = require("classy");
local physics = require("physics");
local bullets = require("bullets");
local player = require("spaceship");
physics.start();

local M = {};

M.class = class("Combat_Station", enemyBase.BaseEnemy);
M.description = "Impenetrável. Imbatível. Inevitável"

function M.class:__init(_x, _y, newIndex)
  self.x = _x;
  self.y = _y;
  enemyBase.BaseEnemy.__init(self, 3, self.x, self.y, 260, 300, math.random(0, 359), "imgs/combat_station.png", "Estação de Combate", description, 0, newIndex);

  self.sprite.maxSpeed = 0;
  self.sprite.acceleration = 0.5;
  self.sprite.healthBar.maxHealth = 100;
  self.sprite.healthBar.health = self.sprite.healthBar.health;
  self.sprite.healthBar.armour = math.random(5, 15)/100;
  self.sprite.radarColour = {1, 65/255, 1};
  self.sprite.isPassive = false;
  self.turnRate = 1;
  self.sprite.damage = 250;

  physics.removeBody(self.sprite);
  physics.addBody(self.sprite, "kinematic", {filter = { categoryBits = self.collisionID, maskBits=self.maskBits }});

  self.bullets = bullets.newInstance(self.sprite, nil, self.sprite.width/15, self.sprite.height/1.5);
  self.bulletCooldown = 0;
end

--Add enemytype specific run routines here
--OVERRIDE BaseEnemy:run()
function M.class:run()
  --Checks if enemy is dead
  if (self.sprite.healthBar.health <= 0 or self:getDistanceTo(player:getX(), player:getY()) > 100000) then
    self.sprite.isDead = true;
  else
    --print(self.sprite.isStuck)
    self:updateHealthBar();

    self:chase(self.sprite.isPassive);

    --draws on Radar
    if(self:getDistanceTo(player:getX(), player:getY()) < 5500)then
      player:getRadar():draw((self.sprite.x - player:getX())/25,
                            (self.sprite.y - player:getY())/25,
                            self.sprite.enemyType,
                            self.sprite.index,
                            self.sprite.radarColour);
    else
      player:getRadar():kill(self.sprite.enemyType, self.sprite.index)
    end
  end
end

function M.class:runCoroutine()
  if(self.sprite.isChasingPlayer == true and self.bulletCooldown<=0) then
    self.bulletCooldown = 4;
    self.bullets:shoot(1, -10);
    self.bullets:shoot(1, -5);
    self.bullets:shoot(1);
    self.bullets:shoot(1, 5);
    self.bullets:shoot(1, 10);
  end
  self.bullets:removeBullets(player:getDisplayObject());

  self.bulletCooldown = self.bulletCooldown - 1;
end

return M;