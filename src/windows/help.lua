local WindowBase = require('src.windows.window')
local Text = require('src.widgets.text')
local Resource = require('src.managers.resource')

--- @class WindowHelp : WindowBase
local WindowHelp = WindowBase:extend()

function WindowHelp:on_load()
  local font = Resource:get_font("default", 12)
  self.message = Text('', 0, 0, font)
end

function WindowHelp:set_text(new_text)
  print(new_text)
  self.message:set_text(new_text)

  self:update_text_position()
end

function WindowHelp:update_text_position()
  local content_width, content_height = self:get_content_size()

  local text_x = (content_width - self.message:get_width()) / 2
  local text_y = (content_height - self.message:get_height()) / 2

  self.message.x = text_x
  self.message.y = text_y
end

function WindowHelp:on_draw()
  self.message:draw()
end

return WindowHelp
