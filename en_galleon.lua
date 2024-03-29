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
local bullets = require("bullets")
physics.start();

local M = {};

M.class = class("Attack_Galleon", enemyBase.BaseEnemy);
M.description = "Não há barganhas com os Galeões de Ataque, eles só tem uma missão: Impedir a sua."

function M.class:__init(_x, _y, newIndex, params)
  self.x = _x;
  self.y = _y;
  self.autokill = params.autokill or true
  enemyBase.BaseEnemy.__init( self, 
                              3, 
                              self.x, 
                              self.y, 
                              150, 
                              190, 
                              math.random(0, 359), 
                              "imgs/attack_galleon.png", 
                              "Galeão de Ataque", 
                              description,
                              20, 
                              0,
                              newIndex,
                              params);

  self.sprite.maxSpeed = 800;
  self.sprite.acceleration = 0.5;
  self.sprite.damage = 75;
  self.sprite.healthBar.maxHealth = 25;
  self.sprite.healthBar.health = 25;
  self.sprite.healthBar.armour = math.random(30, 50)/100;
  self.sprite.radarColour = {1, 0.4, 0.2};

  self.bullets = bullets.newInstance(self.sprite, "imgs/bullet_1.png", self.sprite.width / 4, self.sprite.height - 80, self.sprite.maxSpeed * 125);
  self.bulletCooldown = 0;
end

--Add enemytype specific run routines here
function M.class:runCoroutine()
  if(self.sprite.isChasingPlayer == true and self.bulletCooldown<=0) then
    self.bulletCooldown = 10;
    self.bullets:shoot(1);
    local soundEffect = audio.loadSound( "audio/sfx/shoot_single.mp3" )
		audio.play( soundEffect, {channel=math.random(20, 50), duration = 200})
  end
  self.bullets:removeBullets(player:getDisplayObject());
  self.bulletCooldown = self.bulletCooldown - 1;
end

return M;