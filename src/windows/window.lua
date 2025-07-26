local Object = require('src.shared.object')
local Tween = require('src.shared.tween')
local Resource = require('src.managers.resource')
local NinePatchRect = require('src.shared.ninepatch')

--- @class WindowBase : Object
local WindowBase = Object:extend()

function WindowBase:new(x, y, w, h)
  self.x = x
  self.y = y
  self.w = w
  self.h = h

  self.padding = { 8, 8 }
  self.tween_progress = 0

  -- Estados de animação
  self.tween = nil
  self.opening = false
  self.closing = false

  -- Background
  self.background = Resource:get_system('window_background')
  self.background_rect = NinePatchRect({ top = 6, bottom = 6, left = 6, right = 6 }, self.background)

  -- Frame
  self.frame = Resource:get_system('window_frame')
  self.frame_rect = NinePatchRect({ top = 6, bottom = 6, left = 6, right = 6 }, self.frame)
end

---@private
function WindowBase:is_open()
  return self.tween_progress == 1
end

---@private
function WindowBase:is_closed()
  return self.tween_progress == 0
end

---@private
function WindowBase:is_opening()
  return self.opening
end

---@private
function WindowBase:is_closing()
  return self.closing
end

function WindowBase:open()
  if self.tween_progress == 1 or self.opening then return end

  self.opening = true
  self.closing = false
  self.tween = Tween.new(0.2, self, { tween_progress = 1 }, 'outQuad')
end

function WindowBase:close()
  if self.tween_progress == 0 or self.closing then return end

  self.closing = true
  self.opening = false
  self.tween = Tween.new(0.2, self, { tween_progress = 0 }, 'inQuad')
end

function WindowBase:get_content_area()
  return {
    x = self.x + self.padding[1],
    y = self.y + self.padding[2],
    w = self.w - (self.padding[1] * 2),
    h = self.h - (self.padding[2] * 2),
  }
end

function WindowBase:get_content_size()
  return self.w - (self.padding[1] * 2), self.h - (self.padding[2] * 2)
end

function WindowBase:get_content_offset()
  return self.padding[1], self.padding[2]
end

---@protected
function WindowBase:update(dt)
  if self.tween then
    local complete = self.tween:update(dt)
    if complete then
      if self.opening and self:is_open() then
        self.opening = false
        self.tween = nil
      elseif self.closing and self:is_closed() then
        self.closing = false
        self.tween = nil
      end
    end
  end

  self:on_update(dt)
end

function WindowBase:on_update(dt)
end

---@protected
function WindowBase:draw()
  if not self:is_closed() then
    love.graphics.push()
    love.graphics.translate(self.x, self.y + self.h / 2)
    love.graphics.scale(1, self.tween_progress)
    love.graphics.translate(0, -self.h / 2)

    -- Desenhar background
    love.graphics.setColor(1, 1, 1, 1)
    self.background_rect:draw(0, 0, self.w, self.h)

    -- Desenhar frame por cima
    self.frame_rect:draw(0, 0, self.w, self.h)

    love.graphics.pop()
  end

  if self:is_open() then
    love.graphics.push()
    love.graphics.translate(self.x, self.y)

    love.graphics.push()
    local offset_x, offset_y = self:get_content_offset()
    love.graphics.translate(offset_x, offset_y)

    local content = self:get_content_area()
    love.graphics.setScissor(content.x, content.y, content.w, content.h)

    self:on_draw()

    love.graphics.setScissor()
    love.graphics.pop()
    love.graphics.pop()
  end
end

function WindowBase:on_draw()
end

return WindowBase
