local WindowBase = require('src.windows.window')

--- @class WelcomeWindow : WindowBase
local WelcomeWindow = WindowBase:extend()

function WelcomeWindow:on_draw()
  love.graphics.print("ahjsgdhjasgdjghasd")
end

return WelcomeWindow
