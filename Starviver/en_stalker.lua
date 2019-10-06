--------------------------------------------------------------------------------
--
-- ENEMY: stalker
--
-- en_stalker.lua
--
------------------------------- Private Fields ---------------------------------
local enemyBase = require("baseEnemy");
local class = require("classy")

local M = {}

M.class = class("Perseguidor", enemyBase.BaseEnemy);
M.description = "Rápidos e leves, os Perseguidores são caçadores perigosos que estão sempre dispostos a adicionar uma nova estrela no universo."

function M.class:__init( _x, _y )
  self.x = _x;
  self.y = _y;
  enemyBase.BaseEnemy.__init( self,
                              1,
                              self.x,
                              self.y,
                              160,
                              200,
                              "imgs/stalker.png",
                              "Perseguidores",
                              description,
                              1);
  self.speed = 0;
  self.maxSpeed = 42;
  self.acceleration = 1;
  self.sprite.health = 30;
  self.sprite.armour = 5;

  physics.addBody(self.sprite, "kinematic")
end

return M;