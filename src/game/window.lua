-- Author: Matheus R. Oliveira (adaptado)
-- Base para janelas do jogo estilo Final Fantasy

local Object = require('src.lib.classic')
local utf8 = require("utf8")
local NinePatchRect = require('src.utils.nine_patch_rect')

--- @class Window : Object
local Window = Object:extend()

function Window:new(x, y, w, h, resource, input, data)
  self.x = x
  self.y = y
  self.w = w
  self.h = h

  self.resource = resource
  self.input = input
  self.data = data or {}

  self.visible = true
  self.enabled = true
  self.openness = 1 -- de 0 a 1 (animação)

  self.ox = 0
  self.oy = 0

  self._opening = false
  self._closing = false
  self._openSpeed = 0

  self.font = self.resource:get_font("default.ttf", 16)

  local fullTexture = self.resource:get_system("skin.png")
  local frameQuad = love.graphics.newQuad(64, 0, 64, 64, 128, 128)
  local frameImage = love.graphics.newCanvas(64, 64)

  love.graphics.setCanvas(frameImage)
  love.graphics.clear()
  love.graphics.draw(fullTexture, frameQuad, 0, 0)
  love.graphics.setCanvas()

  self.skinRect = NinePatchRect({ top = 8, bottom = 8, left = 8, right = 8 }, frameImage)

  self._callbacks = {}
end

-- ⬇ Métodos de controle

function Window:isOpen()
  return self.openness > 0
end

function Window:open(duration)
  duration = duration or 10
  self._opening = true
  self._closing = false
  self._openSpeed = 1 / duration
end

function Window:close(duration)
  duration = duration or 10
  self._opening = false
  self._closing = true
  self._openSpeed = 1 / duration
end

function Window:setCallback(name, fn)
  self._callbacks[name] = fn
end

function Window:_call(name)
  if self._callbacks[name] then
    self._callbacks[name]()
  end
end

function Window:setData(data)
  self.data = data or {}
end

-- ⬇ Layout helpers

function Window:getHPad() return 8 end

function Window:getVPad() return 8 end

function Window:getContentW() return self.w - 2 * self:getHPad() end

function Window:getContentH() return self.h - 2 * self:getVPad() end

function Window:getLineH() return 20 end

function Window:getTextW(text) return self.font:getWidth(text) end

-- ⬇ Texto com truncamento e alinhamento
function Window:drawText(text, x, y, w, h, align)
  local tw = self:getTextW(text)
  local rw = w or tw
  local rh = h or self:getLineH()

  if tw > rw then
    while utf8.len(text) > 0 and self:getTextW(text .. "...") > rw do
      text = string.sub(text, 1, utf8.offset(text, -1) - 1)
    end
    text = text .. "..."
    tw = self:getTextW(text)
  end

  love.graphics.setFont(self.font)
  love.graphics.setColor(1, 1, 1)

  if align == "center" then
    x = x + (rw - tw) / 2
  elseif align == "right" then
    x = x + (rw - tw)
  end

  love.graphics.print(text, x, y)
end

-- ⬇ Para sobrescrever nas subclasses
function Window:drawInterface() end

function Window:drawContent() end

function Window:update(dt)
  if self._opening then
    self.openness = math.min(1, self.openness + self._openSpeed * dt)
    if self.openness == 1 then
      self._opening = false
      self:_call("open")
    end
  elseif self._closing then
    self.openness = math.max(0, self.openness - self._openSpeed * dt)
    if self.openness == 0 then
      self._closing = false
      self:_call("close")
    end
  end
end

function Window:draw()
  if not self.visible then return end

  -- Fundo da janela (parte estática)
  local skin = self.resource:get_system("skin.png")
  local bgQuad = love.graphics.newQuad(0, 0, 64, 64, 128, 128)
  love.graphics.setShader()
  love.graphics.setColor(1, 1, 1, 1)
  love.graphics.draw(skin, bgQuad, self.x, self.y, 0, self.w / 64, self.h / 64)

  -- Moldura (sempre)
  self.skinRect:draw(self.x, self.y, self.w, self.h)

  -- Animação de abertura
  if self.openness <= 0 then return end

  -- Conteúdo interno com transformação
  local sw = self:getContentW()
  local sh = self:getContentH()
  local sx = self.x + self:getHPad()
  local sy = self.y + self:getVPad()
  local cx = self:getHPad() - self.ox
  local cy = self:getVPad() - self.oy

  love.graphics.push()
  love.graphics.translate(self.x, self.y + self.h / 2)
  love.graphics.scale(1, self.openness)
  love.graphics.translate(0, -self.h / 2)

  love.graphics.push()
  love.graphics.translate(cx, cy)
  love.graphics.setScissor(sx, sy, sw, sh)
  self:drawInterface()
  self:drawContent()
  love.graphics.setScissor()
  love.graphics.pop()

  love.graphics.pop()
end

return Window
