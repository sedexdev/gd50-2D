--[[
    The PlayState class is the bulk of the game, where the player actually controls the bird and
    avoids pipes. When the player collides with a pipe, we should go to the GameOver state, where
    we then go back to the main menu.
]]
PlayState = Class{__includes = BaseState}

function PlayState:init()
    self.bird = Bird()
    self.pipePairs = {}
    self.pipeSpawnTimer = 0
    self.score = 0
    self.lastY = -PIPE_HEIGHT + math.random(80) + 20
    self.corrected = false
end

function PlayState:correctY(shift, y)
    if y + shift < UPPER_LIMIT then
        y = UPPER_LIMIT + math.random(10)
        self.corrected = true
    elseif y + shift > LOWER_LIMIT then
        y = LOWER_LIMIT - math.random(10)
        self.corrected = true
    end
end

function PlayState:update(dt)
    -- add dt to the time so it goes up by 1/60 every frame
    self.pipeSpawnTimer = self.pipeSpawnTimer + dt

    -- if timer goes past 2 seconds
    if self.pipeSpawnTimer > 2 then
        -- set shift value
        local shift = math.random(-20, 20)
        -- check for image off screen corrections
        PlayState:correctY(shift, self.lastY)
        -- set new pipes y based on shift and any corrections
        local newPipeY = self.corrected and self.lastY or self.lastY + shift
        -- reset corrections flag
        self.corrected = false
        -- set lastY to the value of the new pipes y
        self.lastY = newPipeY
        -- add the new pipe to the scene by updating pipePairs
        table.insert(self.pipePairs, PipePair(newPipeY))
        -- reset the timer
        self.pipeSpawnTimer = 0
    end

    -- check for scoring and update all pipe pair objects
    for k, pair in pairs(self.pipePairs) do
        if not pair.scored then
            if pair.x + PIPE_WIDTH < self.bird.x then
                self.score = self.score + 1
                pair.scored = true
                Sounds['score']:play()
            end
        end
        -- update the position of the pipe pair
        pair:update(dt)
    end

    -- remove any flagged pipes to save memory
    for k, pair in pairs(self.pipePairs) do
        if pair.remove then
            table.remove(self.pipePairs, k)
        end
    end

    -- test for collisions
    for k, pair in pairs(self.pipePairs) do
        for l, pipe in pairs(pair.pipes) do
            if self.bird:collides(pipe) then
                Sounds['explosion']:play()
                Sounds['hurt']:play()

                GStateMachine:change('gameover', {
                    score = self.score
                })
            end
        end
    end

    -- update the bird object
    self.bird:update(dt)

    -- change to gameover state if bird hits the ground
    if self.bird.y > VIRTUAL_HEIGHT - 16 then
        Sounds['explosion']:play()
        Sounds['hurt']:play()

        GStateMachine:change('gameover', {
            score = self.score
        })
    end
end

function PlayState:render()
    -- render pipes
    for k, pair in pairs(self.pipePairs) do
        pair:render()
    end

    -- render game score font
    love.graphics.setFont(FlappyFont)
    love.graphics.print('Score: ' .. tostring(self.score), 8, 8)

    -- render bird
    self.bird:render()
end

function PlayState:enter()
    Scrolling = true
end

function PlayState:exit()
    Scrolling = false
end