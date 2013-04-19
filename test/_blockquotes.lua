return {
  {markdown = 'Leading Paragraph\n\n> Quote paragraph 1\n>\n> Quote paragraph 2\n\nTrailing Paragraph',
   html = '<p>Leading Paragraph</p>\n<blockquote>\n<p>Quote paragraph 1</p>\n<p>Quote paragraph 2</p>\n</blockquote>\n<p>Trailing Paragraph</p>'},
  {markdown = '> Quote with  \n> Linebreak', html = '<blockquote><p>Quote with<br />\nLinebreak</p></blockquote>'},
  {markdown = '> First Quote\n\n> Second Quote', html = '<blockquote>\n<p>First Quote</p>\n</blockquote>\n<blockquote>\n<p>Second Quote</p>\n</blockquote>'}
}