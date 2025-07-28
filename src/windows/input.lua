local WindowSelectable = require('src.windows.selectable')
local Text = require('src.widgets.text')
local Resource = require('src.managers.resource')

--- @class WindowInput : WindowSelectable
local WindowInput = WindowSelectable:extend()

function WindowInput:new(x, y, w, h, max_length, input_type, custom_chars)
  self.input_type = input_type or "full"
  self.custom_chars = custom_chars or {}

  local input_items = self:create_input_items()

  local columns = self:calculate_columns()
  local rows = math.ceil(#input_items / columns)

  WindowInput.super.new(self, x, y, w, h, input_items, columns, rows)

  self.current_text = ""
  self.max_length = max_length or 50

  self.letter_font = Resource:get_font("default", 14)
end

function WindowInput:calculate_columns()
  -- Lógica para calcular colunas baseado no tipo de input
  if self.input_type == "numeric" then
    return 3  -- 0-9 + DEL + OK = 12 items, 4x3 grid
  elseif self.input_type == "name" then
    return 8  -- Mais compacto para nomes
  elseif self.input_type == "chat" then
    return 10 -- Grid maior para chat
  else
    return 10 -- Padrão
  end
end

function WindowInput:create_input_items()
  local items = {}

  if self.input_type == "numeric" then
    -- Apenas números 0-9
    for i = 48, 57 do
      table.insert(items, {
        name = string.char(i),
        action = "char",
        value = string.char(i)
      })
    end
  elseif self.input_type == "name" then
    -- Letras maiúsculas A-Z
    for i = 65, 90 do
      table.insert(items, {
        name = string.char(i),
        action = "char",
        value = string.char(i)
      })
    end
    -- Letras minúsculas a-z
    for i = 97, 122 do
      table.insert(items, {
        name = string.char(i),
        action = "char",
        value = string.char(i)
      })
    end
  elseif self.input_type == "alphanumeric" then
    -- A-Z
    for i = 65, 90 do
      table.insert(items, {
        name = string.char(i),
        action = "char",
        value = string.char(i)
      })
    end
    -- a-z
    for i = 97, 122 do
      table.insert(items, {
        name = string.char(i),
        action = "char",
        value = string.char(i)
      })
    end
    -- 0-9
    for i = 48, 57 do
      table.insert(items, {
        name = string.char(i),
        action = "char",
        value = string.char(i)
      })
    end
  elseif self.input_type == "chat" then
    -- A-Z
    for i = 65, 90 do
      table.insert(items, {
        name = string.char(i),
        action = "char",
        value = string.char(i)
      })
    end
    -- a-z
    for i = 97, 122 do
      table.insert(items, {
        name = string.char(i),
        action = "char",
        value = string.char(i)
      })
    end
    -- 0-9
    for i = 48, 57 do
      table.insert(items, {
        name = string.char(i),
        action = "char",
        value = string.char(i)
      })
    end
    -- Pontuação para chat
    local punctuation = { ".", ",", "!", "?", ":", ";", "-", "'", '"' }
    for _, char in ipairs(punctuation) do
      table.insert(items, {
        name = char,
        action = "char",
        value = char
      })
    end
  else -- "full"
    -- Tudo: A-Z, a-z, 0-9
    for i = 65, 90 do
      table.insert(items, {
        name = string.char(i),
        action = "char",
        value = string.char(i)
      })
    end
    for i = 97, 122 do
      table.insert(items, {
        name = string.char(i),
        action = "char",
        value = string.char(i)
      })
    end
    for i = 48, 57 do
      table.insert(items, {
        name = string.char(i),
        action = "char",
        value = string.char(i)
      })
    end
  end

  -- Adicionar caracteres customizados se fornecidos
  for _, char in ipairs(self.custom_chars) do
    table.insert(items, {
      name = char,
      action = "char",
      value = char
    })
  end

  -- Comandos especiais (sempre presentes)
  if self.input_type ~= "numeric" then
    table.insert(items, {
      name = "ESP",
      action = "space",
      value = " "
    })
  end

  table.insert(items, {
    name = "DEL",
    action = "delete",
    value = ""
  })

  table.insert(items, {
    name = "OK",
    action = "confirm",
    value = ""
  })

  return items
end

-- Métodos de manipulação de texto
function WindowInput:get_current_text()
  return self.current_text
end

function WindowInput:set_current_text(text)
  self.current_text = text or ""
end

function WindowInput:add_char(char)
  if #self.current_text < self.max_length then
    self.current_text = self.current_text .. char
    return true
  else
    return false
  end
end

function WindowInput:delete_char()
  if #self.current_text > 0 then
    self.current_text = string.sub(self.current_text, 1, -2)
    return true
  end
  return false
end

function WindowInput:clear_text()
  self.current_text = ""
  return true
end

-- Métodos de validação
function WindowInput:is_valid()
  return #self.current_text > 0
end

function WindowInput:get_char_count()
  return #self.current_text
end

function WindowInput:get_remaining_chars()
  return self.max_length - #self.current_text
end

return WindowInput
