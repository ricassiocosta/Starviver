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
  self.groupGUI = display.newGroup();     --[ * ] -- main group. contains all sub groups within
  self.miscGUI = display.newGroup();      --[ 1 ] -- Misc. GUI objects
  self.buttonGUI = display.newGroup();    --[ 2 ] -- Buttons
  self.radarGUI = display.newGroup();     --[ 3 ] -- Radar
  self.stickGUI = display.newGroup();     --[ 4 ] -- Joysticks
  self.gameOverGUI = display.newGroup();  --[ 5 ] -- Gameover Screens

  --adds the groups to the main group
  self.groupGUI:insert(self.miscGUI);
  self.groupGUI:insert(self.buttonGUI);
  self.groupGUI:insert(self.radarGUI);
  self.groupGUI:insert(self.stickGUI);
  self.groupGUI:insert(self.gameOverGUI);

  self.miscTable = {};      --[ 1 ] -- Misc. GUI objects
  self.buttonTable = {};    --[ 2 ] -- Buttons
  self.radarTable = {};     --[ 3 ] -- Radar
  self.stickTable = {};     --[ 4 ] -- Joysticks
  self.gameOverTable = {};  --[ 5 ] -- Gameover Screens
  self.GUItable = {
    self.miscTable,
    self.buttonTable,
    self.radarTable,
    self.stickTable,
    self.gameOverTable
  }

  --Special settings for display groups
  self.groupGUI[5].alpha = 0;

  ------------------------------------------------------------------------------

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

  self.gameOverBackground = display.newRect(display.contentWidth/2, display.contentHeight/2, display.actualContentWidth, display.actualContentHeight);
  self.gameOverBackground:setFillColor(0.8, 0.2, 0.1);
  self.gameOverText = display.newText( "Starviver is Dead", display.contentWidth/2, display.contentHeight/1.2, "font/league-spartan-bold.otf", 120 )

  self.gameOverGUI:insert(self.gameOverBackground);
  self.gameOverGUI:insert(self.gameOverText);

  self.stickGUI:insert(self.stick:getBackgroundDisplayObject());
  self.stickGUI:insert(self.stick:getStickDisplayObject());

  self.buttonGUI:insert(self.button:getDisplayObject());
  self.radarGUI:insert(self.radar:getRadarObject());
  self.radarGUI:insert(self.radar:getRadarTriangle());
  self.radarGUI:insert(self.radar:getDots());

  ----------

  table.insert(self.gameOverTable, self.gameOverBackground);
  table.insert(self.gameOverTable, self.gameOverText);
  table.insert(self.stickTable, self.stick);
  table.insert(self.buttonTable, self.button);
  table.insert(self.radarTable, self.radar);
end

--gets an object from the hud
function gui.class:get(index1, index2)
  return self.GUItable[index1][index2];
end

function gui.class:run()
  self.radar:run();
end

function gui.class:showEndscreen()
  self.groupGUI[5].alpha = self.groupGUI[5].alpha + 0.005;
end

function gui.class:insert(_displayObj, _index)
  self.groupGUI[_index]:insert(_displayObj);
end

return gui;