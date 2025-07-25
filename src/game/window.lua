local Object = require('src.lib.classic')
local NinePatchRect = require('src.utils.nine_patch_rect')

--- @class Window : Object
local Window = Object:extend()

function Window:new(x, y, w, h, resource, input, padding_x, padding_y)
  -- Posição e tamanho
  self.x = x
  self.y = y
  self.w = w
  self.h = h

  -- Paddings configuráveis (default: 4)
  self.horizontal_padding = padding_x or 4
  self.vertical_padding = padding_y or 4

  -- Recursos
  self.resource = resource
  self.input = input

  -- Estados
  self.visible = true
  self.enabled = true
  self.openness = 0

  self.ox = 0
  self.oy = 0

  self.opening = false
  self.closing = false
  self.open_speed = 0

  -- Recursos visuais
  self.skin = self.resource:get_system("skin.png")
  self.bg_quad = love.graphics.newQuad(0, 0, 64, 64, 128, 128)

  -- Cria o patch da moldura
  local frame_quad = love.graphics.newQuad(64, 0, 64, 64, 128, 128)
  local frame_image = love.graphics.newCanvas(64, 64)

  love.graphics.setCanvas(frame_image)
  love.graphics.clear()
  love.graphics.draw(self.skin, frame_quad, 0, 0)
  love.graphics.setCanvas()

  self.skin_rect = NinePatchRect({ top = 8, bottom = 8, left = 8, right = 8 }, frame_image)

  self:on_load()
end

--#region states
function Window:is_visible()
  return self.visible
end

function Window:is_enabled()
  return self.enabled
end

function Window:is_open()
  return self.openness == 1
end

function Window:is_closed()
  return self.openness == 0
end

function Window:is_opening()
  return self.opening
end

function Window:is_closing()
  return self.closing
end

function Window:set_visible(visible)
  self.visible = visible
end

function Window:set_enabled(enabled)
  self.enabled = enabled
end

--#endregion

-- Abertura / Fechamento

function Window:open(duration)
  duration = duration or 4
  if duration > 0 then
    self.open_speed = 1 / duration
  else
    self.openness = 1
    self.open_speed = 0
  end
  self.opening = not self:is_open()
  self.closing = false
end

function Window:close(duration)
  duration = duration or 4
  if duration > 0 then
    self.open_speed = 1 / duration
  else
    self.openness = 0
    self.open_speed = 0
  end
  self.opening = false
  self.closing = not self:is_closed()
end

-- Área de conteúdo

function Window:get_content_area()
  return {
    x = self.x + self.horizontal_padding,
    y = self.y + self.vertical_padding,
    w = self.w - 2 * self.horizontal_padding,
    h = self.h - 2 * self.vertical_padding
  }
end

function Window:get_content_offset()
  return self.horizontal_padding - self.ox, self.vertical_padding - self.oy
end

function Window:get_content_size()
  return self.w - 2 * self.horizontal_padding, self.h - 2 * self.vertical_padding
end

-- Métodos de override

function Window:on_load()
end

function Window:draw_interface()
end

function Window:draw_content()
end

function Window:handle_input()
end

function Window:on_update(dt)
end

function Window:update(dt)
  if self.opening then
    local old = self.openness
    self.openness = math.min(1, self.openness + self.open_speed * dt)
    print(("Abrindo: %.2f -> %.2f"):format(old, self.openness))
    if self:is_open() then
      self.opening = false
      print("Janela totalmente aberta!")
    end
  elseif self.closing then
    local old = self.openness
    self.openness = math.max(0, self.openness - self.open_speed * dt)
    print(("Fechando: %.2f -> %.2f"):format(old, self.openness))
    if self:is_closed() then
      self.closing = false
      print("Janela totalmente fechada!")
    end
  end

  if self.enabled and self:is_open() then
    self:handle_input()
  end

  self:on_update(dt)
end

-- Desenho

function Window:draw()
  if not self.visible then return end

  if not self:is_closed() then
    love.graphics.push()
    love.graphics.translate(self.x, self.y + self.h / 2)
    love.graphics.scale(1, self.openness)
    love.graphics.translate(0, -self.h / 2)

    love.graphics.setShader()
    love.graphics.setColor(1, 1, 1, 1)
    love.graphics.draw(self.skin, self.bg_quad, 0, 0, 0, self.w / 64, self.h / 64)

    self.skin_rect:draw(0, 0, self.w, self.h)

    love.graphics.pop()
  end

  if self:is_open() then
    love.graphics.push()
    love.graphics.translate(self.x, self.y)

    self:draw_interface()

    love.graphics.push()
    local offset_x, offset_y = self:get_content_offset()
    love.graphics.translate(offset_x, offset_y)

    local content = self:get_content_area()
    love.graphics.setScissor(content.x, content.y, content.w, content.h)

    self:draw_content()

    love.graphics.setScissor()
    love.graphics.pop()
    love.graphics.pop()
  end
end

return Window
