local Window = require("src.windows.base.window")

--- @class WindowMenu : Window
local WindowMenu = Window:extend()

function WindowMenu:on_load()
  self.text = "Bem-vindo ao menu!"
end

function WindowMenu:on_update(dt)
end

function WindowMenu:on_draw_interface()
end

function WindowMenu:on_handle_input()
end

function WindowMenu:on_draw_content()
  love.graphics.setColor(1, 1, 1, 1)

  for i = 1, 10 do
    local y = 10
    love.graphics.print(self.text, 0, i * y)
  end
end

return WindowMenu
