MenuState = Class{__includes = BaseState}

function MenuState:enter(params)
    self.highScores = params.highScores
end

function MenuState:init()
    self.selected = 1
    -- title colour change RGB values
    self.colours = {
        [1] = {217/255, 87/255, 99/255, 1},
        [2] = {95/255, 205/255, 228/255, 1},
        [3] = {251/255, 242/255, 54/255, 1},
        [4] = {118/255, 66/255, 138/255, 1},
        [5] = {153/255, 229/255, 80/255, 1},
        [6] = {223/255, 113/255, 38/255, 1}
    }
    -- x of each letter relative to the centre of the window
    self.letterTable = {
        {'M', -108},
        {'A', -64},
        {'T', -28},
        {'C', 2},
        {'H', 40},
        {'3', 112}
    }

    -- the knife/timer module gives us access to an interval function
    self.colourTimer = Timer.every(0.075, function()
        -- rotate colours every time this function is called
        self.colours[0] = self.colours[6]
        -- self.colours[0] is used as a place holder to shift the other colours
        for i = 6, 1, -1 do
            self.colours[i] = self.colours[i-1]
        end
    end)

    -- generate a 64 quad map of random tiles
    self.tiles = self:createTileMap()
    self.playTransitionAlpha = 0
    self.pauseInput = false
end

-- example of tweening: changing a table value over time
function MenuState:transition(state, params)
    -- transition into PlayState using a tween
    Timer.tween(1, {
        [self] = {playTransitionAlpha = 1}
    -- after duration of 1 second call finish to execute an annoymous asynchronous callback
    }):finish(function()
        GStateMachine:change(state, params)
    end)
    -- stop the colour timer from updating MATCH 3 letter colours
    self.colourTimer:remove()
end

function MenuState:update(dt)
    if not self.pauseInput then
        -- menu option selection
        if love.keyboard.wasPressed('up') then
            GAUDIO['select']:play()
            self.selected = self.selected - 1
            if self.selected < 1 then
                self.selected = 3
            end
        end
        if love.keyboard.wasPressed('down') then
            GAUDIO['select']:play()
            self.selected = self.selected + 1
            if self.selected > 3 then
                self.selected = 1
            end
        end
        -- changed state on choice
        if love.keyboard.wasPressed('enter') or love.keyboard.wasPressed('return') then
            if self.selected == 1 then
                self:transition('entergame', {
                    highScores = self.highScores,
                    level = 1,
                    score = 0
                })
            elseif self.selected == 2 then
                self:transition('highscores', {
                    highScores = self.highScores
                })
            else
                love.event.quit()
            end
            -- stop player from making selections during transition
            self.pauseInput = true
        end
    end
    -- Timer objects must be upated using dt to behave consistently
    Timer.update(dt)
end

function MenuState:render()
    -- render all tiles and their drop shadows
    self:renderTileMap()
    -- draw the menu over the tile map
    self:drawMenu()
end

--[[
    Function for drawing all the text components of the menu screen
]]
function MenuState:drawMenu()
    -- keep the background and tiles a little darker than normal
    love.graphics.setColor(0, 0, 0, 128/255)
    love.graphics.rectangle('fill', 0, 0, VIRTUAL_WIDTH, VIRTUAL_HEIGHT)

    self:drawTitle()

    local y = 12
    -- draw rect behind options
    love.graphics.setColor(1, 1, 1, 128/255)
    love.graphics.rectangle('fill', VIRTUAL_WIDTH / 2 - 76, VIRTUAL_HEIGHT / 2 + y, 150, 82, 6)
    -- set text and highlighting for menu options with their y offsets
    self:setOptions('Start', y, 8, 1)
    self:setOptions('High Scores', y, 33, 2)
    self:setOptions('Quit Game', y, 58, 3)
    -- draw our transition rect; is normally fully transparent, unless we're moving to a new state
    love.graphics.setColor(1, 1, 1, self.playTransitionAlpha)
    love.graphics.rectangle('fill', 0, 0, VIRTUAL_WIDTH, VIRTUAL_HEIGHT)
end

--[[
    HELPER FUNCTIONS
]]

-- create a map of random tile quad images
function MenuState:createTileMap()
    local map = {}
    for _ = 1, 64 do
        local colour = math.random(18)
        local tile = math.random(6)
        table.insert(map, GQUADS['tiles'][colour][tile])
    end
    return map
end

-- draws the map to the menu screen
function MenuState:renderTileMap()
    local counter = 1
    for y = 1, 8 do
        for x = 1, 8 do
            -- render shadow first
            love.graphics.setColor(0, 0, 0, 1)
            love.graphics.draw(GTEXTURES['main'],
                self.tiles[counter],
                -- x + 128 is for centering: V_WIDTH = 512, 512 / 128 = 4
                -- so x starts 1/4 of the width across and ends 3/4 of the width
                (x - 1) * 32 + 128 + 3,
                -- y + 16 for vertical centering
                (y - 1) * 32 + 16 + 3)

            -- render tile
            love.graphics.setColor(1, 1, 1, 1)
            love.graphics.draw(GTEXTURES['main'],
                self.tiles[counter],
                -- no need to add 3, +3 was for the shadow offset
                (x - 1) * 32 + 128,
                (y - 1) * 32 + 16)
            counter = counter + 1
        end
    end
end

-- Draws "Start" and "Quit Game" text over semi-transparent rectangles.
function MenuState:setOptions(option, y, yOffset, selected)
    love.graphics.setFont(GFONTS['medium'])

    self:drawShadow(option, VIRTUAL_HEIGHT / 2 + y + yOffset)

    -- change colour based on which option is selected
    if self.selected == selected then
        love.graphics.setColor(99/255, 155/255, 1, 1)
    else
        love.graphics.setColor(48/255, 96/255, 130/255, 1)
    end
    love.graphics.printf(option, 0, VIRTUAL_HEIGHT / 2 + y + yOffset, VIRTUAL_WIDTH, 'center')
end

-- Draw the centered MATCH-3 text with background rect, placed along 
-- the Y axis as needed, relative to the center.
function MenuState:drawTitle()
    -- set y offset 
    local y = -60
    -- draw semi-transparent rect behind MATCH 3
    love.graphics.setColor(1, 1, 1, 128/255)
    love.graphics.rectangle('fill', VIRTUAL_WIDTH / 2 - 76, VIRTUAL_HEIGHT / 2 + y - 11, 150, 58, 6)
    -- draw MATCH 3 text shadows
    love.graphics.setFont(GFONTS['large'])

    self:drawShadow('MATCH 3', VIRTUAL_HEIGHT / 2 + y + 2)

    -- print MATCH 3 letters in their corresponding current colours
    for i = 1, 6 do
        love.graphics.setColor(self.colours[i])
        love.graphics.printf(self.letterTable[i][1],
            0, VIRTUAL_HEIGHT / 2 + y + 2,
            VIRTUAL_WIDTH + self.letterTable[i][2],
            'center'
        )
    end
end

-- Draws several layers of the same black text over top of one 
-- another to form a thick shadow
function MenuState:drawShadow(text, y)
    love.graphics.setColor(34/255, 32/255, 52/255, 1)
    love.graphics.printf(text, 2, y + 1, VIRTUAL_WIDTH, 'center')
    love.graphics.printf(text, 1, y + 1, VIRTUAL_WIDTH, 'center')
    love.graphics.printf(text, 0, y + 1, VIRTUAL_WIDTH, 'center')
    love.graphics.printf(text, 1, y + 2, VIRTUAL_WIDTH, 'center')
end
