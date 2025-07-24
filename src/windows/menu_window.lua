local Window = require("src.game.window")

--- @class WindowMenu : Window
local WindowMenu = Window:extend()

function WindowMenu:new(x, y, w, h, resource, data)
  WindowMenu.super.new(self, x, y, w, h, resource, data)

  self.options = {}
  for i = 1, 20 do -- Adiciona 20 opções para testar rolagem
    table.insert(self.options, "Opção " .. i)
  end

  self.selected = 1
end

function WindowMenu:update(dt)
  WindowMenu.super.update(self, dt)

  local lineH = self:getLineH()
  local totalH = #self.options * lineH
  local visibleH = self:getContentH()
  local targetY = (self.selected - 1) * lineH

  if targetY < self.oy then
    self.oy = targetY
  elseif targetY + lineH > self.oy + visibleH then
    self.oy = targetY + lineH - visibleH
  end

  -- Limita scroll para não passar do fim
  self.oy = math.max(0, math.min(self.oy, totalH - visibleH))
end

-- Métodos públicos para controle externo
function WindowMenu:move_up()
  self.selected = self.selected - 1
  if self.selected < 1 then
    self.selected = #self.options
  end
end

function WindowMenu:move_down()
  self.selected = self.selected + 1
  if self.selected > #self.options then
    self.selected = 1
  end
end

function WindowMenu:confirm()
  return self.options[self.selected]
end

function WindowMenu:get_selected()
  return self.selected
end

function WindowMenu:set_selected(index)
  if index >= 1 and index <= #self.options then
    self.selected = index
  end
end

function WindowMenu:drawContent()
  local paddingY = 4
  for i, option in ipairs(self.options) do
    local y = paddingY + (i - 1) * self:getLineH()
    local prefix = (i == self.selected) and "> " or "  "
    self:drawText(prefix .. option, 0, y, self:getContentW(), self:getLineH())
  end
end

return WindowMenu
