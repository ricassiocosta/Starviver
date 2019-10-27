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

return M;