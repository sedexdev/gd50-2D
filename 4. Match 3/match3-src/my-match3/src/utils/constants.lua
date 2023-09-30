-- physical window
WINDOW_WIDTH = 1280
WINDOW_HEIGHT = 720

-- virtual resolution
VIRTUAL_WIDTH = 512
VIRTUAL_HEIGHT = 288

-- global resource tables
GFONTS = {
    ['small'] = love.graphics.newFont('fonts/font.ttf', 8),
    ['medium'] = love.graphics.newFont('fonts/font.ttf', 16),
    ['large'] = love.graphics.newFont('fonts/font.ttf', 32),
}

GAUDIO = {
    ['music'] = love.audio.newSource('audio/music3.mp3', 'static'),
    ['select'] = love.audio.newSource('audio/select.wav', 'static'),
    ['error'] = love.audio.newSource('audio/error.wav', 'static'),
    ['match'] = love.audio.newSource('audio/match.wav', 'static'),
    ['clock'] = love.audio.newSource('audio/clock.wav', 'static'),
    ['game-over'] = love.audio.newSource('audio/game-over.wav', 'static'),
    ['next-level'] = love.audio.newSource('audio/next-level.wav', 'static')
}

GTEXTURES = {
    ['main'] = love.graphics.newImage('graphics/match3.png'),
    ['background'] = love.graphics.newImage('graphics/background.png')
}

GQUADS = {
    ['tiles'] = GenerateQuads(GTEXTURES['main'], 32, 32)
}

-- textures
BACKGROUND_SCROLL_SPEED = 80
BACKGROUND_LOOPING_POINT = 465 -- 1024 - VIRTUAL_WIDTH - 47
