function GenerateQuads(atlas, tileWidth, tileHeight)
    -- /2 to get 6 columns, not 12 as the spritesheet has 18 rows
    local numCols = (atlas:getWidth() / tileWidth) / 2
    local numRows = atlas:getHeight() / tileHeight
    local quads = {}
    local counter = 1

    local createQuads = function(x, y)
        local originalX = x
        for i = 1, numRows do
            -- create nested table for each row of tiles
            quads[counter] = {}
            for j = 1, numCols do
                table.insert(quads[counter], love.graphics.newQuad(x, y, tileWidth, tileHeight, atlas))
                x = x + tileWidth
            end
            x = originalX
            y = y + tileHeight
            counter = counter + 1
        end
    end

    createQuads(0, 0)
    createQuads(atlas:getWidth() / 2, 0)

    return quads
end
