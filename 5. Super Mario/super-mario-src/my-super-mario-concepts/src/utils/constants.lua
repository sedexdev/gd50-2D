-- windows resolution
WINDOW_WIDTH = 1280
WINDOW_HEIGHT = 720
-- virtual inner resolution
VIRTUAL_WIDTH = 256
VIRTUAL_HEIGHT = 144

-- map dimensions
MAP_WIDTH = 20
MAP_HEIGHT = 20

-- tile map IDs
GROUND = 3
SKY = 5

-- number of tile sets in the tile sheet = 60
TILE_ATLAS_COLUMNS = 6  -- x
TILE_ATLAS_ROWS = 10    -- y

-- number of topper sets in the topper sheet = 108
TOPPER_ATLAS_COLUMNS = 6
TOPPER_ATLAS_ROWS = 18

-- number of tiles in both sets = 20
SHEET_SET_COLUMNS = 5  -- x
SHEET_SET_ROWS = 4     -- y

-- tile dimensions
TILE_WIDTH = 16
TILE_HEIGHT = 16

-- character
PLAYER_WIDTH = 16
PLAYER_HEIGHT = 20
PLAYER_SCROLL_SPEED = 60
PLAYER_JUMP_VELOCITY = -4
GRAVITY = 7

-- global resources
GTEXTURES = {
    ['tiles'] = love.graphics.newImage('graphics/tiles.png'),
    ['tiletops'] = love.graphics.newImage('graphics/tile_tops.png'),
    ['alien'] = love.graphics.newImage('graphics/green_alien.png')
}

GQUADS = {
    ['tiles'] = GenerateQuads(GTEXTURES['tiles'], TILE_WIDTH, TILE_HEIGHT),
    ['tiletops'] = GenerateQuads(GTEXTURES['tiletops'], TILE_WIDTH, TILE_HEIGHT),
    ['aliens'] = GenerateQuads(GTEXTURES['alien'], PLAYER_WIDTH, PLAYER_HEIGHT),
}

GTILES = {
    ['tilesets'] = GenerateTileSet(GQUADS['tiles'],
        TILE_ATLAS_COLUMNS,
        TILE_ATLAS_ROWS,
        SHEET_SET_COLUMNS,
        SHEET_SET_ROWS
    ),
    ['toppersets'] = GenerateTileSet(GQUADS['tiletops'],
        TOPPER_ATLAS_COLUMNS,
        TOPPER_ATLAS_ROWS,
        SHEET_SET_COLUMNS,
        SHEET_SET_ROWS
    )
}