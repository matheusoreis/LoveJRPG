local SceneBase = require('src.scenes.scene')

---@class ActorsScene : SceneBase
local ActorsScene = SceneBase:extend()

function ActorsScene:on_load()
  print('Carregando a ActorsScene...')

  self.background = self.resource:get_title('background')
end

function ActorsScene:on_enter()
  print('Entrando na ActorsScene...')
end

function ActorsScene:on_update(dt)
end

function ActorsScene:on_draw(width, height)
  love.graphics.setShader()
  love.graphics.setColor(1, 1, 1)
  for y = 0, math.ceil(height / 32) - 1 do
    for x = 0, math.ceil(width / 32) - 1 do
      love.graphics.draw(self.background, x * 32, y * 32)
    end
  end
end

function ActorsScene:on_exit()

end

return ActorsScene
