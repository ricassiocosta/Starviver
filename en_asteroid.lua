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

function M.class:__init(_x, _y, newIndex, params)
  self.x = _x;
  self.y = _y;
  self.autokill = params.autokill or true
  enemyBase.BaseEnemy.__init( self, 
                              2, 
                              self.x, 
                              self.y, 
                              math.random(100, 300), 
                              math.random(100, 300), 
                              45,
                              "imgs/asteroid.png", 
                              "Asteroide", 
                              description,
                              5, 
                              0,
                              newIndex,
                              params);
                              
  self.sprite.maxSpeed = 200;
  self.sprite.acceleration = 0.25;
  self.sprite.healthBar.maxHealth = 55;
  self.sprite.healthBar.health = self.sprite.healthBar.maxHealth;
  self.sprite.healthBar.armour = ((self.sprite.width + self.sprite.height)) / 2020; --armour can never be 100% resistance
  self.sprite.damage = math.random(5,12);
  self.sprite.radarColour = {0, 0.8, 1};

  physics.addBody(self.sprite, "kinematic");
end

function M.class:runCoroutine(  )

end

return M;