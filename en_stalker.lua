--------------------------------------------------------------------------------
--
-- ENEMY: stalker
--
-- en_stalker.lua
--
------------------------------- Private Fields ---------------------------------
local enemyBase = require("baseEnemy");
local class = require("classy");

local M = {}

M.class = class("Stalker", enemyBase.BaseEnemy);
M.description = "Rápidos e leves, os Perseguidores são caçadores perigosos que estão sempre dispostos a adicionar uma nova estrela no universo."

function M.class:__init( _x, _y )
  self.x = _x;
  self.y = _y;
  enemyBase.BaseEnemy.__init( self,
                              1,
                              self.x,
                              self.y,
                              60,
                              80,
                              0,
                              "imgs/stalker.png",
                              "Perseguidores",
                              description,
                              10,
                              0);
  
  self.sprite.maxSpeed = 1200;
  self.sprite.acceleration = 1;
  self.sprite.healthBar.maxHealth = 30;
  self.sprite.healthBar.health = 30;
  self.sprite.healthBar.armour = math.random(25, 35) / 100;

  physics.addBody(self.sprite, "kinematic")
end

function M.class:runCoroutine( )
  
end

return M;