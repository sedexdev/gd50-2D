--[[
    Ball class containing attributes and operations
    specific to the ball object 
]]

Ball = Class{}

function Ball:init(x, y, width, height)
    self.x = x
    self.y = y
    self.width = width
    self.height = height

    -- set random directional velocity for the ball at game start
    -- e.g (x=100, y=-35) or (x=-100, y=47)
    self.dx = math.random(2) == 1 and 100 or -100
    self.dy = math.random(-50, 50)
end

function Ball:update(dt)
    -- move ball in random direction to start
    self.x = self.x + self.dx * dt
    self.y = self.y + self.dy * dt
end

function Ball:render()
    -- rectangle object for gameplay (ball)
    love.graphics.rectangle('fill', self.x, self.y, self.width, self.height)
end

function Ball:reset()
    -- set ball location
    self.x = VIRTUAL_WIDTH / 2 - 2
    self.y = VIRTUAL_HEIGHT / 2 - 2

    -- set random directional velocity for the ball at game start
    -- e.g (x=100, y=-35) or (x=-100, y=47)
    self.dx = math.random(2) == 1 and 100 or -100
    self.dy = math.random(-50, 50)
end

function Ball:collides(paddle)
    -- first, check to see if the left edge of either is farther to the right
    -- than the right edge of the other
    if (self.x > paddle.x + paddle.width) or (paddle.x > self.x + self.width) then
        return false
    end

    -- then check to see if the bottom edge of either is higher than the top
    -- edge of the other
    if (self.y > paddle.y + paddle.height) or (paddle.y > self.y + self.height) then
        return false
    end

    -- if the above aren't true, they're overlapping
    return true
end