--
-- Author: Matheus R. Oliveira
-- Github: matheusoreis
--

local Object = require('src.lib.classic')
local json = require('src.lib.json')

--- @class Data : Object
--- @field private save_path string Caminho base para salvar os arquivos
local Data = Object:extend()

function Data:new()
  -- Define o diretório base para salvar os arquivos
  self.save_path = "data/"

  -- Garante que o diretório de saves existe
  if not love.filesystem.getInfo(self.save_path) then
    love.filesystem.createDirectory(self.save_path)
  end
end

--- Salva dados em um arquivo JSON
--- @param name string Nome do arquivo (sem extensão)
--- @param data table Dados a serem salvos
--- @return boolean success
--- @return string? error
function Data:save(name, data)
  if type(data) ~= "table" then
    return false, "Dados inválidos: esperava uma tabela"
  end

  local filename = self.save_path .. name .. ".json"

  -- Codifica os dados em JSON
  local encoded_data = json.encode(data)
  if not encoded_data then
    return false, "Erro ao codificar JSON"
  end

  -- Tenta salvar o arquivo
  local success, error = love.filesystem.write(filename, encoded_data)
  if not success then
    return false, "Erro ao salvar arquivo: " .. error
  end

  return true
end

--- Carrega dados de um arquivo JSON
--- @param name string Nome do arquivo (sem extensão)
--- @return table|nil data
--- @return string? error
function Data:load(name)
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

return Data
