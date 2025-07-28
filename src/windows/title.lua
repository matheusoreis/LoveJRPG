local WindowSelectable = require('src.windows.selectable')

---@class TitleWindow : WindowSelectable
local TitleWindow = WindowSelectable:extend()

function TitleWindow:new(x, y, w, h)
  local items = {
    { name = "Acessar",   action = "sign_in" },
    { name = "Cadastrar", action = "sign_up" },
    { name = "Opções",    action = "options" },
    { name = "Sair",      action = "exit" },
  }
  TitleWindow.super.new(self, x, y, w, h, items, 1, 4)
end

function TitleWindow:on_item_selected(item, index)
  print("Selecionou:", item.name)
end

function TitleWindow:on_item_action(item, index)
  if item.action == "sign_in" then
    print("Entrar no sistema")
  elseif item.action == "sign_up" then
    print("Cadastrar usuário")
  elseif item.action == "options" then
    print("Abrir opções")
  elseif item.action == "exit" then
    print("Sair do jogo")
  end
end

return TitleWindow
