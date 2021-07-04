--- A text display frame. With text wrapping at X, and doesn't restart at X=1.
-- @module[kind=component] text

local textApi = {}

--- Create a text box.
-- @tparam number text Text to display in the box.
-- @tparam number iX The starting X position of the text frame.
-- @tparam number iY The starting Y position of the text frame.
-- @tparam number eX The ending X of the text frame.
-- @tparam number eY The ending Y of the text frame.
-- @tparam table term The terminal the text will be written to.
function textApi.create(text, iX, iY, eX, eY, term)
  term.setCursorPos(iX, iY)
  local x, y = iX, iY
  local w, h = eX, eY

  local nLinesPrinted = 0
  local function newLine()
    if y + 1 <= h then
      term.setCursorPos(iX, y + 1)
    end
    x, y = term.getCursorPos()
    nLinesPrinted = nLinesPrinted + 1
  end

  -- Print the line with proper word wrapping
  local sText = tostring(text)
  while #sText > 0 do
    local whitespace = string.match(sText, "^[ \t]+")
    if whitespace then
      -- Print whitespace
      term.write(whitespace)
      x, y = term.getCursorPos()
      sText = string.sub(sText, #whitespace + 1)
    end

    local newline = string.match(sText, "^\n")
    if newline then
      -- Print newlines
      newLine()
      sText = string.sub(sText, 2)
    end

    local text = string.match(sText, "^[^ \t\n]+")
    if text then
      sText = string.sub(sText, #text + 1)
      if #text > w then
        -- Print a multiline word
        while #text > 0 do
          if x > w then
            newLine()
          end
          term.write(text)
          text = string.sub(text, w - x + 2)
          x, y = term.getCursorPos()
        end
      else
        -- Print a word normally
        if x + #text - 1 > w then
          newLine()
        end
        term.write(text)
        x, y = term.getCursorPos()
      end
    end
  end
end

return textApi