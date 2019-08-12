charKnightSheetOptions = {
	width = 84,
	height = 84,
	numFrames = 6,
	sheetContentWidth = 504,
	sheetContentHeight = 84
}

charKnightSheet = graphics.newImageSheet( "image/char_knight_run_up.png", charKnightSheetOptions )

knightSequenceData = {
	name = "char_knight",
	start = 2,
	count = 5,
	time = 700,
	loopCount = 0,
	loopDirection = "forward"
}
function startAnimation()
	newCharKnight = display.newSprite( charKnightSheet, knightSequenceData )
	newCharKnight.x = 320
	newCharKnight.y = 700

	newCharKnight:play( )
end

local bg1
local bg2
local runtime = 0
local scrollSpeed = 1.4

local bg1
local bg2
local runtime = 0
local scrollSpeed = 1.4

local function addScrollableBg()
    local bgImage = { type="image", filename="image/background.png" }

    bg1 = display.newRect(0, 0, display.contentWidth, display.actualContentHeight)
    bg1.fill = bgImage
    bg1.x = display.contentCenterX
    bg1.y = display.contentCenterY

    bg2 = display.newRect(0, 0, display.contentWidth, display.actualContentHeight)
    bg2.fill = bgImage
    bg2.x = display.contentCenterX
    bg2.y = display.contentCenterY - display.actualContentHeight
end

local function moveBg(dt)
    bg1.y = bg1.y + scrollSpeed * dt
    bg2.y = bg2.y + scrollSpeed * dt

    if (bg1.y - display.contentHeight/2) > display.actualContentHeight then
        bg1:translate(0, -bg1.contentHeight * 2)
    end
    if (bg2.y - display.contentHeight/2) > display.actualContentHeight then
        bg2:translate(0, -bg2.contentHeight * 2)
    end
end

local function getDeltaTime()
   local temp = system.getTimer()
   local dt = (temp-runtime) / (1000/60)
   runtime = temp
   return dt
end

local function enterFrame()
    local dt = getDeltaTime()
    moveBg(dt)
end

function init()
    addScrollableBg()
    Runtime:addEventListener("enterFrame", enterFrame)
end

init()

startAnimation()

helloWorld = display.newImage( "image/hello world.png", 335, 100 )
helloWorld:scale( 2, 2 )
display.newText( {text = "Estágio I",x = 335, y = 170, fontSize = 20} )
display.newText( {text = "Professor Eduardo Mendes",x = 335, y = 190, fontSize = 18} )