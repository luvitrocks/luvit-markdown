local table = require 'table'

-- forward declaration of methods
local classify, convert, htmlize, map, sanitize, split

-----------------------------------------------------------------------------
-- Maps each entry of a table "t{i=v}" to a local function "f(v)".
--
-- @param   t
-- @param   f
-- @return  table
-----------------------------------------------------------------------------
function map(t, f)
  local mapped = {}

  for index, value in pairs(t) do
    mapped[index] = f(value)
  end

  return mapped
end

-----------------------------------------------------------------------------
-- Sanitizes text before conversion.
--
-- @param   text
-- @return  text
-----------------------------------------------------------------------------
function sanitize(text)
  text = text:gsub('\r\n', '\n')
  text = text:gsub('\r', '\n')

  return text
end

-----------------------------------------------------------------------------
-- Splits text to table of lines.
--
-- @param   text
-- @return  lines
-----------------------------------------------------------------------------
function split(text)
  local lines = {}
  local pos = 1

  while true do
    local left, right = text:find('\n', pos)

    if not start then
      table.insert(lines, text:sub(pos))
      break
    end

    table.insert(lines, text:sub(pos, start - 1))
    pos = right + 1
  end

  return lines
end


-----------------------------------------------------------------------------
-- Converts text from Markdown to HTML.
--
-- @param   text
-- @return  text
-----------------------------------------------------------------------------
function convert(text)
  local lines = split(text)

  lines = map(lines, classify)
  lines = htmlize(lines)

  return table.concat(lines, '\n')
end

-----------------------------------------------------------------------------
-- Classifies a line to a Markdown type.
--
-- @param   line
-- @return  line
-----------------------------------------------------------------------------
function classify(line)
  -- headers
  local h_level, h_text = line:match('^(#+)[ \t]*(.-)[ \t]*#*[ \t]*$')
  if 1 <= h_level:len() and h_level:len() <= 6 and h_text then
    return {
      type = 'header',
      level = h_level:len(),
      text = h_text
    }
  end
end

-----------------------------------------------------------------------------
-- Converts table of Markdown lines to table of HTML lines.
--
-- @param   lines
-- @return  lines
-----------------------------------------------------------------------------
function htmlize(lines)
  local htmlized = {}
  local formats = {
    header = '<h%u>%s</h%u>'
  }

  for _, line in ipairs(lines) do
    if line.type == 'header' then
      table.insert(
        htmlized,
        formats.header:format(line.level, line.text, line.level)
      )
    end
  end

  return htmlized
end

-----------------------------------------------------------------------------
-- Converts Markdown to HTML.
--
-- @param   text
-- @return  text
-----------------------------------------------------------------------------
return function(text)
  if not text:len() then
    return text
  end

  text = sanitize(text)
  text = convert(text)

  return text
end