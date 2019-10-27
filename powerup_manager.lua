--------------------------------------------------------------------------------
--
-- The M manager
--
--------------------------------------------------------------------------------
------------------------------ POWERUP_MANAGER.LUA -----------------------------
--------------------------------------------------------------------------------
local scene = require("scene");
local class = require("classy");
--powerup modules
local speedboost = require("pwr_speed");

local M = {};
M.class = class("PowerupManager");

function M.class:__init()
  self.moduleList = {
    --[[
        [1] --> Speed Boost
    --]]
    speedboost
  }

  self.speedBoostList = {}

  self.powerupList = {
    self.speedBoostList;
  }
end

function M.class:get(_index1, _index2)
  if (_index1 == nil) then
    return self.powerupList;
  elseif (_index2 == nil) then
    return self.powerupList[_index1];
  else
    return self.powerupList[_index1][_index2];
  end
end

function M.class:spawn(_index, params)
  params = params or {};
  if (_index) then
    table.insert(self.powerupList[_index], self.moduleList[_index].class(_index, params));
  end
end

function M.class:run()
  for i = 1, table.getn(self.powerupList) do
    for j = 1, table.getn(self.powerupList[i]) do
      --print(i .. " | " .. j)
      if (self.powerupList[i][j] == nil) then break
      else
        self.powerupList[i][j]:run();
      end
    end
  end
end

return M;