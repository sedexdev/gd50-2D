VictoryState = Class{__includes = BaseState}

function VictoryState:enter(params)
    GAUDIO['next-level']:play()
    self.highScores = params.highScores
    self.level = params.level
    self.score = params.score
    Timer.tween(1, {
        [self] = { bannerY = VIRTUAL_HEIGHT / 2 - 24 }
    }):finish(function()
        Timer.after(1, function ()
            Timer.tween(1, {
                [self] = { bannerY = VIRTUAL_HEIGHT + 48}
            }):finish(function()
                GStateMachine:change('entergame', {
                    highScores = self.highScores,
                    level = self.level + 1,
                    score = self.score
                })
            end)
        end)
    end)
end

function VictoryState:init()
    self.bannerY = -48
end

function VictoryState:update(dt)
    Timer.update(dt)
end

function VictoryState:render()
    -- draw victory banner
    love.graphics.setColor(233/255, 169/255, 0/255, 200/255)
    love.graphics.rectangle('fill', 0, self.bannerY, VIRTUAL_WIDTH, 48)
    love.graphics.setColor(1, 1, 1, 1)
    love.graphics.setFont(GFONTS['large'])
    love.graphics.printf('Victory!',
        0, self.bannerY + 8,
        VIRTUAL_WIDTH,
        'center'
    )
end