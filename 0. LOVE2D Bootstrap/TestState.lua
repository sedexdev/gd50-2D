TestState = Class{__includes = BaseState}

function TestState:init()
    self.x = 10
    self.y = 20
end

function TestState:update(dt)
    self.x = self.x * dt + 1
    self.y = self.y * dt  + 1
    if love.keyboard.wasPressed('enter') or love.keyboard.wasPressed('return') then
        GStateMachine:change('test2')
    end
end

function TestState:render()
    love.graphics.printf(
        'self.x = ' .. tostring(self.x) .. ', self.y = ' .. tostring(self.y),
        0,
        150,
        VIRTUAL_WIDTH,
        'center'
    )
end

function TestState:enter(params)
    self.x = params.value
end
