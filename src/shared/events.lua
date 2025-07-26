local Emitter = require('src.shared.emitter')

--- @class Events : Emitter
--- @overload fun(): Events
local Events = Emitter:extend()

function Events:new()
  Events.super.new(self)
  self:register_events(
    'key_pressed', 'key_released',
    'text_edited', 'text_input',
    'touch_moved', 'touch_pressed', 'touch_released',
    'mouse_moved', 'mouse_pressed', 'mouse_released', 'wheel_moved',
    'quit'
  )
end

local events = Events()

function love.keypressed(...)
  events:emit_event('key_pressed', ...)
end

function love.keyreleased(...)
  events:emit_event('key_released', ...)
end

function love.textedited(...)
  events:emit_event('text_edited', ...)
end

function love.textinput(...)
  events:emit_event('text_input', ...)
end

function love.mousemoved(...)
  events:emit_event('mouse_moved', ...)
end

function love.mousepressed(...)
  events:emit_event('mouse_pressed', ...)
end

function love.mousereleased(...)
  events:emit_event('mouse_released', ...)
end

function love.wheelmoved(...)
  events:emit_event('wheel_moved', ...)
end

function love.touchmoved(...)
  events:emit_event('touch_moved', ...)
end

function love.touchpressed(...)
  events:emit_event('touch_pressed', ...)
end

function love.touchreleased(...)
  events:emit_event('touch_released', ...)
end

return events
