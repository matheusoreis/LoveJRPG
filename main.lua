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
  -- Configura o modo da janela.
  love.window.setMode(screenWidth, screenHeight, {
    minwidth = minWidth,
    minheight = minHeight,
    resizable = resizable,
    fullscreen = fullscreen,
    vsync = vsync,
  })
  -- Configura o filtro das texturas
  love.graphics.setDefaultFilter('nearest', 'nearest')
  -- Configura a visibilidade do mouse
  love.mouse.setVisible(mouse_visibility)

  local data_files = { 'actors', 'animations', 'effects', 'enemies', 'groups', 'items', 'skills' }
  for _, filename in ipairs(data_files) do
    local loaded = Data:load(filename)
    if loaded == nil then
      return
    end

    print("Dado carregado com sucesso: " .. filename)
  end
end

function love.update(dt)
  Input:update()
end

function love.draw()
end
