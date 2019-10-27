--------------------------------------------------------------------------------
--
-- Powerup --> Speedboost; increases player speed;
--
--------------------------------------------------------------------------------
--------------------------------- PWR_SPEED.LUA --------------------------------
--------------------------------------------------------------------------------
local powerups = require("powerup");
local class = require("classy");
local physics = require("physics");

local M = {};

M.class = class("Speedboost", powerups.Powerup);

function M.class:__init(_index, params)
  self.index = _index;
  self.name = params.name;
end

function M.class:sayHello()
  if(self.name) then print(self.name); end
end

return M;