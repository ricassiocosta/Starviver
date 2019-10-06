--------------------------------------------------------------------------------
--
-- ENEMY: Attack Galleon
--
-- en_galleon.lua
--
------------------------------- Private Fields ---------------------------------

local enemyBase = require("baseEnemy")
local class = require("classy");

local M = {}

M.class = class("Attack_Galleon", enemyBase.BaseEnemy);
M.description = "Não há barganhas com os Galeões de Ataque, eles só tem uma missão: Impedir a sua."

function M.class:__init( _x, _y )
	self.x = _x;
	self.y = _y;
	enemyBase.BaseEnemy.__init(	self,
								3,
								self.x,
								self.y,
								250,
								180,
								math.random(0, 359),
								"imgs/attack_galleon.png",
								"Galeão de Ataque",
								description,
								20,
								1);
	self.maxSpeed = 40;
	self.acceleration = 0.5;
	self.sprite.health = 25;
	self.sprite.armour = math.random(12,17);

	physics.addBody(self.sprite, "kinematic");
end

return M;