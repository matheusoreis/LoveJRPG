local Window = require("src.game.window")

--- @class WindowMenu : Window
local WindowMenu = Window:extend()

function WindowMenu:on_load()
  self.text = "Bem-vindo ao menu!"
  self.elapsed = 0
end

function WindowMenu:on_update(dt)
  -- Atualiza timer
  self.elapsed = self.elapsed + dt

  -- Exemplo: troca texto a cada 1 segundo
  if self.elapsed >= 1 then
    self.text = self.text == "Bem-vindo ao menu!" and "Segure o botão para começar." or "Bem-vindo ao menu!"
    self.elapsed = 0
  end
end

function WindowMenu:draw_content()
  love.graphics.setColor(1, 1, 1, 1)
  love.graphics.print(self.text, 0, 0)
end

return WindowMenu
