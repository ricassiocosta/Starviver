-- Used to add objects to the game scene,
-- As well as camera tracking and parallax movement

-- scene.lua

local perspective = require("perspective")

local scene = {};
local scene_mt = {__index = scene};

local camera;
local sceneNum;

function scene.new(  )
	local newScene = {}
	return setmetatable( newScene, scene_mt );
end

function scene:addObjectToScene( _obj, _layer )
	camera:add(_obj, _layer)
end

function scene:addFocusTrack( _obj )
	camera:setFocus( _obj )
	camera:track();
end

function scene:init( _sceneNum )
	camera = perspective.createView();
	camera:prependLayer();

	if(_sceneNum == 1) then
		local scene = {}
		for i = 1, 100 do
			scene[i] = display.newCircle(0, 0, 10)
			scene[i].x = math.random(display.screenOriginX, display.contentWidth * 3)
			scene[i].y = math.random(display.screenOriginY, display.contentHeight)
			scene[i]:setFillColor(math.random(100) * 0.01, math.random(100) * 0.01, math.random(100) * 0.01)
			camera:add(scene[i], math.random(0, camera:layerCount()))
		end

		camera:setParallax(1, 1, 1, 0.7, 0.6, 0.5, 0.4, 0.3) -- Here we set parallax for each layer in desceding order
	end
end

function scene:destruct( _sceneNum, _transition )
	_transition = _transition or "none";
end

function scene:change( _firstScene, _secondScene,_transition )
	_transition = _transition or "none";

	scene:destruct(_firstScene, _transition);
	scene:init(_secondScene)
end

return scene;