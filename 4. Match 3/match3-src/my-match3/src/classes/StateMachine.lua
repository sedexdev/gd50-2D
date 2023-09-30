StateMachine = Class{__includes = BaseState}

function StateMachine:init(states)
    self.coreState = {
        enter = function(_, params) end,
        exit = function() end,
        update = function(_, dt) end,
        render = function() end
    }
    self.states = states or {}
    self.current = self.coreState
end

function StateMachine:change(state, params)
    assert(self.states[state])
    self.current:exit()
    self.current = self.states[state]()
    self.current:enter(params)
end

function StateMachine:update(dt)
    self.current:update(dt)
end

function StateMachine:render()
    self.current:render()
end