local SelectableWindow = require("src.windows.selectable")
local Button = require("src.windows.widgets.button")

--- @class WindowStartMenu : SelectableWindow
local WindowStartMenu = SelectableWindow:extend()

function WindowStartMenu:new(x, y, w, h, skin, resource, input, audio)
  self.resource = resource
  WindowStartMenu.super.new(self, x, y, w, h, skin, input, audio, 3, 10)
end

function WindowStartMenu:on_load()
  local font = self.resource:get_font("default.ttf", 14)

  local ltters = {
    { "q", "w", "e", "r", "t", "y", "u", "i", "o", "p" },
    { "a", "s", "d", "f", "g", "h", "j", "k", "l", "ç" },
    { "z", "x", "c", "v", "b", "n", "m", "ã", "é", "á" },
  }

  for _, row in ipairs(ltters) do
    for _, letter in ipairs(row) do
      self:add_widget(Button(letter, font, function()
        print(letter)
      end))
    end
  end
end

return WindowStartMenu
