local SceneBase = require('src.scenes.scene')
local WindowInput = require('src.windows.input')
local WindowHelp = require('src.windows.help')

---@class NameInputScene : SceneBase
local NameInputScene = SceneBase:extend()

function NameInputScene:on_load()
  self.background = self.resource:get_title('background')

  local screen_width = love.graphics.getWidth()
  local screen_height = love.graphics.getHeight()

  local help_size = { screen_width - 64, 42 }
  local help_x = (screen_width - help_size[1]) / 2
  local help_y = 16
  self.help_window = WindowHelp(help_x, help_y, help_size[1], help_size[2])
  self:add_window('help', self.help_window)

  local input_size = { 400, 300 }
  local input_x = (screen_width - input_size[1]) / 2
  local input_y = (screen_height - input_size[2]) / 2

  self.input_window = WindowInput(
    input_x, input_y,
    input_size[1], input_size[2],
    8,
    WindowInput.INPUT_TYPES.ALPHANUMERIC
  )

  -- Configurar callbacks seguindo o padrão da OptionsScene
  self.input_window:set_on_action(function(item, index, window)
    self:on_input_action(item, index)
  end)

  self:add_window('input', self.input_window)
end

function NameInputScene:on_enter()
  self:open_window('help')
  self:open_window('input')
  self.help_window:set_text("Digite o nome do seu personagem (máximo 8 caracteres)")
end

function NameInputScene:on_input_action(item, index)
  if item.action == "char" then
    local success = self.input_window:add_char(item.value)
    if success then
      self:update_help_text()
    end
  elseif item.action == "space" then
    local success = self.input_window:add_char(" ")
    if success then
      self:update_help_text()
    end
  elseif item.action == "delete" then
    local success = self.input_window:delete_char()
    if success then
      self:update_help_text()
    end
  elseif item.action == "confirm" then
    self:confirm_name()
  end
end

function NameInputScene:update_help_text()
  local current_name = self.input_window:get_current_text()
  local remaining = self.input_window:get_remaining_chars()

  if remaining > 0 then
    self.help_window:set_text(string.format("Nome: '%s' - %d caracteres restantes", current_name, remaining))
  else
    self.help_window:set_text(string.format("Nome: '%s' - Limite atingido! Pressione OK para confirmar", current_name))
  end
end

function NameInputScene:confirm_name()
  if not self.input_window:is_valid() then
    self.help_window:set_text("O nome não pode estar vazio!")
    return
  end

  local current_name = self.input_window:get_current_text()
  print("Nome confirmado:", current_name)
  self.help_window:set_text(string.format("Nome '%s' confirmado! Pressione ESC para voltar", current_name))
end

function NameInputScene:on_update(dt)
  if self.input:is_action_pressed('back') then
    self.scene:pop()
  end
end

function NameInputScene:on_draw(width, height)
  love.graphics.setShader()
  love.graphics.setColor(1, 1, 1)

  for y = 0, math.ceil(height / 32) - 1 do
    for x = 0, math.ceil(width / 32) - 1 do
      love.graphics.draw(self.background, x * 32, y * 32)
    end
  end
end

return NameInputScene
