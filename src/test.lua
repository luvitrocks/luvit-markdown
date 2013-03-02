local markdown = require './markdown'

assert(type(markdown) == 'function')

-- test helper
local function testset(title, tests)
  process.stdout:write('Testing: ' .. title .. ' ')

  for _,test in pairs(tests) do
    assert(test.html == markdown(test.markdown))
    process.stdout:write('.')
  end

  process.stdout:write('\n')
end

-- headers
local headers = {
  {markdown = '# This is an H1',
   html = '<h1>This is an H1</h1>'},
  {markdown = '## This is an H2',
   html = '<h2>This is an H2</h2>'},
  {markdown = '### This is an H3',
   html = '<h3>This is an H3</h3>'},
  {markdown = '#### This is an H4',
   html = '<h4>This is an H4</h4>'},
  {markdown = '##### This is an H5',
   html = '<h5>This is an H5</h5>'},
  {markdown = '###### This is an H6',
   html = '<h6>This is an H6</h6>'},

  {markdown = '# This is an H1 #',
   html = '<h1>This is an H1</h1>'},
  {markdown = '## This is an H2 ##',
   html = '<h2>This is an H2</h2>'},
  {markdown = '### This is an H3 ###',
   html = '<h3>This is an H3</h3>'},
  {markdown = '#### This is an H4 ####',
   html = '<h4>This is an H4</h4>'},
  {markdown = '##### This is an H5 #####',
   html = '<h5>This is an H5</h5>'},
  {markdown = '###### This is an H6 ######',
   html = '<h6>This is an H6</h6>'},

  {markdown = '# First header\n' ..
              '## Second header##\n' ..
              '### Third header',
   html = '<h1>First header</h1>\n' ..
          '<h2>Second header</h2>\n' ..
          '<h3>Third header</h3>'}
}

testset('Headers', headers)