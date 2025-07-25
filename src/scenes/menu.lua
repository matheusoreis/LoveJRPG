--
-- Author: Matheus R. Oliveira
-- Github: matheusoreis
--

local SceneBase = require('src.game.scene')
local WindowMenu = require("src.windows.menu_window")

--- @class MenuScene : SceneBase
local MenuScene = SceneBase:extend()

function MenuScene:on_load()
  self.background = self.resource:get_title("background.png")

  local w, h = 200, 3 * 20 + 16
  local x = (love.graphics.getWidth() - w) / 2
  local y = (love.graphics.getHeight() - h) / 2

  self.window = WindowMenu(x, y, w, h, self.resource, self.input)
  self.window:open(0) -- Abre imediatamente
end

function MenuScene:on_enter()
end

function MenuScene:on_exit()
end

function MenuScene:on_update(dt)
  self.window:update(dt)

  if self:is_pressed("y") then
    self.window:open(0.2)
  elseif self:is_pressed("x") then
    self.window:close(0.2)
  end
end

function MenuScene:on_draw(width, height)
  -- Fundo em tiles
  love.graphics.setShader()
  love.graphics.setColor(1, 1, 1)
  for y = 0, math.ceil(height / 32) - 1 do
    for x = 0, math.ceil(width / 32) - 1 do
      love.graphics.draw(self.background, x * 32, y * 32)
    end
  end

  -- Janela de menu
  self.window:draw()
end

return MenuScene
