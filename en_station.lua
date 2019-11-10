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

function M.class:__init(_x, _y, newIndex, params)
  self.x = _x;
  self.y = _y;
  self.autokill = params.autokill or true
  enemyBase.BaseEnemy.__init( self, 
                              3, 
                              self.x, 
                              self.y, 
                              260, 
                              300, 
                              math.random(0, 359), 
                              "imgs/combat_station.png", 
                              "Estação de Combate", 
                              description, 
                              50, 
                              0, 
                              newIndex,
                              params);
  
  self.sprite.maxSpeed = 0;
  self.sprite.acceleration = 0.5;
  self.sprite.healthBar.maxHealth = 100;
  self.sprite.healthBar.health = self.sprite.healthBar.health;
  self.sprite.healthBar.armour = math.random(5, 15)/100;
  self.sprite.radarColour = {1, 65/255, 1};
  self.sprite.isPassive = false;
  self.turnRate = 1;
  self.sprite.damage = 150;

  physics.removeBody(self.sprite);
  physics.addBody(self.sprite, "kinematic", {filter = { categoryBits = self.collisionID, maskBits=self.maskBits }});

  self.bullets = bullets.newInstance(self.sprite, "imgs/bullet_4.png", 45, 45);
  self.bulletCooldown = 0;
end

--Add enemytype specific run routines here

function M.class:runCoroutine()
  if(self.sprite.isChasingPlayer == true and self.bulletCooldown<=0) then
    self.bulletCooldown = 20;
    self.bullets:shoot(1, -22);
    self.bullets:shoot(1, 95);
    self.bullets:shoot(1, 35);
    local soundEffect = audio.loadSound( "audio/sfx/shoot_triple2.mp3" )
		audio.play( soundEffect, {channel=21} )
  end
  self.bullets:removeBullets(player:getDisplayObject());
  self.bulletCooldown = self.bulletCooldown - 1;
  self.sprite.rotation = self.sprite.rotation + 2;
end

return M;