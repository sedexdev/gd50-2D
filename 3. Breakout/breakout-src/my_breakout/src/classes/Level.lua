Level = Class{}

-- returns table length
function table.length(T)
    local count = 0
    for _, _ in pairs(T) do count = count + 1 end
    return count
end

-- returns boolean whether table conatins an element
function table.contains(T, element)
    for _, el in pairs(T) do
        if el == element then
            return true
        end
    end
    return false
end

--[[
    Tail recursive function that updates a table <T> based on a read
    table <readT>. A random item is pulled from readT and inserted into
    T <loops> number of times. If the item already exists the function
    is called again without decrementing the <loops> parameter, otherwise
    the item is added and loops is decremented by 1 until it gets to 0
    and returns
]]
function PopuplateGridPositions(T, readT, loops)
    if loops == 0 then return end
    local item = readT[math.random(1, table.length(readT))]
    if table.contains(T, item) then
        PopuplateGridPositions(T, readT, loops)
    else
        table.insert(T, item)
        PopuplateGridPositions(T, readT, loops - 1)
    end
end

function Level:init()
    self.bricks = {}
    self.powerUps = {}
    self.powerUpPositions = {}
    self.keyBrickPositions = {}
    self.numRows = math.random(1, 5)
    -- 13 columns max: 432 % 32 = 13 R16 (R16 = remaining pixels)
    self.numCols = math.random(7, 13)
    -- ensure number of columns is odd
    self.numCols = self.numCols % 2 == 0 and (self.numCols + 1) or self.numCols
    -- powerup trackers
    self.numPowerUps = 0
    self.numKeys = 0
end

function Level:createMap(level)
    -- set highest tier for level we're on
    -- tiers are 0-3 so 3 must be the max ever set
    local maxTier = math.min(3, math.floor(level / 5))

    -- set highest colour for level we're on
    -- colours are 1-5 so 5 must be the max ever set
    local maxColour = math.min(5, level % 5 + 3)

    for y = 1, self.numRows do

        -- set the skipping rule
        local skipping = math.random(1, 2) == 1 and true or false
        local skipFlag = math.random(1, 2) == 1 and true or false

        -- set the alternating colours rule
        local alternating = math.random(1, 2) == 1 and true or false
        local alternateFlag = math.random(1, 2) == 1 and true or false

        -- get 2 colours to alternate between
        local colour1 = math.random(1, maxColour)
        local colour2 = math.random(1, maxColour)

        -- get 2 tiers to alternate between
        local tier1 = math.random(0, maxTier)
        local tier2 = math.random(0, maxTier)

        for x = 1, self.numCols do

            if skipping and skipFlag then
                skipFlag = not skipFlag
                -- goto continue label at end of loop
                goto continue
            else
                skipFlag = not skipFlag
            end

            local brick = Brick(
                    -- x-coordinate
                (x-1)                        -- decrement x by 1 because tables are 1-indexed, coords are 0
                * 32                         -- multiply by 32, the brick width
                + 8                          -- the screen should have 8 pixels of padding; we can fit 13 cols + 16 pixels total
                + (13 - self.numCols) * 16,  -- left-side padding for when there are fewer than 13 columns,
                -- y-coordinate
                y * 16   -- just use y * 16, since we need top padding anyway. +16 if we are making space for powerups
            )

            if alternating and alternateFlag then
                brick.skin = colour1
                brick.tier = tier1
                alternateFlag = not alternateFlag
            else
                brick.skin = colour2
                brick.tier = tier2
                alternateFlag = not alternateFlag
            end
            
            table.insert(self.bricks, brick)

            -- jump to here - effectively continuing
            ::continue::
        end
    end

    -- 1/5 chance of adding a power up to the level
    local addPowerUps = math.random(1, 5) == 1 and true or false

    if addPowerUps then
        -- set number of powerups in play 1-3
        self.numPowerUps = math.random(1, 3)
        -- create the powerup objects
        self:CreatePowerUps()
        -- set the number of key powerups in play
        self:SetNumKeys()
        -- populate a table full of bricks x coordinates to then base
        -- power up positions on
        PopuplateGridPositions(
            self.powerUpPositions,
            self:GetBrickXs(),
            self.numPowerUps
        )
        -- give each power up it's random x value
        self:ApplyPowerUpPositions()
        -- move all bricks down 16px to set powerups at the top
        self:AdjustBricks()
        -- -- if keys are in play
        if self.numKeys > 0 then
            -- populate a table full of self.bricks indices to then pull
            -- random bricks from to set key bricks
            PopuplateGridPositions(
                self.keyBrickPositions,
                self:GetBrickIndices(),
                self.numKeys
            )
            -- set the key bricks based on the table of keyBrickPositions
            self:ApplyKeyBrickPositions()
        end
    end

    return {
        bricks = self.bricks,
        powerups = self.powerUps
    }
end

-- creates self.numPowerUps number of power ups
function Level:CreatePowerUps()
    for _ = 1, self.numPowerUps do
        table.insert(self.powerUps, PowerUp(
            -- x is updated by Level:GetBrickXs() and Level:ApplyPowerUpPositions()
            _, 16,
            POWERUPS[math.random(1, 3)]
        ))
    end
end

-- set the number of key power ups in the level
function Level:SetNumKeys()
    for _, powerup in pairs(self.powerUps) do
        if powerup.id == 10 then
            self.numKeys = self.numKeys + 1
        end
    end
end

-- returns a table of the x coordinate of each brick 
function Level:GetBrickXs()
    local bricksX = {}
    for _, brick in pairs(self.bricks) do
        table.insert(bricksX, brick.x)
    end
    return bricksX
end

-- applies an x coordinate to all powerups (+8 to center powerup with bricks)
function Level:ApplyPowerUpPositions()
    for k, powerup in pairs(self.powerUps) do
        powerup.x = self.powerUpPositions[k] + 8
    end
end

-- applies the key brick skin to randomly chosen bricks based on self.numKeys
function Level:ApplyKeyBrickPositions()
    for _, pos in pairs(self.keyBrickPositions) do
       self.bricks[pos].skin = 6
       self.bricks[pos].tier = 1
    end
end

-- nudge all bricks down 16px if we are adding power ups
function Level:AdjustBricks()
    for _, brick in pairs(self.bricks) do
        brick.y = brick.y + 16
    end
end

-- get a table of indices for self.bricks to choose random bricks from
function Level:GetBrickIndices()
    local brickIndices = {}
    for i = 1, table.length(self.bricks) do
        table.insert(brickIndices, i)
    end
    return brickIndices
end

-- check if all bricks have been destroyed
function Level:checkVictory()
    for _, brick in pairs(self.bricks) do
        if brick.inPlay then
            return false
        end
    end
    return true
end
