TestState2 = Class{__includes = BaseState}

function TestState2:init()
    self.a = 10
    self.b = 20
end

function TestState2:update(dt)
    self.a = self.a * dt + 1
    self.b = self.b * dt + 1
end

function TestState2:render()
    love.graphics.printf(
        'self.a = ' .. tostring(self.a) .. ', self.b = ' .. tostring(self.b),
        0,
        150,
        VIRTUAL_WIDTH,
        'center'
    )
end