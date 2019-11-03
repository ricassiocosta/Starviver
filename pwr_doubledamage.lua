--------------------------------------------------------------------------------
--
-- Powerup --> Double Damage; Doubles the player's bullet damage;
--
--------------------------------------------------------------------------------
----------------------------- PWR_DOUBLEDAMAGE.LUA -----------------------------
--------------------------------------------------------------------------------
local basePowerup = require("powerup");
local class = require("classy");
local physics = require("physics");
local timeMan = require("powerupTimerManager")

local M = {};

M.class = class("DoubleDam", basePowerup.class);

function M.class:__init(_index, params)
  params.image = "imgs/pwr-doubleD.png";
  basePowerup.class.__init(self, params);
  self.index = _index;
  self.name = "Double Damage";
  self.sprite.duration = 7;
end

function M.class:sayHello()
  if(self.name) then print(self.name); end
end

function M.class.onCollision(self, event)
  if(event.phase == "began") then
    self.isDead = true;
    if(event.other.powerupBuffs[2] <= 0) then
      event.other.bulletDamage = event.other.bulletDamage * 2;
      event.other:setFillColor(90/255, 30/255, 255/255)
    end
    event.other.powerupBuffs[2] = self.duration * 60; --buff duration

    timeMan:create({index = 2, x = 800, duration = self.duration});
    local soundEffect = audio.loadSound( "audio/sfx/success.wav" )
		audio.play( soundEffect )
  end
end

return M;