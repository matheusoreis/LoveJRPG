local SceneBase = require('src.scenes.scene')
local TitleWindow = require('src.windows.title')

---@class MenuScene : SceneBase
---@field title_window TitleWindow
local MenuScene = SceneBase:extend()

function MenuScene:on_load()
  print('Carregando a MenuScene...')

  self.background = self.resource:get_title('background')

  local title_window = TitleWindow(20, 20, 300, 200)
  self:add_window("title", title_window)
end

function MenuScene:on_enter()
  print('Entrando na MenuScene...')

  self:open_window("title")
end

function MenuScene:on_update(dt)

end

function MenuScene:on_draw(width, height)
  love.graphics.setShader()
  love.graphics.setColor(1, 1, 1)
  for y = 0, math.ceil(height / 32) - 1 do
    for x = 0, math.ceil(width / 32) - 1 do
      love.graphics.draw(self.background, x * 32, y * 32)
    end
  end
end

function MenuScene:on_exit()
end

return MenuScene
