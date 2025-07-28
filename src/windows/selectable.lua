local WindowBase = require('src.windows.window')
local Text = require('src.widgets.text')
local Input = require('src.managers.input')
local Resource = require('src.managers.resource')
local NinePatchRect = require('src.shared.ninepatch')
local Audio = require('src.managers.audio')

--- @class WindowSelectable : WindowBase
local WindowSelectable = WindowBase:extend()

function WindowSelectable:new(x, y, w, h, items, columns, rows)
  WindowSelectable.super.new(self, x, y, w, h)

  self.items = items or {}
  self.index = 1
  self.columns = columns or 1
  self.rows = rows or 1

  self.scroll_page = 0

  self.default_font = Resource:get_font("default", 14)

  self.callbacks = {
    on_select = nil,
    on_action = nil,
  }
end

function WindowSelectable:on_load()
  self.hover_texture = Resource:get_system('hover')
  self.hover_rect = NinePatchRect({ top = 6, bottom = 6, left = 6, right = 6 }, self.hover_texture)

  self.a_texture = Resource:get_system('a')
end

function WindowSelectable:set_on_select(callback)
  self.callbacks.on_select = callback
  return self
end

function WindowSelectable:set_on_action(callback)
  self.callbacks.on_action = callback
  return self
end

function WindowSelectable:get_selected_item()
  return self.items[self.index]
end

function WindowSelectable:get_selected_index()
  return self.index
end

--- @param dt number
function WindowSelectable:on_update(dt)
  local previous_index = self.index

  if Input:is_action_pressed('down') then
    Audio:play_se('move')
    self.index = self.index + self.columns
  elseif Input:is_action_pressed('up') then
    Audio:play_se('move')
    self.index = self.index - self.columns
  elseif Input:is_action_pressed('right') then
    Audio:play_se('move')
    self.index = self.index + 1
  elseif Input:is_action_pressed('left') then
    Audio:play_se('move')
    self.index = self.index - 1
  end

  self.index = math.max(1, math.min(#self.items, self.index))

  local items_per_page = self.columns * self.rows
  local new_page = math.floor((self.index - 1) / items_per_page)
  if new_page ~= self.scroll_page then
    self.scroll_page = new_page
  end

  if self.index ~= previous_index then
    local selected_item = self.items[self.index]
    if self.callbacks.on_select and selected_item then
      self.callbacks.on_select(selected_item, self.index, self)
    end
  end

  if Input:is_action_pressed('a') then
    local current_item = self.items[self.index]
    if current_item then
      Audio:play_se('select')

      if self.callbacks.on_action then
        self.callbacks.on_action(current_item, self.index, self)
      end
    end
  end
end

function WindowSelectable:on_draw()
  local content_width, content_height = self:get_content_size()
  local item_width = content_width / self.columns
  local item_height = content_height / self.rows
  local items_per_page = self.columns * self.rows
  local start_item_index = self.scroll_page * items_per_page + 1
  local end_item_index = math.min(start_item_index + items_per_page - 1, #self.items)

  for item_index = start_item_index, end_item_index do
    local local_index = item_index - start_item_index
    local column_index = local_index % self.columns
    local row_index = math.floor(local_index / self.columns)

    local item_pos_x = column_index * item_width
    local item_pos_y = row_index * item_height

    if item_index == self.index then
      self.hover_rect:draw(item_pos_x, item_pos_y, item_width, item_height)
      if self.a_texture then
        local icon_w, icon_h = self.a_texture:getWidth(), self.a_texture:getHeight()
        local padding = 4

        local icon_x = item_pos_x + item_width - icon_w - padding
        local icon_y = item_pos_y + item_height - icon_h - padding

        love.graphics.draw(self.a_texture, icon_x, icon_y)
      end
    end

    local item_name = self.items[item_index].name or tostring(self.items[item_index])
    local text_object = Text(item_name, 0, 0, self.default_font)

    local text_pos_x = item_pos_x + (item_width - text_object:get_width()) / 2
    local text_pos_y = item_pos_y + (item_height - text_object:get_height()) / 2

    text_object.x = text_pos_x
    text_object.y = text_pos_y
    text_object:draw()
  end
end

return WindowSelectable
