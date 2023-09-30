Brick = Class{__includes = BaseState}

function Brick:init(x, y)
    self.skin = 1
    self.tier = 0
    self.x = x
    self.y = y
    self.width = 32
    self.height = 16
    self.inPlay = true
    -- particle system
    self.psystem = love.graphics.newParticleSystem(GTextures['particle'], 64)
    -- lasts between 0.5-1 seconds seconds
    self.psystem:setParticleLifetime(0.5, 1)
    -- set linear acceleration
    self.psystem:setLinearAcceleration(-15, 0, 15, 80)
    -- particle spread
    self.psystem:setEmissionArea('normal', 10, 10)
end

function Brick:hit(hasKey)
    -- set the particle system to interpolate between two colors; in this case, we give
    -- it our self.skin but with varying alpha; brighter for higher tiers, fading to 0
    -- over the particle's lifetime (the second color)
    if self.skin == 6 and self.tier == 1 then
        if not hasKey then
            GAudio['no-select']:play()
            return
        end
    end
    self.psystem:setColors(
        PARTICLE_RGB[self.skin].r / 255,
        PARTICLE_RGB[self.skin].g / 255,
        PARTICLE_RGB[self.skin].b / 255,
        55 * (self.tier + 1) / 255,
        PARTICLE_RGB[self.skin].r / 255,
        PARTICLE_RGB[self.skin].g / 255,
        PARTICLE_RGB[self.skin].b / 255,
        0
    )
    self.psystem:emit(64)

    -- play sound on hit
    GAudio['brick-hit-2']:stop()
    GAudio['brick-hit-2']:play()

    if self.tier > 0 then
        -- drop to next tier for this skin
        self.tier = self.tier - 1
    else
        if self.skin == 1 then
            -- no memory management here, just don't draw it
            self.inPlay = false
        else
            -- otherwise drop a skin and reset the tier
            self.skin = self.skin - 1
            self.tier = 3
        end
    end

    -- play second layer sound on destroy
    if not self.inPlay  then
        GAudio['brick-hit-1']:stop()
        GAudio['brick-hit-1']:play()
    end
end

function Brick:update(dt)
    self.psystem:update(dt)
end

function Brick:render()
    if self.inPlay then
    -- Formula for finding the correct index of chosen brick quad
        -- brickIndex = ((self.skin - 1) * 4) + 1 + self.tier
        
        -- self.skin * 4                          <-- find the right skin group, too high so -1
        -- (self.skin - 1) * 4                    <-- too low, so +1 (table index starts at 1)
        -- ((self.skin - 1) * 4) + 1              <-- Gives correct index of the skin block, now add the tier
        -- ((self.skin - 1) * 4) + 1 + self.tier  <-- now it finds skin block and tier
    
        -- E.g.
        --      ((1 - 1) * 4) + 1 + 0
        --    = (0 * 4) + 1 + 0
        --    = 1 
        love.graphics.draw(GTextures['main'],
            GQuads['bricks'][((self.skin - 1) * 4) + 1 + self.tier],
            self.x,
            self.y
        )
    end
end

function Brick:renderParticles()
    love.graphics.draw(self.psystem, self.x + 16, self.y + 8)
end