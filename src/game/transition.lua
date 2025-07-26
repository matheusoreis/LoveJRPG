local Object = require('src.shared.object')
local Tween = require('src.shared.tween')

---@class Transition : Object
local Transition = Object:extend()

function Transition:new(color)
  self.color = color or { 0, 0, 0 }
  self.opacity = 1
  self.tween = nil
  self.duration = 0
end

local transition = Transition()

--- Inicia o fade-in (do cheio para transparente)
--- @param duration number
function Transition:fade_in(duration)
  self.duration = duration
  self.tween = Tween.new(duration, self, { opacity = 0 }, 'linear')
end

--- Inicia o fade-out (do transparente para cheio)
--- @param duration number
function Transition:fade_out(duration)
  self.duration = duration
  self.tween = Tween.new(duration, self, { opacity = 1 }, 'linear')
end

--- Verifica se o tween ainda está ocorrendo
function Transition:is_transitioning()
  return self.tween ~= nil
end

--- Atualiza o tween
---@param dt number
function Transition:update(dt)
  if self.tween then
    local complete = self.tween:update(dt)
    if complete then self.tween = nil end
  end
end

--- Desenha o retângulo de transição
--- @param width number Largura da janela
--- @param height number Altura da janela
function Transition:draw(width, height)
  if self.opacity == 0 then return end

  love.graphics.setShader()
  love.graphics.setColor(self.color[1], self.color[2], self.color[3], self.opacity)
  love.graphics.rectangle("fill", 0, 0, width, height)
end

return transition
