--------------------------------------------------------------------------------
--
-- ENEMY: stalker
--
-- en_stalker.lua
--
------------------------------- Private Fields ---------------------------------
local enemyBase = require("baseEnemy");
local class = require("classy");

local M = {};

M.class = class("Stalker", enemyBase.BaseEnemy);
M.description = "Rápidos e leves, os Perseguidores são caçadores perigosos que estão sempre dispostos a adicionar uma nova estrela no universo."

function M.class:__init( _x, _y, newIndex, params )
  self.x = _x;
  self.y = _y;
  self.autokill = params.autokill or true
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
                              0,
                              newIndex,
                              params);
                              
  self.sprite.maxSpeed = 1800;
  self.sprite.acceleration = 1;
  self.sprite.healthBar.maxHealth = 30;
  self.sprite.healthBar.health = 30;
  self.sprite.healthBar.armour = math.random(25, 35) / 100;
  self.sprite.radarColour = {0.8, 0.8, 0.8};
  self.sprite.damage = 18;
  self.turnRate = 6;

  physics.addBody(self.sprite, "kinematic")
end

function M.class:runCoroutine()
  --Add enemytype specific run routines here
end

return M;