GameOverState = Class{__includes = BaseState}

function GameOverState:enter(params)
    self.highScores = params.highScores
    self.level = params.level
    self.score = params.score
end

function GameOverState:update(dt)
    -- check for highscores
    local gotHighScore = false
    local pauseInput = true
    local index = nil

    -- get the index of the highscore if found
    for i = 1, #self.highScores do
        if self.score > self.highScores[i].score then
            index = i
            gotHighScore = true
            break
        end
    end

    -- enter highscore state if necessary
    if gotHighScore then
        GAUDIO['next-level']:play()
        GStateMachine:change('enterhighscore', {
            highScores = self.highScores,
            level = self.level,
            score = self.score,
            index = index
        })
    else
        pauseInput = false
    end

    if not pauseInput then
        if love.keyboard.wasPressed('enter') or love.keyboard.wasPressed('return') then
            GStateMachine:change('menu', {
                highScores = self.highScores
            })
        end
    end
end

function GameOverState:render()
    -- draw rectangle behind score
    love.graphics.setColor(56/255, 56/255, 56/255, 230/255)
    love.graphics.rectangle('fill', VIRTUAL_WIDTH / 2 - 64, 64, 128, 136, 6)
    -- draw text
    love.graphics.setFont(GFONTS['large'])
    love.graphics.setColor(99/255, 155/255, 1, 1)
    love.graphics.printf('GAME OVER', VIRTUAL_WIDTH / 2 - 64, 64, 128, 'center')
    love.graphics.setFont(GFONTS['medium'])
    love.graphics.printf('Your Score: ' .. tostring(self.score), VIRTUAL_WIDTH / 2 - 64, 140, 128, 'center')
    love.graphics.printf('Press Enter', VIRTUAL_WIDTH / 2 - 64, 180, 128, 'center')
end