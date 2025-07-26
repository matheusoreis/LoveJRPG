local Object = require('src.shared.object')
local Json = require('src.shared.json')

---@class DataManager : Object
---@field data table Tabela dos dados carregados
---@field private path string Caminho padrão dos dados
local DataManager = Object:extend()

function DataManager:new()
  self.data = {}

  self.path = 'data/'
  if not love.filesystem.getInfo(self.path) then
    return
  end
end

local data_manager = DataManager()

--- Carrega os dados do jogo do arquivo informado.
---@param name string Nome do arquivo
---@return table|nil Dados carregados ou nil em caso de erro
function DataManager:load(name)
  local filename = self.path .. name .. '.json'

  if not love.filesystem.getInfo(filename) then
    print('Arquivo não encontrado: ' .. filename)
    return nil
  end

  local content = love.filesystem.read(filename)
  if not content then
    print('Erro ao ler arquivo.')
    return nil
  end

  local decoded = Json.decode(content)
  if not decoded then
    print('Erro ao decodificar o JSON.')
    return nil
  end

  self.data[name] = decoded
  return decoded
end

return data_manager
