local Object = require('src.shared.object')

--- @class NinePatchRect : Object
--- @field private margin { top: number, bottom: number, left: number, right: number }
--- @field private texture love.Texture
--- @field private quads table
local NinePatchRect = Object:extend()

function NinePatchRect:new(margin, texture)
  self.margin = margin or { top = 0, bottom = 0, left = 0, right = 0 }
  self.texture = texture

  self:create_quads()
end

--- Cria os 9 quads do nine-patch
function NinePatchRect:create_quads()
  local m = self.margin
  local texW, texH = self.texture:getWidth(), self.texture:getHeight()

  -- Dimensões das seções
  local leftW = m.left
  local rightW = m.right
  local topH = m.top
  local bottomH = m.bottom
  local centerW = texW - leftW - rightW
  local centerH = texH - topH - bottomH

  -- Cria os 9 quads
  self.quads = {
    -- Linha superior
    tl = love.graphics.newQuad(0, 0, leftW, topH, texW, texH),                -- Top-left
    tm = love.graphics.newQuad(leftW, 0, centerW, topH, texW, texH),          -- Top-middle
    tr = love.graphics.newQuad(leftW + centerW, 0, rightW, topH, texW, texH), -- Top-right

    -- Linha do meio
    ml = love.graphics.newQuad(0, topH, leftW, centerH, texW, texH),                -- Middle-left
    mm = love.graphics.newQuad(leftW, topH, centerW, centerH, texW, texH),          -- Middle-middle (centro)
    mr = love.graphics.newQuad(leftW + centerW, topH, rightW, centerH, texW, texH), -- Middle-right

    -- Linha inferior
    bl = love.graphics.newQuad(0, topH + centerH, leftW, bottomH, texW, texH),               -- Bottom-left
    bm = love.graphics.newQuad(leftW, topH + centerH, centerW, bottomH, texW, texH),         -- Bottom-middle
    br = love.graphics.newQuad(leftW + centerW, topH + centerH, rightW, bottomH, texW, texH) -- Bottom-right
  }

  -- Guarda as dimensões originais para cálculo de escala
  self.centerW = centerW
  self.centerH = centerH
end

--- Desenha o retângulo com nine-patch
--- @param x number Posição X
--- @param y number Posição Y
--- @param width number Largura
--- @param height number Altura
function NinePatchRect:draw(x, y, width, height)
  local m = self.margin
  local tex = self.texture
  local quads = self.quads

  -- Calcula escalas para as seções que precisam esticar
  local scaleX = (width - m.left - m.right) / self.centerW
  local scaleY = (height - m.top - m.bottom) / self.centerH

  -- Posições calculadas
  local rightX = x + width - m.right
  local bottomY = y + height - m.bottom
  local centerX = x + m.left
  local centerY = y + m.top

  love.graphics.setColor(1, 1, 1, 1)

  -- Desenha os 9 pedaços

  -- Cantos (não escalam)
  love.graphics.draw(tex, quads.tl, x, y)            -- Top-left
  love.graphics.draw(tex, quads.tr, rightX, y)       -- Top-right
  love.graphics.draw(tex, quads.bl, x, bottomY)      -- Bottom-left
  love.graphics.draw(tex, quads.br, rightX, bottomY) -- Bottom-right

  -- Bordas horizontais (escalam só no X)
  love.graphics.draw(tex, quads.tm, centerX, y, 0, scaleX, 1)       -- Top-middle
  love.graphics.draw(tex, quads.bm, centerX, bottomY, 0, scaleX, 1) -- Bottom-middle

  -- Bordas verticais (escalam só no Y)
  love.graphics.draw(tex, quads.ml, x, centerY, 0, 1, scaleY)      -- Middle-left
  love.graphics.draw(tex, quads.mr, rightX, centerY, 0, 1, scaleY) -- Middle-right

  -- Centro (escala em X e Y)
  love.graphics.draw(tex, quads.mm, centerX, centerY, 0, scaleX, scaleY) -- Middle-middle
end

return NinePatchRect
