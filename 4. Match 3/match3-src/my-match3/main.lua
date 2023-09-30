require 'src/utils/dependencies'

-- backgroun x coordinate or scrolling
local backgroundX = 0

local function initialiseWindow()
    love.window.setTitle('MATCH 3')
    love.graphics.setDefaultFilter('nearest', 'nearest')
    Push:setupScreen(VIRTUAL_WIDTH, VIRTUAL_HEIGHT, WINDOW_WIDTH, WINDOW_HEIGHT, {
        fullscreen = false,
        resizable = true,
        vsync = true
    })
end

local function initialiseStateMachine()
    GStateMachine = StateMachine{
        ['menu'] = function() return MenuState() end,
        ['entergame'] = function() return EnterLevelState() end,
        ['play'] = function() return PlayState() end,
        ['gameover'] = function() return GameOverState() end,
        ['victory'] = function() return VictoryState() end,
        ['enterhighscore'] = function() return EnterHighScoreState() end,
        ['highscores'] = function() return HighScoreState() end,
    }
    GStateMachine:change('menu', {
        highScores = LoadHighScores()
    })
end

function love.load()

    -- seed the RNG to start creating random numbers
    math.randomseed(os.time())

    initialiseWindow()
    -- set working directory
    love.filesystem.setIdentity('match3')
    if not love.filesystem.getInfo('match3.lst') then
        CreateScoreFile()
    end
    initialiseStateMachine()

    -- GAUDIO['music']:play()
    -- GAUDIO['music']:setLooping(true)

    love.keyboard.keyPressed = {}
end

function love.update(dt)
    -- scroll background
    backgroundX = (backgroundX + BACKGROUND_SCROLL_SPEED * dt) % BACKGROUND_LOOPING_POINT

    GStateMachine:update(dt)
    love.keyboard.keyPressed = {}
end

function love.keypressed(key)
    love.keyboard.keyPressed[key] = true
end

function love.keyboard.wasPressed(key)
    return love.keyboard.keyPressed[key]
end

function love.resize(w, h)
    Push:resize(w, h)
end

function love.draw()
    Push:start()
    love.graphics.draw(GTEXTURES['background'], -backgroundX, 0)
    GStateMachine:render()
    Push:finish()
end