-- push is a library that will allow us to draw our game at a virtual
-- resolution, instead of however large our window is; used to provide
-- a more retro aesthetic
--
-- https://github.com/Ulydev/push
local push = require 'push'

-- the "Class" library we're using will allow us to represent anything in
-- our game as code, rather than keeping track of many disparate variables and
-- methods
--
-- https://github.com/vrld/hump/blob/master/class.lua
Class = require 'class'

-- a basic StateMachine class which will allow us to transition to and from
-- game states smoothly and avoid monolithic code in one file
require 'StateMachine'

require 'states/BaseState'
require 'states/CountdownState'
require 'states/PlayState'
require 'states/GameOverState'
require 'states/TitleScreenState'

require 'Bird'
require 'Pipe'
require 'PipePair'


-- images
local BACKGROUND_IMAGE = love.graphics.newImage('images/background.png')
local GROUND_IMAGE = love.graphics.newImage('images/ground.png')

-- scrolling variables/constants
local backgroundScroll = 0
local groundScroll = 0
local BACKGROUND_SCROLL_SPEED = 30
local GROUND_SCROLL_SPEED = 60
local BACKGROUND_LOOPING_POINT = 413
-- global variable to scroll the screen during all states except GameOverState
Scrolling = true

-- resolution
local WINDOW_WIDTH = 1280
local WINDOW_HEIGHT = 720
VIRTUAL_WIDTH = 512
VIRTUAL_HEIGHT = 288

function SetWindowsProperties()
    love.window.setTitle('Flappy bird')
    love.graphics.setDefaultFilter('nearest', 'nearest')
    push:setupScreen(VIRTUAL_WIDTH, VIRTUAL_HEIGHT, WINDOW_WIDTH, WINDOW_HEIGHT, {
        fullscreen = false,
        resizable = true,
        vsync = true
    })
end

function InitialiseFonts()
    -- initialize our nice-looking retro text fonts
    SmallFont = love.graphics.newFont('fonts/font.ttf', 8)
    MediumFont = love.graphics.newFont('fonts/flappy.ttf', 14)
    FlappyFont = love.graphics.newFont('fonts/flappy.ttf', 28)
    HugeFont = love.graphics.newFont('fonts/flappy.ttf', 56)
    love.graphics.setFont(FlappyFont)
end

function InitialiseSounds()
    Sounds = {
        ['jump'] = love.audio.newSource('audio/jump.wav', 'static'),
        ['explosion'] = love.audio.newSource('audio/explosion.wav', 'static'),
        ['hurt'] = love.audio.newSource('audio/hurt.wav', 'static'),
        ['score'] = love.audio.newSource('audio/score.wav', 'static'),

        -- https://freesound.org/people/xsgianni/sounds/388079/
        ['music'] = love.audio.newSource('audio/marios_way.mp3', 'static')
    }
end

function InitialiseStateMachine()
    -- initialize state machine with all state-returning functions
    GStateMachine = StateMachine {
        ['title'] = function() return TitleScreenState() end,
        ['countdown'] = function() return CountdownState() end,
        ['play'] = function() return PlayState() end,
        ['gameover'] = function() return GameOverState() end
    }
    GStateMachine:change('title')
end

function PlayMusic()
    Sounds['music']:setLooping(true)
    Sounds['music']:play()
end

function love.load()
    SetWindowsProperties()
    InitialiseFonts()
    InitialiseSounds()
    InitialiseStateMachine()
    PlayMusic()
    math.randomseed(os.time())
    -- initialise empty Table in LOVE2D's own love.keyboard Table
    -- this will be used to keep track of key presses in the game
    love.keyboard.keysPressed = {}
    -- same with mouse
    love.mouse.buttonsPressed = {}
end

-- capture a key press into our keysPressed Table
function love.keypressed(key)
    love.keyboard.keysPressed[key] = true
    if key == 'escape' then
        love.event.quit()
    end
end

-- capture a mouse click into our buttonsPressed Table
function love.mousepressed(x, y, button)
    love.mouse.buttonsPressed[button] = true
end

--[[ 
    Add a custom function to a LOVE2D Table
    We are doing this so we can implement checks for key presses
    in game object classes. Now each class with have access to 
    love.keyboard.wasPressed(key) and be able to define it's own
    [key] press response 
]]
function love.keyboard.wasPressed(key)
    -- return true if the key has been pressed
    return love.keyboard.keysPressed[key]
end

-- same as above but for mouse clicks
function love.mouse.wasPressed(button)
    return love.mouse.buttonsPressed[button]
end

-- use push to resize the windows cleanly
function love.resize(w, h)
    push:resize(w, h)
end

function love.update(dt)
    if Scrolling then
        -- this expression has the effect of adding 0.5 to backgroundScroll
        -- every frame. When the value reaches 413 then 413 % 413 = 0
        -- this resets the image position to (0, 0)
        backgroundScroll = (backgroundScroll + BACKGROUND_SCROLL_SPEED * dt)
            % BACKGROUND_LOOPING_POINT

        -- here we use the VIRTUAL_WIDTH as the reset width since the image
        -- used for the ground is small and has a repeating pattern. It is
        -- impossible to notice the translation back to (0, VIRTUAL_HEIGHT-16)
        groundScroll = (groundScroll + GROUND_SCROLL_SPEED * dt)
            % VIRTUAL_WIDTH
    end

    -- update the state machine every frame
    GStateMachine:update(dt)

    -- flush the keysPressed Table on every frame so new input
    -- can be read in
    love.keyboard.keysPressed = {}
    love.mouse.buttonsPressed = {}
end

function love.draw()
    push:start()
    -- negating the width param causes the image to move to the left
    -- giving the illusion that it is travelling to the right
    love.graphics.draw(BACKGROUND_IMAGE, -backgroundScroll, 0)
    GStateMachine:render()
    love.graphics.draw(GROUND_IMAGE, -groundScroll, VIRTUAL_HEIGHT-16)
    push:finish()
end