PlayState = Class{__includes = BaseState}

function PlayState:enter(params)
    -- state attributes
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
    -- random ball starting velocity
    self.ball.dx = math.random(-200, 200)
    self.ball.dy = math.random(-50, -60)
    self.paused = false
end

function PlayState:CheckPaddleCollisions(ball)
    if ball:collides(self.paddle) then
        -- correct hit loop bug by reseting the ball
        ball.y = self.paddle.y - 8
        -- reverse ball velocity
        ball.dy = -ball.dy
        self.paddle:correctBallImpact(ball)
        GAudio['paddle-hit']:play()
    end
end

function PlayState:CheckBrickCollisions(ball)
    for _, brick in pairs(self.bricks) do
        if brick.inPlay and ball:collides(brick) then
            -- alter ball on impact
            ball:checkImpact(brick)
            -- update score
            self.score = self.score + (brick.tier * 200 + brick.skin * 25)
            -- register brick collisions
            brick:hit(self.hasKey)
            -- if we bumped the key brick down because we had the key, reset hasKey
            if brick.skin == 6 and brick.tier == 0 then
                self.numKeys = self.numKeys - 1
                if self.numKeys == 0 then
                    self.hasKey = false
                end
            end

            -- check for victory - no remaining bricks
            if self.levelObj:checkVictory() then
                GAudio['victory']:play()

                GStateMachine:change('victory', {
                    paddle = self.paddle,
                    ball = self.ball,
                    additionalBalls = {},
                    bricks = self.bricks,
                    powerups = self.powerups,
                    hud = self.hud,
                    health = self.health,
                    score = self.score,
                    level = self.level,
                    highScores = self.highScores
                })
            end

            -- speed up the ball
           ball.dy = ball.dy * 1.02
            -- only collide with one brick at a time
            break
        end
    end
end

function PlayState:CheckPowerUpCollisions(ball)
    for _, powerup in pairs(self.powerups) do
        if powerup.inPlay and ball:collides(powerup) then
            ball:checkImpact(powerup)
            local id = powerup:hit()
            if id == 3 then
                if self.health < 3 then
                    self.health = self.health + 1
                end
            elseif id == 9 then
                local newBall = Ball()
                newBall.x = self.paddle.x + (self.paddle.width / 2) - 4
                newBall.y = self.paddle.y - 8
                newBall.dx = math.random(-200, 200)
                newBall.dy = math.random(-50, -60)
                table.insert(self.additionalBalls, newBall)
            elseif id == 10 then
                self.hasKey = true
                self.numKeys = self.numKeys + 1
            end
            -- speed up the ball
            ball.dy = ball.dy * 1.02
            break
        end
    end
end

function PlayState:update(dt)
    if love.keyboard.wasPressed('space') then
        self.paused = not self.paused
        GAudio['pause']:play()
    end

    if not self.paused then
        self.paddle:update(dt)
        self.ball:update(dt)

        self:CheckPaddleCollisions(self.ball)
        self:CheckBrickCollisions(self.ball)
        self:CheckPowerUpCollisions(self.ball)

        for k, ball in pairs(self.additionalBalls) do
            ball:update(dt)
            if ball.y > VIRTUAL_HEIGHT then
                -- remove additional balls that go below bounds
                table.remove(self.additionalBalls, k)
            end
            self:CheckPaddleCollisions(ball)
            self:CheckBrickCollisions(ball)
            self:CheckPowerUpCollisions(ball)
        end

        -- check if main ball went below bounds
        if self.ball.y > VIRTUAL_HEIGHT then
            self.health = self.health - 1
            if self.health == 0 then
                GStateMachine:change('gameover', {
                    score = self.score,
                    highScores = self.highScores
                })
            else
                GStateMachine:change('serve', {
                    paddle = self.paddle,
                    ball = self.ball,
                    additionalBalls = {},
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
        end

        -- update the particle systems
        for k, brick in pairs(self.bricks) do
            brick:update(dt)
        end
        for k, powerup in pairs(self.powerups) do
            powerup:update(dt)
        end
    else
        if love.keyboard.wasPressed('escape') then
            GStateMachine:change('menu', {
                highScores = self.highScores
            })
        end
    end
end

function PlayState:render()

    -- render the bricks in this level
    for k, brick in pairs(self.bricks) do
        brick:render()
        brick:renderParticles()
    end

    -- render the powerups in this level
    for k, powerup in pairs(self.powerups) do
        powerup:render()
        powerup:renderParticles()
    end

    self.paddle:render()
    self.ball:render()
    for _, ball in pairs(self.additionalBalls) do
        ball:render()
    end
    self.hud:render(self.level, self.numKeys, self.health, self.score)

    if self.paused then
        love.graphics.setFont(GFonts['large'])
        love.graphics.printf(
            "PAUSED",
            0,
            VIRTUAL_HEIGHT / 2 - 16,
            VIRTUAL_WIDTH,
            'center')

        love.graphics.setFont(GFonts['small'])
        love.graphics.printf(
            "Press escape to quit to menu",
            0,
            VIRTUAL_HEIGHT / 2 + 32,
            VIRTUAL_WIDTH,
            'center')
    end
end