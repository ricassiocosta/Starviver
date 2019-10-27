--------------------------------------------------------------------------------
--
-- Base Class for all powerups
--
--------------------------------------------------------------------------------
---------------------------------- POWERUP.LUA ---------------------------------
--------------------------------------------------------------------------------

local class = require("classy");
local scene = require("scene");
local physics = require("physics");

local powerups = {};
powerups.class = class("Powerup");

function powerups.class:__init(params)
  params.x = params.x or 0;
  params.y = params.y or 0;
  self.image = params.image or "";
  self.sprite = display.newImageRect(params.image, params.width, params.height);
  self.sprite.x, self.sprite.y = params.x, params.y
  scene:addObjectToScene(self.sprite, 1);
end

function powerups.class:run()
  self.sprite.rotation = self.sprite.rotation + 1;
end

return powerups;