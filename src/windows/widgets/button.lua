local Object = require('src.lib.classic')
local Text = require('src.windows.widgets.text')

local Button = Object:extend()

function Button:new(label, font, callback)
  self.font = font
  self.text = Text(label, 0, 0, self.font, { 1, 1, 1, 1 })
  self.callback = callback or function() end

  self.isHighlighted = false
end

function Button:setHighlighted(highlighted)
  self.isHighlighted = highlighted
end

function Button:draw(w, h)
  if self.isHighlighted then
    love.graphics.setColor(0.8, 0.8, 0.8, 0.5)
  else
    love.graphics.setColor(0.2, 0.2, 0.2, 1)
  end

  love.graphics.rectangle("fill", 0, 0, w, h)

  local textWidth = self.text:getWidth()
  local textHeight = self.text:getHeight()

  self.text.x = (w - textWidth) / 2
  self.text.y = (h - textHeight) / 2

  love.graphics.setColor(1, 1, 1, 1)
  self.text:draw()
end

function Button:on_select()
  self.callback()
end

return Button
