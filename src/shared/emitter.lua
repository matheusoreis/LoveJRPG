local Object = require('src.shared.object')

--- @class Emitter : Object
--- @field super Object
local Emitter = Object:extend()

local function swap_remove(t, v)
  local tlen = #t
  for i = 1, tlen do
    if t[i] == v then
      t[i], t[tlen] = t[tlen], t[i]
      table.remove(t)
      return
    end
  end
end

function Emitter:new()
  Emitter.super.new(self)
  self.events = {}
end

--- @param event string
function Emitter:register_event(event)
  assert(self.events[event] == nil, 'Event already registered.')
  self.events[event] = {}
end

--- @param ... string
function Emitter:register_events(...)
  for _, event in pairs({ ... }) do
    self:register_event(event)
  end
end

--- @param event string
--- @param callback function
function Emitter:on_event(event, callback)
  if not self.events[event] then
    self.events[event] = {}
  end
  local events = self.events[event]
  table.insert(events, callback)
  return function() swap_remove(events, callback) end
end

--- @param event string
--- @param callback function
function Emitter:on_event_once(event, callback)
  local disconnect
  disconnect = self:on_event(event, function()
    callback()
    disconnect()
  end)
end

--- @param events string[]
--- @param callback fun(event: string, ...)
function Emitter:on_multiple_events(events, callback)
  local disconnect_list = {}
  for _, event in pairs(events) do
    table.insert(disconnect_list, self:on_event(event, function(...)
      callback(event, ...)
    end))
  end
  return function()
    for _, disconnect in ipairs(disconnect_list) do
      disconnect()
    end
  end
end

--- @param event string
--- @param ... any
--- @return boolean
function Emitter:emit_event(event, ...)
  local events = self.events[event]
  if not events then return false end
  for _, callback in ipairs(events) do
    if callback(...) then
      return true
    end
  end
  return false
end

return Emitter
