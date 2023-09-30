HUD = Class{}

function HUD:render(level, numKeys, health, score)
    -- render health
    local healthX = VIRTUAL_WIDTH - 100

    local function renderHealth(index)
        -- just use health to render solid hearts
        -- use 3 - health to find empty hearts
        for i = 1, index == 2 and 3 - health or health do
            love.graphics.draw(GTextures['hearts'],
                GQuads['hearts'][index],
                healthX,
                4
            )
            healthX = healthX + 12
        end
    end

    renderHealth(1)
    renderHealth(2)

    -- render level
    love.graphics.setFont(GFonts['small'])
    love.graphics.setColor(0, 1, 0, 1)
    love.graphics.print('Level: ' .. tostring(level), 5, 5)

    -- render any icons for keys we have
    love.graphics.setColor(1, 1, 1, 1)
    local keyX = 40
    for i = 1, numKeys do
        love.graphics.draw(GTextures['main'],
            GQuads['powerups'][10],
            keyX,
            4
        )
        keyX = keyX + 18
    end

    -- render score
    -- love.graphics.setColor(1, 1, 1, 1)
    love.graphics.print('Score:', VIRTUAL_WIDTH - 60, 5)
    love.graphics.printf(tostring(score), VIRTUAL_WIDTH - 50, 5, 40, 'right')
end