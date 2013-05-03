return {
  {markdown = '\n  <div>protected</div> \n\n', html = '<div>protected</div> \n\n'},
  {markdown = 'surrounding\n\n<blockquote>protected\nhtml</blockquote>\n\nwith text\n\n<div>and\n          MORE</div>\n\ntext',
   html = '<p>surrounding</p>\n\n<blockquote>protected\nhtml</blockquote>\n\n<p>with text</p>\n\n<div>and\n          MORE</div>\n\n<p>text</p>'}
}
