--
-- Author: Matheus R. Oliveira
-- Github: matheusoreis
--

local Object = require "src.lib.classic"

--- @class SceneBase : Object
--- @field protected resource Resource
--- @field protected input InputManager
--- @field protected data DataManager
--- @field protected audio AudioManager
--- @field protected transition Transition
--- @field private started boolean
local SceneBase = Object:extend()

function SceneBase:new(resource, input, data, audio, transition)
  self.resource = resource
  self.input = input
  self.data = data
  self.audio = audio
  self.transition = transition
  self.started = false

  self:on_load()
end

function SceneBase:on_load()
end

--- @return boolean
function SceneBase:is_busy()
  return self.transition:is_busy()
end

--- @param duration? number
function SceneBase:start(duration)
  if not self.started then
    self.started = true
    self:on_enter()
    self.transition:fade_in(duration or 8)
  end
end

--- @param duration? number
function SceneBase:stop(duration)
  if self.started then
    self.started = false
    self:on_exit()
    self.transition:fade_out(duration or 8)
  end
end

function SceneBase:update(dt)
  self.transition:update()

  -- Se a cena estiver ativa, chama update customizado
  if self.started and not self:is_busy() then
    self:on_update(dt)
  end
end

function SceneBase:draw(width, height)
  self:on_draw(width, height)
  self.transition:draw(width, height)
end

function SceneBase:on_enter()
end

function SceneBase:on_exit()
end

function SceneBase:on_update(dt)
end

function SceneBase:on_draw(width, height)
end

function SceneBase:is_pressed(symbol)
  return self.input:is_pressed(symbol)
end

function SceneBase:is_released(symbol)
  return self.input:is_released(symbol)
end

function SceneBase:is_down(symbol)
  return self.input:is_down(symbol)
end

function SceneBase:play_bgm(name)
  self.audio:play_bgm(name)
end

function SceneBase:set_bgm_volume(volume)
  self.audio:set_bgm_volume(volume)
end

function SceneBase:stop_bgm()
  self.audio:stop_bgm()
end

function SceneBase:play_se(name)
  self.audio:play_se(name)
end

function SceneBase:set_se_volume(volume)
  self.audio:set_se_volume(volume)
end

function SceneBase:stop_se()
  self.audio:stop_all_se()
end

return SceneBase
