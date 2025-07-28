--
-- Author: Matheus R. Oliveira
-- Github: matheusoreis
--

-- Inicializa os eventos
require('src.shared.events')


local Config = require('src.config')

---@type InputManager
local Input = require('src.managers.input')
---@type DataManager
local Data = require('src.managers.data')
---@type AudioManager
local Audio = require('src.managers.audio')
---@type SceneManager
local Scene = require('src.managers.scene')()

function love.load()
  local title = Config.title
  local version = Config.version
  local screenWidth = Config.screen_width
  local screenHeight = Config.screen_height
  local minWidth = Config.min_width
  local minHeight = Config.min_height
  local fullscreen = Config.fullscreen
  local vsync = Config.vsync
  local resizable = Config.resizable
  local mouse_visibility = Config.mouse_visibility

  -- Configura o título da janela.
  love.window.setTitle(title .. ' ' .. version)
  -- Configura o filtro das texturas
  love.graphics.setDefaultFilter('nearest', 'nearest')
  -- Configura a visibilidade do mouse
  love.mouse.setVisible(mouse_visibility)

  -- Carrega todos os dados do jogo
  local data_files = { 'actors', 'animations', 'effects', 'enemies', 'groups', 'items', 'skills' }
  for _, filename in ipairs(data_files) do
    local loaded = Data:load(filename)
    if loaded == nil then
      return
    end

    print("Dado carregado com sucesso: " .. filename)
  end

  -- Carrega os arquivos de áudios
  Audio:load()

  -- Inicializa a scene principal
  Scene:push(require('src.scenes.title'))
end

function love.update(dt)
  Scene:update(dt)
  Input:update()
end

function love.draw()
  local width = love.graphics.getWidth()
  local height = love.graphics.getHeight()

  Scene:draw(width, height)
end
