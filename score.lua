--------------------------------------------------------------------------------
--
-- SCORE
--
--
--------------------------------------------------------------------------------
local player = require("spaceship")
local score = {}
local highscore = {}
local totalScore = 0;

function score:increase( enemy, pointsEarned )
	if(enemy:getDistanceTo(player:getX(), player:getY()) > 10000) then
	else
		totalScore = totalScore + pointsEarned;
	end
end

function score:get(  )
	return totalScore;
end

return score;
