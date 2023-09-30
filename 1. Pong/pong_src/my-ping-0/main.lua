--[[
    My implementation of the Pong project

    Contains all the same components but configured
    differently for shits and giggles

    Author: Andrew Macmillan
    Version: 1.0
]]

--[[ 
    External libraries need to be local .lua files
    Use them with the require keyword

    https://github.com/vrld/hump/blob/master/class.lua
    https://github.com/Ulydev/push/push.lua
]]
Class = require "class"
local push = require "push"

--[[
    Locally defined classes within this directory
]]
require 'Ball'
require 'Paddle'

-- Window size
WINDOW_WIDTH  = 1280
WINDOW_HEIGHT = 720

-- Zoomed in resolution using push library
VIRTUAL_WIDTH  = 432
VIRTUAL_HEIGHT = 243

-- Game state vars
START   = 'start'
PLAYING = 'playing'
SERVING = 'serving'
OVER    = 'over'

function SetFilter()
    -- add retro blur to the screen
    love.graphics.setDefaultFilter('nearest', 'nearest')
end

function LoadGameFonts()
    -- Set a new font for the game title
    NameFont = love.graphics.newFont('font.ttf', 8)
    -- Set a medium font for winning message
    WinningFont = love.graphics.newFont('font.ttf', 16)
    -- set a larger font for the score
    ScoreFont = love.graphics.newFont('font.ttf', 32)
    -- set active font to the smaller one
    love.graphics.setFont(NameFont)
end

function SetWindowResolution()
    love.window.setTitle('Ping')
    -- set the screen size and virtual resolution
    push:setupScreen(VIRTUAL_WIDTH, VIRTUAL_HEIGHT, WINDOW_WIDTH, WINDOW_HEIGHT, {
        fullscreen = false,
        resizable = true,
        vsync = true,
        centered = true
    })
end

function InitialiseSounds()
    Sounds = {
        ['paddle_hit'] = love.audio.newSource('sounds/paddle_hit.wav', 'static'),
        ['score'] = love.audio.newSource('sounds/score.wav', 'static'),
        ['wall_hit'] = love.audio.newSource('sounds/wall_hit.wav', 'static')
    }
end

function InitialisePlayerScores()
    -- set player scores
    Player1Score = 0
    Player2Score = 0
end

function InitialiseServingPlayer()
    ServingPlayer = 1
end

function UpdateServingPlayer(playerID)
    ServingPlayer = playerID
end

function CreateGameObjects()
    -- players
    Player1 = Paddle(10, 30, 5, 20, 'w', 's')
    Player2 = Paddle(VIRTUAL_WIDTH - 15, VIRTUAL_HEIGHT - 30, 5, 20, 'up', 'down')
    -- ball
    Ball = Ball(VIRTUAL_WIDTH / 2 - 2, VIRTUAL_HEIGHT / 2 - 2, 4, 4)
end

-- Main function called on game start
function love.load()
    --[[
    love.window.setMode(WINDOW_WIDTH, WINDOW_HEIGHT, {
        fullscreen = false,
        resizable = true,
        vsync = 1,
        centered = true
    })
    ]]
    SetFilter()
    LoadGameFonts()
    SetWindowResolution()
    InitialiseSounds()
    InitialisePlayerScores()
    InitialiseServingPlayer()
    -- seed the RNG with a random value based on Unix Epoch Time
    math.randomseed(os.time())
    CreateGameObjects()
    -- set game state to start at the beginning of the game
    GameState = START
end

--[[
    Called by LÖVE whenever we resize the screen; here, we just want to pass in the
    width and height to push so our virtual resolution can be resized as needed.
]]
function love.resize(w, h)
    push:resize(w, h)
end

function HandleCollision(player, offset)
    Sounds['paddle_hit']:play()

    -- detect ball collision with paddles, reversing dx if true and
    -- slightly increasing it, then altering the dy based on the position of collision
    Ball.dx = -Ball.dx * 1.03

    if player == Player1 then
        Ball.x = player.x + offset
    else
        Ball.x = player.x - offset
    end

    if Ball.dy < 0 then
        Ball.dy = -math.random(10, 150)
    else
        Ball.dy = math.random(10, 150)
    end
end

function HandleBoundaryCollision()
    -- detect upper and lower screen boundary collision and reverse if collided
    -- Top
    if Ball.y <= 0 then
        Ball.y = 0
        Ball.dy = -Ball.dy
        Sounds['wall_hit']:play()
    end

    -- -4 to account for the ball's size
    -- Bottom:
    if Ball.y >= VIRTUAL_HEIGHT - 4 then
        Ball.y = VIRTUAL_HEIGHT - 4
        Ball.dy = -Ball.dy
        Sounds['wall_hit']:play()
    end
end

function CheckWinningScore(playerID, playerScore)
    -- if player score is 10 we are done
    if playerScore == 10 then
        WinningPlayer = playerID
        GameState = OVER
    else
        -- otherwise serve again
        GameState = SERVING
        Ball:reset()
    end
end

-- Update function runs every frame with access to deltatime
-- Deltatime: time passed since last frame rendered
function love.update(dt)
    if GameState == SERVING then
        Ball.dy = math.random(-50, 50)
        if ServingPlayer == 1 then
            Ball.dx = math.random(140, 200)
        else
            Ball.dx = -math.random(140, 200)
        end
    elseif GameState == PLAYING then
        -- Player 1 collision
        if Ball:collides(Player1) then
            HandleCollision(Player1, 5)
        end
        if Ball:collides(Player2) then
            HandleCollision(Player2, 4)
        end

        HandleBoundaryCollision()

        -- update player score when balls goes past game boundary
        if Ball.x > VIRTUAL_WIDTH then
            UpdateServingPlayer(1)
            Sounds['score']:play()
            Player1Score = Player1Score + 1
            CheckWinningScore(1, Player1Score)
        end

        if Ball.x < 0 then
            UpdateServingPlayer(2)
            Sounds['score']:play()
            Player2Score = Player2Score + 1
            CheckWinningScore(2, Player2Score)
        end

        -- update player paddle locations
        Player1:setDY()
        Player2:setDY()

        -- if the game is in a playing state then set
        -- the dx and dy for the ball
        Ball:update(dt)
        Player1:update(dt)
        Player2:update(dt)
    end
end

-- Keypress functions
function love.keypressed(key)
    -- keys can be referenced using string names
    if key == "escape" then
        love.event.quit()
    elseif key == 'enter' or key == 'return' then
        -- control the game state using return key
        if GameState == START then
            GameState = SERVING
        elseif GameState == SERVING then
            GameState = PLAYING
        elseif GameState == OVER then
            GameState = SERVING
            Ball:reset()
            InitialisePlayerScores()
            if WinningPlayer == 1 then
                UpdateServingPlayer(2)
            else
                UpdateServingPlayer(1)
            end
        end
    end
end

function RenderBackgroundColour()
    -- set background colour
    love.graphics.clear(89/255, 133/255, 109/255, 255/255)
end

function RenderGameFonts()
    -- game name at top center of screen
    if GameState == START then
        love.graphics.setFont(NameFont)
        love.graphics.printf("Welcome to Ping!", 0, 10, VIRTUAL_WIDTH, 'center')
        love.graphics.printf("Press enter to start!", 0, 20, VIRTUAL_WIDTH, 'center')
    elseif GameState == SERVING then
        love.graphics.setFont(NameFont)
        love.graphics.printf('Player ' .. tostring(ServingPlayer) .. "'s serve!", 0, 10, VIRTUAL_WIDTH, 'center')
        love.graphics.printf('Press enter to serve!', 0, 20, VIRTUAL_WIDTH, 'center')
        love.graphics.setFont(ScoreFont)
        love.graphics.print(tostring(Player1Score), VIRTUAL_WIDTH / 2 - 50, VIRTUAL_HEIGHT / 3)
        love.graphics.print(tostring(Player2Score), VIRTUAL_WIDTH / 2 + 30, VIRTUAL_HEIGHT / 3)
    elseif GameState == OVER then
        love.graphics.setFont(WinningFont)
        love.graphics.printf('Player ' .. tostring(WinningPlayer) .. ' wins!', 0, 10, VIRTUAL_WIDTH, 'center')
        love.graphics.setFont(NameFont)
        love.graphics.printf('Press enter to play again!', 0, 40, VIRTUAL_WIDTH, 'center')
    end
end

-- Render function called on every frame
function love.draw()
    -- start redendering this frame using push library
    push:start()
    RenderBackgroundColour()
    RenderGameFonts()
    -- render player objects
    Player1:render()
    Player2:render()
    -- render ball object
    Ball:render()

    DisplayFPS()

    -- finish redendering this frame using push library
    push:finish()
end

function DisplayFPS()
    love.graphics.setFont(NameFont)
    love.graphics.setColor(0, 255/255, 0, 255/255)
    love.graphics.print('FPS: ' .. tostring(love.timer.getFPS()), 10, 10)
end