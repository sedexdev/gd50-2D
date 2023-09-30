-- windows size
WINDOW_WIDTH = 1280
WINDOW_HEIGHT = 720

-- virtual resolution
VIRTUAL_WIDTH = 432
VIRTUAL_HEIGHT = 243

-- change in x for the paddle
PADDLE_SPEED = 200

-- colour pallette to be used with the particle system
PARTICLE_RGB = {
    -- blue
    [1] = {
        ['r'] = 99,
        ['g'] = 155,
        ['b'] = 255
    },
    -- green
    [2] = {
        ['r'] = 106,
        ['g'] = 190,
        ['b'] = 47
    },
    -- red
    [3] = {
        ['r'] = 217,
        ['g'] = 87,
        ['b'] = 99
    },
    -- purple
    [4] = {
        ['r'] = 215,
        ['g'] = 123,
        ['b'] = 186
    },
    -- gold
    [5] = {
        ['r'] = 251,
        ['g'] = 242,
        ['b'] = 54
    },
    -- black
    [6] = {
        ['r'] = 10,
        ['g'] = 10,
        ['b'] = 10
    }
}

POWERUPS = {
    [1] = 3, -- health
    [2] = 9, -- ball
    [3] = 10 -- key
}