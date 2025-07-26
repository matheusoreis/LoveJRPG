--
-- Author: Matheus R. Oliveira
-- Github: matheusoreis
--

-- Inicializa os eventos
require('src.shared.events')


local Config = require('src.config')

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
  love.window.setTitle(title .. " " .. version)
  -- Configura o modo da janela.
  love.window.setMode(screenWidth, screenHeight, {
    minwidth = minWidth,
    minheight = minHeight,
    resizable = resizable,
    fullscreen = fullscreen,
    vsync = vsync,
  })
  -- Configura o filtro das texturas
  love.graphics.setDefaultFilter("nearest", "nearest")
  -- Configura a visibilidade do mouse
  love.mouse.setVisible(mouse_visibility)
end

function love.update(dt)
end

function love.draw()
end
