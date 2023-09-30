-- libraries
Class = require 'lib/class'
Push = require 'lib/push'
Timer = require 'lib/knife/timer'

-- classes
require 'src/classes/Board'
require 'src/classes/StateMachine'
require 'src/classes/Tile'

-- states
require 'src/states/BaseState'
require 'src/states/EnterHighScoreState'
require 'src/states/EnterLevelState'
require 'src/states/GameOverState'
require 'src/states/HighScoreState'
require 'src/states/MenuState'
require 'src/states/PlayState'
require 'src/states/VictoryState'

-- utils
require 'src/utils/utils'
require 'src/utils/constants'
require 'src/utils/scores'