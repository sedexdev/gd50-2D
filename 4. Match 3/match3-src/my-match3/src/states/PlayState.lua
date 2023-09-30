PlayState = Class{__includes = BaseState}

function PlayState:init()
    self.startTransition = 1
    -- tile selector x, y
    self.tileSelectorX = 0
    self.tileSelectorY = 0
    -- selectors flashing highligh
    self.selectorFlash = false
    self.pauseInput = false
    self.selectedTile = nil
    self.timer = 60
    -- toggle selector highlighting every 0.5s
    Timer.every(0.5, function()
        self.selectorFlash = not self.selectorFlash
    end)
    -- count the timer down
    Timer.every(1, function()
        self.timer = self.timer - 1
        -- play warning sound on low time
        if self.timer <= 5 then
            GAUDIO['clock']:play()
        end
    end)
end

function PlayState:enter(params)
    self.highScores = params.highScores
    self.level = params.level
    self.board = params.board or Board(VIRTUAL_WIDTH - 272, 16)
    self.score = params.score
    self.winningScore = (self.level * 1.25) * 1000
    -- check for matches on game start
    self:calculateMatches()
end

function PlayState:update(dt)
    if love.keyboard.wasPressed('escape') then
        love.event.quit()
    end

    -- gameover conditions
    if self.timer <= 0 then
        -- always clear timers on state change
        Timer.clear()
        GAUDIO['game-over']:play()
        GStateMachine:change('gameover', {
            highScores = self.highScores,
            level = self.level,
            score = self.score
        })
    end

    -- win level conditions
    if self.score >= self.winningScore then
        Timer.clear()
        GStateMachine:change('victory', {
            highScores = self.highScores,
            level = self.level,
            score = self.score
        })
    end

    -- game play conditions
    if not self.pauseInput then
        -- update the x and y of the selector
        if love.keyboard.wasPressed('up') then
            self.tileSelectorY = math.max(0, self.tileSelectorY - 1)
            GAUDIO['select']:play()
        end
        if love.keyboard.wasPressed('down') then
            self.tileSelectorY = math.min(7, self.tileSelectorY + 1)
            GAUDIO['select']:play()
        end
        if love.keyboard.wasPressed('left') then
            self.tileSelectorX = math.max(0, self.tileSelectorX - 1)
            GAUDIO['select']:play()
        end
        if love.keyboard.wasPressed('right') then
            self.tileSelectorX = math.min(7, self.tileSelectorX + 1)
            GAUDIO['select']:play()
        end

        if love.keyboard.wasPressed('enter') or love.keyboard.wasPressed('return') then
            -- set x, y of selected tile (+1 because Tables are 1-based, not 0)
            local x = self.tileSelectorX + 1
            local y = self.tileSelectorY + 1
            -- select current tile if nothing is selected
            if not self.selectedTile then
                self.selectedTile = self.board.tiles[y][x]
            -- remove selectedTile if we select the already selected tile
            elseif self.selectedTile == self.board.tiles[y][x] then
                self.selectedTile = nil
            -- make sure tiles to swap are adjacent (distance of 1 between them)
            elseif math.abs(self.selectedTile.gridX - x) + math.abs(self.selectedTile.gridY - y) > 1 then
                GAUDIO['error']:play()
                self.selectedTile = nil
            else
                -- swap the selected tile with the tile at x, y
                local t2 = self.board.tiles[y][x]
                self.board:swapTiles(self.selectedTile, t2)
                -- execute the tweens
                Timer.tween(0.1, {
                    [self.selectedTile] = {x = t2.x, y = t2.y},
                    [t2] = {x = self.selectedTile.x, y = self.selectedTile.y}
                }):finish(function ()
                    self:calculateMatches()
                end)
            end
        end
    end
    Timer.update(dt)
end

function PlayState:calculateMatches()
    self.selectedTile = nil

    self.board:checkMatches()

    if self.board.numMatches > 0 then

        self.pauseInput = true
        GAUDIO['match']:stop()
        GAUDIO['match']:play()

        local totalTilesMatched = 0
        for _, matches in pairs(self.board.matches) do
            for _ in pairs(matches) do
                totalTilesMatched = totalTilesMatched + 1
            end
        end

        self.timer = self.timer + totalTilesMatched

        -- update the score for each match
        self.score = self.score + self.board.numMatches * 100
        -- set the tweens for the tiles
        local tweens = self.board:tweenTiles()
        -- reset the matches
        self.board:resetMatches()
        -- tween all tile tweens
        Timer.tween(0.25, tweens):finish(function()
            self:calculateMatches()
        end)
        self.pauseInput = false
    else
        self.pauseInput = false
    end
end

function PlayState:render()
    -- render board of tiles
    self.board:render()

    -- render highlighted tile if it exists
    if self.selectedTile then

        -- multiply so drawing white rect makes it brighter
        love.graphics.setBlendMode('add')

        love.graphics.setColor(1, 1, 1, 96/255)
        love.graphics.rectangle('fill', (self.selectedTile.gridX - 1) * 32 + (VIRTUAL_WIDTH - 272),
            (self.selectedTile.gridY - 1) * 32 + 16, 32, 32, 4)

        -- back to alpha
        love.graphics.setBlendMode('alpha')
    end

    -- render highlight rect color based on timer
    if self.rectHighlighted then
        love.graphics.setColor(217/255, 87/255, 99/255, 1)
    else
        love.graphics.setColor(172/255, 50/255, 50/255, 1)
    end

    -- draw actual cursor rect
    love.graphics.setLineWidth(4)
    love.graphics.rectangle('line', self.tileSelectorX * 32 + (VIRTUAL_WIDTH - 272),
        self.tileSelectorY * 32 + 16, 32, 32, 4)

    -- GUI text
    love.graphics.setColor(56/255, 56/255, 56/255, 234/255)
    love.graphics.rectangle('fill', 16, 16, 186, 116, 4)

    love.graphics.setColor(99/255, 155/255, 1, 1)
    love.graphics.setFont(GFONTS['medium'])
    love.graphics.printf('Level: ' .. tostring(self.level), 20, 24, 182, 'center')
    love.graphics.printf('Score: ' .. tostring(self.score), 20, 52, 182, 'center')
    love.graphics.printf('Goal : ' .. tostring(self.winningScore), 20, 80, 182, 'center')
    love.graphics.printf('Timer: ' .. tostring(self.timer), 20, 108, 182, 'center')
end