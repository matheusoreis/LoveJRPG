--
-- Author: Matheus R. Oliveira
-- Github: matheusoreis
--

local Object = require('src.lib.classic')

--- @class Transition : Object
local Transition = Object:extend()

--- Construtor da transição.
--- @param initial_opacity? number Opacidade inicial (default: 1)
--- @param color? table Cor opcional no formato {r, g, b}
function Transition:new(initial_opacity, color)
  self.step = 0
  self.opacity = initial_opacity or 1
  self.color = {
    (color and color[1]) or 0,
    (color and color[2]) or 0,
    (color and color[3]) or 0
  }
end

--- Verifica se a transição ainda está ocorrendo.
--- @return boolean
function Transition:is_busy()
  return (self.step > 0 and self.opacity < 1)
      or (self.step < 0 and self.opacity > 0)
end

--- Inicia o fade-in.
--- @param duration number Duração em segundos
function Transition:fade_in(duration)
  self.step = (duration > 0) and (-1 / duration) or 0
  self.opacity = 1
end

--- Inicia o fade-out.
--- @param duration number Duração em segundos
function Transition:fade_out(duration)
  self.step = (duration > 0) and (1 / duration) or 0
  self.opacity = 0
end

--- Atualiza o valor da opacidade com base no passo atual.
function Transition:update()
  self.opacity = math.max(0, math.min(1, self.opacity + self.step))
end

--- Desenha o retângulo de transição na tela.
--- @param width number Largura da tela
--- @param height number Altura da tela
function Transition:draw(width, height)
  if self.opacity == 0 then return end

  love.graphics.setShader()
  love.graphics.setColor(self.color[1], self.color[2], self.color[3], self.opacity)
  love.graphics.rectangle("fill", 0, 0, width, height)
end

return Transition
