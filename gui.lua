--------------------------------------------------------------------------------
--
-- Stores all elements of the GUI and/or the HUD
--
--------------------------------------------------------------------------------
-------------------------------------GUI.LUA------------------------------------
--------------------------------------------------------------------------------
local class = require("classy");
local radar = require("radar");
local stick = require("joystick");
local button = require("button");

local gui = {};

gui.class = class("GUI");

function gui.class:__init()
  --Display Groups
  self.groupGUI = display.newGroup();

  self.redd = display.newRect(1200, 400, 200, 300);
  self.redd.rotation = self.redd.rotation+55;

  --GUI
  self.radar = radar.class(self.redd);
  self.stick = stick.new(1.125 * display.contentWidth/8, 6 * display.contentHeight / 8);
  self.button = button.new(display.contentWidth - (display.contentHeight/4),  --x
                           display.contentHeight-(display.contentHeight/6),   --y
                           display.contentHeight/2, display.contentHeight/3,  --width, height
                           false,     --toggleable?
                           1,      --red
                           0.6,      --green
                           0.6,     --blue
                           0.5,     --alpha
                           "fire");  --tag)
  --self.gameOverBackground = display.newRect(display.contentWidth/2, display.contentHeight/2, display.contentWidth, display.contentHeight);
  --self.gameOverBackground:setFillColor(0.8, 0.1, 0.2, 1);
  --self.gameOverBackground.alpha = 0.5;
  self.gameOverText = display.newText( "gaem is ded", display.contentWidth/2, display.contentHeight/1.2, "font/LeagueSpartan-Bold.ttf", 120 )

  --self.groupGUI:insert(self.radar);
  --self.groupGUI:insert(self.stick);
  --self.groupGUI:insert(self.button);
  --self.groupGUI:insert(self.gameOverBackground);
  --self.groupGUI:insert(self.gameOverText);

end

function gui.class:initControls()
  self.stick:init();
  self.button:init();
end

return gui;