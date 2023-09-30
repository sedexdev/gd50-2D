-- Lua's version of inheritance using the class.lua library
TitleScreenState = Class{__includes = BaseState}

function TitleScreenState:init()
    -- nothing to do here
end

function TitleScreenState:update(dt)
    if love.keyboard.wasPressed('enter') or love.keyboard.wasPressed('return') then
        GStateMachine:change('countdown')
    end
end

function TitleScreenState:render()
    love.graphics.setFont(FlappyFont)
    love.graphics.printf('Fifty Bird', 0, 64, VIRTUAL_WIDTH, 'center')

    love.graphics.setFont(MediumFont)
    love.graphics.printf('Press Enter', 0, 100, VIRTUAL_WIDTH, 'center')
end
