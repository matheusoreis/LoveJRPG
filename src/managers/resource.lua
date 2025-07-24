--
-- Author: Matheus R. Oliveira
-- Github: matheusoreis
--

local Object = require('src.lib.classic')

--- @class Resource : Object
--- @field private shaders table<string, love.Shader>
--- @field private fonts table<string, table<number, love.Font>>
--- @field private images table<string, love.Image>
local Resource = Object:extend()

function Resource:new()
  self.shaders = {}
  self.fonts = {}
  self.images = {}
end

---@private
--- Carrega um recurso do cache ou o cria se não existir
--- @param cache table
--- @param key any
--- @param loader function
function Resource:load_cache(cache, key, loader)
  if not cache[key] then
    cache[key] = loader()
  end

  return cache[key]
end

--- Carrega um shader
--- @param name string
--- @return love.Shader
function Resource:load_shader(name)
  local path = 'graphics/shaders/' .. name
  return self:load_cache(self.shaders, path, function()
    return love.graphics.newShader(path)
  end)
end

--- Carrega uma fonte
--- @param name string
--- @param size number
--- @return love.Font
function Resource:load_font(name, size)
  local path = 'graphics/fonts/' .. name
  self.fonts[path] = self.fonts[path] or {}
  return self:load_cache(self.fonts[path], size, function()
    return love.graphics.newFont(path, size)
  end)
end

---@private
--- Carrega uma imagem
--- @param path string
--- @return love.Image
function Resource:load_image(path)
  return self:load_cache(self.images, path, function()
    return love.graphics.newImage(path)
  end)
end

--- Carrega um sprite de ator
--- @param name string
--- @return love.Image
function Resource:load_actor(name)
  return self:load_image('graphics/actors/' .. name)
end

--- Carrega um sprite de animação
--- @param name string
--- @return love.Image
function Resource:load_animation(name)
  return self:load_image('graphics/animations/' .. name)
end

--- Carrega uma imagem de fundo
--- @param name string
--- @return love.Image
function Resource:load_background(name)
  return self:load_image('graphics/backgrounds/' .. name)
end

--- Carrega um sprite de inimigo
--- @param name string
--- @return love.Image
function Resource:load_enemy(name)
  return self:load_image('graphics/enemies/' .. name)
end

--- Carrega uma imagem do sistema
--- @param name string
--- @return love.Image
function Resource:load_system(name)
  return self:load_image('graphics/system/' .. name)
end

--- Carrega um tileset
--- @param name string
--- @return love.Image
function Resource:load_tileset(name)
  return self:load_image('graphics/tilesets/' .. name)
end

--- Carrega uma imagem de título
--- @param name string
--- @return love.Image
function Resource:load_title(name)
  return self:load_image('graphics/titles/' .. name)
end

return Resource
