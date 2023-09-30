PipePair = Class{}

-- see Visio diagram for info on where values come from
UPPER_LIMIT = -PIPE_HEIGHT + 50
LOWER_LIMIT = UPPER_LIMIT + 82
local GAP_HEIGHT = 90

function PipePair:init(y)
    -- flag to test if this pair has been passed
    self.scored = false
    -- initialize pipes past the end of the screen
    self.x = VIRTUAL_WIDTH
    -- y value is for the topmost pipe; gap is a vertical shift of the second lower pipe
    self.y = y
    self.pipes = {
        ['upper'] = Pipe('top', self.y),
        ['lower'] = Pipe('bottom', self.y + PIPE_HEIGHT + GAP_HEIGHT)
    }
    -- whether this pipe pair is ready to be removed from the scene
    self.remove = false
end

function PipePair:update(dt)
    -- remove the pipe from the scene if it's beyond the left edge of the screen,
    -- else move it from right to left
    if self.x > -PIPE_WIDTH then
        self.x = self.x - PIPE_SPEED * dt
        self.pipes['lower'].x = self.x
        self.pipes['upper'].x = self.x
    else
        self.remove = true
    end
end

function PipePair:render()
    for k, pipe in pairs(self.pipes) do
        pipe:render()
    end
end