local Object = require('src.shared.object')
local Text = require('src.windows.widgets.text')

local TextArea = Text:extend()

function TextArea:new(text, x, y, width, font, color)
  self.width = width or 200
  TextArea.super.new(self, "", x, y, font, color)
  self:setText(text)
end

function TextArea:wrap_text(text, font, maxWidth)
  local spaceWidth = font:getWidth(" ")
  local lines = {}
  local line = ""
  local lineWidth = 0

  for word in text:gmatch("%S+") do
    local wordWidth = font:getWidth(word)
    if lineWidth + wordWidth <= maxWidth then
      if line ~= "" then
        line = line .. " " .. word
        lineWidth = lineWidth + spaceWidth + wordWidth
      else
        line = word
        lineWidth = wordWidth
      end
    else
      table.insert(lines, line)
      line = word
      lineWidth = wordWidth
    end
  end
  table.insert(lines, line)
  return table.concat(lines, "\n")
end

function TextArea:setText(newText)
  local wrappedText = self:wrap_text(newText, self.font, self.width)
  self.text = wrappedText
  self.textObject:set(self.text)
end

function TextArea:draw()
  love.graphics.setColor(self.color)
  love.graphics.draw(self.textObject, self.x, self.y)
  love.graphics.setColor(1, 1, 1, 1)
end

return TextArea
