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

  for _, value in ipairs(t) do
    table.insert(mapped, f(value))
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

    if not left then
      table.insert(lines, text:sub(pos))
      break
    end

    table.insert(lines, text:sub(pos, left - 1))
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
  -- blank
  if line == '' then
    return {type = 'blank'}
  end

  -- headers
  local h_level, h_text = line:match('^(#+)[ \t]*(.-)[ \t]*#*[ \t]*$')
  if h_level and 1 <= h_level:len() and h_level:len() <= 6 and h_text then
    return {
      type = 'header',
      level = h_level:len(),
      text = h_text
    }
  end

  -- line breaks
  local br_text = line:match('^.*  $')
  if br_text then
    return {
      type = 'linebreak',
      text = br_text
    }
  end

  -- regular lines
  return {
    type = 'regular',
    text = line
  }
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
    header = '<h%u>%s</h%u>',
    linebreak = '%s<br />',
    paragraph_start = '<p>%s',
    paragraph_end = '%s</p>'
  }

  -- paragraph tag helper
  local function paragraph_line(index, line)
    local paragraphs = { linebreak = 1, regular = 1 }

    if not lines[index-1] or not (paragraphs)[lines[index-1].type] then
      line = formats.paragraph_start:format(line)
    end

    if lines[index].type == 'linebreak' and
       lines[index+1] and (paragraphs)[lines[index+1].type] then
      line = formats.linebreak:format(line)
    elseif not lines[index+1] or not (paragraphs)[lines[index+1].type] then
      line = formats.paragraph_end:format(line)
    end

    return line
  end

  -- convert lines to html
  local previous = 0

  for index, line in ipairs(lines) do
    -- header
    if line.type == 'header' then
      table.insert(
        htmlized,
        formats.header:format(line.level, line.text, line.level)
      )
    end

    -- paragraphs and linebreaks
    if line.type == 'regular' or line.type == 'linebreak' then
      table.insert(
        htmlized,
        paragraph_line(index, line.text)
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
  if not text or not text:len() then
    return text
  end

  text = sanitize(text)
  text = convert(text)

  return text
end