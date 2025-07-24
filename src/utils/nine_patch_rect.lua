---
--- NinePatchRect
---
--- Copyright (C) Paulo Carabalone
--- GitHub: /carabalonepaulo
---
--- Mit License

local Object = require('src.lib.classic')

--- @class NinePatchRect : Object
--- @field private margin { top: number, bottom: number, left: number, right: number }
--- @field private texture love.Texture
--- @field private canvas love.Canvas?
--- @field private lastWidth number?
--- @field private lastHeight number?
local NinePatchRect = Object:extend()

--- Construtor
--- @param margin { top: number, bottom: number, left: number, right: number }
--- @param texture love.Texture
function NinePatchRect:new(margin, texture)
  self.margin = margin or { top = 0, bottom = 0, left = 0, right = 0 }
  self.texture = texture

  self.canvas = nil
  self.lastWidth = nil
  self.lastHeight = nil
end

--- Desenha o retângulo com nine-patch
--- @param x number Posição X
--- @param y number Posição Y
--- @param width number Largura
--- @param height number Altura
function NinePatchRect:draw(x, y, width, height)
  if not self.canvas or self.lastWidth ~= width or self.lastHeight ~= height then
    self.canvas = love.graphics.newCanvas(width, height)
    self.lastWidth = width
    self.lastHeight = height

    local m = self.margin
    local tex = self.texture
    local texW, texH = tex:getWidth(), tex:getHeight()
    local draw = love.graphics.draw
    local newQuad = love.graphics.newQuad

    local cutW = texW - m.left - m.right
    local cutH = texH - m.top - m.bottom
    local scaleX = (width - m.left - m.right) / cutW
    local scaleY = (height - m.top - m.bottom) / cutH

    love.graphics.setCanvas(self.canvas)
    love.graphics.clear()

    -- Centro
    draw(tex, newQuad(m.left, m.top, cutW, cutH, texW, texH), m.left, m.top, 0, scaleX, scaleY)

    -- Cantos
    draw(tex, newQuad(0, 0, m.left, m.top, texW, texH), 0, 0)
    draw(tex, newQuad(texW - m.right, 0, m.right, m.top, texW, texH), width - m.right, 0)
    draw(tex, newQuad(0, texH - m.bottom, m.left, m.bottom, texW, texH), 0, height - m.bottom)
    draw(tex, newQuad(texW - m.right, texH - m.bottom, m.right, m.bottom, texW, texH), width - m.right, height - m
      .bottom)

    -- Bordas
    draw(tex, newQuad(m.left, 0, cutW, m.top, texW, texH), m.left, 0, 0, scaleX, 1)
    draw(tex, newQuad(m.left, texH - m.bottom, cutW, m.bottom, texW, texH), m.left, height - m.bottom, 0, scaleX, 1)
    draw(tex, newQuad(0, m.top, m.left, cutH, texW, texH), 0, m.top, 0, 1, scaleY)
    draw(tex, newQuad(texW - m.right, m.top, m.right, cutH, texW, texH), width - m.right, m.top, 0, 1, scaleY)

    love.graphics.setCanvas()
  end

  love.graphics.draw(self.canvas, x, y)
end

return NinePatchRect
