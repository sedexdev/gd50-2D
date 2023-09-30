ServeState = Class{__includes = BaseState}

function ServeState:enter(params)
    self.paddle = params.paddle
    self.ball = params.ball
    self.additionalBalls = params.additionalBalls
    self.levelObj = params.levelObj
    self.bricks = params.bricks
    self.powerups = params.powerups
    self.hud = params.hud
    self.health = params.health
    self.score = params.score
    self.level = params.level
    self.highScores = params.highScores
    self.numKeys = params.numKeys
    self.hasKey = params.hasKey
end

function ServeState:update(dt)
    -- track the ball with the paddle
    self.paddle:update(dt)
    self.ball.x = self.paddle.x + (self.paddle.width / 2) - 4
    self.ball.y = self.paddle.y - 8

    if love.keyboard.wasPressed('enter') or love.keyboard.wasPressed('return') then
        GStateMachine:change('play', {
            paddle = self.paddle,
            ball = self.ball,
            additionalBalls = self.additionalBalls,
            levelObj = self.levelObj,
            bricks = self.bricks,
            powerups = self.powerups,
            hud = self.hud,
            health = self.health,
            score = self.score,
            level = self.level,
            highScores = self.highScores,
            numKeys = self.numKeys,
            hasKey = self.hasKey
        })
    end

    if love.keyboard.wasPressed('exit') then
        love.event.quit()
    end
end

function ServeState:render()
    self.paddle:render()
    self.ball:render()
    self.hud:render(self.level, self.numKeys, self.health, self.score)


    for k, brick in pairs(self.bricks) do
        brick:render()
    end

    for k, powerup in pairs(self.powerups) do
        powerup:render()
    end

    love.graphics.setFont(GFonts['medium'])
    love.graphics.printf('Press Enter to serve!',
        0, VIRTUAL_HEIGHT / 2,
        VIRTUAL_WIDTH,
        'center')
end