-----------------------------------------------------------------------------
-- Markdown test suite.
--
-- @see http://daringfireball.net/projects/markdown/dingus
-----------------------------------------------------------------------------

local markdown = require '../src/markdown'

assert(type(markdown) == 'function')

-- test helper
local function testset(title, tests)
  process.stdout:write('Testing: ' .. title .. ' ')

  for _,test in pairs(tests) do
    if test.html == markdown(test.markdown) then
      process.stdout:write('.')
    else
      process.stdout:write(
        '\n\n- Error!\n' ..
        'Expected: ' .. test.html:gsub('\n', '\\n') .. '\n' ..
        'Returned: ' .. markdown(test.markdown):gsub('\n', '\\n') .. '\n'
      )
    end

  end

  process.stdout:write('\n')
end

-- test sets
testset('HTML', require('./_html'))
testset('Rules', require('./_rules'))
testset('Headers', require('./_headers'))
testset('Lists', require('./_lists'))
testset('Paragraphs + Linebreaks', require('./_paragraphs'))
testset('Blockquotes', require('./_blockquotes'))
testset('Emphasis', require('./_emphasis'))
testset('Anchors', require('./_anchors'))
testset('Document', require('./_document'))
