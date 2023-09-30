function Split(str, sep)
    local data = {}
    for s in string.gmatch(str, "([^" .. sep .. "]+)") do
        table.insert(data, s)
    end
    return data
end

function CreateScoreFile()
    -- set working directory
    love.filesystem.setIdentity('breakout')
    local scores = ''
    for i = 10, 1, -1 do
        scores = scores .. 'BRK, ' .. tostring(i * 10000) .. '\n'
    end
    love.filesystem.write('breakout.lst', scores)
end

function WriteHighScoreFile(highScores)
    love.filesystem.setIdentity('breakout')
    local scores = ''
    for i = 1, 10 do
        scores = scores .. highScores[i].name .. ', ' .. tostring(highScores[i].score .. '\n')
    end
    love.filesystem.write('breakout.lst', scores)
end

function LoadHighScores()
    -- inistalise empty table with 10 entries
    local highScores = {}
    for i = 1, 10 do
        highScores[i] = {
            name = nil,
            score = nil
        }
    end

    local counter = 1
    for line in love.filesystem.lines('breakout.lst') do
        local data = Split(line, ',')
        highScores[counter].name = data[1]
        highScores[counter].score = tonumber(data[2])
        counter = counter + 1
    end

    return highScores
end