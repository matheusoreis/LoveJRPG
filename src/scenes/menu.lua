local SceneBase = require('src.scenes.scene')
local TitleWindow = require('src.windows.title')

---@class MenuScene : SceneBase
---@field title_window TitleWindow
local MenuScene = SceneBase:extend()

function MenuScene:on_load()
  print('Carregando a MenuScene...')

  self.background = self.resource:get_title('background')
  self.title_window = TitleWindow(20, 20, 500, 50)
end

function MenuScene:on_enter()
  print('Entrando na MenuScene...')
end

function MenuScene:on_update(dt)
  ---@diagnostic disable-next-line: invisible
  self.title_window:update(dt)

  if self.input:is_action_pressed("down") then
    print("Fechando a janela...")
    self.title_window:close()
  end

  if self.input:is_action_pressed("up") then
    print("Abrindo a janela...")
    self.title_window:open()
  end

  if self.input:is_action_pressed('start') then
    self.scene:push(require('src.scenes.options'))
  end
end

function MenuScene:on_draw(width, height)
  love.graphics.setShader()
  love.graphics.setColor(1, 1, 1)
  for y = 0, math.ceil(height / 32) - 1 do
    for x = 0, math.ceil(width / 32) - 1 do
      love.graphics.draw(self.background, x * 32, y * 32)
    end
  end

  ---@diagnostic disable-next-line: invisible
  self.title_window:draw()
end

function MenuScene:on_exit()

end

return MenuScene
