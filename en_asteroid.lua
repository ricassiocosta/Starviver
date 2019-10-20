--------------------------------------------------------------------------------
--
-- Controls the basic, common logic of enemies
--
-- en_asteroid.lua
--
------------------------------- Private Fields ---------------------------------

local enemyBase = require("baseEnemy")
local class = require("classy")

local M = {}

M.class = class("Asteroid", enemyBase.BaseEnemy);
M.description = "Cuidado! Você não vai querer ser atingido por eles!"

function M.class:__init(_x, _y)
  self.x = _x;
  self.y = _y;
  enemyBase.BaseEnemy.__init( self, 
                              2, 
                              self.x, 
                              self.y, 
                              math.random(100, 300), 
                              math.random(100, 300), 
                              0,
                              "imgs/asteroid.png", 
                              "Asteroide", 
                              description,
                              5, 
                              0);
                              
  self.sprite.maxSpeed = 200;
  self.sprite.acceleration = 0.25;
  self.sprite.healthBar.maxHealth = 65;
  self.sprite.healthBar.health = 65;
  self.sprite.healthBar.armour = ((self.sprite.width + self.sprite.height)/200) / 10;
  self.sprite.damage = math.random(30,60);

  physics.addBody(self.sprite, "kinematic");
end

function M.class:runCoroutine(  )

end

return M;