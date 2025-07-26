local Object = require('src.shared.object')

---@class AudioManager : Object
local AudioManager = Object:extend()

function AudioManager:new()
  self.bgm = {}
  self.se = {}

  self.current_bgm = nil
  self.active_se = {}

  self.bgm_volume = 1
  self.se_volume = 1
end

---@type AudioManager
local audio_manager = AudioManager()

--- Verifica se o arquivo é um formato de áudio suportado.
---@param file string
---@return boolean
function AudioManager:is_audio_file(file)
  local audio_formats = { "ogg", "wav", "mp3" }
  for _, ext in ipairs(audio_formats) do
    if file:match("%." .. ext .. "$") then
      return true
    end
  end
  return false
end

---Carrega todos os arquivos de áudio.
function AudioManager:load()
  local folders = { 'bgm', 'se' }

  for _, folder in ipairs(folders) do
    local path = "audio/" .. folder
    local files = love.filesystem.getDirectoryItems(path)

    for _, file in ipairs(files) do
      if self:is_audio_file(file) then
        local name = file:gsub("%.[^%.]+$", "")
        local full_path = path .. "/" .. file

        if folder == "bgm" then
          self:load_bgm(name, full_path)
        elseif folder == "se" then
          self:load_se(name, full_path)
        end
      end
    end
  end
end

--- Carrega uma BGM para uso posterior.
---@param name string
---@param path string
function AudioManager:load_bgm(name, path)
  if not self.bgm[name] and self:is_audio_file(path) and love.filesystem.getInfo(path) then
    local source = love.audio.newSource(path, "stream")
    source:setLooping(true)
    source:setVolume(self.bgm_volume)
    self.bgm[name] = source
  end
end

--- Toca a BGM especificada, parando a anterior.
---@param name string
function AudioManager:play_bgm(name)
  local bgm = self.bgm[name]
  if bgm then
    if self.current_bgm and self.current_bgm:isPlaying() then
      self.current_bgm:stop()
    end
    self.current_bgm = bgm
    self.current_bgm:play()
  end
end

--- Para a BGM atual.
function AudioManager:stop_bgm()
  if self.current_bgm and self.current_bgm:isPlaying() then
    self.current_bgm:stop()
  end
  self.current_bgm = nil
end

--- Define o volume da BGM.
---@param volume number
function AudioManager:set_bgm_volume(volume)
  self.bgm_volume = volume
  if self.current_bgm then
    self.current_bgm:setVolume(volume)
  end
end

--- Carrega um efeito sonoro para uso posterior.
---@param name string
---@param path string
function AudioManager:load_se(name, path)
  if not self.se[name] and self:is_audio_file(path) and love.filesystem.getInfo(path) then
    local source = love.audio.newSource(path, "static")
    source:setVolume(self.se_volume)
    self.se[name] = source
  end
end

--- Toca um efeito sonoro.
---@param name string
function AudioManager:play_se(name)
  local template = self.se[name]
  if template then
    local instance = template:clone()
    instance:setVolume(self.se_volume)
    instance:play()
    table.insert(self.active_se, instance)
  end
end

--- Para todos os efeitos sonoros em execução.
function AudioManager:stop_se()
  for _, se in ipairs(self.active_se) do
    if se:isPlaying() then
      se:stop()
    end
  end
  self.active_se = {}
end

--- Define o volume dos efeitos sonoros.
---@param volume number
function AudioManager:set_se_volume(volume)
  self.se_volume = volume
  for _, se in ipairs(self.active_se) do
    se:setVolume(volume)
  end
end

return audio_manager
