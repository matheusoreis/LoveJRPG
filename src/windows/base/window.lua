local Object = require('src.lib.classic')
local Tween = require('src.lib.tween')
local NinePatchRect = require('src.utils.nine_patch_rect')

--- @class Window : Object
local Window = Object:extend()

function Window:new(x, y, w, h, skin)
  -- Posição e tamanho
  self.x = x
  self.y = y
  self.w = w
  self.h = h

  self.horizontal_padding = 8
  self.vertical_padding = 8

  self.enabled = true
  self.openness = 0

  self.ox = 0
  self.oy = 0

  self.tween = nil
  self.opening = false
  self.closing = false

  -- Recursos visuais
  self.skin = skin
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

function Window:open()
  self.opening = true
  self.closing = false
  self.tween = Tween.new(0.2, self, { openness = 1 }, 'outQuad')
end

function Window:close()
  self.closing = true
  self.opening = false
  self.tween = Tween.new(0.2, self, { openness = 0 }, 'inQuad')
end

--- @private
function Window:get_content_area()
  return {
    x = self.x + self.horizontal_padding,
    y = self.y + self.vertical_padding,
    w = self.w - 2 * self.horizontal_padding,
    h = self.h - 2 * self.vertical_padding
  }
end

--- @private
function Window:get_content_offset()
  return self.horizontal_padding - self.ox, self.vertical_padding - self.oy
end

--- @private
function Window:get_content_size()
  return self.w - 2 * self.horizontal_padding, self.h - 2 * self.vertical_padding
end

--- @private
function Window:update(dt)
  if self.tween then
    local complete = self.tween:update(dt)
    if complete then
      if self.opening and self:is_open() then
        self.opening = false
        self.enabled = true
        self.tween = nil
        print("Janela totalmente aberta!")
      elseif self.closing and self:is_closed() then
        self.closing = false
        self.enabled = false
        self.tween = nil
        print("Janela totalmente fechada!")
      end
    end
  end

  if self.enabled and self:is_open() then
    self:on_handle_input()
  end

  self:on_update(dt)
end

--- @private
function Window:draw()
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

    self:on_draw_interface()

    love.graphics.push()
    local offset_x, offset_y = self:get_content_offset()
    love.graphics.translate(offset_x, offset_y)

    local content = self:get_content_area()
    love.graphics.setScissor(content.x, content.y, content.w, content.h)

    self:on_draw_content()

    love.graphics.setScissor()
    love.graphics.pop()
    love.graphics.pop()
  end
end

function Window:on_load() end

function Window:on_draw_interface() end

function Window:on_draw_content() end

function Window:on_handle_input() end

function Window:on_update(dt) end

return Window
