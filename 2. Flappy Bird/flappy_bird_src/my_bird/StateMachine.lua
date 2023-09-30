--
-- StateMachine - a state machine
--
-- Usage:
--
-- -- States are only created as need, to save memory, reduce clean-up bugs and increase speed
-- -- due to garbage collection taking longer with more data in memory.
-- --
-- -- States are added with a string identifier and an intialisation function.
-- -- It is expected that the init function, when called, will return a table with
-- -- Render, Update, Enter and Exit methods.
--
-- gStateMachine = StateMachine {
-- 		['MainMenu'] = function()
-- 			return MainMenu()
-- 		end,
-- 		['InnerGame'] = function()
-- 			return InnerGame()
-- 		end,
-- 		['GameOver'] = function()
-- 			return GameOver()
-- 		end,
-- }
-- gStateMachine:change("MainGame")
--
-- Arguments passed into the Change function after the state name
-- will be forwarded to the Enter function of the state being changed too.
--
-- State identifiers should have the same name as the state table, unless there's a good
-- reason not to. i.e. MainMenu creates a state using the MainMenu table. This keeps things
-- straight forward.
--
-- =Doing Transitions=
--
StateMachine = Class{}

function StateMachine:init(states)
    -- this table is a definition of a state
    self.coreState = {
        render = function () end,
        update = function (_, dt) end,
        enter = function (_, params) end,
        exit = function () end,
    }
    self.states = states or {}
    self.current = self.coreState
end

-- change states
function StateMachine:change(stateName, params)
    assert(self.states[stateName])          -- check the stateName is valid
    self.current:exit()                     -- exit the current state
    self.current = self.states[stateName]() -- set current to state returned from stateName()
    self.current:enter(params)              -- enter the new state with relevant parameters
end

-- call update function of current state
function StateMachine:update(dt)
    self.current:update(dt)
end

-- call render function of current state
function StateMachine:render()
    self.current:render()
end