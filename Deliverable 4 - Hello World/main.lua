-- Main file for Section 3- Corona Applications


display.newText( {text = "Hello World!",x = 320, y = 100, fontSize = 32} )
display.newText( {text = "Estágio I",x = 320, y = 200, fontSize = 32} )
display.newText( {text = "Professor Eduardo Mendes",x = 320, y = 260, fontSize = 32} )

charKnightSheetOptions = {
	width = 84,
	height = 84,
	numFrames = 5,
	sheetContentWidth = 420,
	sheetContentHeight = 84
}

charKnightSheet = graphics.newImageSheet( "image/char_knight_run_right.png", charKnightSheetOptions )

knightSequenceData = {
	name = "char_knight",
	start = 2,
	count = 5,
	time = 500,
	loopCount = 0,
	loopDirection = "forward"
}

newCharKnight = display.newSprite( charKnightSheet, knightSequenceData )
newCharKnight.x = 320
newCharKnight.y = 700

newCharKnight:play( )