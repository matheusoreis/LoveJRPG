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

function Resource:loadCache(cache, key, loader)
  if not cache[key] then
    cache[key] = loader()
  end

  return cache[key]
end

function Resource:getShaders(name)
  local path = 'graphics/shaders/' .. name
  return self:loadCache(self.shaders, path, function()
    return love.graphics.newShader(path)
  end)
end

function Resource:getFonts(name, size)
  local path = 'graphics/fonts/' .. name
  self.fonts[path] = self.fonts[path] or {}
  return self:loadCache(self.fonts[path], size, function()
    return love.graphics.newFont(path, size)
  end)
end

function Resource:getTextures(path)
  return self:loadCache(self.images, path, function()
    return love.graphics.newImage(path)
  end)
end

--- Obtem as texturas dos atores
--- @param name string
--- @return love.Image
function Resource:getActorTextures(name)
  return self:getTextures('graphics/actors/' .. name)
end

--- Obtem as texturas de animação.
--- @param name string
--- @return love.Image
function Resource:getAnimationTextures(name)
  return self:getTextures('graphics/animations/' .. name)
end

--- Obtem as texturas de fundo.
--- @param name string
--- @return love.Image
function Resource:getBackgroundTextures(name)
  return self:getTextures('graphics/backgrounds/' .. name)
end

--- Obtem as texturas de inimigos.
--- @param name string
--- @return love.Image
function Resource:getEnemyTextures(name)
  return self:getTextures('graphics/enemies/' .. name)
end

--- Obtem as texturas do sistema.
--- @param name string
--- @return love.Image
function Resource:getSystemTextures(name)
  return self:getTextures('graphics/system/' .. name)
end

--- Obtem as texturas dos tilesets.
--- @param name string
--- @return love.Image
function Resource:getTilesetTextures(name)
  return self:getTextures('graphics/tilesets/' .. name)
end

--- Obtem as texturas do título.
--- @param name string
--- @return love.Image
function Resource:getTitleTextures(name)
  return self:getTextures('graphics/titles/' .. name)
end

return Resource
