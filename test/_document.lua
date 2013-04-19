return {
  {markdown = '# H1\nParagraph\n[linkage]: http://somepage.tld "with a title!"\n## H2 ##' ..
              '\n\nLinebroken  \nParagraph\n## H2\n[linkage]\n* * * * *\n' ..
              'Paragraph with **emphasized** whitespace  \n### _H3_\n+ just a list\n1. stylechange!\n' ..
              '__incredible stuff__',
   html = '<h1>H1</h1>\n<p>Paragraph</p>\n<h2>H2</h2>\n<p>Linebroken  <br />\nParagraph</p>\n<h2>H2</h2>\n' ..
          '<p><a href="http://somepage.tld" title="with a title!">linkage</a></p>\n<hr />\n' ..
          '<p>Paragraph with <strong>emphasized</strong> whitespace  </p>\n<h3><em>H3</em></h3>\n' ..
          '<ul>\n<li>just a list</li>\n</ul>\n<ol>\n<li>stylechange!</li>\n</ol>\n' ..
          '<p><strong>incredible stuff</strong></p>'}
}