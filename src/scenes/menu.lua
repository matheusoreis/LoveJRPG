--
-- Author: Matheus R. Oliveira
-- Github: matheusoreis
--

local SceneBase = require('src.game.scene')
local WindowMenu = require("src.windows.menu_window")

--- @class MenuState : SceneBase
local MenuScene = SceneBase:extend()

function MenuScene:initialize()
  self.background = self.resource:get_title("background.png")

  local w, h = 200, 3 * 20 + 16
  local x = (love.graphics.getWidth() - w) / 2
  local y = (love.graphics.getHeight() - h) / 2
  self.menu_window = WindowMenu(x, y, w, h, self.resource, self.data, nil)
end

function MenuScene:on_enter()
end

function MenuScene:on_exit()
end

function MenuScene:on_update(dt)
  self.menu_window:update(dt)

  -- Input controlado pela scene
  if self:is_pressed("y") then
    self.menu_window:open(0.2)
  elseif self:is_pressed("x") then
    self.menu_window:close(0.2)
  end

  if not self.menu_window:isOpen() then return end

  if self:is_pressed("up") then
    self.menu_window:move_up()
  elseif self:is_pressed("down") then
    self.menu_window:move_down()
  elseif self:is_pressed("a") then
    local selected = self.menu_window:confirm()
    print("Selecionado: " .. selected)
  end
end

function MenuScene:on_draw(width, height)
  love.graphics.setShader()
  love.graphics.setColor(1, 1, 1)
  for y = 0, math.ceil(height / 32) - 1 do
    for x = 0, math.ceil(width / 32) - 1 do
      love.graphics.draw(self.background, x * 32, y * 32)
    end
  end

  self.menu_window:draw()
end

return MenuScene
