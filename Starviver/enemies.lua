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
local galleon = require("en_galleon")

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
  galleonList = {};

  enemyList = {
    --[[
    /////INDEX of ENEMIES/////
    [1] = stalkerList,
    [2] = asteroidList,
    [3] = galleonList,
    ]]
    stalkerList,
    asteroidList,
    galleonList
  }


--List of all modules; corresponds with order in enemyList;
  moduleList = {
    stalker,
    asteroid,
    galleon
  }

  return newEnemies;
end

------------------------------ Public Functions --------------------------------

--[[
  spawn(_index, _x, _y)
  spawn(_index, _layer, _x, _y)
    - spawns a new enemy, and adds it to the list
    - _index determines which type of enemy to spawn
    - does NOT add the oobject to the scene
    @return the instance of the enemy;
  get(_index1, _index2)
    - retrieves the specificed enemy instance;
    - _index1 is the type of enemy, and _index2 specifes which in particular
    - retrieves newest instance if _index2 is not specified
    @return the instance of the enemy;
]]

function enemies:spawn(_index, _x, _y)
  if (_index ~= nil) then
    table.insert(enemyList[_index], moduleList[_index].class(_x, _y));
    return enemyList[_index][table.getn(enemyList[_index])];
  else
    return -1;
  end
  print(enemyList[_index][table.getn(enemyList[_index])].sprite.name);
end

function enemies:get(_index1, _index2)
  if (_index1 == nil) then
    return enemyList;
  elseif (_index2 == nil) then
    return enemyList[_index1];
  else
    return enemyList[_index1][_index2];
  end
end

function enemies:kill( _index1, _index2 )
  table.remove(enemyList[_index1], _index2)
end

return enemies;