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
    a     = { "s", "gamepad:a" },
    b     = { "d", "gamepad:b" },
    x     = { "a", "gamepad:x" },
    y     = { "w", "gamepad:y" },

    left  = { "left", "gamepad:dpleft", "gamepad:leftx-" },
    up    = { "up", "gamepad:dpup", "gamepad:lefty-" },
    right = { "right", "gamepad:dpright", "gamepad:leftx+" },
    down  = { "down", "gamepad:dpdown", "gamepad:lefty+" },

    lb    = { "q", "gamepad:leftshoulder" },
    rb    = { "e", "gamepad:rightshoulder" },

    start = { "return", "gamepad:start" },
    back  = { "escape", "gamepad:back" }
  }

  self.pressed = {}
  self.released = {}
  self.down = {}
end

--- Chamado quando uma tecla for pressionada.
--- @param key string
function Input:key_pressed(key)
  -- Encontra todos os símbolos associados a esta tecla
  for symbol, keys in pairs(self.keymap) do
    for _, mapped_key in ipairs(keys) do
      if mapped_key == key then
        self.pressed[symbol] = true
        self.down[symbol] = true
      end
    end
  end
end

--- Chamado quando uma tecla for solta
--- @param key string
function Input:key_released(key)
  -- Encontra todos os símbolos associados a esta tecla
  for symbol, keys in pairs(self.keymap) do
    for _, mapped_key in ipairs(keys) do
      if mapped_key == key then
        self.released[symbol] = true
        self.down[symbol] = false
      end
    end
  end
end

--- Chamado quando um botão de gamepad for pressionado
--- @param button string
function Input:gamepad_pressed(button)
  local key = "gamepad:" .. button
  self:key_pressed(key)
end

--- Chamado quando um botão de gamepad for solto
--- @param button string
function Input:gamepad_released(button)
  local key = "gamepad:" .. button
  self:key_released(key)
end

--- Atualiza os estados de direção do analógico esquerdo do joystick.
--- @param joystick love.Joystick
function Input:update_gamepad_axes(joystick)
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
--- Verifica se um símbolo foi pressionado neste frame
--- @param symbol string
--- @return boolean
function Input:is_pressed(symbol)
  return self.pressed[symbol] == true
end

--- Verifica se um símbolo foi liberado neste frame
--- @param symbol string
--- @return boolean
function Input:is_released(symbol)
  return self.released[symbol] == true
end

--- Verifica se um símbolo está sendo mantido
--- @param symbol string
--- @return boolean
function Input:is_down(symbol)
  return self.down[symbol] == true
end

--- Atualiza o estado de entrada
function Input:update()
  -- Limpa os estados temporários do frame
  self.pressed = {}
  self.released = {}
end

return Input
