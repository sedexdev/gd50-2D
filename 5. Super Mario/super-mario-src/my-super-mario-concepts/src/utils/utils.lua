-- gets quads of equal size from a tile sheet
function GenerateQuads(atlas, tileWidth, tileHeight)
    local quads = {}
    local numCols = atlas:getWidth() / tileWidth
    local numRows = atlas:getHeight() / tileHeight

    local counter = 1

    -- start (x, y) at (0, 0) so the px values will be correct
    for y = 0, numRows - 1 do
        for x = 0, numCols - 1 do
            quads[counter] = love.graphics.newQuad(
                x * tileWidth, y * tileHeight,
                tileWidth,
                tileHeight,
                atlas:getDimensions()
            )
            counter = counter + 1
        end
    end
    return quads
end

--[[
    Pass in a flat array 'quads' to index into according to where we are
    in the grid system of the tile sheet. A 4-nested for loop is required
    because we are looping over the x, y of the atlas, then the x, y of 
    each tileset within it. There are 60 sets in total for tiles, and 108
    for toppers
]]
function GenerateTileSet(quads, atlasCols, atlasRows, setCols, setRows)
    local tileSet = {}
    local counter = 0
    local sheetWidth = atlasCols * setCols

    -- loop over x, y for the atlas
    for tileSetY = 1, atlasRows do
        io.write('======= TILESETY: ' .. tostring(tileSetY) .. ' =======\n')
        for tileSetX = 1, atlasCols do
            io.write('======= TILESETX: ' .. tostring(tileSetX) .. ' =======\n')
            table.insert(tileSet, {})
            counter = counter + 1

            -- loop over x, y for the individual tile sets
            local fromY = setRows * (tileSetY - 1) + 1      -- +1 here to go over each row
            local toY = fromY + setRows - 1                 -- -1 here to stop at SHEET_SET_ROWS (4)
            for y = fromY, toY do
                io.write('~~~~~~~~~ y = '..tostring(y)..' ~~~~~~~~~\n')
                local fromX = setCols * (tileSetX - 1) + 1  -- +1 here to go over each column
                local toX = fromX + setCols - 1             -- -1 here to stop at SHEET_SET_COLUMNS (5)
                for x = fromX, toX do
                    io.write('x = '..tostring(x)..'\n')
                    --[[
                        When we insert a quad into the to tileset we are indexing the 
                        flat quads array at sheetWidth * (y - 1) + x:

                        sheetwidth = 30 (5 tilesets, 6 columns); finds the right tileset
                        (y - 1)    = because we need to set y = 0 to access the first tileset
                                     the first x items will be part of the first tile set
                        + x        = because we want to go x columns in to get the right tile
                    ]]
                    table.insert(tileSet[counter], quads[sheetWidth * (y - 1) + x])
                end
            end
        end
    end
    return tileSet
end

--[[
    Recursive table printing function.
    https://coronalabs.com/blog/2014/09/02/tutorial-printing-table-contents/
]]
function Print_r ( t )
    local print_r_cache={}
    local function sub_print_r(t,indent)
        if (print_r_cache[tostring(t)]) then
            print(indent.."*"..tostring(t))
        else
            print_r_cache[tostring(t)]=true
            if (type(t)=="table") then
                for pos,val in pairs(t) do
                    if (type(val)=="table") then
                        print(indent.."["..pos.."] => "..tostring(t).." {")
                        sub_print_r(val,indent..string.rep(" ",string.len(pos)+8))
                        print(indent..string.rep(" ",string.len(pos)+6).."}")
                    elseif (type(val)=="string") then
                        print(indent.."["..pos..'] => "'..val..'"')
                    else
                        print(indent.."["..pos.."] => "..tostring(val))
                    end
                end
            else
                print(indent..tostring(t))
            end
        end
    end
    if (type(t)=="table") then
        print(tostring(t).." {")
        sub_print_r(t,"  ")
        print("}")
    else
        sub_print_r(t,"  ")
    end
    print()
end