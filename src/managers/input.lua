--
-- Author: Matheus R. Oliveira
-- Github: matheusoreis
--

local Object = require('src.lib.classic')

--- @class Input : Object
--- @field private keymap table<string, string[]>
--- @field private pressed table<string, boolean>
--- @field private released table<string, boolean>
--- @field private down table<string, boolean>
local Input = Object:extend()

function Input:new()
  self.keymap = {
    Left  = { "left", "gamepad:dpleft", "gamepad:leftx-" },
    Up    = { "up", "gamepad:dpup", "gamepad:lefty-" },
    Right = { "right", "gamepad:dpright", "gamepad:leftx+" },
    Down  = { "down", "gamepad:dpdown", "gamepad:lefty+" },

    X     = { "a", "gamepad:x" },
    Y     = { "w", "gamepad:y" },
    B     = { "d", "gamepad:b" },
    A     = { "s", "gamepad:a" }
  }

  self.pressed = {}
  self.released = {}
  self.down = {}
end

--- Chamado quando uma tecla for pressionada.
--- @param key string
function Input:keyPressed(key)
  self.pressed[key] = true
  self.down[key] = true
end

--- Chamado quando uma tecla for solta.
--- @param key string
function Input:keyReleased(key)
  self.released[key] = true
  self.down[key] = false
end

--- Chamado quando um botão de gamepad for pressionado.
--- @param button string
function Input:gamepadPressed(button)
  local key = "gamepad:" .. button
  self.pressed[key] = true
  self.down[key] = true
end

--- Chamado quando um botão de gamepad for solto.
--- @param button string
function Input:gamepadReleased(button)
  local key = "gamepad:" .. button
  self.released[key] = true
  self.down[key] = false
end

--- Atualiza os estados de direção do analógico esquerdo do joystick.
--- @param joystick love.Joystick
function Input:updateGamepadAxes(joystick)
  local deadzone = 0.3

  local x = joystick:getGamepadAxis("leftx")
  local y = joystick:getGamepadAxis("lefty")

  -- Reseta estados anteriores
  self.down["gamepad:leftx+"] = false
  self.down["gamepad:leftx-"] = false
  self.down["gamepad:lefty+"] = false
  self.down["gamepad:lefty-"] = false

  if x > deadzone then
    self.down["gamepad:leftx+"] = true
  elseif x < -deadzone then
    self.down["gamepad:leftx-"] = true
  end

  if y > deadzone then
    self.down["gamepad:lefty+"] = true
  elseif y < -deadzone then
    self.down["gamepad:lefty-"] = true
  end
end

--- @private
--- Verifica se alguma das teclas está ativa em um estado.
--- @param state table<string, boolean>
--- @param keys string[]
--- @return boolean
function Input:checkKeys(state, keys)
  for _, key in ipairs(keys or {}) do
    if state[key] then return true end
  end
  return false
end

--- Verifica se a ação foi pressionada neste frame.
--- @param action string
--- @return boolean
function Input:isPressed(action)
  return self:checkKeys(self.pressed, self.keymap[action])
end

--- Verifica se a ação foi liberada neste frame.
--- @param action string
--- @return boolean
function Input:isReleased(action)
  return self:checkKeys(self.released, self.keymap[action])
end

--- Verifica se a ação está sendo mantida.
--- @param action string
--- @return boolean
function Input:isDown(action)
  return self:checkKeys(self.down, self.keymap[action])
end

--- Atualiza o estado de entrada.
function Input:update()
  self.pressed = {}
  self.released = {}
end

return Input
