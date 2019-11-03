--------------------------------------------------------------------------------
--
-- Powerup --> Speedboost; increases player speed;
--
--------------------------------------------------------------------------------
--------------------------------- PWR_SPEED.LUA --------------------------------
--------------------------------------------------------------------------------
local basePowerup = require("powerup");
local class = require("classy");
local physics = require("physics");
local timeMan = require("powerupTimerManager");

local M = {};

M.class = class("Speedboost", basePowerup.class);

function M.class:__init(_index, params)
  params.image = "imgs/pwr-speed.png";
  basePowerup.class.__init(self, params);
  self.index = _index;
  self.name = "Speedboost";
  self.sprite.duration = 3;
end

function M.class:sayHello()
  if(self.name) then print(self.name); end
end

function M.class.onCollision(self, event)
  if(event.phase == "began") then
    self.isDead = true;
    event.other.powerupBuffs[1] = self.duration * 60; --buff duration

    timeMan:reset(1, {r = 0.8, g = 0.1, b = 0.6, x = 600});
    timeMan:get(1):goTo(0, self.duration*1000);

    event.other.maxSpeed = 50;
  end
end

return M;