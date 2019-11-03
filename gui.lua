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

function gui.class:__init(params)
  --Display Groups
  self.groupGUI = display.newGroup();     --[ 0 ] -- main group. contains all sub groups within
  self.gameOverGUI = display.newGroup();  --[ 1 ] -- Gameover Screens
  self.stickGUI = display.newGroup();     --[ 2 ] -- Joysticks
  self.buttonGUI = display.newGroup();    --[ 3 ] -- Buttons
  self.radarGUI = display.newGroup();     --[ 4 ] -- Radar
  self.miscGUI = display.newGroup();      --[ 5 ] -- Misc. GUI objects

  --adds the groups to the main group
  self.groupGUI:insert(self.miscGUI);
  self.groupGUI:insert(self.buttonGUI);
  self.groupGUI:insert(self.radarGUI);
  self.groupGUI:insert(self.stickGUI);
  self.groupGUI:insert(self.gameOverGUI);

  self.miscTable = {};      --[ 1 ] -- Misc. GUI objects
  self.gameOverTable = {};  --[ 2 ] -- Gameover Screens
  self.stickTable = {};     --[ 3 ] -- Joysticks
  self.buttonTable = {};    --[ 4 ] -- Buttons
  self.radarTable = {};     --[ 5 ] -- Radar
  self.GUItable = {
    self.miscTable,
    self.gameOverTable,
    self.stickTable,
    self.buttonTable,
    self.radarTable
  }

  --GUI
  self.radar = radar.class(params.player);
  self.stick = stick.newInstance(1.125 * display.contentWidth/8, 6 * display.contentHeight / 8);
  self.button = button.newInstance({x        = 1.7 * (display.contentWidth / 2),
                                    y        = 1.5 * (display.contentHeight / 2),
                                    width    = display.contentWidth/17, 
                                    height   = display.contentWidth/17,
                                    r        = 255,
                                    g        = 45,
                                    b        = 65,
                                    a        = 0.5,
                                    tag      = "fire"});

  self.gameOverBackground = display.newRect(display.contentWidth/2, display.contentHeight/2, display.contentWidth, display.contentHeight);
  self.gameOverBackground:setFillColor(0.8, 0.1, 0.2, 1);
  self.gameOverBackground.alpha = 0.5;
  self.gameOverText = display.newText( "gaem is ded", display.contentWidth/2, display.contentHeight/1.2, "font/LeagueSpartan-Bold.ttf", 120 )

  self.gameOverGUI:insert(self.gameOverBackground);
  self.gameOverGUI:insert(self.gameOverText);

  self.stickGUI:insert(self.stick:getBackgroundDisplayObject());
  self.stickGUI:insert(self.stick:getStickDisplayObject());

  self.buttonGUI:insert(self.button:getDisplayObject());
  self.radarGUI:insert(self.radar:getRadarObject());
  self.radarGUI:insert(self.radar:getRadarTriangle());

  ----------

  table.insert(self.gameOverTable, self.gameOverBackground);
  table.insert(self.gameOverTable, self.gameOverText);
  table.insert(self.stickTable, self.stick);
  table.insert(self.buttonTable, self.button);
  table.insert(self.radarTable, self.radar);

  ---------

  self.groupGUI[5].alpha = 0.2;
end

--gets an object from the hud
function gui.class:get(index1, index2)
  return self.GUItable[index1][index2];
end

function gui.class:run()
  self.radar:run();
end

return gui;