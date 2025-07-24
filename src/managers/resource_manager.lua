--
-- Author: Matheus R. Oliveira
-- Github: matheusoreis
--

local Object = require('src.lib.classic')

--- @class Resource : Object
--- @field private shaders table<string, love.Shader>
--- @field private fonts table<string, table<number, love.Font>>
--- @field private images table<string, love.Image>
local ResourceManager = Object:extend()

function ResourceManager:new()
  self.shaders = {}
  self.fonts = {}
  self.images = {}
end

---@private
--- @param cache table
--- @param key any
--- @param loader function
function ResourceManager:load_cache(cache, key, loader)
  if not cache[key] then
    cache[key] = loader()
  end

  return cache[key]
end

--- @param name string
--- @return love.Shader
function ResourceManager:get_shader(name)
  local path = 'graphics/shaders/' .. name
  return self:load_cache(self.shaders, path, function()
    return love.graphics.newShader(path)
  end)
end

--- @param name string
--- @param size number
--- @return love.Font
function ResourceManager:get_font(name, size)
  local path = 'graphics/fonts/' .. name
  self.fonts[path] = self.fonts[path] or {}
  return self:load_cache(self.fonts[path], size, function()
    return love.graphics.newFont(path, size)
  end)
end

---@private
--- @param path string
--- @return love.Image
function ResourceManager:get_image(path)
  return self:load_cache(self.images, path, function()
    return love.graphics.newImage(path)
  end)
end

--- @param name string
--- @return love.Image
function ResourceManager:get_actor(name)
  return self:get_image('graphics/actors/' .. name)
end

--- @param name string
--- @return love.Image
function ResourceManager:get_animation(name)
  return self:get_image('graphics/animations/' .. name)
end

--- @param name string
--- @return love.Image
function ResourceManager:get_background(name)
  return self:get_image('graphics/backgrounds/' .. name)
end

--- @param name string
--- @return love.Image
function ResourceManager:get_enemy(name)
  return self:get_image('graphics/enemies/' .. name)
end

--- @param name string
--- @return love.Image
function ResourceManager:get_system(name)
  return self:get_image('graphics/system/' .. name)
end

--- @param name string
--- @return love.Image
function ResourceManager:get_tileset(name)
  return self:get_image('graphics/tilesets/' .. name)
end

--- @param name string
--- @return love.Image
function ResourceManager:get_title(name)
  return self:get_image('graphics/titles/' .. name)
end

return ResourceManager
