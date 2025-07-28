local SceneBase = require('src.scenes.scene')
local OptionsWindow = require('src.windows.options')
local Audio = require('src.managers.audio')

---@class OptionsScene : SceneBase
local OptionsScene = SceneBase:extend()

function OptionsScene:on_load()
  self.background = self.resource:get_title('background')

  local screen_width = love.graphics.getWidth()
  local screen_height = love.graphics.getHeight()

  local options_size = { 220, 140 }

  local center_x = (screen_width - options_size[1]) / 2
  local center_y = (screen_height - options_size[2]) / 2

  local options = OptionsWindow(center_x, center_y, options_size[1], options_size[2])

  self:add_window('options', options)
end

function OptionsScene:on_enter()
  self:open_window('options')
end

function OptionsScene:on_update(dt)
  if self.input:is_action_pressed('back') then
    Audio:play_se('cancel')
    self.scene:pop()
  end
end

function OptionsScene:on_draw(width, height)
  love.graphics.setShader()
  love.graphics.setColor(1, 1, 1)
  for y = 0, math.ceil(height / 32) - 1 do
    for x = 0, math.ceil(width / 32) - 1 do
      love.graphics.draw(self.background, x * 32, y * 32)
    end
  end
end

return OptionsScene
