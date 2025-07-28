local WindowBase = require('src.windows.window')
local Text = require('src.widgets.text')
local Resource = require('src.managers.resource')

--- @class WelcomeWindow : WindowBase
local WelcomeWindow = WindowBase:extend()

function WelcomeWindow:on_load()
  local font = Resource:get_font("default", 14)
  self.message = Text('Bem-vindo ao NetMaker!', 0, 0, font)
end

function WelcomeWindow:on_draw()
  self.message:draw()
end

return WelcomeWindow
