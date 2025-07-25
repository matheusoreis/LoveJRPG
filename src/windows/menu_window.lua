local Window = require("src.windows.window")
local Text = require("src.windows.widgets.text")
local TextArea = require("src.windows.widgets.text_area")

--- @class WindowMenu : Window
local WindowMenu = Window:extend()

function WindowMenu:new(x, y, w, h, skin, resource, input)
  self.resource = resource
  self.input = input

  WindowMenu.super.new(self, x, y, w, h, skin)
end

function WindowMenu:on_load()
  local font = self.resource:get_font("default.ttf", 14)
  self.title = Text("Novo Jogo", 0, 0, font)

  self.text = TextArea(
    "Esse é um texto bem grande, porque estou testando o TextArea que deve quebrar a linha automaticamente.", 0, 30,
    self:get_content_size(), font)
end

function WindowMenu:on_update(dt)
end

function WindowMenu:on_draw_interface()
end

function WindowMenu:on_handle_input()
end

function WindowMenu:on_draw_content()
  self.title:draw()
  self.text:draw()
end

return WindowMenu
