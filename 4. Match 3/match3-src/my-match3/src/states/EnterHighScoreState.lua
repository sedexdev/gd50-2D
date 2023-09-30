EnterHighScoreState = Class{__includes = BaseState}

function EnterHighScoreState:enter(params)
    self.highScores = params.highScores
    self.level = params.level
    self.score = params.score
    self.index = params.index
end

function EnterHighScoreState:init()
    self.selected = 1
    self.chars = {
        [1] = 65,
        [2] = 65,
        [3] = 65,
    }
end

function EnterHighScoreState:update(dt)
    if love.keyboard.wasPressed('enter') or love.keyboard.wasPressed('return') then
        local playerName = ''
        for i = 1, 3 do
            playerName = playerName .. string.char(self.chars[i])
        end
        -- shift highScores down to fit in new score
        -- i = 10
        -- self.highScores[10] now = self.highScores[9] etc...
        for i = 10, self.index, -1 do
            if i == 1 then break end
            self.highScores[i] = {
                name = self.highScores[i - 1].name,
                level = self.highScores[i - 1].level,
                score = self.highScores[i - 1].score
            }
        end

        self.highScores[self.index].name = playerName
        self.highScores[self.index].level = self.level
        self.highScores[self.index].score = self.score

        WriteHighScoreFile(self.highScores)

        GStateMachine:change('highscores', {
            highScores = self.highScores
        })
    end

    -- select letters to enter name using ASCII
    if love.keyboard.wasPressed('left') then
        GAUDIO['select']:play()
        self.selected = self.selected == 1 and 3 or self.selected - 1
    end
    if love.keyboard.wasPressed('right') then
        GAUDIO['select']:play()
        self.selected = self.selected == 3 and 1 or self.selected + 1
    end
    if love.keyboard.wasPressed('up') then
        self.chars[self.selected] = self.chars[self.selected] + 1
        if self.chars[self.selected] > 90 then
            self.chars[self.selected] = 65
        end
    end
    if love.keyboard.wasPressed('down') then
        self.chars[self.selected] = self.chars[self.selected] - 1
        if self.chars[self.selected] < 65 then
            self.chars[self.selected] = 90
        end
    end
end

function EnterHighScoreState:render()
    love.graphics.setFont(GFONTS['medium'])
    love.graphics.printf('Your score: ' .. tostring(self.score),
        0, 30,
        VIRTUAL_WIDTH,
        'center'
    )

    love.graphics.setFont(GFONTS['large'])

    --
    -- render all three characters of the name
    --
    if self.selected == 1 then
        love.graphics.setColor(103/255, 1, 1, 1)
    end
    love.graphics.print(string.char(self.chars[1]), VIRTUAL_WIDTH / 2 - 28, VIRTUAL_HEIGHT / 2)
    love.graphics.setColor(1, 1, 1, 1)

    if self.selected == 2 then
        love.graphics.setColor(103/255, 1, 1, 1)
    end
    love.graphics.print(string.char(self.chars[2]), VIRTUAL_WIDTH / 2 - 6, VIRTUAL_HEIGHT / 2)
    love.graphics.setColor(1, 1, 1, 1)

    if self.selected == 3 then
        love.graphics.setColor(103/255, 1, 1, 1)
    end
    love.graphics.print(string.char(self.chars[3]), VIRTUAL_WIDTH / 2 + 20, VIRTUAL_HEIGHT / 2)
    love.graphics.setColor(1, 1, 1, 1)

    love.graphics.setFont(GFONTS['small'])
    love.graphics.printf('Press Enter to confirm!',
        0, VIRTUAL_HEIGHT - 18,
        VIRTUAL_WIDTH,
        'center'
    )
end