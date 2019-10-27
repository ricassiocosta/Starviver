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
    self.x = params.x or 0;
    self.y = params.y or 0;
    self.width = params.width or 256;
    self.height = params.height or 256;
    self.image = params.image or "";
    self.sprite = display.newImageRect(self.image, self.width, self.height);
    self.sprite.x, self.sprite.y = self.x, self.y;
    scene:addObjectToScene(self.sprite, 1);
end

function powerups.class:run()
    self.sprite.rotation = self.sprite.rotation + 1;
end

return powerups;