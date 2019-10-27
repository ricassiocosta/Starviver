--------------------------------------------------------------------------------
--
-- The powerup manager
--
--------------------------------------------------------------------------------
------------------------------ POWERUP_MANAGER.LUA -----------------------------
--------------------------------------------------------------------------------
local scene = require("scene");
local classy = require("classy");
--powerup modules
--local speedboost = require("pwr_speed");

local powerup = {};
powerup.class = class("PowerupManager");

function powerup.class:__init()
  self.moduleList = {
    --[[
        [1] --> Speed Boost
    --]]
    --speedboost
  }

  self.speedBoostList = {}

  self.powerupList = {
    self.speedBoostList;
  }
end

function powerup.class:get(_index1, _index2)
  if (_index1 == nil) then
    return powerupList;
  elseif (_index2 == nil) then
    return powerupList[_index1];
  else
    return powerupList[_index1][_index2];
  end
end

function powerup.class:spawn(_index, params)
  if (_index) then
    table.insert(powerupList[_index], moduleList[_index].class(params));
  end
end

return powerup;