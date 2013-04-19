return {
  {markdown = '[foo](/bar)', html = '<p><a href="/bar">foo</a></p>'},
  {markdown = '[foo](/bar "desc")', html = '<p><a href="/bar" title="desc">foo</a></p>'},
  {markdown = '[foo](/bar \'desc\')', html = '<p><a href="/bar" title="desc">foo</a></p>'},
  {markdown = '[foo]: http://x.y/ "optional"\n[foo]', html = '<p><a href="http://x.y/" title="optional">foo</a></p>'},
  {markdown = '[foo]: http://x.y/ "optional"\n[foo]: http://y.x/ "override"\n[foo]', html = '<p><a href="http://y.x/" title="override">foo</a></p>'}
}