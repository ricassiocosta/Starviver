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
                              1);
                              
  self.sprite.maxSpeed = 200;
  self.sprite.acceleration = 0.25;
  self.sprite.healthBar.maxHealth = 65;
  self.sprite.healthBar.health = 65;
  self.sprite.healthBar.armour = ((self.sprite.width + self.sprite.height)/200)*3;
  self.sprite.damage = math.random(30,60);

  physics.addBody(self.sprite, "kinematic");
end

function M.class:runCoroutine(  )
  --Add enemytype specific run routines here

  --Size of Asteroids change over time
  --[[
  self.widthSinFactor = math.random(-100, 100); --Used to change width and height based on sine waves over time
  self.heightSinFactor = math.random( -100, 100 ); -- ||
  self.widthSinFactor =self.widthSinFactor + 1;
  self.heightSinFactor = self.heightSinFactor + 1;
  self.sprite.width = self.width + (1000 * math.sin( self.widthSinFactor/50000 ));
  self.sprite.height = self.height + (1000 * math.sin(self.widthSinFactor/50000));]]

  if(self.sprite.width >= self.width + 99) then
    self.widthIncrease = false
  elseif(self.sprite.width <= self.width - 99) then
    self.widthIncrease = true;
  end

  if(self.widthIncrease == true) then
    self.sprite.width = self.sprite.width + 1;
  else
    self.sprite.width = self.sprite.width - 1;
  end

  if(self.sprite.height >= self.height + 99) then
    self.heightIncrease = false;
  elseif(self.sprite.height <= self.height - 99) then
    self.heightIncrease = true;
  end

  if(self.heightIncrease == true) then
    self.sprite.height = self.sprite.height + 1;
  else
    self.sprite.height = self.sprite.height - 1;
  end
end

return M;