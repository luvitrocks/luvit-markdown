local table = require 'table'

-- forward declaration of methods
local anchorize, classify, convert, emphasize, htmlize, map, sanitize, split

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
  if not text or not text:len() then
    return text
  end

  text = text:gsub('\r\n', '\n')
  text = text:gsub('\r', '\n')

  return text
end

-----------------------------------------------------------------------------
-- Converts link references to inline links.
--
-- @param   text
-- @return  text
-----------------------------------------------------------------------------
function anchorize(text)
  local references = {}
  local linkdef = ' ? ? ?(%b[]):[ \t]*([^%s]+)[ \t\n]'
  local patterns = {
    linkdef .. '[ \t]*["]([^\n]+)["][ \t]*',
    linkdef .. '[ \t]*[\']([^\n]+)[\'][ \t]*',
    linkdef .. '[ \t]*[(]([^\n]+)[)][ \t]*',
    linkdef
  }

  -- reference indexer
  local function get_references(id, url, title)
    id = id:match('%[(.+)%]'):lower()

    references[id] = {
      url = url,
      title = title
    }

    return ''
  end

  -- reference converter
  local function set_references(id)
    if '[]' == id then
      return '[]'
    end

    id = id:match('%[(.+)%]'):lower()

    if not references[id] then
      return '[' .. id .. ']'
    end

    if not references[id].title then
      return ('[%s](%s)'):format(id, references[id].url)
    end

    return ('[%s](%s "%s")'):format(id, references[id].url, references[id].title)
  end

  -- inline converter
  local function set_inlines(text, def)
    text = text:match('%[(.+)%]'):lower()
    local patterns = {
      '%((.-)[ \t]*"(.-)"%)',
      '%((.-)[ \t]*\'(.-)\'%)',
      '%((.-)%)',
    }

    for _, pattern in ipairs(patterns) do
      local url, title = def:match(pattern)

      if url and title then
        return ('<a href="%s" title="%s">%s</a>'):format(url, title, text)
      end

      if url then
        return ('<a href="%s">%s</a>'):format(url, text)
      end
    end

    return ''
  end

  -- parse references
  for _,pattern in ipairs(patterns) do
    text = text:gsub(pattern, get_references)
  end

  text = text:gsub('(%b[])[^(\n]?', set_references)

  -- parse anchors
  return text:gsub('(%b[])(%b())', set_inlines)
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
  lines = map(lines, emphasize)

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
  -- rule detection helper
  local function is_rule(line)
    for _,c in ipairs({'*', '-', '_'}) do
      if line:match('^ ? ? ?%' .. c .. '[ \t%' .. c .. ']') and
         line:gsub('[^ \t%' .. c .. ']', ''):len() == line:len() then
        return true
      end
    end

    return false
  end

  -- blank
  if line == '' then
    return {type = 'blank'}
  end

  -- rules
  if line:match('^[%=]+$') then
    return {
      type  = 'rule_header',
      level = 1
    }
  end

  if line:match('^[%-]+$') then
    return {
      type  = 'rule_header',
      level = 2
    }
  end

  if is_rule(line) then
    return {type = 'rule'}
  end

  -- headers
  local h_level, h_text = line:match('^(#+)[ \t]*(.-)[ \t]*#*[ \t]*$')
  if h_level and 1 <= h_level:len() and h_level:len() <= 6 and h_text then
    return {
      type       = 'header',
      level      = h_level:len(),
      text       = h_text,
      unmodified = line
    }
  end

  -- lists
  local ol_text = line:match('^ ? ? ?%d+%.[ \t]+(.+)')
  if ol_text then
    return {
      type       = 'list',
      style      = 'numeric',
      text       = ol_text,
      unmodified = line
    }
  end

  local ul_text = line:match('^ ? ? ?[%*%+%-][ \t]+(.+)')
  if ul_text then
    return {
      type       = 'list',
      style      = 'bullet',
      text       = ul_text,
      unmodified = line
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
-- Converts Markdown emphasis in a line to corresponding HTML tags.
--
-- @param   line
-- @return  line
-----------------------------------------------------------------------------
function emphasize(line)
  if line.type == 'blank' or not line.text then
    return line
  end

  emphasis = {
    strong = {'%*%*', '%_%_'},
    em     = {'%*', '%_'}
  }

  for _, strong in ipairs(emphasis.strong) do
    local patterns = {
      strong .. '([^%s][%*%_]?)' .. strong,
      strong .. '([^%s][^<>]-[^%s][%*%_]?)' .. strong
    }

    for _, pattern in ipairs(patterns) do
      line.text = line.text:gsub(pattern, '<strong>%1</strong>')
    end
  end

  for _, em in ipairs(emphasis.em) do
    local patterns = {
      em .. '([^%s_])' .. em,
      em .. '(<strong>[^%s_]</strong>)' .. em,
      em .. '([^%s][^<>_]-[^%s])' .. em,
      em .. '([^<>_]-<strong>[^<>_]-</strong>[^<>_]-)' .. em
    }

    for _, pattern in ipairs(patterns) do
      line.text = line.text:gsub(pattern, '<em>%1</em>')
    end
  end

  return line
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
    header             = '<h%u>%s</h%u>',
    list_numeric_start = '<ol>',
    list_numeric_end   = '</ol>',
    list_bullet_start  = '<ul>',
    list_bullet_end    = '</ul>',
    list_item          = '<li>%s</li>',
    linebreak          = '%s<br />',
    paragraph_start    = '<p>%s',
    paragraph_end      = '%s</p>',
    rule               = '<hr />'
  }

  -- list tag helper
  local function list_line(index, line)
    local elements = {}
    local prev_line = lines[index-1]
    local cur_line  = lines[index]
    local next_line = lines[index+1]

    if not prev_line or
       prev_line.type ~= cur_line.type or
       prev_line.style ~= cur_line.style then
      table.insert(elements, formats['list_' .. cur_line.style .. '_start'])
    end

    table.insert(elements, formats.list_item:format(line))


    if not next_line or
       next_line.type ~= cur_line.type or
       next_line.style ~= cur_line.style then
      table.insert(elements, formats['list_' .. cur_line.style .. '_end'])
    end

    return elements
  end

  -- paragraph tag helper
  local function paragraph_line(index, line)
    local paragraphs = {
      linebreak = 1,
      regular   = 1
    }

    local prev_line = lines[index-1]
    local cur_line  = lines[index]
    local next_line = lines[index+1]

    if not prev_line or not (paragraphs)[prev_line.type] then
      line = formats.paragraph_start:format(line)
    end

    if cur_line.type == 'linebreak' and
       next_line and (paragraphs)[next_line.type] then
      line = formats.linebreak:format(line)
    elseif not next_line or
           not (paragraphs)[next_line.type] or
           (lines[index+2] and 'rule_header' == lines[index+2].type) then
      line = formats.paragraph_end:format(line)
    end

    return line
  end

  -- convert lines to html
  for index, line in ipairs(lines) do
    -- header_rule detection
    if lines[index+1] and lines[index+1].type == 'rule_header' then
      line.type  = 'header'
      line.level = lines[index+1].level

      if line.unmodified then
        line.text = line.unmodified
      end
    end

    -- rules
    if line.type == 'rule' then
      table.insert(htmlized, formats.rule)
    end

    -- header
    if line.type == 'header' then
      table.insert(
        htmlized,
        formats.header:format(line.level, line.text, line.level)
      )
    end

    -- lists
    if line.type == 'list' then
      for _,l in ipairs(list_line(index, line.text)) do
        table.insert(htmlized, l)
      end
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
  text = anchorize(text)
  text = convert(text)

  return text
end