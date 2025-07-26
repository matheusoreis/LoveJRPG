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
    'joystick_pressed', 'joystick_released',
    'joystick_added', 'joystick_removed',
    'gamepad_pressed', 'gamepad_released'
  )
end

local events = Events()

--#region Keyboard
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

--#endregion

--#region Mouse
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

--#endregion

--#region Touch
function love.touchmoved(...)
  events:emit_event('touch_moved', ...)
end

function love.touchpressed(...)
  events:emit_event('touch_pressed', ...)
end

function love.touchreleased(...)
  events:emit_event('touch_released', ...)
end

--#endregion

--#region Joystick
function love.joystickpressed(joystick, button)
  events:emit_event('joystick_pressed', joystick, button)
end

function love.joystickreleased(joystick, button)
  events:emit_event('joystick_released', joystick, button)
end

function love.joystickadded(joystick)
  events:emit_event('joystick_added', joystick)
end

function love.joystickremoved(joystick)
  events:emit_event('joystick_removed', joystick)
end

function love.gamepadpressed(gamepad, button)
  events:emit_event('gamepad_pressed', gamepad, button)
end

function love.gamepadreleased(gamepad, button)
  events:emit_event('gamepad_released', gamepad, button)
end

--#endregion

return events
