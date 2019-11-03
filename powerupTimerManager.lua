----------------------------------------------------------------------------------------------------------------------------------------------------------------
--
-- Manages the pie timers that determine how much time is left for the powerups
--
--------------------------------------------------------------------------------
--------------------------- powerupTimerManager.lua ----------------------------
--------------------------------------------------------------------------------
local progressRing = require("progressRing");

local timerManager = {};

local countdownTimers = {};

function timerManager:init()
  countdownTimers = {
    progressRing.new({ringColor = {0,0,0}, bgColor = {1,1,1,0.01}, position = 1, ringDepth = 1, radius = 80}),
    progressRing.new({ringColor = {0,0,0}, bgColor = {1,1,1,0.01}, position = 1, ringDepth = 1, radius = 80})
  };

  for i = 1, table.getn(countdownTimers) do
    countdownTimers[i].y = display.contentHeight - 200;
    countdownTimers[i].x = -1000;
  end

end

function timerManager:get(_index)
  if(_index) then
    return countdownTimers[_index];
  else
    return countdownTimers;
  end
end

function timerManager:reset(_index, params)
  local r = params.r or 0.2;
  local g = params.g or 0.8;
  local b = params.b or 0.1;
  countdownTimers[_index] = progressRing.new({ringColor = {r, g, b}, bgColor = {1,1,1,0.01}, position = 1, ringDepth = 1, radius = 80});

  countdownTimers[_index].y = display.contentHeight - 200;
  countdownTimers[_index].x = params.x or 300;
end

return timerManager;