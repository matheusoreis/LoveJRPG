--
-- Author: Matheus R. Oliveira
-- Github: matheusoreis
--

local Object = require('src.lib.classic')

--- @class SceneManager : Object
--- @field private stack SceneBase[]
--- @field private scene SceneBase?
--- @field private stopped boolean
local SceneManager = Object:extend()

function SceneManager:new(resource, input, data, audio, transition)
  self.stack = {}
  self.scene = nil
  self.stopped = false

  self.resource = resource
  self.input = input
  self.data = data
  self.audio = audio

  self.transition = transition
end

--- @return boolean
function SceneManager:is_changing()
  return self.scene ~= self.stack[#self.stack]
end

--- @return SceneBase?
function SceneManager:peek()
  return self.stack[#self.stack]
end

function SceneManager:push(state_class, clear, ...)
  if clear then
    self.stack = {}
  end

  local state_instance = state_class(self.resource, self.input, self.data, self.audio, self.transition, self, ...)
  table.insert(self.stack, state_instance)
end

function SceneManager:pop()
  table.remove(self.stack)
end

function SceneManager:update(dt)
  local next_state = self:peek()

  if self.scene ~= next_state then
    if self.scene and not self.stopped then
      self.stopped = true
      self.scene:stop()
    end

    if not self.scene or not self.scene:is_busy() then
      self.stopped = false
      self.scene = next_state

      if self.scene then
        self.scene:start()
      else
        love.event.quit()
      end
    end
  end

  if self.scene then
    self.scene:update(dt)
  end
end

--- @param width number
--- @param height number
function SceneManager:draw(width, height)
  if self.scene then
    self.scene:draw(width, height)
  end
end

return SceneManager
