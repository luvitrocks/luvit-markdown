return {
  {markdown = '* foo', html = '<ul>\n<li>foo</li>\n</ul>'},
  {markdown = '+ foo', html = '<ul>\n<li>foo</li>\n</ul>'},
  {markdown = '- foo', html = '<ul>\n<li>foo</li>\n</ul>'},
  {markdown = '1. foo', html = '<ol>\n<li>foo</li>\n</ol>'},
  {markdown = '* foo\n+ bar\n- baz', html = '<ul>\n<li>foo</li>\n<li>bar</li>\n<li>baz</li>\n</ul>'},
  {markdown = '7. foo\n662. bar\n1. baz', html = '<ol>\n<li>foo</li>\n<li>bar</li>\n<li>baz</li>\n</ol>'},
  {markdown = '* foo\n1. bar\n- baz', html = '<ul>\n<li>foo</li>\n</ul>\n<ol>\n<li>bar</li>\n</ol>\n<ul>\n<li>baz</li>\n</ul>'}
}