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
local scene = require("scene")
local stalker = require("en_stalker")
local asteroid = require("en_asteroid")

enemies = {};
enemies_mt = {__index = enemies}; --metatable

local enemyList;
local moduleList;
local stalkerList;
local asteroidList;

--------------------------------- Constructor ----------------------------------

function enemies.new()
  local newEnemies = {
  }
  setmetatable(newEnemies, enemies_mt);
  stalkerList = {};
  asteroidList = {};


--List of all modules; corresponds with order in enemyList;
  moduleList = {
    stalker,
    asteroid
  }

  enemyList = {
    --[[
    /////INDEX of ENEMIES/////
    [1] = stalkerList,
    [2] = asteroidList,
    ]]
    stalkerList,
    asteroidList
  }

  return newEnemies;
end

------------------------------ Public Functions --------------------------------

--[[
  spawn(_index)
]]

function enemies:spawn(_index, _x, _y)
  table.insert(enemyList[_index], moduleList[_index].new(_x, _y));
  enemyList[_index][table.getn(enemyList[_index])]:init();
  return enemyList[_index][table.getn(enemyList[_index])];
end

function enemies:get(_index1, _index2)
  if(_index2 == nil) then
    return enemyList[_index1][table.getn(enemyList[_index1])];
  else 
    return enemyList[_index1][_index2];
  end
end

function enemies:getDisplayObject(_index1, _index2)
  enemyList[_index1][_index2]:getDisplayObject();
end

return enemies;