local Object = require('src.shared.object')
local Audio = require('src.managers.audio')
local Data = require('src.managers.data')
local Input = require('src.managers.input')
local Resource = require('src.managers.resource')

---@class SceneBase : Object
---@field audio AudioManager
---@field data DataManager
---@field input InputManager
---@field resource ResourceManager
---@field scene SceneManager
---@field windows table<string, WindowBase>
local SceneBase = Object:extend()

--- @protected
function SceneBase:new(scene_manager)
  self.audio = Audio
  self.data = Data
  self.input = Input
  self.resource = Resource
  self.scene = scene_manager

  self.windows = {}

  self:on_load()
end

function SceneBase:on_load()
end

function SceneBase:on_enter()
end

function SceneBase:add_window(name, window)
  self.windows[name] = window
end

function SceneBase:remove_window(name)
  self.windows[name] = nil
end

function SceneBase:open_window(name)
  local window = self.windows[name]
  if window then
    window:open()
  end
end

function SceneBase:close_window(name)
  local window = self.windows[name]
  if window then
    window:close()
  end
end

--- @protected
function SceneBase:update(dt)
  self:on_update(dt)

  for _, window in pairs(self.windows) do
    ---@diagnostic disable-next-line: invisible
    window:update(dt)
  end
end

function SceneBase:on_update(dt)
end

--- @protected
function SceneBase:draw(width, height)
  self:on_draw(width, height)

  for _, window in pairs(self.windows) do
    ---@diagnostic disable-next-line: invisible
    window:draw()
  end
end

function SceneBase:on_draw(width, height)
end

function SceneBase:on_exit()
end

return SceneBase
