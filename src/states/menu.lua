local State = require("src.game.scene")
local WindowMenu = require("src.windows.menu_window")

--- @class MenuState : SceneBase
local MenuState = State:extend()

function MenuState:new(resource, input, data, transition)
  MenuState.super.new(self, resource, input, data, transition)

  self.background = resource:get_title("background.png")

  local w, h = 200, 3 * 20 + 16
  local x = (love.graphics.getWidth() - w) / 2
  local y = (love.graphics.getHeight() - h) / 2
  self.menu_window = WindowMenu(x, y, w, h, resource, input, data, nil)
end

function MenuState:update()
  MenuState.super.update(self)
  self.menu_window:update()
end

function MenuState:draw(width, height)
  MenuState.super.draw(self, width, height)

  love.graphics.setShader()
  love.graphics.setColor(1, 1, 1)
  for y = 0, math.ceil(height / 32) - 1 do
    for x = 0, math.ceil(width / 32) - 1 do
      love.graphics.draw(self.background, x * 32, y * 32)
    end
  end

  self.menu_window:draw()
end

return MenuState
