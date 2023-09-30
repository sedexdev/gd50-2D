--[[
    Given an "atlas" (a texture with multiple sprites), as well as a
    width and a height for the tiles therein, split the texture into
    all of the quads by simply dividing it evenly.

    This method works if the sprite sheet contains sprites of equal
    width, separated on lines of equal height. Good for animated 
    sprites where all textures have the same dimensions 
]]
function GenerateQuads(atlas, tileWidth, tileHeight)
    local numTiles = atlas:getWidth() / tileWidth
    local numRows = atlas:getHeight() / tileHeight

    local tileCount = 1
    local spriteSheet = {}

    for y = 0, numRows - 1 do
        for x = 0, numTiles - 1 do
            spriteSheet[tileCount] = love.graphics.newQuad(
                x * tileWidth,
                y * tileHeight,
                tileWidth,
                tileHeight,
                atlas:getDimensions()
            )
            tileCount = tileCount + 1
        end
    end
    return spriteSheet
end

--[[
    Utility function for slicing tables, like Python

    https://stackoverflow.com/questions/24821045/does-lua-have-something-like-pythons-slice
]]
function table.slice(table, first, last, step)
    local sliced = {}

    -- the #table syntax means the 'length' of table
    for i = first or 1, last or #table, step or 1 do
        -- Table indexing starts at 1
      sliced[#sliced+1] = table[i]
    end

    return sliced
end

function GeneratePaddles(atlas)
    local x = 0
    local y = 64

    local counter = 1
    local quads = {}

    for i = 0, 3 do
        -- smallest
        quads[counter] = love.graphics.newQuad(x, y, 32, 16, atlas:getDimensions())
        counter = counter + 1
        -- medium
        quads[counter] = love.graphics.newQuad(x + 32, y, 64, 16, atlas:getDimensions())
        counter = counter + 1
        -- large
        quads[counter] = love.graphics.newQuad(x + 96, y, 96, 16, atlas:getDimensions())
        counter = counter + 1
        -- huge
        quads[counter] = love.graphics.newQuad(x, y + 16, 128, 16, atlas:getDimensions())
        counter = counter + 1

        -- prepare X and Y for the next set of paddles
        x = 0
        y = y + 32
    end

    return quads
end

function GenerateBalls(atlas)
    local counter = 1
    local quads = {}

    local function addQuads(count, x, y)
        for i = 0, count do
            quads[counter] = love.graphics.newQuad(x, y, 8, 8, atlas:getDimensions())
            x = x + 8
            counter = counter + 1
        end
    end

    addQuads(3, 96, 48)
    addQuads(2, 96, 56)

    return quads
end

function GenerateBricks(atlas)
    local spriteSheet = GenerateQuads(atlas, 32, 16)
    local bricks = table.slice(spriteSheet, 1, 21)
    local keyBrick = table.slice(spriteSheet, 24, 24)
    table.insert(bricks, keyBrick[1])
    return bricks
end

function GeneratePowerUps(atlas)
    local spriteSheet = GenerateQuads(atlas, 16, 16)
    -- 192 is the width of the spritesheet: 
    -- 192 / 16 = 12
    -- 12^2 = 144
    -- +1 because we know the powerups are on the 13th row
    local firstSprite = math.pow(192 / 16, 2) + 1
    local lastSprite = firstSprite + 12
    return table.slice(spriteSheet, firstSprite, lastSprite)
end
