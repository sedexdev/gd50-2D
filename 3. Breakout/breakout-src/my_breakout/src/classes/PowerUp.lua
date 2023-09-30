PowerUp = Class{}

function PowerUp:init(x, y, id)
    self.x = x
    self.y = y
    self.width = 16
    self.height = 16
    self.id = id
    self.inPlay = true
    self.psystem = love.graphics.newParticleSystem(GTextures['particle'], 64)
    self.psystem:setParticleLifetime(0.5, 1)
    self.psystem:setLinearAcceleration(-15, 0, 15, 80)
    self.psystem:setEmissionArea('normal', 10, 10)
end

function PowerUp:hit()
    self.psystem:setColors(1, 215, 0, 1, 1, 215, 0, 0)
    self.psystem:emit(64)
    GAudio['victory']:play()
    self.inPlay = false

    -- return the id of the power up
    return self.id
end

function PowerUp:update(dt)
    self.psystem:update(dt)
end

function PowerUp:render()
    if self.inPlay then
        love.graphics.draw(GTextures['main'],
            GQuads['powerups'][self.id],
            self.x,
            self.y
        )
    end
end

function PowerUp:renderParticles()
    love.graphics.draw(self.psystem, self.x + 8, self.y + 8)
end