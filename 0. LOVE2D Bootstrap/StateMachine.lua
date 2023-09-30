StateMachine = Class{}

function StateMachine:init(states)
    -- this table is a definition of a state
    self.stateDefinition = {
        render = function () end,
        update = function (_, dt) end,
        enter = function (_, params) end,
        exit = function () end,
    }
    self.states = states or {}
    self.current = self.stateDefinition
end

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