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

---@virtual
function SceneBase:on_load()
end

---@virtual
function SceneBase:on_enter()
end

--- @protected
function SceneBase:update(dt)
  self:on_update(dt)
end

---@virtual
function SceneBase:on_update(dt)
end

--- @protected
function SceneBase:draw(width, height)
  self:on_draw(width, height)
end

---@virtual
function SceneBase:on_draw(width, height)
end

---@virtual
function SceneBase:on_exit()
end

return SceneBase
