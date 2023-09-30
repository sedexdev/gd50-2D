--[[
    Paddle class containing attributes and operations
    specific to the paddle objects 
]]

Paddle = Class{}

function Paddle:init(x, y, width, height, upkey, downkey)
    self.x = x
    self.y = y
    self.width = width
    self.height = height
    self.upkey = upkey
    self.downkey = downkey
    self.dy = 0
    self.speed = 200
end

function Paddle:update(dt)
    if self.dy < 0 then
        -- move paddle up
        self.y = math.max(0, self.y + self.dy * dt)
    else
        -- move paddle down
        io.write(tostring(self.y) .. ' + ' .. tostring(self.dy) .. ' * ' .. tostring(dt) .. ' = ' .. tostring(self.y + self.dy * dt) .. '\n')
        self.y = math.min(VIRTUAL_HEIGHT - 20, self.y + self.dy * dt)
    end
end

function Paddle:render()
    love.graphics.rectangle('fill', self.x, self.y, self.width, self.height)
end

function Paddle:setDY()
    -- set players control keys
    if love.keyboard.isDown(self.upkey) then
        self.dy = -self.speed
    elseif love.keyboard.isDown(self.downkey) then
        self.dy = self.speed
    else
        self.dy = 0
    end
end
