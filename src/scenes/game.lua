local SceneBase = require('src.scenes.scene')

---@class GameScene : SceneBase
local GameScene = SceneBase:extend()

function GameScene:on_load()
  print('Carregando a GameScene...')

  self.background = self.resource:get_title('background')
end

function GameScene:on_enter()
  print('Entrando na GameScene...')
end

function GameScene:on_update(dt)
end

function GameScene:on_draw(width, height)
  love.graphics.setShader()
  love.graphics.setColor(1, 1, 1)
  for y = 0, math.ceil(height / 32) - 1 do
    for x = 0, math.ceil(width / 32) - 1 do
      love.graphics.draw(self.background, x * 32, y * 32)
    end
  end
end

function GameScene:on_exit()

end

return GameScene
