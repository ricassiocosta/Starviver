--configuramos largura e altura dos sprites, bem como o nro. deles
local sheetOptions = { width = 84, height = 84, numFrames = 31 }
--carregamos a spritesheet com as opções
local sheet = graphics.newImageSheet( "image/char_knight/spritesheet_char_knight.png", sheetOptions )
 
--definimos uma animação (sequence)
local sequences = {
    {
        name = "normalRun",
        start = 1,
        count = 36,
        time = 500,
        loopCount = 0,
        loopDirection = "forward"
    }
}
--criamos um objeto de display com todas as configs anteriores
local running = display.newSprite( sheet, sequences )
 
--posicionamos o objeto na tela
running.x = display.contentWidth / 4 + 40
running.y = 225--distância do cavalo ao chão
running.xScale = 1.2
running.yScale = 1.2
 
--manda rodar
running:play()