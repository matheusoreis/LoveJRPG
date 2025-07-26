local WindowBase = require('src.windows.window')

--- @class TitleWindow : WindowBase
local TitleWindow = WindowBase:extend()

function TitleWindow:on_load()
end

function TitleWindow:on_update(dt)
end

function TitleWindow:on_draw()
  love.graphics.print("É! A janela foi finalizada e o conteúdo está sendo desenhado dentro dela.")
end

return TitleWindow
