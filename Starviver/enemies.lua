--------------------------------------------------------------------------------
--
-- Centralized module for spawning, tracking, and handling enemies
-- Contains a table, which itself contains more table_insert
-- Each subtable contains all instances of enemies.
-- This way, every enemy can be accessed through this one module
--
-- enemies.lua
--
------------------------------- Private Fields ---------------------------------
enemies = {};
enemies_mt = {__index = enemies}; --metatable

local enemyList;
local skeletonList;

--------------------------------- Constructor ----------------------------------

function enemies.new()
  local newEnemies = {
  }
  --List of all enemies
  skeletonList = {};

  enemyList = {
    --[[
    /////INDEX of ENEMIES/////
    [1] = Skeletons,
    ]]
    skeletonList
  }

  return setmetatable(newEnemies, enemies_mt);
end

------------------------------ Public Functions --------------------------------

--[[
  spawn(_index)
]]

function enemies:spawn(_index, _x, _y)

end

return enemies;