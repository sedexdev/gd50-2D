-- libraries
Class = require 'lib/class'
Push = require 'lib/push'

-- util files
require 'src/utils/constants'
require 'src/utils/scores'
require 'src/utils/spritesheet'

-- classes
require 'src/classes/Ball'
require 'src/classes/Brick'
require 'src/classes/HUD'
require 'src/classes/Level'
require 'src/classes/Paddle'
require 'src/classes/PowerUp'
require 'src/classes/StateMachine'

-- states
require 'src/states/BaseState'
require 'src/states/EnterHighScoreState'
require 'src/states/MenuState'
require 'src/states/HighScoreState'
require 'src/states/ServeState'
require 'src/states/PaddleSelectState'
require 'src/states/PlayState'
require 'src/states/VictoryState'
require 'src/states/GameOverState'
