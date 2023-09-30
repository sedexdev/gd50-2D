Bird = Class{}

local GRAVITY = 20
local ANTI_GRAVITY = -5

function Bird:init()
    self.image = love.graphics.newImage('images/bird.png')
    self.width = self.image:getWidth()
    self.height = self.image:getHeight()
    self.x = VIRTUAL_WIDTH / 2 - (self.width / 2)
    self.y = VIRTUAL_HEIGHT / 2 - (self.height / 2)
    self.dy = 0
end

function Bird:update(dt)
    -- increase the velocity by adding gravity * dt to the 
    -- change in y (dy velocity)
    self.dy = self.dy + GRAVITY * dt

    -- check for space key press (jump)
    if love.keyboard.wasPressed('space') then
        self.dy = ANTI_GRAVITY
        Sounds['jump']:play()
    end

    -- update y with the change
    self.y = self.y + self.dy
end

function Bird:render()
    -- render the bird in the centre of the screen
    love.graphics.draw(self.image, self.x, self.y)
end

function Bird:collides(pipe)
    local offset = 2
    local correction = 4
    if ((self.x + offset) > pipe.x + pipe.width) or (pipe.x > (self.x + offset) + (self.width - correction)) then
        return false
    end
    if ((self.y + offset) > pipe.y + pipe.height) or (pipe.y > (self.y + offset) + (self.height - correction)) then
        return false
    end
    return true
end