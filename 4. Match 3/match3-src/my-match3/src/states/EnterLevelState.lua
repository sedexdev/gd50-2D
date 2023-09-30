EnterLevelState = Class{__includes = BaseState}

function EnterLevelState:init()
    -- white screen animation tween
    self.startTransition = 1
    -- level banner should be off-screen then tween in
    self.levelBannerY = -64
    -- render board from x=240, y=16
    self.board = Board(VIRTUAL_WIDTH - 272, 16)
end

function EnterLevelState:enter(params)
    self.highScores = params.highScores
    self.level = params.level
    self.score = params.score
    -- tween white fade animation back to transparent
    Timer.tween(1, {
        [self] = {startTransition = 0}
    })

    -- tween level banner down the screen to the center
    Timer.tween(1, {
        [self] = {levelBannerY = VIRTUAL_HEIGHT / 2 - 24}
    }):finish(function()
        -- after 2 seconds tween the banner off screen and change to play state
        Timer.after(2, function()
            Timer.tween(1, {
                [self] = {levelBannerY = VIRTUAL_HEIGHT + 48}
            }):finish(function()
                GStateMachine:change('play', {
                    highScores = self.highScores,
                    level = self.level,
                    board = self.board,
                    score = self.score
                })
            end)
        end)
    end)

end

function EnterLevelState:update(dt)
    if love.keyboard.wasPressed('escape') then
        love.event.quit()
    end
    -- DON'T FORGET TO UPDATE THE TIMER!!
    Timer.update(dt)
end

function EnterLevelState:render()
    -- render a board of random tiles
    self.board:render()

    -- render Level banner and background rectangle
    love.graphics.setColor(95/255, 205/255, 228/255, 200/255)
    love.graphics.rectangle('fill', 0, self.levelBannerY, VIRTUAL_WIDTH, 48)
    love.graphics.setColor(1, 1, 1, 1)
    love.graphics.setFont(GFONTS['large'])
    love.graphics.printf('Level ' .. tostring(self.level),
        0, self.levelBannerY + 8,
        VIRTUAL_WIDTH,
        'center'
    )

    -- draw white rectangle for fade animation
    love.graphics.setColor(1, 1, 1, self.startTransition)
    love.graphics.rectangle('fill', 0, 0, VIRTUAL_WIDTH, VIRTUAL_HEIGHT)
end
