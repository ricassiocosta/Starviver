--------------------------------------------------------------------------------
--
-- SCORE
--
--
--------------------------------------------------------------------------------
local player = require("spaceship")
local preference = require("preference")
local score = {}
local highscore = preference.getValue("a")
local totalScore = 0;

if(highscore == nil) then
	highscore = 0
end

function score:increase( enemy, pointsEarned )
	if(enemy:getDistanceTo(player:getX(), player:getY()) > 10000) then
	else
		totalScore = totalScore + pointsEarned;
	end
end

function score:get(  )
	return totalScore;
end

function score:set(_score)
	totalScore = _score;
end

function score:getHighscore()
	return highscore
end

function score:setHighscore(_score)
	preference.save{a=_score}
end

function score:isHighscore(_score)
	if(_score > highscore) then
		return true;
	else
		return false;
	end
end

return score;
