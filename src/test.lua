-----------------------------------------------------------------------------
-- Markdown test suite.
--
-- @see http://daringfireball.net/projects/markdown/dingus
-----------------------------------------------------------------------------

local markdown = require './markdown'

assert(type(markdown) == 'function')

-- test helper
local function testset(title, tests)
  process.stdout:write('Testing: ' .. title .. ' ')

  for _,test in pairs(tests) do
    assert(
      test.html == markdown(test.markdown),
      'assertion failed!\n' ..
      'expected: ' .. test.html ..
      'returned: ' .. markdown(test.markdown)
    )

    process.stdout:write('.')
  end

  process.stdout:write('\n')
end

-- headers
testset('Headers', {
  {markdown = '# This is an H1', html = '<h1>This is an H1</h1>'},
  {markdown = '## This is an H2', html = '<h2>This is an H2</h2>'},
  {markdown = '### This is an H3', html = '<h3>This is an H3</h3>'},
  {markdown = '#### This is an H4', html = '<h4>This is an H4</h4>'},
  {markdown = '##### This is an H5', html = '<h5>This is an H5</h5>'},
  {markdown = '###### This is an H6', html = '<h6>This is an H6</h6>'},
  {markdown = '# This is an H1 #', html = '<h1>This is an H1</h1>'},
  {markdown = '## This is an H2 ##', html = '<h2>This is an H2</h2>'},
  {markdown = '### This is an H3 ###', html = '<h3>This is an H3</h3>'},
  {markdown = '#### This is an H4 ####', html = '<h4>This is an H4</h4>'},
  {markdown = '##### This is an H5 #####', html = '<h5>This is an H5</h5>'},
  {markdown = '###### This is an H6 ######', html = '<h6>This is an H6</h6>'},

  {markdown = '# First header\n## Second header##\n### Third header',
   html = '<h1>First header</h1>\n<h2>Second header</h2>\n<h3>Third header</h3>'}
})

-- paragraphs and linebreaks
testset('Paragraphs + Linebreaks', {
  {markdown = 'Some\nText', html = '<p>Some\nText</p>'},
  {markdown = 'Two\n\nParagraphs', html = '<p>Two</p>\n<p>Paragraphs</p>'},
  {markdown = 'Linebroken  \nParagraph', html = '<p>Linebroken  <br />\nParagraph</p>'},
  {markdown = 'No break before end  ', html = '<p>No break before end  </p>'}
})

-- emphasis
testset('Emphasis', {
  {markdown = 'with ***strong and em***', html = '<p>with <strong><em>strong and em</em></strong></p>'},
  {markdown = 'with strong ***and*** em', html = '<p>with strong <strong><em>and</em></strong> em</p>'},
  {markdown = 'with ___strong and em___', html = '<p>with <strong><em>strong and em</em></strong></p>'},
  {markdown = 'with strong ___and___ em', html = '<p>with strong <strong><em>and</em></strong> em</p>'},
  {markdown = 'not* emphasized*', html = '<p>not* emphasized*</p>'},
  {markdown = 'single l*e*tt__e__r', html = '<p>single l<em>e</em>tt<strong>e</strong>r</p>'},
  {markdown = 'mixed __x __weird', html = '<p>mixed <em>_x _</em>weird</p>'}
})

-- document
testset('Document', {
  {markdown = '# H1\n' ..
              'Paragraph\n' ..
              '## H2 ##\n'..
              '\n' ..
              'Linebroken  \nParagraph\n' ..
              '## H2\n' ..
              'Paragraph with **emphasized** whitespace  \n' ..
              '### _H3_',
   html = '<h1>H1</h1>\n' ..
          '<p>Paragraph</p>\n' ..
          '<h2>H2</h2>\n'..
          '<p>Linebroken  <br />\nParagraph</p>\n' ..
          '<h2>H2</h2>\n' ..
          '<p>Paragraph with <strong>emphasized</strong> whitespace  </p>\n' ..
          '<h3><em>H3</em></h3>'}
})