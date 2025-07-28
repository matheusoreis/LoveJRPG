local WindowSelectable = require('src.windows.selectable')

--- @class TitleWindow : WindowSelectable
local TitleWindow = WindowSelectable:extend()

function TitleWindow:new(x, y, w, h, scene)
  local items = {
    { name = "Novo Jogo", action = "new_game" },
    { name = "Carregar",  action = "load_game" },
    { name = "Opções",    action = "options" },
    { name = "Sair",      action = "exit" },
  }

  TitleWindow.super.new(self, x, y, w, h, scene, items, 1, 4)
end

function TitleWindow:on_action(action)
  if action == "new_game" then
    print("Novo jogo iniciado!")
  elseif action == "load_game" then
    print("Carregando jogo...")
  elseif action == "options" then
    self.scene:push(require('src.scenes.options'))
  elseif action == "exit" then
    love.event.quit()
  end
end

return TitleWindow
