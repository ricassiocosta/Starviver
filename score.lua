--------------------------------------------------------------------------------
--
-- SCORE
--
--
--------------------------------------------------------------------------------
local score = {}
local highscore = {}
local totalScore = 0;

function score:increase( pointsEarned )
	totalScore = totalScore + pointsEarned;
end

function score:get(  )
	return totalScore;
end

return score;
