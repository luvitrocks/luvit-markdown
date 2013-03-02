local markdown = require './markdown'

assert(type(markdown) == 'function')

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
}

for _,header in pairs(headers) do
  assert(header.html == markdown(header.markdown))
end