Ball = Class{__includes = BaseState}

function Ball:init()
    self.x = VIRTUAL_WIDTH / 2 - 4
    self.y = VIRTUAL_HEIGHT - 38
    self.dx = 0
    self.dy = 0
    self.width = 8
    self.height = 8
    self.skin = math.random(7)
end

function Ball:collides(object)
    if (self.x > object.x + object.width) or (object.x > self.x + self.width) then
        return false
    elseif (self.y > object.y + object.height) or (object.y > self.y + self.height) then
        return false
    end
    return true
end

function Ball:checkImpact(object)
    -- check for left edge collision when moving right
    if self.x + 2 < object.x and self.dx > 0 then
        self.dx = -self.dx
        self.x = object.x - 8
    -- check for right edge collision when moving left
    elseif self.x + 6 > object.x + object.width and self.dx < 0 then
        self.dx = -self.dx
        self.x = object.x + 32
    -- if no x collisions check top edge
    elseif self.y < object.y then
        self.dy = -self.dy
        self.y = object.y - 8
    -- last condition is the ball hit the bottom edge
    else
        self.dy = -self.dy
        self.y = object.y + 16
    end
end

function Ball:update(dt)
    self.x = self.x + self.dx * dt
    self.y = self.y + self.dy * dt

    -- check bounce off left wall
    if self.x < 0 then
        self.x = 0
        self.dx = -self.dx
        GAudio['wall-hit']:play()
    end
    -- check bounce off right wall
    if self.x >= VIRTUAL_WIDTH - 8 then
        self.x = VIRTUAL_WIDTH - 8
        self.dx = -self.dx
        GAudio['wall-hit']:play()
    end
    -- check bounce off ceiling
    if self.y <= 0 then
        self.y = 0
        self.dy = -self.dy
        GAudio['wall-hit']:play()
    end
    -- check gone past bottom of screen
    if self.y >= VIRTUAL_HEIGHT then
        GAudio['hurt']:play()
    end
end

function Ball:render()
    love.graphics.draw(GTextures['main'],
        GQuads['balls'][self.skin],
        self.x,
        self.y
    )
end