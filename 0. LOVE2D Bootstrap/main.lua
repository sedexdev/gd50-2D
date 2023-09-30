Push = require 'push'
Class = require 'class'

require 'BaseState'
require 'TestState'
require 'TestState2'
require 'Statemachine'

-- resolution
local WINDOW_WIDTH = 1280
local WINDOW_HEIGHT = 720
VIRTUAL_WIDTH = 512
VIRTUAL_HEIGHT = 288

local testFunctions = {
    test1 = function() love.graphics.printf('Heronimous', 0, 20, VIRTUAL_WIDTH, 'center') end,
    test2 = function() love.graphics.printf('Bosch!!', 0, 40, VIRTUAL_WIDTH, 'center') end,
}

function love.load()
    love.graphics.setBackgroundColor(115/255, 130/255, 90/255, 255/255)
    love.window.setTitle('Test')
    love.graphics.setDefaultFilter('nearest', 'nearest')
    Push:setupScreen(VIRTUAL_WIDTH, VIRTUAL_HEIGHT, WINDOW_WIDTH, WINDOW_HEIGHT, {
        fullscreen = false,
        resizable = true,
        vsync = true
    })
    GStateMachine = StateMachine {
        ['test'] = function() return TestState() end,
        ['test2'] = function() return TestState2() end
    }
    GStateMachine:change('test', {value = 1000})
    love.keyboard.keysPressed = {}
end

function love.keypressed(key)
    love.keyboard.keysPressed[key] = true
    if key == 'escape' then
        love.event.quit()
    end
end

function love.keyboard.wasPressed(key)
    -- return true if the key has been pressed
    return love.keyboard.keysPressed[key]
end

function love.update(dt)
    GStateMachine:update(dt)
end

function love.draw()
    Push:start()
    love.graphics.printf('TESTING', 0, 100, VIRTUAL_WIDTH, 'center')
    
    local testPlaceHolder = testFunctions

    testPlaceHolder:test1()
    testPlaceHolder:test2()

    GStateMachine:render()
    Push:finish()
end