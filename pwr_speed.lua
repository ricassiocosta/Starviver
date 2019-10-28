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

local M = {};

M.class = class("Speedboost", basePowerup.class);

function M.class:__init(_index, params)
  params.image = "imgs/pwr-speed.png";
  basePowerup.class:__init(self, params);
  self.index = _index;
  self.name = "Speedboost";
end

function M.class:sayHello()
  if(self.name) then print(self.name); end
end

function M.class.onCollision( self, event )
  if (event.phase == "began") then
    self.isDead = true;
    if (event.other.maxSpeed < 72) then
      event.other.maxSpeed = event.other.maxSpeed + 15;
    end
  end
end

return M;