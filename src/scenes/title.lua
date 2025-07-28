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

  local center_x_welcome = (screen_width / 2) - (welcome_size[1] / 2)
  local center_x_title = (screen_width / 2) - (title_size[1] / 2)

  local welcome_window = WelcomeWindow(center_x_welcome, start_y, welcome_size[1], welcome_size[2])
  self:add_window('welcome', welcome_window)

  local title_items = {
    { name = "Acessar",   action = "sign_in" },
    { name = "Cadastrar", action = "sign_up" },
    { name = "Opções",    action = "options" },
    { name = "Sair",      action = "exit" },
  }

  local title_window = TitleWindow(
    center_x_title,
    (start_y + welcome_size[2]) + 10,
    title_size[1],
    title_size[2],
    title_items, 1, 4
  )

  title_window:set_on_action(
    function(item, index, window)
      self:on_menu_action(item.action, item, index)
    end
  )

  self:add_window('title', title_window)

  self.title_window = title_window
end

function TitleScene:on_enter()
  self:open_window('welcome')
  self:open_window('title')
end

-- Evento quando confirma/clica em um item
function TitleScene:on_menu_action(action, item, index)
  print("Executando ação:", action, "do item", item.name)

  if action == 'sign_in' then
    -- Lógica para entrar
    -- self.scene:change(require('src.scenes.login'))
  elseif action == 'sign_up' then
    -- Lógica para cadastrar
    -- self.scene:change(require('src.scenes.register'))
  elseif action == 'options' then
    self.scene:push(require('src.scenes.options'))
  elseif action == 'exit' then
    love.event.quit()
  end
end

-- Remove o método antigo que contaminava a scene
-- function TitleScene:on_window_action(action) -- <-- REMOVIDO!

-- Métodos utilitários se precisar acessar dados da window
function TitleScene:get_selected_menu_item()
  return self.title_window:get_selected_item()
end

function TitleScene:get_selected_menu_index()
  return self.title_window:get_selected_index()
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
