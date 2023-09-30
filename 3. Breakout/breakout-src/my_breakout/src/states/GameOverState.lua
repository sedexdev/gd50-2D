GameOverState = Class{__includes = BaseState}

function GameOverState:enter(params)
    self.score = params.score
    self.highScores = params.highScores
end

function GameOverState:update(dt)
    if love.keyboard.wasPressed('enter') or love.keyboard.wasPressed('return') then
        -- use flag to find high score
        local gotHighScore = false
        local index = nil

        -- loop over highScores table to find a new high score
        for i = 1, #self.highScores do
            if self.score > self.highScores[i].score then
                index = i
                gotHighScore = true
                break
            end
        end

        if gotHighScore then
            GAudio['high-score']:play()
            GStateMachine:change('enter', {
                score = self.score,
                highScores = self.highScores,
                index = index
            })
        else
            GStateMachine:change('menu', {
                highScores = self.highScores
            })
        end
    end

    if love.keyboard.wasPressed('escape') then
        love.event.quit()
    end
end

function GameOverState:render()
    love.graphics.setFont(GFonts['large'])
    love.graphics.printf('GAME OVER',
        0, VIRTUAL_HEIGHT / 3,
        VIRTUAL_WIDTH,
        'center'
    )
    love.graphics.setFont(GFonts['medium'])
    love.graphics.printf('Final Score: ' .. tostring(self.score),
        0, VIRTUAL_HEIGHT / 2,
        VIRTUAL_WIDTH,
        'center'
    )
    love.graphics.printf('Press Enter!',
        0, VIRTUAL_HEIGHT - VIRTUAL_HEIGHT / 4,
        VIRTUAL_WIDTH,
        'center'
    )
end