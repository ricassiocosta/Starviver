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
    for i = 1, table.getn(countdownTimers) do
        countdownTimers[i].y = display.contentHeight - 120;
        countdownTimers[i].x = -1000;
        countdownTimers[i].isInProgress = false;
    end
end

function timerManager:get(_index)
    if(_index) then
        return countdownTimers[_index];
    else
        return countdownTimers;
    end
end

function timerManager:create(params)
    params.duration = params.duration or 1;
    if(countdownTimers[params.index].isInProgress == false) then
        countdownTimers[params.index].isInProgress = true;
        countdownTimers[params.index].x = params.x or 300;
        countdownTimers[params.index]:goTo(0, 1000*params.duration);
        countdownTimers[params.index]:addEventListener("completed", timerManager.onComplete)
    else
        countdownTimers[params.index]:goTo(1, 0.1);
        countdownTimers[params.index].isInProgress = false;
        local recursiveTimer = timer.performWithDelay(5, function() timerManager:create({index = params.index, duration = params.duration, x = params.x}) end);
    end
end

function timerManager:onComplete()
    print("timeOUT!!!!!!!!!!!!!!!!!!!!!");
end

return timerManager;