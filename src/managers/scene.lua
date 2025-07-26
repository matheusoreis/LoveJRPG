local Object = require('src.shared.object')
local Transition = require('src.game.transition')

---@class SceneManager : Object
local SceneManager = Object:extend()

function SceneManager:new()
  self.stack = {}

  self.current_scene = nil
  self.next_scene = nil

  self.transition_active = false
  Transition.opacity = 0
end

--- Retorna a cena atual ativa
function SceneManager:current()
  return self.current_scene
end

--- Retorna o número de cenas na pilha
function SceneManager:count()
  return #self.stack
end

--- Empilha uma nova cena
---@param scene_class any
function SceneManager:push(scene_class)
  local new_scene = scene_class(self)
  table.insert(self.stack, new_scene)
  self:switch_to(new_scene)
end

--- Remove a cena atual e volta para a anterior
function SceneManager:pop()
  if #self.stack <= 1 then
    return
  end

  table.remove(self.stack)
  local top = self.stack[#self.stack]
  self:switch_to(top)
end

--- Substitui a cena atual por outra
---@param scene_class any
function SceneManager:replace(scene_class)
  local current = self.stack[#self.stack]
  if current and getmetatable(current) == scene_class then
    return
  end

  if #self.stack > 0 then
    table.remove(self.stack)
  end

  self:push(scene_class)
end

--- Limpa toda a pilha e empilha uma nova cena
---@param scene_class any
function SceneManager:clear_and_push(scene_class)
  self.stack = {}
  self:push(scene_class)
end

--- Troca de cena com transição
---@param new_scene any
function SceneManager:switch_to(new_scene)
  if self.transition_active then
    return
  end

  if self.current_scene then
    self.next_scene = new_scene
    self.transition_active = true
    Transition:fade_out(0.5)
  else
    self.current_scene = new_scene
    self.next_scene = nil
    if self.current_scene and self.current_scene.on_enter then
      self.current_scene:on_enter()
    end
  end
end

--- Atualiza a cena e gerencia transições
function SceneManager:update(dt)
  if self.transition_active then
    Transition:update(dt)

    if Transition:is_transitioning() then
      return
    end

    if Transition.opacity == 1 and self.next_scene then
      if self.current_scene and self.current_scene.on_exit then
        self.current_scene:on_exit()
      end

      self.current_scene = self.next_scene
      self.next_scene = nil

      if self.current_scene and self.current_scene.on_enter then
        self.current_scene:on_enter()
      end

      Transition:fade_in(0.5)
    elseif Transition.opacity == 0 then
      self.transition_active = false
    end
  else
    if self.current_scene and self.current_scene.update then
      self.current_scene:update(dt)
    end
  end
end

--- Desenha a cena atual e a transição
---@param width number
---@param height number
function SceneManager:draw(width, height)
  if self.current_scene and self.current_scene.draw then
    self.current_scene:draw(width, height)
  end

  if self.transition_active or Transition.opacity > 0 then
    Transition:draw(width, height)
  end
end

return SceneManager
