require 'src/utils/dependencies'

local function initialiseFonts()
    -- initialize our nice-looking retro text fonts
    GFonts = {
        ['small'] = love.graphics.newFont('fonts/font.ttf', 8),
        ['medium'] = love.graphics.newFont('fonts/font.ttf', 16),
        ['large'] = love.graphics.newFont('fonts/font.ttf', 32)
    }
    love.graphics.setFont(GFonts['small'])
end

local function initialiseTextures()
     -- load up the graphics we'll be using throughout our states
    GTextures = {
        ['background'] = love.graphics.newImage('graphics/background.png'),
        ['main'] = love.graphics.newImage('graphics/breakout.png'),
        ['arrows'] = love.graphics.newImage('graphics/arrows.png'),
        ['hearts'] = love.graphics.newImage('graphics/hearts.png'),
        ['particle'] = love.graphics.newImage('graphics/particle.png')
    }
end

local function initialiseQuads()
    -- Quads we will generate for all of our textures; Quads allow us
    -- to show only part of a texture and not the entire thing
    GQuads = {
        ['paddles'] = GeneratePaddles(GTextures['main']),
        ['balls'] = GenerateBalls(GTextures['main']),
        ['bricks'] = GenerateBricks(GTextures['main']),
        ['hearts'] = GenerateQuads(GTextures['hearts'], 10, 9),
        ['arrows'] = GenerateQuads(GTextures['arrows'], 24, 24),
        ['powerups'] = GeneratePowerUps(GTextures['main'])
     }
end

local function initialiseWindow()
    Push:setupScreen(VIRTUAL_WIDTH, VIRTUAL_HEIGHT, WINDOW_WIDTH, WINDOW_HEIGHT, {
        vsync = true,
        fullscreen = false,
        resizable = true
    })
end

local function initialiseAudio()
    -- set up our sound effects; later, we can just index this table and
    -- call each entry's `play` method
    GAudio = {
        ['paddle-hit'] = love.audio.newSource('audio/paddle_hit.wav', 'static'),
        ['score'] = love.audio.newSource('audio/score.wav', 'static'),
        ['wall-hit'] = love.audio.newSource('audio/wall_hit.wav', 'static'),
        ['confirm'] = love.audio.newSource('audio/confirm.wav', 'static'),
        ['select'] = love.audio.newSource('audio/select.wav', 'static'),
        ['no-select'] = love.audio.newSource('audio/no-select.wav', 'static'),
        ['brick-hit-1'] = love.audio.newSource('audio/brick-hit-1.wav', 'static'),
        ['brick-hit-2'] = love.audio.newSource('audio/brick-hit-2.wav', 'static'),
        ['hurt'] = love.audio.newSource('audio/hurt.wav', 'static'),
        ['victory'] = love.audio.newSource('audio/victory.wav', 'static'),
        ['recover'] = love.audio.newSource('audio/recover.wav', 'static'),
        ['high-score'] = love.audio.newSource('audio/high_score.wav', 'static'),
        ['pause'] = love.audio.newSource('audio/pause.wav', 'static'),

        ['music'] = love.audio.newSource('audio/music.wav', 'static')
    }
end

local function initialiseStateMachine()
    GStateMachine = StateMachine {
        ['menu'] = function() return MenuState() end,
        ['highscore'] = function() return HighScoreState() end,
        ['paddleselect'] = function() return PaddleSelectState end,
        ['serve'] = function() return ServeState() end,
        ['play'] = function() return PlayState() end,
        ['victory'] = function() return VictoryState() end,
        ['gameover'] = function() return GameOverState() end,
        ['enter'] = function() return EnterHighScoreState() end
    }
    GStateMachine:change('menu', {
        highScores = LoadHighScores()
    })
end

function love.load()
    love.graphics.setDefaultFilter('nearest', 'nearest')
    math.randomseed(os.time())
    love.window.setTitle('Breakout')

    -- set working directory
    love.filesystem.setIdentity('breakout')
    if not love.filesystem.getInfo('breakout.lst') then
        CreateScoreFile()
    end

    initialiseFonts()
    initialiseTextures()
    initialiseQuads()
    initialiseWindow()
    initialiseAudio()
    initialiseStateMachine()

    -- play music constantly
    GAudio['music']:play()
    GAudio['music']:setLooping(true)

    love.keyboard.keysPressed = {}
end

function love.keypressed(key)
    love.keyboard.keysPressed[key] = true
end

function love.keyboard.wasPressed(key)
    return love.keyboard.keysPressed[key]
end

function love.update(dt)
    GStateMachine:update(dt)
    love.keyboard.keysPressed = {}
end

function love.resize(w, h)
    Push:resize(w, h)
end

function love.draw()
    Push:start()

    local backgroundWidth = GTextures['background']:getWidth()
    local backgroundHeight = GTextures['background']:getHeight()

    --[[
        local scaleX = VIRTUAL_WIDTH / (backgroundWidth-1)
        local scaleY = VIRTUAL_HEIGHT / (backgroundHeight-1)

        WITHOUT SUBTRACTING 1
        (1.4304635761589, 1.8837209302326) * (302, 129) = (432, 243)
        This is the exact virtual resolution but is short of filling the whole screen

        SUBTRACTING 1
        (1.4352159468439, 1.8984375) * (302, 129) = (433.44, 244.90)
        Going over by small scale actually fits the image to the screen
    ]]

    love.graphics.draw(GTextures['background'],
        0, 0,
        0,
        VIRTUAL_WIDTH / (backgroundWidth - 1),
        VIRTUAL_HEIGHT / (backgroundHeight - 1)
    )

    GStateMachine:render()
    Push:finish()
end
