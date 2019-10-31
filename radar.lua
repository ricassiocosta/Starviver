--------------------------------------------------------------------------------
--
-- Code behind the radar
-- Shows player direction, location of enemies, and map around the player
--
-- radar.lua
--
--------------------------------------------------------------------------------

local class = require ("classy");

local radar = {};

radar.class = class("Radar");

function radar.class:__init(_rootObj)
  self.rootObject = _rootObj;

  self.radarBackground = display.newCircle(275, 275, 225);
  self.radarBackground:setFillColor(0,0,0, 0.65);
  self.radarTri = display.newImageRect("imgs/radar-triangle.png", 50, 50);
  self.radarTri.x = 275; self.radarTri.y = 275;
  self.radarTri.rotation = self.rootObject.rotation;

  self.stalkerDot = {};
  self.asteroidDot = {};
  self.stationDot = {};

  self.dotTable = {
    self.stalkerDot,
    self.asteroidDot,
    self.stationDot
  }
end

--returns the display object
function radar.class:getRadarObject()
  return self.radarBackground;
end

function radar.class:getRadarTriangle()
  return self.radarTri;
end

--Gets distance, in pixel widths, to a given point
function radar.class:getDistanceTo(_x1, _y1, _x2, _y2)
  local distance = math.sqrt(((_x1 - _x2) * (_x1 - _x2)) + ((_y1 - _y2) * (_y1 - _y2)));
  return distance;
end

function radar.class:draw(_x, _y, _enemyType, _index, _colour)
  _colour = _colour or {1, 1, 1}
  _x = _x;
  _y = _y;

  if(self.dotTable[_enemyType][_index] == nil) then
    local dot = display.newCircle(275+_x, 275+_y, 10);
    table.insert(self.dotTable[_enemyType], _index, dot);
  else
    self.dotTable[_enemyType][_index].isVisible = true;
    self.dotTable[_enemyType][_index].x = 275+_x;
    self.dotTable[_enemyType][_index].y = 275+_y;
    self.dotTable[_enemyType][_index]:setFillColor(unpack(_colour));
  end
end

function radar.class:kill(_enemyType, _index)
  if(self.dotTable[_enemyType][_index] ~= nil) then
    self.dotTable[_enemyType][_index].isVisible = false;
  end
end

function radar.class:clear()
  for i = 1, table.getn(self.dotTable) do
    for i = 1, table.getn(self.dotTable[i]) do
      self.dotTable[i][j].isVisible = false;
    end
  end
end

function radar.class:run()
  self.radarTri.rotation = self.rootObject.rotation;
end

return radar;