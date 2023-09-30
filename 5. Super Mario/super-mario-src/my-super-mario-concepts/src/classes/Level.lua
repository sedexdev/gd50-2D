Level = Class{}

function Level:init()
    self.tiles = {}
    -- random tiles to populate the level
    self.tileset = math.random(#GTILES['tilesets'])
    self.topperset = math.random(#GTILES['toppersets'])
end

function Level:update(dt)
    if love.keyboard.wasPressed('r') then
        self.tileset = math.random(#GTILES['tilesets'])
        self.topperset = math.random(#GTILES['toppersets'])
    end
end

function Level:render()
    for y = 1, MAP_HEIGHT do
        for x = 1, MAP_WIDTH do
            local tile = self.tiles[y][x]
            love.graphics.draw(GTEXTURES['tiles'],
                GTILES['tilesets'][self.tileset][tile.id],
                -- -1 so we start from (0, 0)
                (x - 1) * TILE_WIDTH, (y - 1) * TILE_HEIGHT
            )
            if tile.topper then
                love.graphics.draw(GTEXTURES['tiletops'],
                    GTILES['toppersets'][self.topperset][tile.id],
                    (x - 1) * TILE_WIDTH, (y - 1) * TILE_HEIGHT
                )
            end
        end
    end
end

function Level:generateLevel()
    for y = 1, MAP_HEIGHT do
        table.insert(self.tiles, {})
        for x = 1, MAP_WIDTH do
            table.insert(self.tiles[y], {
                id = SKY,
                topper =  false
            })
        end
    end

    -- iterate over the x of the map to draw the map in columns, not rows
    for x = 1, MAP_WIDTH do
        -- random chance to not draw anything - a chasm
        if math.random(7) == 1 then
            goto continue
        end

        -- random chance for a piller
        local spawnPillar = math.random(5) == 1

        if spawnPillar then
            for pillar = 4, 6 do
                self.tiles[pillar][x] = {
                    id = GROUND,
                    topper = pillar == 4 and true or false
                }
            end
        end

        -- always spawn ground
        for ground = 7, MAP_HEIGHT do
            self.tiles[ground][x] = {
                id = GROUND,
                topper = (not spawnPillar and ground == 7) and true or false
            }
        end

        ::continue::
    end

    return self.tiles
end