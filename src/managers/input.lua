local Object = require('src.shared.object')
local Events = require('src.shared.events')

---@class InputManager : Object
---@field keymap table
---@field private held table
---@field private pressed_once table
---@field private released_once table
---@field private axes table
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

  self.held = {}
  self.pressed_once = {}
  self.released_once = {}
  self.axes = {}

  Events:on_event("key_pressed", function(key)
    if not self.held[key] then
      self.pressed_once[key] = true
    end
    self.held[key] = true
  end)

  Events:on_event("key_released", function(key)
    self.held[key] = false
    self.released_once[key] = true
  end)

  Events:on_event("gamepad_pressed", function(_, button)
    local key = "gamepad:" .. button
    if not self.held[key] then
      self.pressed_once[key] = true
    end
    self.held[key] = true
  end)

  Events:on_event("gamepad_released", function(_, button)
    local key = "gamepad:" .. button
    self.held[key] = false
    self.released_once[key] = true
  end)

  Events:on_event("gamepad_axis", function(_, axis, value)
    self.axes["gamepad:" .. axis] = value
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
      self.axes["gamepad:" .. axis_name] = value
    end
  end)
end

---@type InputManager
local input_manager = InputManager()

function InputManager:update()
  self.pressed_once = {}
  self.released_once = {}
end

--- Verifica se a ação está segurada (tecla, botão ou eixo)
---@param action string
---@return boolean
function InputManager:is_action_held(action)
  local keys = self.keymap[action]
  if not keys then return false end

  for _, key in ipairs(keys) do
    if key == "gamepad:leftx-" then
      if (self.axes["gamepad:leftx"] or 0) < -0.5 then return true end
    elseif key == "gamepad:leftx+" then
      if (self.axes["gamepad:leftx"] or 0) > 0.5 then return true end
    elseif key == "gamepad:lefty-" then
      if (self.axes["gamepad:lefty"] or 0) < -0.5 then return true end
    elseif key == "gamepad:lefty+" then
      if (self.axes["gamepad:lefty"] or 0) > 0.5 then return true end
    elseif key == "gamepad:rightx-" then
      if (self.axes["gamepad:rightx"] or 0) < -0.5 then return true end
    elseif key == "gamepad:rightx+" then
      if (self.axes["gamepad:rightx"] or 0) > 0.5 then return true end
    elseif key == "gamepad:righty-" then
      if (self.axes["gamepad:righty"] or 0) < -0.5 then return true end
    elseif key == "gamepad:righty+" then
      if (self.axes["gamepad:righty"] or 0) > 0.5 then return true end
    else
      if self.held[key] then return true end
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
    if self.pressed_once[key] then
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
    if self.released_once[key] then
      return true
    end
  end

  return false
end

return input_manager
