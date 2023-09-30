Player = Class{}

function Player:init()
    self.width = 16
    self.height = 20
    self.x = VIRTUAL_WIDTH / 2 - self.width / 2
    self.y = (TILE_HEIGHT * 6) - self.height
    self.dy = 0
    self.idleAnimation = Animation:create({ 1 }, 1)
    self.movingAnimation = Animation:create({ 10, 11 }, 0.2)
    self.jumpingAnimation = Animation:create({ 3 }, 1)
    self.currentAnimation = self.idleAnimation
    self.direction = 'right'
end

function Player:update(dt)
    self.currentAnimation:update(dt)

    if love.keyboard.isDown('right') then
        self.x = self.x + PLAYER_SCROLL_SPEED * dt
        if self.dy == 0 then
            self.currentAnimation = self.movingAnimation
        end
        self.direction = 'right'
    elseif love.keyboard.isDown('left') then
        self.x = self.x - PLAYER_SCROLL_SPEED * dt
        if self.dy == 0 then
            self.currentAnimation = self.movingAnimation
        end
        self.direction = 'left'
    else
        self.currentAnimation = self.idleAnimation
    end

    if love.keyboard.wasPressed('space') and self.dy == 0 then
        -- set alien dy to negative value to jump
        self.dy = PLAYER_JUMP_VELOCITY
        self.currentAnimation = self.jumpingAnimation
    end

    -- update alien dy/y so gravity acts on the alien
    self.dy = self.dy + GRAVITY * dt
    self.y = self.y + self.dy

    -- stop alien from falling through the ground
    if self.y > (TILE_HEIGHT * 6) - PLAYER_HEIGHT then
        self.y = (TILE_HEIGHT * 6) - PLAYER_HEIGHT
        self.dy = 0
    end
end

function Player:render()
    --[[
        draw character, this time getting the current frame from the animation
        we also check for our direction and scale by -1 on the X axis if we're facing left
        when we scale by -1, we have to set the origin (x, y) to the center of the sprite 
        as well for proper flipping
    ]]
    love.graphics.draw(GTEXTURES['alien'], GQUADS['aliens'][self.currentAnimation:getCurrentFrame()],

        -- X and Y we draw at need to be shifted by half our width and height because we're setting the origin
        -- to that amount for proper scaling, which reverse-shifts rendering
        math.floor(self.x) + self.width / 2, math.floor(self.y) + self.height / 2,

        -- 0 rotation, then the X and Y scales
        0, self.direction == 'left' and -1 or 1, 1,

        -- lastly, the origin offsets relative to 0,0 on the sprite (set here to the sprite's center)
        self.width / 2, self.height / 2)
end