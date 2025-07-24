--
-- Author: Matheus R. Oliveira
-- Github: matheusoreis
--

local Object = require('src.lib.classic')
local Config = require('src.config')

--- @class AudioManager : Object
--- @field private bgm table<string, love.Source>
--- @field private se table<string, love.Source>
--- @field private current_bgm table<string, love.Source>
--- @field private active_se table<string, love.Source[]>
--- @field private bgm_volume number
--- @field private se_volume number
local AudioManager = Object:extend()

function AudioManager:new()
  self.bgm = {}
  self.se = {}

  self.current_bgm = {}
  self.active_se = {}

  self.bgm_volume = 0.5
  self.se_volume = 0.5

  self:load()
end

--- @private
--- @param file string
function AudioManager:is_audio_file(file)
  for _, ext in ipairs(Config.audioFormats) do
    if file:match("%." .. ext .. "$") then
      return true
    end
  end
  return false
end

--- @private
function AudioManager:load()
  local folders = {
    bgm = function(name, path) self:load_bgm(name, path) end,
    se  = function(name, path) self:load_se(name, path) end,
  }

  for folder, load_func in pairs(folders) do
    local files = love.filesystem.getDirectoryItems("audio/" .. folder)
    for _, file in ipairs(files) do
      if self:is_audio_file(file) then
        local name = file:gsub("%.[^%.]+$", "")
        local path = "audio/" .. folder .. "/" .. file
        load_func(name, path)
      end
    end
  end
end

--- @private
--- @param name string
--- @param path string
function AudioManager:load_bgm(name, path)
  local source = love.audio.newSource(path, "stream")
  source:setLooping(true)
  source:setVolume(self.bgm_volume)
  self.bgm[name] = source
end

--- @private
--- @param name string
--- @param path string
function AudioManager:load_se(name, path)
  local source = love.audio.newSource(path, "static")
  source:setVolume(self.se_volume)
  self.se[name] = source
end

--- @param name string
function AudioManager:play_bgm(name)
  local bgm_source = self.bgm[name]
  if not bgm_source then return end

  if self.current_bgm[name] == bgm_source and bgm_source:isPlaying() then
    return
  end

  for playing_name, playing_source in pairs(self.current_bgm) do
    playing_source:stop()
    self.current_bgm[playing_name] = nil
  end

  self.current_bgm[name] = bgm_source
  bgm_source:play()
end

function AudioManager:stop_bgm()
  for playing_name, playing_source in pairs(self.current_bgm) do
    playing_source:stop()
    self.current_bgm[playing_name] = nil
  end
end

--- @param volume number
function AudioManager:set_bgm_volume(volume)
  self.bgm_volume = volume
  for _, source in pairs(self.bgm) do
    source:setVolume(volume)
  end
end

--- @param name string
function AudioManager:play_se(name)
  local base_source = self.se[name]
  if not base_source then return end

  local new_source = base_source:clone()
  new_source:setVolume(self.se_volume)
  new_source:play()

  self.active_se[name] = self.active_se[name] or {}
  table.insert(self.active_se[name], new_source)
end

function AudioManager:stop_all_se()
  for name, source_list in pairs(self.active_se) do
    for _, source in ipairs(source_list) do
      source:stop()
    end
    self.active_se[name] = nil
  end
end

--- @param volume number
function AudioManager:set_se_volume(volume)
  self.se_volume = volume
  for _, source in pairs(self.se) do
    source:setVolume(volume)
  end
end

--- @param dt number
function AudioManager:update(dt)
  for name, source_list in pairs(self.active_se) do
    for i = #source_list, 1, -1 do
      local source = source_list[i]
      if not source:isPlaying() then
        table.remove(source_list, i)
      end
    end

    if #source_list == 0 then
      self.active_se[name] = nil
    end
  end
end

return AudioManager
