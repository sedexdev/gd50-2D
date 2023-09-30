VictoryState = Class{__includes = BaseState}

function VictoryState:enter(params)
    self.paddle = params.paddle
    self.ball = params.ball
    self.additionalBalls = params.additionalBalls
    self.bricks = params.bricks
    self.powerups = params.powerups
    self.hud = params.hud
    self.health = params.health
    self.score = params.score
    self.level = params.level
    self.highScores = params.highScores
end

function VictoryState:update(dt)
    self.paddle:update(dt)

    self.ball.x = self.paddle.x + (self.paddle.width / 2) - 4
    self.ball.y = self.paddle.y - 8

    -- go to play screen if the player presses Enter
    if love.keyboard.wasPressed('enter') or love.keyboard.wasPressed('return') then
        local levelObj = Level()
        self.level = self.level + 1
        local map = levelObj:createMap(self.level)
        GStateMachine:change('serve', {
            paddle = self.paddle,
            ball = self.ball,
            additionalBalls = self.additionalBalls,
            levelObj = levelObj,
            bricks = map.bricks,
            powerups = map.powerups,
            hud = self.hud,
            health = self.health,
            score = self.score,
            level = self.level,
            highScores = self.highScores
        })
    end
end

function VictoryState:render()
    self.paddle:render()
    self.ball:render()
    self.hud:render(self.level, self.health, self.score)

    -- level complete text
    love.graphics.setFont(GFonts['large'])
    love.graphics.printf("Level " .. tostring(self.level) .. " complete!",
        0, VIRTUAL_HEIGHT / 4,
        VIRTUAL_WIDTH,
        'center'
    )

    -- instructions text
    love.graphics.setFont(GFonts['medium'])
    love.graphics.printf('Press Enter to serve!',
        0, VIRTUAL_HEIGHT / 2,
        VIRTUAL_WIDTH,
        'center'
    )
end