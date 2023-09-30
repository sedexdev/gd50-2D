Board = Class{}

function table.length(T)
    local counter = 0
    for _ in pairs(T) do counter = counter + 1 end
    return counter
end

function table.inRange(from, to)
    local t = {}
    for i = from, to do
        t[i] = {}
        table.insert(t, t[i])
    end
    return t
end

function Board:init(x, y)
    self.x = x
    self.y = y
    self.matches = table.inRange(1, 8)
    self.numMatches = 0
    self:initialiseTiles()
end

function Board:initialiseTiles()
    self.tiles = {}
    for y = 1, 8 do
        -- create a table for each row
        table.insert(self.tiles, {})
        for x = 1, 8 do
            table.insert(self.tiles[y], Tile(x, y, math.random(18), math.random(6)))
        end
    end
end

function Board:insertRowMatch(x, y, rowMatches)
    -- go back to the first matching tile index
    -- x - 1          = last matching tile
    -- x - rowMatches = first matching tile 
    self.numMatches = self.numMatches + 1
    local from = x == 8 and x or x - 1
    local to = x == 8 and x - rowMatches + 1 or x - rowMatches
    for x2 = from, to, -1 do
        self.matches[x2] = {}
        table.insert(self.matches[x2], y)
    end
end

function Board:checkRows()
    for y = 1, 8 do
        -- number of matches we've found in a row
        local rowMatches = 1
        -- look at the colour of the first tile in the first row
        local tileToMatch = self.tiles[y][1].skin
        -- loop over this row starting from next tile along (2)
        for x = 2, 8 do
            if self.tiles[y][x].skin == tileToMatch then
                rowMatches = rowMatches + 1
            else
                -- set the tileToMatch to the next tile
                tileToMatch = self.tiles[y][x].skin
                -- if there are 3 or more matches, add all matching tiles to self.matches
                if rowMatches >= 3 then
                    self:insertRowMatch(x, y, rowMatches)
                end
                rowMatches = 1
                -- if x made it to 7 without finding matches there cannot be 
                -- 3 matches in the remaining 2 tiles at 7 and 8
                if x >= 7 then
                    break
                end
            end
        end
        -- if the loop finished and matches >= 3 then the last tile ended with a match
        if rowMatches >= 3 then
            self:insertRowMatch(8, y, rowMatches)
        end
    end
end

function Board:insertColMatch(x, y, colMatches, last)
    self.numMatches = self.numMatches + 1
    local from = y - 1
    local to = y - colMatches
    if y == 8 and last then
        from = y
        to = y - colMatches + 1
    end
    self.matches[x] = {}
    for y2 = from, to, -1 do
        table.insert(self.matches[x], y2)
    end
end

function Board:checkCols()
    -- same as rows just inverted
    for x = 1, 8 do
        local colMatches = 1
        local tileToMatch = self.tiles[1][x].skin
        for y = 2, 8 do
            if self.tiles[y][x].skin == tileToMatch then
                colMatches = colMatches + 1
            else
                tileToMatch = self.tiles[y][x].skin
                if colMatches >= 3 then
                    self:insertColMatch(x, y, colMatches, false)
                end
                colMatches = 1
                if y >= 7 then
                    break
                end
            end
        end
        if colMatches >= 3 then
            self:insertColMatch(x, 8, colMatches, true)
        end
    end
end

function Board:checkMatches()
    self:checkRows()
    self:checkCols()
end

function Board:swapTiles(t1, t2)
    if t1 and t2 then
        -- store selected tile x, y in placeholders
        local tempX = t1.gridX
        local tempY = t1.gridY
        -- swap the 2 tiles in the underlying 2D array
        t1.gridX = t2.gridX
        t1.gridY = t2.gridY
        t2.gridX = tempX
        t2.gridY = tempY
        -- swap the tiles in the table
        self.tiles[t1.gridY][t1.gridX] = t1
        self.tiles[t2.gridY][t2.gridX] = t2
    end
end

-- calculate the tweens for tiles above those that have been matched
function Board:tweenTiles()
    local tweens = {}
    -- get all match locations in the grid
    -- check each column (k) and it's stored table of match y values
    for k, matches in pairs(self.matches) do
        -- how many matches are in this column
        local yMatches = table.length(matches)
        -- if this column has matches
        if yMatches > 0 then
            -- first match in the column
            local firstMatch = matches[1]
            -- if only 1 match shift all tiles down 1 from match-1
            if yMatches == 1 then
                for y = firstMatch - 1, 1, -1 do
                    -- record each tween as y * 32
                    tweens[self.tiles[y][k]] = {y = y * 32}
                    -- swap the tiles so their x, y and their gridX, gridY are swapped
                    self:swapTiles(self.tiles[y + 1][k], self.tiles[y][k])
                end
                -- set top tile to nil
                self.tiles[1][k] = nil
            -- otherwise keep track of how many shifts needed per tile
            else
                -- remove the matched tiles
                for _, y in pairs(matches) do
                    self.tiles[y][k] = nil
                end
                local shifts = 1
                -- get an index for each match y value
                local matchIndex = 1
                -- starting at match-1 count back up the column
                for y = firstMatch - 1, 1, -1 do
                    -- if we find a nil tile, get the next match y value
                    if self.tiles[y][k] == nil then
                        matchIndex = matchIndex + 1
                    end
                    -- if the current y is a y in the match table increase the number of shifts needed for each subsequent tile
                    if matches[matchIndex] == y then
                        shifts = shifts + 1
                    else
                        tweens[self.tiles[y][k]] = {y = ((y - 1) + shifts) * 32}
                        self.tiles[y + shifts][k] = self.tiles[y][k]
                        self.tiles[y + shifts][k].gridY = y + shifts
                        self.tiles[y][k] = nil
                    end
                end
            end
        end
    end
    self:tweenReplaceTiles(tweens)
    return tweens
end

-- replace the tiles at the top after tweening down
function Board:tweenReplaceTiles(tweens)
    for y = 1, 8 do
        for x = 1, 8 do
            if not self.tiles[y][x] then
                local newTile = Tile(x, y, math.random(18), math.random(6))
                newTile.y = -32
                self.tiles[y][x] = newTile
                tweens[newTile] = {
                    y = (y - 1) * 32
                }
            end
        end
    end
end

-- reset the numMatches count and the self.matches table
function Board:resetMatches()
    self.numMatches = 0
    for _, matches in pairs(self.matches) do
        matches = nil
    end
    self.matches = table.inRange(1, 8)
end

function Board:render()
    for y = 1, #self.tiles do
        for x = 1, #self.tiles[1] do
            self.tiles[y][x]:render(self.x, self.y)
        end
    end
end