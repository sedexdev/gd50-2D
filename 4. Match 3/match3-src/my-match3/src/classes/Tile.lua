Tile = Class{}

function Tile:init(x, y, skin, pattern)
    -- positions in the 2D matrix
    self.gridX = x
    self.gridY = y
    -- coordinates in the window
    self.x = (self.gridX - 1) * 32
    self.y = (self.gridY - 1) * 32
    self.skin = skin
    self.pattern = pattern
end

function Tile:render(x, y)
    -- draw shadow
    love.graphics.setColor(34, 32, 52, 255)
    love.graphics.draw(GTEXTURES['main'],
        GQUADS['tiles'][self.skin][self.pattern],
        self.x + x + 2,
        self.y + y + 2
    )
    -- draw tile itself
    love.graphics.setColor(255, 255, 255, 255)
    love.graphics.draw(GTEXTURES['main'],
        GQUADS['tiles'][self.skin][self.pattern],
        self.x + x,
        self.y + y)
end