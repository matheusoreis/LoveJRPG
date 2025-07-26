local Object = require('src.shared.object')
local Events = require('src.shared.events')

---@class InputManager : Object
local InputManager = Object:extend()

function InputManager:new()
  self.keymap = {
    a     = { "s", "gamepad:a" },
    b     = { "d", "gamepad:b" },
    x     = { "a", "gamepad:x" },
    y     = { "w", "gamepad:y" },

    left  = { "left", "gamepad:dpleft", "gamepad:leftx-", "gamepad:rightx-" },
    up    = { "up", "gamepad:dpup", "gamepad:lefty-", "gamepad:righty-" },
    right = { "right", "gamepad:dpright", "gamepad:leftx+", "gamepad:rightx+" },
    down  = { "down", "gamepad:dpdown", "gamepad:lefty+", "gamepad:righty+" },

    lb    = { "q", "gamepad:leftshoulder" },
    rb    = { "e", "gamepad:rightshoulder" },

    start = { "return", "gamepad:start" },
    back  = { "escape", "gamepad:back" }
  }

  self._held = {}
  self._pressed_once = {}
  self._released_once = {}
  self._axes = {}

  Events:on_event("key_pressed", function(key)
    if not self._held[key] then
      self._pressed_once[key] = true
    end
    self._held[key] = true
  end)

  Events:on_event("key_released", function(key)
    self._held[key] = false
    self._released_once[key] = true
  end)

  Events:on_event("gamepad_pressed", function(_, button)
    local key = "gamepad:" .. button
    if not self._held[key] then
      self._pressed_once[key] = true
    end
    self._held[key] = true
  end)

  Events:on_event("gamepad_released", function(_, button)
    local key = "gamepad:" .. button
    self._held[key] = false
    self._released_once[key] = true
  end)

  Events:on_event("gamepad_axis", function(_, axis, value)
    self._axes["gamepad:" .. axis] = value
  end)

  Events:on_event("joystick_axis", function(joystick, axis, value)
    local axis_map = {
      [1] = "leftx",
      [2] = "lefty",
      [3] = "rightx",
      [4] = "righty",
    }
    local axis_name = axis_map[axis]

    if axis_name then
      self._axes["gamepad:" .. axis_name] = value
    end
  end)
end

function InputManager:update()
  self._pressed_once = {}
  self._released_once = {}
end

--- Verifica se a ação está segurada (tecla, botão ou eixo)
---@param action string
---@return boolean
function InputManager:is_action_held(action)
  local keys = self.keymap[action]
  if not keys then return false end

  for _, key in ipairs(keys) do
    if key == "gamepad:leftx-" then
      if (self._axes["gamepad:leftx"] or 0) < -0.5 then return true end
    elseif key == "gamepad:leftx+" then
      if (self._axes["gamepad:leftx"] or 0) > 0.5 then return true end
    elseif key == "gamepad:lefty-" then
      if (self._axes["gamepad:lefty"] or 0) < -0.5 then return true end
    elseif key == "gamepad:lefty+" then
      if (self._axes["gamepad:lefty"] or 0) > 0.5 then return true end
    elseif key == "gamepad:rightx-" then
      if (self._axes["gamepad:rightx"] or 0) < -0.5 then return true end
    elseif key == "gamepad:rightx+" then
      if (self._axes["gamepad:rightx"] or 0) > 0.5 then return true end
    elseif key == "gamepad:righty-" then
      if (self._axes["gamepad:righty"] or 0) < -0.5 then return true end
    elseif key == "gamepad:righty+" then
      if (self._axes["gamepad:righty"] or 0) > 0.5 then return true end
    else
      if self._held[key] then return true end
    end
  end

  return false
end

--- Verifica se a ação foi clicada neste frame (clique único)
---@param action string
---@return boolean
function InputManager:is_action_pressed(action)
  local keys = self.keymap[action]
  if not keys then return false end

  for _, key in ipairs(keys) do
    if self._pressed_once[key] then
      return true
    end
  end

  return false
end

--- Verifica se a ação foi liberada neste frame (clique único de soltura)
---@param action string
---@return boolean
function InputManager:is_action_released(action)
  local keys = self.keymap[action]
  if not keys then return false end

  for _, key in ipairs(keys) do
    if self._released_once[key] then
      return true
    end
  end

  return false
end

local input_manager = InputManager()
return input_manager
