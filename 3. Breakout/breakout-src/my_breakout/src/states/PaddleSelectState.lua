PaddleSelectState = Class{__includes = BaseState}

function PaddleSelectState:enter(params)
    self.highScores = params.highScores
    self.selected = 1
end

function PaddleSelectState:update(dt)
    if love.keyboard.wasPressed('left') then
        if self.selected == 1 then
            GAudio['no-select']:play()
        else
            GAudio['select']:play()
            self.selected = self.selected - 1
        end
    end

    if love.keyboard.wasPressed('right') then
        if self.selected == 4 then
            GAudio['no-select']:play()
        else
            GAudio['select']:play()
            self.selected = self.selected + 1
        end
    end

    if love.keyboard.wasPressed('enter') or love.keyboard.wasPressed('return') then
        GAudio['confirm']:play()
        local levelObj = Level()
        local level = 1
        local map = levelObj:createMap(level)
        -- pass state to PlayState
        GStateMachine:change('serve', {
            paddle = Paddle(self.selected),
            ball = Ball(),
            additionalBalls = {},
            levelObj = levelObj,
            bricks = map.bricks,
            powerups = map.powerups,
            hud = HUD(),
            health = 3,
            score = 0,
            level = level,
            highScores = self.highScores,
            numKeys = 0,
            hasKey = false
        })
    end

    if love.keyboard.wasPressed('escape') then
        GStateMachine:change('menu', {
            highScores = self.highScores
        })
    end
end

function PaddleSelectState:render()
    -- instructions
    love.graphics.setFont(GFonts['medium'])
    love.graphics.printf("Select your paddle with left and right!",
        0, VIRTUAL_HEIGHT / 4,
        VIRTUAL_WIDTH,
        'center'
    )
    love.graphics.setFont(GFonts['small'])
    love.graphics.printf("(Press Enter to continue!)",
        0, VIRTUAL_HEIGHT / 3,
        VIRTUAL_WIDTH,'center'
    )

    -- left arrow; should render normally if we're higher than 1, else
    -- in a shadowy form to let us know we're as far left as we can go
    if self.selected == 1 then
        -- tint; give it a dark gray with half opacity
        love.graphics.setColor(40/255, 40/255, 40/255, 128/255)
    end

    love.graphics.draw(GTextures['arrows'],
        GQuads['arrows'][1],
        VIRTUAL_WIDTH / 4 - 24,
        VIRTUAL_HEIGHT - VIRTUAL_HEIGHT / 3
    )

    -- reset drawing color to full white for proper rendering
    love.graphics.setColor(1, 1, 1, 1)

    -- right arrow; should render normally if we're less than 4, else
    -- in a shadowy form to let us know we're as far right as we can go
    if self.selected == 4 then
        -- tint; give it a dark gray with half opacity
        love.graphics.setColor(40/255, 40/255, 40/255, 128/255)
    end

    love.graphics.draw(GTextures['arrows'],
        GQuads['arrows'][2],
        VIRTUAL_WIDTH - VIRTUAL_WIDTH / 4,
        VIRTUAL_HEIGHT - VIRTUAL_HEIGHT / 3)

    -- reset drawing color to full white for proper rendering
    love.graphics.setColor(1, 1, 1, 1)

    -- draw the paddle itself, based on which we have selected
    love.graphics.draw(GTextures['main'],
        GQuads['paddles'][2 + 4 * (self.selected - 1)],
        VIRTUAL_WIDTH / 2 - 32,
        VIRTUAL_HEIGHT - VIRTUAL_HEIGHT / 3
    )
end