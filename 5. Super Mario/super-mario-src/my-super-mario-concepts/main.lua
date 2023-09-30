require 'src/utils/dependencies'

local function initialiseWindow()
    love.window.title = 'Super Mario!'
    love.graphics.setDefaultFilter('nearest', 'nearest')
    Push:setupScreen(VIRTUAL_WIDTH, VIRTUAL_HEIGHT, WINDOW_WIDTH, WINDOW_HEIGHT, {
        fullscreen = false,
        vsync = true,
        resizable = true
    })
end

function love.load()
    initialiseWindow()

    -- seed a random number to initialise RNG
    math.randomseed(os.time())

    Map = Level{}
    Tiles = Map:generateLevel()
    Alien = Player{}

    BackgroundR = math.random(255) / 255
    BackgroundG = math.random(255) / 255
    BackgroundB = math.random(255) / 255

    -- Print_r(GTILES['tilesets'])

    love.keyboard.keyPressed = {}
end

function love.keypressed(key)
    love.keyboard.keyPressed[key] = true
end

function love.keyboard.wasPressed(key)
    return love.keyboard.keyPressed[key]
end

function love.update(dt)
    -- keyboard events
    if love.keyboard.wasPressed('escape') then
        love.event.quit()
    end

    Alien:update(dt)
    Map:update(dt)

    --[[
        Alien.x                = center of the screen
        - (VIRTUAL_WIDTH / 2)  = move "camera" to the left by half screen width
        + (Alien.width / 2)    = add half width of alien to center the sprite
    ]]
    CameraScroll = Alien.x - (VIRTUAL_WIDTH / 2) + (Alien.width / 2)

    love.keyboard.keyPressed = {}
end

function love.resize(w, h)
    Push:resize(w, h)
end

function love.draw()
    Push:start()

    --[[
        negate the CameraScroll so it looks like we are travelling left or right
        math.floor forces integer translations that avoid image tearing that can 
        occur with floating point values
    ]]
    love.graphics.translate(-math.floor(CameraScroll), 0)

    love.graphics.clear(BackgroundR, BackgroundG, BackgroundB, 1)

    Alien:render()
    Map:render()

    Push:finish()
end