Pipe = Class{}

local PIPE_IMAGE = love.graphics.newImage('images/pipe.png')
-- speed at which the pipe should scroll right to left
PIPE_SPEED = 60

-- height of pipe image, globally accessible
PIPE_HEIGHT = 288
PIPE_WIDTH = 70

function Pipe:init(orientation, y)
    self.x = VIRTUAL_WIDTH
    -- place the pipes at random points on the y axis
    self.y = y
    self.width = PIPE_IMAGE:getWidth()
    self.height = PIPE_HEIGHT
    self.orientation = orientation
end

function Pipe:render()
    love.graphics.draw(
        PIPE_IMAGE,                                                         -- image file
        self.x,                                                             -- x axis
        self.orientation == 'top' and (self.y + PIPE_HEIGHT) or self.y,     -- y axis
        0,                                                                  -- rotation in radians
        1,                                                                  -- x axis scale factor (1 == no scale)
        self.orientation == 'top' and -1 or 1                               -- y axis scale factor (-1 == inverted/mirrored))
    )
end
