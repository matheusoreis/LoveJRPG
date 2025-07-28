local Object = require('src.shared.object')

local Text = Object:extend()

function Text:new(text, x, y, font, color)
  self.text = text
  self.x = x
  self.y = y
  self.font = font or love.graphics.getFont()
  self.color = color or { 1, 1, 1, 1 }

  self.textObject = love.graphics.newText(self.font, self.text)
end

function Text:setText(newText)
  self.text = newText
  self.textObject:set(self.text)
end

function Text:getWidth()
  return self.textObject:getWidth()
end

function Text:getHeight()
  return self.textObject:getHeight()
end

function Text:draw()
  love.graphics.setColor(self.color)
  love.graphics.draw(self.textObject, self.x, self.y)
  love.graphics.setColor(1, 1, 1, 1)
end

return Text
