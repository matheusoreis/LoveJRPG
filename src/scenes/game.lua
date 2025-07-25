--
-- Author: Matheus R. Oliveira
-- Github: matheusoreis
--

local SceneBase = require('src.game.scene')
local WindowStartMenu = require("src.windows.start_menu")

--- @class GameScene : SceneBase
local GameScene = SceneBase:extend()

function GameScene:on_load()
  self.background = self.resource:get_title("background.png")

  local w, h = 300, 3 * 20 + 100
  local x = (love.graphics.getWidth() - w) / 2
  local y = (love.graphics.getHeight() - h) / 2

  self.window_selectable = WindowStartMenu(x, y, w, h, self.resource:get_system("skin.png"), self.resource, self.input,
    self.audio)
  self.window_selectable:open(0)
end

function GameScene:on_enter()
end

function GameScene:on_exit()
end

function GameScene:on_update(dt)
  self.window_selectable:update(dt)
end

function GameScene:on_draw(width, height)
  -- Fundo em tiles
  love.graphics.setShader()
  love.graphics.setColor(1, 1, 1)
  for y = 0, math.ceil(height / 32) - 1 do
    for x = 0, math.ceil(width / 32) - 1 do
      love.graphics.draw(self.background, x * 32, y * 32)
    end
  end

  self.window_selectable:draw()
end

return GameScene
