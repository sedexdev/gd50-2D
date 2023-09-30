Paddle = Class{}

function Paddle:init(skin)
    self.x = VIRTUAL_WIDTH / 2 - 32
    self.y = VIRTUAL_HEIGHT - 30
    self.dx = 0
    self.width = 64
    self.height = 16
    -- 4 different colours (1-4)
    self.skin = skin
    -- 4 different lengths (1-4)
    self.size = 2
end

function Paddle:correctBallImpact(ball)
    local paddleCentre = self.x + (self.width / 2)
    local impactPoint = paddleCentre - ball.x
    -- ball hits left side of paddle while paddle is moving left
    if ball.x < paddleCentre and self.dx < 0 then
        ball.dx = -50 + -(8 * impactPoint)
    -- ball hits right side of paddle while paddle is moving right
    elseif ball.x > paddleCentre and self.dx > 0 then
        ball.dx = 50 + (8 * math.abs(impactPoint))
    end
    GAudio['paddle-hit']:play()
end

function Paddle:update(dt)
    if love.keyboard.isDown('left') then
        self.dx = -PADDLE_SPEED
    elseif love.keyboard.isDown('right') then
        self.dx = PADDLE_SPEED
    else
        self.dx = 0
    end

    if self.dx < 0 then
        self.x = math.max(0, self.x + self.dx * dt)
    else
        self.x = math.min(VIRTUAL_WIDTH - self.width, self.x + self.dx * dt)
    end
end

function Paddle:render()
    -- Formula for finding the correct index of chosen paddle quad
    -- self.size + 4 * (self.skin - 1)
    -- E.g.
    --      2 + 4 * (1 - 1)
    --    = 2 + 4 * 0
    --    = 2
    love.graphics.draw(GTextures['main'],
        GQuads['paddles'][self.size + 4 * (self.skin - 1)],
        self.x,
        self.y
    )
end
