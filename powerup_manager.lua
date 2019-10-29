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
local doubleDamage = require("pwr_doubledamage")
local healthkit = require("pwr_health")

local M = {};
M.class = class("PowerupManager");

function M.class:__init()
  self.moduleList = {
    --[[
        [1] --> Speed Boost
        [2] --> Double Damage
        [3] --> HealthKit
    --]]
    speedboost,
    doubleDamage,
    healthkit
  }

  self.speedBoostList = {}
  self.healthkitList = {}
  self.doubleDamage = {}

  self.powerupList = {
    self.speedBoostList,
    self.doubleDamage,
    self.healthkitList

  }

  self.spawnTimer = 0;
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

function M.class:randomSpawn(_x, _y)
  --randomly spawns enemies
  if (self.spawnTimer < 90) then
    self.spawnTimer = self.spawnTimer + 1;
  else
    self.spawnTimer = 0;
    if (true) then
      self:spawn(math.random(1, table.getn(self.powerupList)), {x = math.random(_x - 3000, _x + 3000), y = math.random(_y - 3000, _y + 3000)});
    end
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
      elseif (self.powerupList[i][j].sprite.isDead == true) then
        self.powerupList[i][j].sprite:removeSelf();
        table.remove(self.powerupList[i], j)
      else
        self.powerupList[i][j]:run();
      end
    end
  end
end

return M;