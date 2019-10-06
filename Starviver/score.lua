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
	print(totalScore);
end

return score;
