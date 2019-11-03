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
local progressRing = require("progressRing")
physics:start();

local powerups = {};
powerups.class = class("Powerup");

function powerups.class:__init(params)
    self.x = params.x or math.random(-1000, 1000);
    self.y = params.y or math.random(-1000, 1000);
    self.width = params.width or 128;
    self.height = params.height or 128;
    self.image = params.image or "";
    self.sprite = display.newImageRect(self.image, self.width, self.height);
    self.sprite.x, self.sprite.y = self.x, self.y;
    while (self.rotationFactor == nil or self.rotationFactor == 0) do
        self.rotationFactor = math.random(-360, 360)/120
    end
    scene:addObjectToScene(self.sprite, 1);

    physics.addBody( self.sprite, "dynamic", {isSensor=true, filter = {categoryBits = 16, maskBits = 1}});
    self.sprite.gravityScale = 0;
    self.sprite.collision = self.onCollision;
    self.sprite:addEventListener("collision", self.sprite);

    self.sprite.timeShown = progressRing.new({ringColor = {0.8, 0.2, 0.1}, bgColor = {1,1,1,0.01}, position = 1, ringDepth = 1, radius = 80});
    self.sprite.timeShown.y = display.contentHeight - 200;
    self.sprite.timeShown.x = -300;
    self.sprite.duration = 1; --time, in seconds, that the powerup lasts
end

function powerups.class:run(_index)
    self.sprite.rotation = self.sprite.rotation + self.rotationFactor;
end

return powerups;