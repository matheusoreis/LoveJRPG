local SceneBase = require('src.scenes.scene')
local WelcomeWindow = require('src.windows.welcome')
local TitleWindow = require('src.windows.title')
local Input = require('src.managers.input')

---@class  TitleScene : SceneBase
---@field title_window TitleWindow
local TitleScene = SceneBase:extend()

function TitleScene:on_load()
  self.background = self.resource:get_title('background')

  local screen_width = love.graphics.getWidth()
  local screen_height = love.graphics.getHeight()

  local welcome_size = { 220, 60 }
  local title_size = { 220, 140 }

  local total_height = welcome_size[2] + title_size[2]
  local start_y = (screen_height / 2) - (total_height / 2)

  -- Centraliza horizontalmente
  local center_x_welcome = (screen_width / 2) - (welcome_size[1] / 2)
  local center_x_title = (screen_width / 2) - (title_size[1] / 2)

  -- Cria a WelcomeWindow
  local welcome_window = WelcomeWindow(center_x_welcome, start_y, welcome_size[1], welcome_size[2], self.scene)
  self:add_window('welcome', welcome_window)

  -- Cria a TitleWindow
  local title_window = TitleWindow(center_x_title, start_y + welcome_size[2], title_size[1], title_size[2], self.scene)
  self:add_window('title', title_window)
end

function TitleScene:on_enter()
  self:open_window('welcome')
  self:open_window('title')
end

function TitleScene:on_draw(width, height)
  love.graphics.setShader()
  love.graphics.setColor(1, 1, 1)
  for y = 0, math.ceil(height / 32) - 1 do
    for x = 0, math.ceil(width / 32) - 1 do
      love.graphics.draw(self.background, x * 32, y * 32)
    end
  end
end

return TitleScene
