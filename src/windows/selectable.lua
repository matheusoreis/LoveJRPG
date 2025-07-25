local Window = require("src.windows.window")

---@class SelectableWindow : Window
---@field x number
---@field y number
---@field w number
---@field h number
---@field skin love.Texture
---@field input InputManager
---@field audio AudioManager
---@field rows number?
---@field cols number?
local SelectableWindow = Window:extend()

function SelectableWindow:new(x, y, w, h, skin, input, audio, rows, cols)
  self.input = input
  self.audio = audio
  self.rows = rows or 1
  self.cols = cols or 1
  self.selected_index = 1
  self.widgets = {}

  self.scroll_page = 0

  SelectableWindow.super.new(self, x, y, w, h, skin)
end

function SelectableWindow:add_widget(widget)
  table.insert(self.widgets, widget)
end

function SelectableWindow:on_update(dt)
  if #self.widgets == 0 then return end

  local moved = false
  local old_index = self.selected_index

  if self.input:is_pressed("down") then
    self.selected_index = self.selected_index + self.cols
    self.audio:play_se("cursor")
    moved = true
  elseif self.input:is_pressed("up") then
    self.selected_index = self.selected_index - self.cols
    self.audio:play_se("cursor")
    moved = true
  elseif self.input:is_pressed("right") then
    self.selected_index = self.selected_index + 1
    self.audio:play_se("cursor")
    moved = true
  elseif self.input:is_pressed("left") then
    self.selected_index = self.selected_index - 1
    self.audio:play_se("cursor")
    moved = true
  end

  -- Limita dentro dos widgets
  self.selected_index = math.max(1, math.min(#self.widgets, self.selected_index))

  if moved and self.selected_index ~= old_index then
    local items_per_page = self.rows * self.cols
    local page_of_selection = math.floor((self.selected_index - 1) / items_per_page)

    -- Atualiza página ativa se mudou
    if page_of_selection ~= self.scroll_page then
      self.scroll_page = page_of_selection
    end
  end

  if self.input:is_pressed("a") then
    local current = self.widgets[self.selected_index]
    if current and current.on_select then
      self.audio:play_se("select")
      current:on_select()
    end
  end
end

function SelectableWindow:on_draw_content()
  local cw, ch = self:get_content_size()
  local item_w = cw / self.cols
  local item_h = ch / self.rows
  local items_per_page = self.rows * self.cols
  local start_index = self.scroll_page * items_per_page + 1
  local end_index = math.min(start_index + items_per_page - 1, #self.widgets)

  for i = start_index, end_index do
    local local_index = i - start_index
    local col = local_index % self.cols
    local row = math.floor(local_index / self.cols)

    love.graphics.push()
    love.graphics.translate(col * item_w, row * item_h)

    local widget = self.widgets[i]
    widget:setHighlighted(i == self.selected_index)
    widget:draw(item_w, item_h)

    love.graphics.pop()
  end
end

return SelectableWindow
