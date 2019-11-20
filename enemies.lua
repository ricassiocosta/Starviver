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
local station = require("en_station")
local score = require("score")

enemies = {};
enemies_mt = {__index = enemies}; --metatable

local enemyList;
local moduleList;
local stalkerList;
local asteroidList;
local galleonList;
local stationList;

local enemyCount = 0; --stores number of enemies spawned
local enemyTimer = 0; --used to repeatedly spawn in enemies

--------------------------------- Constructor ----------------------------------

function enemies.new()
  local newEnemies = {
  }
  setmetatable(newEnemies, enemies_mt);
  stalkerList = {};
  asteroidList = {};
  galleonList = {};
  stationList = {};

  enemyList = {
    --[[
    /////INDEX of ENEMIES/////
    [1] = stalkerList,
    [2] = asteroidList,
    [3] = galleonList,
    [4] = stationList,
    ]]
    stalkerList,
    asteroidList,
    galleonList,
    stationList
  }

  enemyListScoutMode = {
    --[[
    /////INDEX of ENEMIES/////
    [1] = stalkerList,
    [2] = asteroidList,
    [3] = galleonList,
    [4] = stationList,
    ]]
    stalkerList,
    asteroidList,
    galleonList
  }


--List of all modules; corresponds with order in enemyList;
  moduleList = {
    stalker,
    asteroid,
    galleon,
    station
  }

  moduleListScoutMode = {
    stalker,
    asteroid,
    galleon
  }

  BatedorModeEnemies = 100

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

function enemies:spawn(_index, _x, _y, params)
  params = params or {};
  _index = _index or math.random(1, table.getn(enemyList))
  if(_index and score:get() > 500) then
    table.insert(enemyList[_index], moduleList[_index].class(_x, _y, table.getn(enemyList[_index])+1, params));
    return enemyList[_index][table.getn(enemyList[_index])];
  elseif (_index and _index ~= 4) then
    table.insert(enemyList[_index], moduleList[_index].class(_x, _y, table.getn(enemyList[_index])+1, params));
    return enemyList[_index][table.getn(enemyList[_index])];
  else
    return -1;
  end
end

function enemies:batchSpawn(_amount, params)
  params = params or {};
  for i = 1, _amount do
    _index = math.random(1, table.getn(enemyListScoutMode))
    table.insert(enemyListScoutMode[_index], moduleListScoutMode[_index].class(_x, _y, table.getn(enemyListScoutMode[_index])+1, params));
  end
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

function enemies:kill(_index1, _index2)
  table.remove(enemyList[_index1], _index2);
  local soundEffect = audio.loadSound( "audio/sfx/success2.wav" )
  audio.play( soundEffect )
end

function enemies:randomSpawn(_x, _y, params)
  --randomly spawns enemies
  if (enemyTimer < 120) then
    enemyTimer = enemyTimer + 1;
  else
    enemyTimer = 0;
    if (enemyCount < 100) then
      enemies:spawn(math.random(1, table.getn(enemyList)), math.random(_x - 3000, _x + 3000), math.random(_y - 3000, _y + 3000), params);
    end
  end
end

function enemies:clear(radar)
  for i = 1, table.getn(enemyList) do
    for j = 1, table.getn(enemyList[i]) do
      if (enemyList[i][j] == nil) then break
      else
        enemyList[i][j]:kill(radar);
        enemies:kill(i, j)
      end
    end
  end
end

function enemies:run(params)
  enemyCount = 0;
  params.x = params.x or 0
  params.y = params.y or 0
  --runs logic behind enemies
  for i = 1, table.getn(enemyList) do
    for j = 1, table.getn(enemyList[i]) do
      if (enemyList[i][j] == nil) then break
      elseif ((enemyList[i][j].sprite.isDead) and ((enemyList[i][j]:getDistanceTo(params.x, params.y) < 5000))) then
        enemyList[i][j]:kill(params.radar, "isDead");
        enemies:updateBatedorMode()
        table.remove(enemyList[i], j);
        enemyCount = enemyCount - 1;
      elseif (enemyList[i][j]:getDistanceTo(params.x, params.y) > 5000 and enemyList[i][j]:getAutoKill()) then
        enemyList[i][j]:kill(params.radar, "Distance");
        table.remove(enemyList[i], j);
        enemyCount = enemyCount - 1;
      else
        enemyList[i][j]:run(params.radar);
        enemyList[i][j]:runCoroutine();
        enemyCount = enemyCount + 1;
      end
    end
  end
  return enemyCount;
end

function enemies:getAmount()
  local enemyAmount = 0;
  for i = 1, table.getn(enemyList) do
    for j = 1, table.getn(enemyList[i]) do
      if (enemyList[i][j] == nil) then break
      else
        enemyAmount = enemyAmount + 1;
      end
    end
  end
  return enemyAmount;
end

function enemies:resetBatedorMode()
  BatedorModeEnemies = 100
end

function enemies:updateBatedorMode()
  BatedorModeEnemies = BatedorModeEnemies - 1
end

function enemies:getBatedorMode()
  return BatedorModeEnemies
end

return enemies;