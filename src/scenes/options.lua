local SceneBase = require('src.scenes.scene')
local OptionsWindow = require('src.windows.options')
local WindowHelp = require('src.windows.help')

---@class OptionsScene : SceneBase
local OptionsScene = SceneBase:extend()

function OptionsScene:on_load()
  self.background = self.resource:get_title('background')

  local screen_width = love.graphics.getWidth()
  local screen_height = love.graphics.getHeight()

  local help_size = { love.graphics.getWidth() - 42, 42 }
  local help_x = (screen_width - help_size[1]) / 2
  local help_y = 16
  self.help_window = WindowHelp(help_x, help_y, help_size[1], help_size[2])
  self:add_window('help', self.help_window)

  local options_size = { 220, 140 }
  local center_x = (screen_width - options_size[1]) / 2
  local center_y = (screen_height - options_size[2]) / 2

  local options_items = {
    { name = "Geral",   action = "general",   help = "Configurações gerais do sistema." },
    { name = "Áudio",   action = "audio",     help = "Ajuste de volume e efeitos sonoros." },
    { name = "Vídeo",   action = "graphics",  help = "Resolução, modo tela cheia, etc." },
    { name = "Atalhos", action = "shortcuts", help = "Mapeamento de teclas e controles." },
  }

  self.options_window = OptionsWindow(
    center_x, center_y,
    options_size[1], options_size[2],
    options_items, 1, 4
  )

  self.options_window:set_on_select(function(item, index, window)
    self:on_option_highlight(item, index)
  end)

  self.options_window:set_on_action(function(item, index, window)
    self:on_option_action(item.action, item, index)
  end)

  self:add_window('options', self.options_window)
end

function OptionsScene:on_enter()
  self:open_window('options')
  self:open_window('help')

  local first_item = self.options_window:get_selected_item()
  if first_item then
    self:on_option_highlight(first_item, 1)
  end
end

function SceneBase:on_resume(...)
  print(...)
end

function OptionsScene:on_update(dt)
  if self.input:is_action_pressed('back') then
    self.scene:pop()
  end
end

function OptionsScene:on_option_highlight(item, index)
  local help_text = item.help or ""
  if self.help_window then
    self.help_window:set_text(help_text)
  end
end

function OptionsScene:on_option_action(action, item, index)
  print("Executando ação:", action, "do item", item.name, " index: ", index)

  if action == 'general' then
    self.scene:push(require('src.scenes.name_input'))
  elseif action == 'audio' then
    print("Abrindo configurações de áudio...")
  elseif action == 'graphics' then
    print("Abrindo configurações de vídeo...")
  elseif action == 'shortcuts' then
    print("Abrindo configurações de atalhos...")
  elseif action == 'back' then
    self.scene:pop()
  end
end

function OptionsScene:update_help_text(text)
  if self.help_window then
    self.help_window:set_text(text or "")
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
