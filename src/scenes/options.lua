local SceneBase = require('src.scenes.scene')

---@class OptionsScene : SceneBase
local OptionsScene = SceneBase:extend()

function OptionsScene:on_load()
  print('Carregando a OptionsScene...')

  self.background = self.resource:get_title('background')
end

function OptionsScene:on_enter()
  print('Entrando na OptionsScene...')
end

function OptionsScene:on_update(dt)
end

function OptionsScene:on_draw(width, height)
  love.graphics.setShader()
  love.graphics.setColor(1, 1, 1)
  for y = 0, math.ceil(height / 32) - 1 do
    for x = 0, math.ceil(width / 32) - 1 do
      love.graphics.draw(self.background, x * 32, y * 32)
    end
  end
end

function OptionsScene:on_exit()

end

return OptionsScene
