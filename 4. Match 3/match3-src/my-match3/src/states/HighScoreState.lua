HighScoreState = Class{__includes = BaseState}

function HighScoreState:enter(params)
    self.highScores = params.highScores
    Timer.tween(1, {
        [self] = { transitionAlpha = 0 }
    })
end

function HighScoreState:init()
    self.transitionAlpha = 1
end

function HighScoreState:update(dt)
    if love.keyboard.wasPressed('escape') then
        GStateMachine:change('menu', {
            highScores = self.highScores
        })
    end
    Timer.update(dt)
end

function HighScoreState:render()
    -- display the highscore list
    love.graphics.setFont(GFONTS['large'])
    love.graphics.printf('High Scores', 0, 20, VIRTUAL_WIDTH, 'center')

    love.graphics.setFont(GFONTS['medium'])

    -- iterate over all high score indices in our high scores table
    for i = 1, 10 do
        local name = self.highScores[i].name or '---'
        local level = self.highScores[i].level or '---'
        local score = self.highScores[i].score or '---'

        -- score number (1-10)
        love.graphics.printf(tostring(i) .. '.',
            VIRTUAL_WIDTH / 4, 60 + i * 13,
            50,
            'left'
        )

        -- score name
        love.graphics.printf(name,
            VIRTUAL_WIDTH / 4, 60 + i * 13,
            50,
            'right'
        )
        
        -- level acheieved
        love.graphics.printf(tostring(level),
            VIRTUAL_WIDTH / 4 + 70, 60 + i * 13,
            50,
            'right'
        )
        
        -- score itself
        love.graphics.printf(tostring(score),
            VIRTUAL_WIDTH / 2, 60 + i * 13,
            100,
            'right'
        )
    end

    love.graphics.setFont(GFONTS['small'])
    love.graphics.printf("Press Escape to return to the main menu!",
        0, VIRTUAL_HEIGHT - 18,
        VIRTUAL_WIDTH,
        'center'
    )

    -- transition screen
    love.graphics.setColor(1, 1, 1, self.transitionAlpha)
    love.graphics.rectangle('fill', 0, 0, VIRTUAL_WIDTH, VIRTUAL_HEIGHT)
end