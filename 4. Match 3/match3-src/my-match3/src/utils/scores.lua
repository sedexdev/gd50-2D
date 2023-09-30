function Split(str, sep)
    local data = {}
    for s in string.gmatch(str, "([^" .. sep .. "]+)") do
        table.insert(data, s)
    end
    return data
end

function CreateScoreFile()
    -- set working directory
    love.filesystem.setIdentity('match3')
    local scores = ''
    for i = 10, 1, -1 do
        scores = scores .. 'MT3, 10, ' .. tostring(i * 10000) .. '\n'
    end
    love.filesystem.write('match3.lst', scores)
end

function WriteHighScoreFile(highScores)
    love.filesystem.setIdentity('match3')
    local scores = ''
    for i = 1, 10 do
        scores = scores .. highScores[i].name .. ', ' .. tostring(highScores[i].level) .. ', ' .. tostring(highScores[i].score .. '\n')
    end
    love.filesystem.write('match3.lst', scores)
end

function LoadHighScores()
    -- inistalise empty table with 10 entries
    local highScores = {}
    for i = 1, 10 do
        highScores[i] = {
            name = nil,
            level = nil,
            score = nil
        }
    end

    local counter = 1
    for line in love.filesystem.lines('match3.lst') do
        local data = Split(line, ',')
        highScores[counter].name = data[1]
        highScores[counter].level = tonumber(data[2])
        highScores[counter].score = tonumber(data[3])
        counter = counter + 1
    end

    return highScores
end
