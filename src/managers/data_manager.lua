--
-- Author: Matheus R. Oliveira
-- Github: matheusoreis
--

local Object = require('src.lib.classic')
local json = require('src.lib.json')

--- @class DataManager : Object
--- @field private save_path string
local DataManager = Object:extend()

function DataManager:new()
  self.save_path = "data/"

  if not love.filesystem.getInfo(self.save_path) then
    love.filesystem.createDirectory(self.save_path)
  end
end

--- @param name string
--- @param data table
--- @return boolean success
function DataManager:save(name, data)
  if type(data) ~= "table" then
    return false
  end

  local filename = self.save_path .. name .. ".json"

  local encoded_data = json.encode(data)
  if not encoded_data then
    return false
  end

  local success, _ = love.filesystem.write(filename, encoded_data)
  if not success then
    return false
  end

  return true
end

--- @param name string
--- @return table|nil data
--- @return string? error
function DataManager:load(name)
  local filename = self.save_path .. name .. ".json"

  -- Verifica se o arquivo existe
  if not love.filesystem.getInfo(filename) then
    return nil, "Arquivo não encontrado: " .. filename
  end

  -- Lê o arquivo
  local content = love.filesystem.read(filename)
  if not content then
    return nil, "Erro ao ler arquivo"
  end

  -- Decodifica o JSON
  local decoded_data = json.decode(content)
  if not decoded_data then
    return nil, "Erro ao decodificar JSON"
  end

  return decoded_data
end

return DataManager
