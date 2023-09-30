Animation = Class{}

function Animation:init(params)
    -- table containing frame indexes for an animation sequence
    self.frames = params.frames
    self.interval = params.interval
    self.timer = 0
    self.currentFrame  = 1
end

function Animation:update(dt)
    if #self.frames > 1 then                        -- if this animation has more than one frame
        self.timer = self.timer + dt                -- increment the timer by dt
        if self.timer > self.interval then          -- if the timer goes past the frame interval
            self.timer = self.timer % self.interval -- reset the timer using the interval value

            -- set the current frame to the next frame
            -- reset to 1 when we go over the number of frames in this sequence
            self.currentFrame = math.max(1, (self.currentFrame + 1) % (#self.frames + 1))
        end
    end
end

-- factory method for creating Animation instances
function Animation:create(frames, interval)
    return Animation {
        frames = frames,
        interval = interval
    }
end

function Animation:getCurrentFrame()
    return self.frames[self.currentFrame]
end