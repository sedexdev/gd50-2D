MenuState = Class{__includes = BaseState}

function MenuState:enter(params)
    self.highScores = params.highScores
    -- keep track of which menu option is highlighted
    self.highlighted = 1
end

function MenuState:update(dt)
    if love.keyboard.wasPressed('up') or love.keyboard.wasPressed('down') then
        self.highlighted = self.highlighted == 1 and 2 or 1
        GAudio['paddle-hit']:play()
    end

    if love.keyboard.wasPressed('enter') or love.keyboard.wasPressed('return') then
        GAudio['confirm']:play()
        if self.highlighted == 1 then
            GStateMachine:change('paddleselect', {
                highScores = self.highScores
            })
        else
            GStateMachine:change('highscore', {
                highScores = self.highScores
            })
        end
    end

    if love.keyboard.wasPressed('escape') then
        love.event.quit()
    end
end

function MenuState:render()
    love.graphics.setFont(GFonts['large'])
    love.graphics.printf('BREAKOUT', 0, VIRTUAL_HEIGHT / 3, VIRTUAL_WIDTH, 'center')

    love.graphics.setFont(GFonts['medium'])

    if self.highlighted == 1 then
        love.graphics.setColor(103/255, 1, 1, 1)
    end
    love.graphics.printf('START', 0, VIRTUAL_HEIGHT / 2 + 70, VIRTUAL_WIDTH, 'center')
    love.graphics.setColor(1, 1, 1, 1)

    if self.highlighted == 2 then
        love.graphics.setColor(103/255, 1, 1, 1)
    end
    love.graphics.printf('HIGH SCORES', 0, VIRTUAL_HEIGHT / 2 + 90, VIRTUAL_WIDTH, 'center')
    love.graphics.setColor(1, 1, 1, 1)
end