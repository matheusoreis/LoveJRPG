local WindowSelectable = require('src.windows.selectable')
local Text = require('src.widgets.text')
local Resource = require('src.managers.resource')

--- @class OptionsWindow : WindowSelectable
local OptionsWindow = WindowSelectable:extend()

function OptionsWindow:new(x, y, w, h)
  local items = {
    { name = "Geral",   action = "general",   help = "Configurações gerais do sistema." },
    { name = "Áudio",   action = "audio",     help = "Ajuste de volume e efeitos sonoros." },
    { name = "Vídeo",   action = "graphics",  help = "Resolução, modo tela cheia, etc." },
    { name = "Atalhos", action = "shortcuts", help = "Mapeamento de teclas e controles." },
  }
  OptionsWindow.super.new(x, y, w, h, items, 1, 4)
end

function OptionsWindow:on_item_selected(item, index)
  print("Selecionou:", item.name)
end

function OptionsWindow:on_item_action(item, index)
  if item.action == "general" then
    print("Entrando em geral")
  elseif item.action == "audio" then
    print("Entrando em audio")
  elseif item.action == "graphics" then
    print("Entrando em gráficos")
  elseif item.action == "exit" then
    print("Entrando em atalhos")
  end
end

return OptionsWindow
