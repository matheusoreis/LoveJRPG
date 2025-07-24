--
-- Author: Matheus R. Oliveira
-- Github: matheusoreis
--

--#region Imports
local AudioManager = require('src.managers.audio_manager')
--- @type AudioManager
local audio_manager = AudioManager()

local ResourceManager = require('src.managers.resource_manager')
--- @type Resource
local resource_manager = ResourceManager()

local InputManager = require('src.managers.input_manager')
--- @type InputManager
local input_manager = InputManager()

local DataManager = require('src.managers.data_manager')
--- @type DataManager
local data_manager = DataManager()

local Transition = require('src.game.transition')
--- @type Transition
local transition = Transition()

local SceneManager = require("src.managers.scene_manager")
--- @type SceneManager
local scene_manager = SceneManager(resource_manager, input_manager, data_manager, audio_manager, transition)
--#endregion

--#region Scenes
local MenuScene = require("src.scenes.menu")
--#endregion

-- Dados do jogo no globals do lua
Data = {}

function love.load()
  local keys = { "actors", "animations", "effects", "enemies", "groups", "skills" }

  for _, key in ipairs(keys) do
    local result, err = data_manager:load(key)
    if err then return end
    Data[key] = result
  end

  scene_manager:push(MenuScene, true)
end

function love.update(dt)
  for _, joystick in ipairs(love.joystick.getJoysticks()) do
    input_manager:update_gamepad_axes(joystick)
  end

  audio_manager:update(dt)
  scene_manager:update(dt)
  input_manager:update(dt)
end

function love.draw()
  local width = love.graphics.getWidth()
  local height = love.graphics.getHeight()

  scene_manager:draw(width, height)
end

function love.keypressed(key)
  input_manager:key_pressed(key)
end

function love.keyreleased(key)
  input_manager:key_released(key)
end

function love.gamepadpressed(_, button)
  input_manager:gamepad_pressed(button)
end

function love.gamepadreleased(_, button)
  input_manager:gamepad_released(button)
end
