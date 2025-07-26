local Object = require('src.shared.object')

---@class ResourceManager : Object
---@field private shaders table<string, love.Shader>
---@field private fonts table<string, love.Font>
---@field private images table<string, love.Image>
local ResourceManager = Object:extend()

function ResourceManager:new()
  self.shaders = {}
  self.fonts = {}
  self.images = {}
end

local resource_manager = ResourceManager()

--- Armazena um recurso em cache se ainda não estiver presente.
---@param store table Armazenamento (shaders, fonts, images)
---@param key string Chave de identificação
---@param data any Valor a ser armazenado
function ResourceManager:cache(store, key, data)
  if not store[key] and data ~= nil then
    store[key] = data
  end

  return store[key]
end

--- Retorna um shader carregado.
---@param name string Nome do shader
function ResourceManager:get_shader(name)
  if self.shaders[name] then
    return self.shaders[name]
  end

  local path = 'graphics/shaders/' .. name .. '.glsl'
  if not love.filesystem.getInfo(path) then
    print("Erro: shader não encontrado: " .. path)
    return nil
  end

  local code = love.filesystem.read(path)
  if not code then
    print("Erro: falha ao ler shader: " .. path)
    return nil
  end

  local shader = love.graphics.newShader(code)
  return self:cache(self.shaders, name, shader)
end

--- Retorna uma fonte carregada.
---@param name string Nome do arquivo de fonte (sem extensão)
---@param size number Tamanho da fonte
function ResourceManager:get_font(name, size)
  local key = name

  if self.fonts[key] then
    return self.fonts[key]
  end

  local path = 'graphics/fonts/' .. name .. '.ttf'
  if not love.filesystem.getInfo(path) then
    print("Erro: fonte não encontrada: " .. path)
    return nil
  end

  local font = love.graphics.newFont(path, size)
  return self:cache(self.fonts, key, font)
end

--- Carrega e retorna uma imagem por categoria.
---@param category string Subpasta em graphics/
---@param name string Nome do arquivo de imagem
function ResourceManager:get_image(category, name)
  local path = 'graphics/' .. category .. '/' .. name .. '.png'

  if not self.images[name] then
    if love.filesystem.getInfo(path) then
      local image = love.graphics.newImage(path)
      return self:cache(self.images, name, image)
    else
      print("Erro: imagem não encontrada: " .. path)
      return nil
    end
  end

  return self.images[name]
end

--- Retorna imagem de ator.
---@param name string Nome do arquivo
function ResourceManager:get_actor(name)
  return self:get_image('actors', name)
end

--- Retorna imagem de animação.
---@param name string Nome do arquivo
function ResourceManager:get_animation(name)
  return self:get_image('animations', name)
end

--- Retorna imagem de fundo.
---@param name string Nome do arquivo
function ResourceManager:get_background(name)
  return self:get_image('backgrounds', name)
end

--- Retorna imagem de inimigo.
---@param name string Nome do arquivo
function ResourceManager:get_enemy(name)
  return self:get_image('enemies', name)
end

--- Retorna imagem do sistema.
---@param name string Nome do arquivo
function ResourceManager:get_system(name)
  return self:get_image('system', name)
end

--- Retorna imagem de tileset.
---@param name string Nome do arquivo
function ResourceManager:get_tileset(name)
  return self:get_image('tilesets', name)
end

--- Retorna imagem de título.
---@param name string Nome do arquivo
function ResourceManager:get_title(name)
  return self:get_image('titles', name)
end

return resource_manager
