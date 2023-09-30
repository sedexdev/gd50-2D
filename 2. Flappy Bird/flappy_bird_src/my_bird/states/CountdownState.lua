--[[
    Counts down visually on the screen (3,2,1) so that the player knows the
    game is about to begin. Transitions to the PlayState as soon as the
    countdown is complete.
]]
CountdownState = Class{__includes = BaseState}

function CountdownState:init()
    self.count = 3
    self.timer = 0
end

function CountdownState:update(dt)
    self.timer = self.timer + dt

    if self.timer >= 1 then
        self.timer = 0
        self.count = self.count - 1

        if self.count == 0 then
            GStateMachine:change('play')
        end
    end
end

function CountdownState:render()
    love.graphics.setFont(HugeFont)
    love.graphics.printf(tostring(self.count), 0, 120, VIRTUAL_WIDTH, 'center')
end