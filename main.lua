--
-- Author: Matheus R. Oliveira
-- Github: matheusoreis
--

local Resource = require('src.managers.resource')
--- @type Resource
local resource = Resource()

local Input = require('src.managers.input')
--- @type Input
local input = Input()

local Data = require('src.managers.data')
--- @type Data
local data = Data()

--- Dados carregados
local loaded_data = {
  actors = {},
  animations = {},
  effects = {},
  enemies = {},
  groups = {},
  skills = {},
}

function love.load()
  love.graphics.setDefaultFilter("nearest", "nearest")

  -- Carrega os atores
  local all_actors, actors_error = data:load("actors")
  if actors_error then
    return
  end

  -- Carrega as animações
  local all_animations, animations_error = data:load("animations")
  if animations_error then
    return
  end

  -- Carrega os efeitos
  local all_effects, effects_error = data:load("effects")
  if effects_error then
    return
  end

  -- Carrega os inimigos
  local all_enemies, enemies_error = data:load("enemies")
  if enemies_error then
    return
  end

  -- Carrega os grupos de inimigos
  local all_groups, groups_error = data:load("groups")
  if groups_error then
    return
  end

  -- Carrega as habilidades
  local all_skills, skills_error = data:load("skills")
  if skills_error then
    return
  end

  loaded_data.actors = all_actors
  loaded_data.animations = all_animations
  loaded_data.effects = all_effects
  loaded_data.enemies = all_enemies
  loaded_data.groups = all_groups
  loaded_data.skills = all_skills

  print("Atores carregados: " .. #loaded_data.actors)
  print("Animacoes carregadas: " .. #loaded_data.animations)
  print("Efeitos carregados: " .. #loaded_data.effects)
  print("Inimigos carregados: " .. #loaded_data.enemies)
  print("Grupos de inimigos carregados: " .. #loaded_data.groups)
  print("Habilidades carregadas: " .. #loaded_data.skills)
end

local player = { x = 100, y = 100, speed = 120 }

function love.update(dt)
  for _, joystick in ipairs(love.joystick.getJoysticks()) do
    input:update_gamepad_axes(joystick)
  end

  if input:is_down("left") then
    player.x = player.x - player.speed * dt
  elseif input:is_down("right") then
    player.x = player.x + player.speed * dt
  elseif input:is_down("up") then
    player.y = player.y - player.speed * dt
  elseif input:is_down("down") then
    player.y = player.y + player.speed * dt
  end

  input:update()
end

function love.draw()
  love.graphics.rectangle("fill", player.x, player.y, 32, 32)
end

function love.keypressed(key)
  input:key_pressed(key)
end

function love.keyreleased(key)
  input:key_released(key)
end

function love.gamepadpressed(_, button)
  input:gamepad_pressed(button)
end

function love.gamepadreleased(_, button)
  input:gamepad_released(button)
end
