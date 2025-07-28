local WindowSelectable = require('src.windows.selectable')
local Text = require('src.widgets.text')
local Resource = require('src.managers.resource')

--- @class OptionsWindow : WindowSelectable
local OptionsWindow = WindowSelectable:extend()

function OptionsWindow:new(x, y, w, h, scene)
  local items = {
    { name = "Resolução", action = "resolution" },
    { name = "Música",    action = "music" },
    { name = "Som",       action = "sound" },
  }

  OptionsWindow.super.new(self, x, y, w, h, scene, items, 1, 4)
end

return OptionsWindow
